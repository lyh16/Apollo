#!/bin/bash
set -e

# Post-build patches for Dystopia-spoofed Apollo
# Run this from inside the build directory (where Payload/ lives)
#
# Applies:
#   1. Dystopia URL scheme injection (for OAuth redirect spoofing)
#   2. App Group capitalization fix (group.com.christianselig.apollo → .Apollo)
#      Required for SideStore signing compatibility

APP_DIR="Payload/Apollo.app"
PLIST="${APP_DIR}/Info.plist"
EXECUTABLE="${APP_DIR}/Apollo"

if [ ! -f "$PLIST" ]; then
    echo "Error: $PLIST not found. Run from the directory containing Payload/"
    exit 1
fi

# --- 1. Add dystopia URL scheme ---
echo "Adding dystopia URL scheme..."

# Find the CFBundleURLSchemes array index
url_type_index=0
found_schemes=false

if /usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes" "$PLIST" &>/dev/null; then
    while /usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:${url_type_index}" "$PLIST" &>/dev/null; do
        if /usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:${url_type_index}:CFBundleURLSchemes" "$PLIST" &>/dev/null; then
            found_schemes=true
            break
        fi
        url_type_index=$((url_type_index + 1))
    done
fi

if [ "$found_schemes" == "false" ]; then
    echo "Error: No CFBundleURLSchemes found in Info.plist"
    exit 1
fi

# Check if dystopia scheme already exists
existing=$(/usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:${url_type_index}:CFBundleURLSchemes" "$PLIST" 2>/dev/null | grep -cxF "    dystopia" || true)
if [ "$existing" -eq 0 ]; then
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:${url_type_index}:CFBundleURLSchemes: string dystopia" "$PLIST"
    echo "  Added: dystopia"
else
    echo "  Already present, skipping"
fi

echo "  URL schemes:"
/usr/libexec/PlistBuddy -c "Print :CFBundleURLTypes:${url_type_index}:CFBundleURLSchemes" "$PLIST"

# --- 2. Fix App Group capitalization for SideStore ---
echo "Fixing App Group capitalization..."

for f in "$EXECUTABLE" "${APP_DIR}"/PlugIns/*.appex/*; do
    # Skip non-Mach-O files
    file "$f" 2>/dev/null | grep -q "Mach-O" || continue

    # Extract entitlements
    ENTS=$(ldid -e "$f" 2>/dev/null) || continue

    # Check if this binary has the lowercase app group
    if echo "$ENTS" | grep -q "group.com.christianselig.apollo"; then
        echo "$ENTS" | sed 's|group\.com\.christianselig\.apollo|group.com.christianselig.Apollo|g' > /tmp/ent_fix.plist
        ldid -S/tmp/ent_fix.plist "$f"
        echo "  Patched: $(basename "$f")"
    fi
done

rm -f /tmp/ent_fix.plist
echo "Done."

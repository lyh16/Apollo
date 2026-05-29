# Apollo Dystopia Fork — Setup & Reference

## Overview

This fork of [Balackburn/Apollo](https://github.com/Balackburn/Apollo) automatically builds Apollo for Reddit IPAs with two additional patches:

1. **Dystopia URL scheme** — Adds `dystopia` to `CFBundleURLSchemes` in `Info.plist` so iOS routes `dystopia://response` OAuth callbacks to Apollo instead of the real Dystopia app.
2. **App Group capitalization fix** — Changes `group.com.christianselig.apollo` to `group.com.christianselig.Apollo` (capital A) in binary entitlements, fixing SideStore signing error 3014.

The Dystopia spoof lets you use Apollo without creating your own Reddit API key, by piggybacking on Dystopia's free accessibility API deal with Reddit. Based on the [patcheddit](https://github.com/wchill/patcheddit) method, [guide by u/Ill-Economist-5285](https://www.reddit.com/r/apollosideloaded/comments/1r864m7/).

## How the automation works

```
Apollo-Reborn/Apollo-Reborn pushes a new tweak release
  → This fork's cron job (every 6 hours) detects new release
    → Downloads base Apollo 1.15.11 IPA + Apollo-Reborn .deb
    → cyan injects the tweak into the IPA
    → dystopia-patch.sh adds URL scheme + fixes App Group entitlements
    → Builds 4 IPA variants (standard, GLASS, no-ext, no-ext+GLASS)
    → Creates a GitHub release with all 4 IPAs
    → update_json.py regenerates apps.json source files
    → SideStore notifies you of available update
```

### Key files

| File | Purpose |
|------|---------|
| `dystopia-patch.sh` | Post-build script: adds `dystopia` URL scheme + fixes App Group capitalization |
| `.github/workflows/create_release.yml` | Main CI workflow — checks for upstream releases, builds IPAs, publishes |
| `.github/workflows/deploy.yml` | Deploys the landing page to GitHub Pages |
| `config.json` | Configuration for `update_json.py` (repo URL, image paths, app metadata) |
| `update_json.py` | Regenerates all 4 `apps*.json` AltStore source files from GitHub releases |
| `apps.json` | Standard AltStore/SideStore source |
| `apps_noext.json` | No-extensions source (1 App ID instead of 7) |
| `apps_glass.json` | Liquid Glass source (iOS 26+) |
| `apps_noext_glass.json` | No-extensions + Liquid Glass source |

### Why dystopia-patch.sh runs twice per build

Each IPA variant is built in two stages:

1. `cyan` injects the tweak → **dystopia-patch.sh runs** → standard IPA is zipped
2. `vtool` + `ldid -S -M` re-sign for Liquid Glass → **dystopia-patch.sh runs again** → GLASS IPA is zipped

The second run is needed because `ldid -S -M` may overwrite the entitlement fixes from the first run. The script is idempotent (checks before adding, skips if already present).

## SideStore source URLs

| Variant | URL |
|---------|-----|
| Standard | `https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps.json` |
| No Extensions | `https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext.json` |
| GLASS (iOS 26+) | `https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_glass.json` |
| No Ext + GLASS | `https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext_glass.json` |

## Post-install configuration

After installing the IPA via SideStore, open Apollo and go to **Settings > General > Custom API**:

| Setting | Value |
|---------|-------|
| Reddit API Key | *(App ID from the Reddit "You've authorized a new app" email)* |
| Redirect URI | `dystopia://response` |
| User Agent | `ios:com.CarbonDev.Dystopia:v1.0.1(by u/DystopiaForReddit)` |

### How to get the App ID

1. Install [Dystopia for Reddit](https://apps.apple.com/app/dystopia-for-reddit/id6475596587) on your iPhone
2. Log in to your Reddit account through Dystopia
3. Check your email for "You've authorized a new app in your Reddit account"
4. Copy the **App ID** from that email
5. You can uninstall Dystopia after this step

**Important**: Your Reddit account must have a valid email address linked to it.

## Syncing with upstream (Balackburn/Apollo)

If Balackburn makes changes to the build workflow or landing page that you want to pull in:

```bash
# One-time setup
git remote add upstream https://github.com/Balackburn/Apollo.git

# Pull upstream changes
git fetch upstream
git merge upstream/main
# Resolve any conflicts in dystopia-patch.sh or create_release.yml
git push origin main
```

## Triggering a manual build

Go to **Actions > build release > Run workflow** on GitHub. Useful when:

- You don't want to wait for the 6-hour cron
- You want to rebuild after changing `dystopia-patch.sh`
- You want to test with a different base Apollo IPA URL (enter in the workflow input)

## Image URLs in source JSON

AltStore source JSON files reference images via `raw.githubusercontent.com`. The images live at `public/images/` in the repo, so URLs must include the `public/` prefix:

```
https://raw.githubusercontent.com/lyh16/Apollo/main/public/images/image_0.webp
```

The upstream Balackburn repo had these paths wrong (missing `public/`), causing 404s. Fixed in this fork.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| SideStore error 3014 | App Group case mismatch | `dystopia-patch.sh` fixes this — verify it ran in the build log |
| Reddit says "invalid redirect_uri" | Wrong redirect URI in Apollo settings | Must be exactly `dystopia://response` |
| OAuth callback doesn't return to Apollo | `dystopia` URL scheme missing from IPA | Check build log for "Added: dystopia" |
| Images missing in AltStore source | Broken image URLs in JSON | Ensure URLs use `main/public/images/` path |
| Build workflow skips | No new upstream release | Trigger manually via workflow_dispatch |

<p align="center">
  <img src="public/images/header/github_header.png" alt="Apollo for Reddit Banner" />
</p>

[![Platform](http://img.shields.io/badge/platform-iOS/iPadOS/macOS-blue.svg)](https://developer.apple.com/iphone/index.action)
![Release](https://img.shields.io/github/downloads/lyh16/Apollo/total)
![GitHub issues](https://img.shields.io/github/issues-raw/lyh16/Apollo)

# Apollo for Reddit with ImprovedCustomAPI (Dystopia Fork)

This is a fork of [Balackburn/Apollo](https://github.com/Balackburn/Apollo) with additional patches applied automatically during the build:

### What this fork adds

1. **Dystopia URL scheme** — Injects `dystopia` into `CFBundleURLSchemes` so iOS routes the `dystopia://response` OAuth callback to Apollo, enabling the [free API spoof](https://github.com/wchill/patcheddit) without manually editing the IPA.
2. **App Group capitalization fix** — Changes `group.com.christianselig.apollo` to `group.com.christianselig.Apollo` (capital A) in binary entitlements, fixing SideStore error 3014 caused by a case mismatch with the Apple Developer Portal.

After installing, you still need to enter these in Apollo > Settings > General > Custom API:

| Setting | Value |
|---------|-------|
| Reddit API Key | *(your Dystopia App ID from the Reddit email)* |
| Redirect URI | `dystopia://response` |
| User Agent | `ios:com.CarbonDev.Dystopia:v1.0.1(by u/DystopiaForReddit)` |

For the full setup walkthrough, see [this guide](https://www.reddit.com/r/apollosideloaded/comments/1r864m7/) by [u/Ill-Economist-5285](https://www.reddit.com/user/Ill-Economist-5285) on [r/apollosideloaded](https://www.reddit.com/r/apollosideloaded/), based on [patcheddit](https://github.com/wchill/patcheddit).

### Upstream

This source tracks [JeffreyCA/Apollo-ImprovedCustomApi](https://github.com/JeffreyCA/Apollo-ImprovedCustomApi) releases automatically every 6 hours. It uses version `1.15.11` of the app and the latest release of the tweak.

Before raising any issues, please check the [ImprovedCustomApi](https://github.com/JeffreyCA/Apollo-ImprovedCustomApi/issues) repo first — this source only integrates it.

### Versioning

Apollo itself is frozen at `1.15.11` (the last public release before Christian Selig was forced off the App Store). What actually changes between releases is the [ImprovedCustomApi](https://github.com/JeffreyCA/Apollo-ImprovedCustomApi) tweak version that gets patched in. To keep SideStore and other AltStore-compatible clients reliably detecting updates, this fork uses the following field mapping in both the source JSON and the IPA's `Info.plist`:

| Field | Value | Where it shows |
|-------|-------|----------------|
| `version` / `CFBundleShortVersionString` | ICA tweak version (e.g. `2.8.0`) | SideStore "Version" column, the primary version shown in iOS Settings, **and Apollo's own About page** |
| `buildVersion` / `CFBundleVersion` | Apollo app version (`1.15.11`) | The build number shown in parentheses in iOS Settings |

**Where you will see this in practice.** Anywhere iOS, SideStore, or Apollo itself reads `CFBundleShortVersionString` will now display the ICA tweak version instead of Apollo's underlying `1.15.11`:

| Surface | Displays | Notes |
|---|---|---|
| SideStore "Version" column | ICA version (e.g. `2.8.0`) | This is the whole point of the swap — drives update detection |
| iOS Settings → General → iPhone Storage → Apollo | `2.8.0 (1.15.11)` | The value in parentheses is `CFBundleVersion`, where Apollo's version is preserved |
| **Apollo's own About page (in-app)** | ICA version (e.g. `2.8.0`) | Apollo reads its own version from the same plist key — there is no way to make it show `1.15.11` separately without binary-patching the app |
| GitHub release tags | `v1.15.11_2.8.0` | Unchanged — both versions are visible |
| GitHub release titles | `Apollo v1.15.11 with ImprovedCustomApi v2.8.0` | Unchanged |
| IPA filenames | `Apollo-1.15.11_ImprovedCustomApi-2.8.0.ipa` | Unchanged |

So inside Apollo and in iOS's primary version display, you will see the ICA number where you might have expected Apollo's `1.15.11`. The Apollo version is still recoverable in iOS Settings (the build-number slot in parentheses) and on every GitHub release page — it just isn't the headline number anymore.

**Why this swap?** SideStore's update detection parses `version` as semantic versioning (`major.minor.patch`) and only compares those three components; `buildVersion` is consulted just as a beta-channel tiebreaker or as a fallback when SemVer parsing fails. Using Apollo's frozen `1.15.11` as `version` produced the same string for every release, so SideStore never offered updates even when the underlying ICA tweak changed. Surfacing the ICA version as `version` makes every release advertise a strictly higher SemVer than the previous one, and update detection works out of the box.

## Available Sources

| Version | Best For | Features |
|---------|----------|----------|
| **Standard** | Most users | Apollo + ImprovedCustomApi + Dystopia spoof + App Group fix |
| **No Extensions** | Free Apple Developer accounts | Same as Standard with removed extensions — uses fewer App IDs (1 vs 7) |
| **GLASS** | iOS 26+ users | Same as Standard with Liquid Glass UI Patch (iOS 26+) |
| **No Extensions + LIQUID GLASS** | iOS 26 + Free accounts | Combines both options |

## Standard Source

<a href="https://intradeus.github.io/http-protocol-redirector?r=altstore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Altstore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Altstore.png">
    <img alt="Add to AltStore" src="public/images/buttons/LIGHT/Altstore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=feather://source/https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Feather.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Feather.png">
    <img alt="Add to Feather" src="public/images/buttons/LIGHT/Feather.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=sidestore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Sidestore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Sidestore.png">
    <img alt="Add to SideStore" src="public/images/buttons/LIGHT/Sidestore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/DirectURL.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/DirectURL.png">
    <img alt="Direct URL" src="public/images/buttons/LIGHT/DirectURL.png" height="55">
  </picture>
</a>

## No Extensions Source (Avoid AppID Limit)

<a href="https://intradeus.github.io/http-protocol-redirector?r=altstore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Altstore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Altstore.png">
    <img alt="Add to AltStore" src="public/images/buttons/LIGHT/Altstore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=feather://source/https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Feather.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Feather.png">
    <img alt="Add to Feather" src="public/images/buttons/LIGHT/Feather.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=sidestore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Sidestore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Sidestore.png">
    <img alt="Add to SideStore" src="public/images/buttons/LIGHT/Sidestore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/DirectURL.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/DirectURL.png">
    <img alt="Direct URL" src="public/images/buttons/LIGHT/DirectURL.png" height="55">
  </picture>
</a>

## GLASS Source (iOS 26+)

<a href="https://intradeus.github.io/http-protocol-redirector?r=altstore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Altstore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Altstore.png">
    <img alt="Add to AltStore" src="public/images/buttons/LIGHT/Altstore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=feather://source/https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Feather.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Feather.png">
    <img alt="Add to Feather" src="public/images/buttons/LIGHT/Feather.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=sidestore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Sidestore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Sidestore.png">
    <img alt="Add to SideStore" src="public/images/buttons/LIGHT/Sidestore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/DirectURL.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/DirectURL.png">
    <img alt="Direct URL" src="public/images/buttons/LIGHT/DirectURL.png" height="55">
  </picture>
</a>

## No Extensions + GLASS Source (Avoid AppID Limit - iOS 26+)

<a href="https://intradeus.github.io/http-protocol-redirector?r=altstore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Altstore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Altstore.png">
    <img alt="Add to AltStore" src="public/images/buttons/LIGHT/Altstore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=feather://source/https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Feather.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Feather.png">
    <img alt="Add to Feather" src="public/images/buttons/LIGHT/Feather.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://intradeus.github.io/http-protocol-redirector?r=sidestore://source?url=https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Sidestore.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Sidestore.png">
    <img alt="Add to SideStore" src="public/images/buttons/LIGHT/Sidestore.png" height="55">
  </picture>
</a>
&nbsp;
<a href="https://raw.githubusercontent.com/lyh16/Apollo/refs/heads/main/apps_noext_glass.json">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/DirectURL.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/DirectURL.png">
    <img alt="Direct URL" src="public/images/buttons/LIGHT/DirectURL.png" height="55">
  </picture>
</a>

## Website

<a href="https://lyh16.github.io/Apollo">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="public/images/buttons/DARK/Website.png">
    <source media="(prefers-color-scheme: light)" srcset="public/images/buttons/LIGHT/Website.png">
    <img alt="Visit Website" src="public/images/buttons/LIGHT/Website.png" height="55">
  </picture>
</a>

##
This project is not affiliated with Apollo or Christian Selig.

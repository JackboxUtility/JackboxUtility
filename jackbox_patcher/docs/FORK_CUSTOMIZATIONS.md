# Fork Customizations

This document tracks major custom behavior added in this fork.

## Purpose

This repo is a custom fork of the original application.
The goal is to move fast on user-requested workflow changes while keeping a path open for upstreaming.

I would like to merge these improvements back into the main project, but I am not yet confident in the upstream contribution process.

## Major Changes In This Fork

## 1) Mobile Remote Experience

- Expanded mobile web SPA behavior for remote browse/control workflows.
- Improved desktop synchronization behavior for full-sync mode.
- Added/adjusted phone-to-desktop sync for:
  - Search text
  - Filters and int filters
  - Sort settings
  - Tags
  - Visibility toggles

## 2) Navigation and Control Quality Improvements

- Show-game navigation cleanup to reduce route stacking issues.
- Random game behavior updated to better broadcast and sync state.
- Detail close behavior propagated so desktop and phone stay in step.

## 3) Card Overlay UX

- Added an always-on card overlay mode for stat-focused browsing.
- Added clearer family-friendly badge styling for rapid visual scanning.

## 4) Settings and Persistence

- Added persisted toggle for always-on card overlays.
- Added control points in both desktop settings and mobile admin controls.

## 5) Visual Identity / Icon Pack

- Replaced the icon pack used by the app in this fork.
- Reference commit:
   - `65bcdacdb0ea5008eeef66a22dd770639e01c4e1`

## Build/Runtime Notes

## Windows

Known environment-specific issue: Flutter Windows build may fail at CMake INSTALL script step.
Workaround in this forked setup:

1. Build with Flutter as normal.
2. Copy newest `.dart_tool/flutter_build/<hash>/app.so` to:
   - `build/windows/x64/runner/Release/data/app.so`
3. Launch:
   - `build/windows/x64/runner/Release/jackbox_patcher.exe`

## Linux / Arch

Linux builds are generated via CI on feature branches.
For Arch Linux usage, take the Linux build output as a baseline and adapt packaging/runtime dependencies as needed.

## Upstreaming Plan (Wanted)

Desired next step is to upstream these changes in smaller PRs.
Help is especially welcome for:

- Breaking down fork changes into reviewable units
- Aligning with upstream code style and contribution expectations
- Preparing and submitting merge-ready PRs
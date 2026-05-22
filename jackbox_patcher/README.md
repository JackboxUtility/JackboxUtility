# Jackbox Utility (Fork)

This repository is a fork with custom features and behavior changes added on top of the original app.

I would love to merge this work into the main app, but I do not fully know the upstream contribution process yet. If you maintain the original project or know the merge flow, help is very welcome.

## What This Fork Adds

This fork currently includes custom work around:

- Mobile remote web experience and synchronization behavior.
- Desktop/phone sync improvements for filters, tags, and sorting.
- Random game and show-on-screen flow improvements.
- Card overlay customization (including always-on overlay mode).
- Family-friendly status badge visibility improvements on game cards.
- Relative path visibility in Owned Games and recursive portable folder scan for executables.
- Optional phone remote admin lock pattern (4 taps on a 9x9 grid).
- Custom icon pack changes in this fork (commit `65bcdacdb0ea5008eeef66a22dd770639e01c4e1`).

## Security Warning (Phone Admin Lock)

The phone remote admin lock pattern is intentionally **insecure** and is only meant to keep casual users out of admin controls.

- The pattern is delivered to the browser client.
- A determined user can inspect client-side code/network traffic and recover it.
- Do not treat this as real security or authentication.

Use it only as a convenience barrier for friends on the same local network.

For a running summary of fork-specific changes, see:

- [docs/FORK_CUSTOMIZATIONS.md](docs/FORK_CUSTOMIZATIONS.md)

## Build Notes

### Windows

Windows builds can hit a known CMake INSTALL step failure in this forked environment.
When that happens, the app can still be run using the latest compiled `app.so` copied into:

- `build/windows/x64/runner/Release/data/app.so`

### Linux / Arch

Linux builds are produced through CI workflows on feature branches.
If you are targeting Arch Linux, use the Linux CI artifact as the base package/output and adapt for your local runtime environment.

## Local Development

This is a Flutter desktop project.

1. Install Flutter (matching the version used by this workspace).
2. Run dependency restore:
	- `flutter pub get`
3. Run locally:
	- `flutter run -d windows lib/main_beta.dart`

## Upstream Merge Intent

This fork is actively maintained for custom needs, but the long-term goal is to upstream as much as possible.
If you want to help with:

- Splitting features into clean PR-sized commits
- Mapping changes against upstream branch expectations
- Opening and iterating pull requests

please open an issue or reach out in project discussions.

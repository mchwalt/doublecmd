# Changelog

All notable changes to this Total Commander look-alike fork are documented here.
Only the fork's own changes on top of upstream Double Commander are listed; for the
upstream history see [`doc/changelog.txt`](doc/changelog.txt).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Version scheme: `<upstream-base>-tc.<n>` - the Double Commander base version plus a
fork revision counter.

## [Unreleased]

## [1.3.0-tc.5] - 2026-06-24

### Added
- XTree "ShowAll" feel: in flat view (Ctrl+B), the separate directory tree
  (Ctrl+Shift+F8) now follows the cursor's directory. The tree also follows into
  hidden folders (when hidden files are shown) and resolves 8.3 short paths
  (`GetLongName`), so it works under `Temp`/`AppData` too.

## [1.3.0-tc.4] - 2026-06-24

### Changed
- Double-clicking the path label now edits the path by default (TC behaviour),
  instead of opening the hot-dir menu (`gDblClickEditPath`). Right-click still
  opens the path edit too.

## [1.3.0-tc.3] - 2026-06-24

### Added
- Copy/move from a flat view (Ctrl+B) can now recreate the relative sub-directory
  structure at the target instead of flattening (XTree-style). Global default in
  Configuration > File operations, plus a per-operation checkbox in the F5/F6 dialog
  shown only for flat-view sources.

## [1.3.0-tc.2] - 2026-06-24

### Changed
- ZIP/ZIPX/JAR now default to the fast `sevenzip.wcx` decoder instead of the slow
  internal `zip.wcx`, removing the multi-second delay when opening/extracting ZIPs
  (`src/platform/udefaultplugins.pas`). Existing configs are migrated on start.

## [1.3.0-tc.1] - 2026-06-23

Baseline of the fork on top of Double Commander 1.3.0.

### Added
- Total Commander look & feel: `Microsoft Sans Serif` panel font, TC gray `[..]`
  up-arrow (`WCMICONS.DLL,15`), compact TC-like rows and toolbar.
- Running file index in the panel footer (position / total) with click-to-jump
  and a `Ctrl+G` shortcut.
- `ALT+B`, `d` accelerator opening the terminal / command-line window from the
  Commands menu.
- Windows build & TC setup guide
  ([`doc/WINDOWS-BUILD-AND-TC-SETUP.md`](doc/WINDOWS-BUILD-AND-TC-SETUP.md)).

### Fixed
- Keyboard navigation no longer dead-stops on menu separators; LCL Win32 owner-draw
  separators are forced back to real `MFT_SEPARATOR`
  (`src/platform/win/uwin32menufix.pas`).

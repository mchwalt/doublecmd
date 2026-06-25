# Double Commander - Total Commander (Windows XP) look-alike fork

This is a personal fork of [Double Commander](https://github.com/doublecmd/doublecmd).
Its goal is a file manager that stays as close as possible to the **classic Total
Commander look and feel in the Windows XP style**, while tracking the upstream
Double Commander codebase.

The fork keeps full compatibility with upstream and only adds Windows/TC-oriented
tweaks and a few small features on top.

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md) for the versioned history of this fork's changes
(current: `1.3.0-tc.6`). The upstream Double Commander changelog is in
[`doc/changelog.txt`](doc/changelog.txt).

## What this fork changes

### Total Commander look & feel
- Main panel font set to `Microsoft Sans Serif` (the TC default) for matching text rendering.
- The `[..]` parent-directory icon replaced with Total Commander's gray up arrow
  (`WCMICONS.DLL,15`) instead of the green Double Commander arrow.
- Compact, TC-like rows and toolbar via the local user config (panel icon size 16,
  `ExtraLineSpan` 0, font size 9, TC toolbar imported from `default.bar`).

### New features
- **Running file index in the panel footer** - a right-aligned field shows the cursor
  position / total of the listing (excluding `..`), updated live on cursor move.
- **Click-to-jump** - click the index to open a small inline editor and jump to a
  position (Enter confirms, Esc or focus loss cancels).
- **`Ctrl+G` shortcut** - opens the same jump editor from the keyboard.
- **`ALT+B`, `d` terminal accelerator** - opens the terminal / command-line window
  from the Commands menu, mirroring Total Commander's underlined mnemonic.

### Fixes
- **Menu separator navigation** - keyboard arrow navigation no longer dead-stops on
  menu separators (works around an LCL Win32 owner-draw bug).

### Building on Windows
Notes on building under Windows (Lazarus + FPC, the `C:\Program Files` space problem,
the `windres` wrapper) and the full TC setup are documented in
[`doc/WINDOWS-BUILD-AND-TC-SETUP.md`](doc/WINDOWS-BUILD-AND-TC-SETUP.md).

### Staying in sync with upstream
```
git fetch upstream
git merge upstream/master
```
(`origin` = this fork, `upstream` = `github.com/doublecmd/doublecmd`.)

---

## About Double Commander (upstream)

**Double Commander** is a [free](https://www.gnu.org/philosophy/free-sw.html) cross-platform open source file manager with two panels side by side (or one above the other). It is inspired by Total Commander and features some innovative new ideas. 

Double Commander can be run on several platforms and operating systems.
It supports 32-bit and 64-bit processors. See [Supported platforms](https://github.com/doublecmd/doublecmd/wiki/Supported-platforms)
for a complete list.

See Double Commander in action in the [Screenshot Gallery](https://doublecmd.sourceforge.io/gallery).

### Where to start

#### Download

Go to the [Double Commander download page](https://sourceforge.net/p/doublecmd/wiki/Download) to download the latest release.

You can check the latest version on the [Versions](https://github.com/doublecmd/doublecmd/wiki/Versions) page.

See if Double Commander is supported for your platform on the [Supported
platforms](https://github.com/doublecmd/doublecmd/wiki/Supported-platforms) page.

#### Develop

For more information on the development of Double Commander,
see the [Development](https://github.com/doublecmd/doublecmd/wiki/Development) page.

#### Discuss
  
Go to our [forum](https://doublecmd.h1n.ru) for discussions. There are English and Russian sections.

If you want to stay up-to-date with the project, you can check out the available [news feeds](https://github.com/doublecmd/doublecmd/wiki/News-feeds).

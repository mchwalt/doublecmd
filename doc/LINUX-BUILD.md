# Double Commander on Linux - Build Notes (Lubuntu 24.04 / Qt5)

Local notes for building Double Commander in a Lubuntu 24.04 VM (VMware) to verify
this fork's cross-platform changes build and run outside Windows. **This is the
verified, headless-over-SSH procedure** - it replaces an earlier draft that assumed
fpcupdeluxe + Qt6, both of which turned out not to work here (see "Dead ends" below).

Toolchain that actually works: **FPC 3.2.2 from apt + Lazarus 4.8 built from source +
the Qt5 widgetset**. DC requires at least FPC 3.2.2 and Lazarus 4.0 (`doc/INSTALL.txt`).

## 0. After the Lubuntu install (in the VM)

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y open-vm-tools open-vm-tools-desktop   # clipboard/resize; then reboot
```

- Use the **apt** `open-vm-tools-desktop`, NOT the legacy `linux.iso` VMware Tools.
  Reboot afterwards or clipboard won't work yet.
- A **"Minimal installation"** lacks many CLI tools - install them as needed.

## 1. Build dependencies

```bash
sudo apt update
sudo apt install -y build-essential binutils git subversion \
  libx11-dev libxext-dev libgtk2.0-dev libqt5pas-dev zlib1g-dev
```

- `libqt5pas-dev` provides the **Qt5** Pascal bindings (`libQt5Pas`) for the qt5 widgetset.
- `libgtk2.0-dev` is needed for a GTK2 build and pulls in common LCL deps.

## 2. FPC 3.2.2 from apt

Ubuntu 24.04 (noble) ships exactly FPC 3.2.2:

```bash
sudo apt install -y fpc
fpc -iV    # -> 3.2.2
```

(The noble `lazarus` package is only 3.0 - too old for DC - so Lazarus is built from
source below. fpcupdeluxe is NOT used; see "Dead ends".)

## 3. Lazarus 4.8 from source -> lazbuild

Only the `lazbuild` tool is needed to build DC from the command line.

```bash
cd ~
wget -O lazarus_4_8.tar.gz \
  "https://gitlab.com/freepascal.org/lazarus/lazarus/-/archive/lazarus_4_8/lazarus-lazarus_4_8.tar.gz"
tar xzf lazarus_4_8.tar.gz
cd lazarus-lazarus_4_8
make lazbuild                 # compiles ./lazbuild with the apt FPC (a few minutes)
./lazbuild --version          # -> 4.8
sudo ln -sf "$PWD/lazbuild" /usr/local/bin/lazbuild   # so build.sh finds it on PATH
```

(Pick another version by changing the `lazarus_4_8` tag, e.g. `lazarus_4_6`. Available
tags: gitlab.com/freepascal.org/lazarus/lazarus/-/tags)

## 4. Tell lazbuild where Lazarus lives (REQUIRED)

A source-built lazbuild does not know its Lazarus directory, and DC's `build.sh` calls
`lazbuild` without `--lazarusdir`. Without this you get:
`Error: (lazbuild) Invalid Lazarus directory "": directory lcl not found`.
Set it once in the primary config path:

```bash
mkdir -p ~/.lazarus
cat > ~/.lazarus/environmentoptions.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<CONFIG>
  <EnvironmentOptions>
    <Version Value="110"/>
    <LazarusDirectory Value="/home/<USER>/lazarus-lazarus_4_8/"/>
  </EnvironmentOptions>
</CONFIG>
XML
```

Replace `<USER>` with your username (the path must be absolute).

## 5. Clone and build DC (Qt5)

```bash
cd ~
git clone --branch windows-tc-setup --single-branch https://github.com/mchwalt/doublecmd.git
cd doublecmd
chmod +x build.sh
./build.sh release qt5        # 1st param = target, 2nd = widgetset
```

`build.sh release` builds components -> plugins -> doublecmd. Output: `./doublecmd`
(~17 MB ELF), plus `doublecmd.dbg` / `doublecmd.zdli`.

## 6. Run / smoke-test

With a desktop session just run `./doublecmd`. Headless over SSH, verify it starts under
a virtual X server:

```bash
sudo apt install -y xvfb
ldd ./doublecmd | grep "not found"     # expect: nothing
xvfb-run -a bash -c './doublecmd --config-dir=/tmp/dctest & P=$!; sleep 8; kill -0 $P && echo RUNNING; kill $P'
```

`RUNNING` (no crash) confirms the binary is viable. An "Error loading .../tabs.xml" on a
fresh `--config-dir` is harmless.

## Dead ends (so they aren't re-tried)

- **fpcupdeluxe is unusable headless here.** The current release (v2.4.0i) ships only the
  GTK GUI binary (`fpcupdeluxe-x86_64-linux`), no `fpclazup` console binary. The GUI binary
  needs an X display even for `--help`; passing `installdir=... fpcVersion=... noconfirm`
  does NOT trigger batch mode in the GUI build - it just sits idle (~0% CPU) in xvfb.
  Use apt FPC + source Lazarus instead.
- **Qt6 is not readily available on 24.04.** `libqt6pas-dev` / `libqt6pas6` are not in the
  noble repos (only `libqt5pas-dev`). A qt6 build would require building libQt6Pas from
  source. We use **qt5**, which fully exercises this fork's (widgetset-independent) features.

## What this verifies

The fork's core features are pure LCL and were confirmed to build and start on Linux/Qt5:
running file-position index in the footer, Ctrl+G jump, flat-view copy/move keeping
directory structure, separate-tree follow-cursor, smarter tree scrolling. Windows-only
bits (`src/platform/win/uwin32menufix.pas`, the 8.3 short-name resolution under
`{$IFDEF MSWINDOWS}`) have no effect here.

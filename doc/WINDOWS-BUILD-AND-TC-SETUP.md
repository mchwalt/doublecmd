# Double Commander on Windows - Build & Total Commander Look-alike Setup

Local notes for building Double Commander on Windows and tweaking it to mirror a
Total Commander setup. Captures the non-obvious findings so they don't have to be
re-discovered.

## 1. Toolchain

- Lazarus 4.8 + FPC 3.2.2 (`winget install Lazarus.Lazarus`), installed to
  `C:\Program Files\Lazarus`.
- Build from the repo root: `build.bat release` (components + plugins + app) or
  `build.bat doublecmd` (app only). Output: `doublecmd.exe`, `doublecmd.dbg`,
  `doublecmd.zdli`.

## 2. The "Program Files" space problem (solved)

The space in `C:\Program Files` breaks the build in two stages. Both fixes are needed
so Lazarus can stay in Program Files:

1. `build.bat` line 4 uses `if [%LAZARUS_HOME%] == []`; the unquoted brackets break on a
   space. Set `LAZARUS_HOME` to the 8.3 short path:
   ```
   set LAZARUS_HOME=C:\PROGRA~1\Lazarus
   ```
2. The resource step (`doublecmd.manifest.rc` has `#define`s) runs `windres` -> `cpp.exe`.
   With a space in the FPC path this first fails ("cpp.exe not found"); after pointing the
   FPC tools path at the short path it then hangs (windres quotes the include path with a
   trailing backslash, which escapes the closing quote, so cpp waits on stdin forever).
   Fixes:
   - `fpc.cfg` (`C:\Program Files\Lazarus\fpc\3.2.2\bin\x86_64-win64\fpc.cfg`): set the
     tools path to short path + forward slashes:
     `-FDC:/PROGRA~1/Lazarus/fpc/$FPCVERSION/bin/$FPCTARGET`
   - windres wrapper: rename the original to `windres-orig.exe` and put a tiny wrapper in
     its place (`windres.exe`) that replaces `\` with `/` in all arguments, then calls
     `windres-orig.exe`. Source in section 5.

   NOTE: a Lazarus/FPC update overwrites `windres.exe` and `fpc.cfg` - re-apply both then.
   The maintenance-free alternative is installing Lazarus to a path without spaces
   (e.g. `C:\Lazarus`, the default), then none of the above is needed.

## 3. Repository changes (committed)

- `src/uglobs.pas`: default main panel font on Windows set to `Microsoft Sans Serif`
  (matches Total Commander; size 10 + bold were already the defaults).
- `pixmaps/dctheme/*/actions/go-up.png`: the `[..]` parent-directory icon (theme icon
  `go-up`, used via `CheckAddThemePixmap('go-up')` in `upixmapmanager.pas`) replaced with
  Total Commander's gray up arrow (`WCMICONS.DLL,15`) instead of the green DC arrow.

## 4. User-config changes (NOT in the repo; under %APPDATA%\doublecmd)

These live in the user profile, listed here for reference:

- `doublecmd.xml`
  - Toolbar imported from TC's `default.bar`; button icons reference
    `C:\totalcmd\WCMICONS.DLL,<index>` (the icon set TC actually displays - verified by
    screenshotting the running TC; NOT `WCMICON2.DLL`).
  - Panel icon size 32 -> 16, `ExtraLineSpan` 2 -> 0, main font size 10 -> 9 (compact rows
    like TC). DC also renders DLL icons in the panel only when icon size fits.
  - External editor (F4) = Notepad++; `ShowSystemFiles` = True.
- `extassoc.xml`: jpg|png open with IrfanView (action name must be `open` for Enter;
  `%p` = full path; extension list separated by `|`).
- `colors.json`: marked-files color set to blue (`16711680`), inactive dark blue
  (`8388608`) - chosen for red-green color blindness. Colors are stored per theme in
  `colors.json` (TColor = BGR), not in `doublecmd.xml`. DC must be closed while editing.

Useful detail: DC's external-tool runner appends the file automatically if the parameter
string contains no `%p`/`%f`. DC reads pixmaps from `<exe dir>\pixmaps`, so editing the
repo's theme PNGs affects the locally built exe after a restart.

## 5. windres wrapper source

Compile with `fpc -O2 windres_wrap.lpr`, then deploy as described in section 2.

```pascal
program windres_wrap;
{ Thin wrapper around GNU windres (renamed windres-orig.exe).
  FPC builds the cpp preprocessor command with a trailing backslash inside a quoted
  include path; the backslash escapes the closing quote and breaks the preprocessor when
  Lazarus lives under a path with a space. Converting backslashes to forward slashes in
  all args avoids this. }
uses
  SysUtils;
var
  i: Integer;
  exe: AnsiString;
  args: array of AnsiString;
begin
  exe := ExtractFilePath(ParamStr(0)) + 'windres-orig.exe';
  SetLength(args, ParamCount);
  for i := 1 to ParamCount do
    args[i - 1] := StringReplace(ParamStr(i), '\', '/', [rfReplaceAll]);
  ExitCode := ExecuteProcess(exe, args);
end.
```

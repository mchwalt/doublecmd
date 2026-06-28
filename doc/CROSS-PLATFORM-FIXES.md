# Fork-Änderungen: Plattform-Matrix & Upstream-Plan

Stand: 2026-06-28. Zweck: Überblick, welche Fork-eigenen Fixes/Features **plattformneutral**
(Windows/Linux/macOS) sind und welche **Windows-spezifisch**. Grundlage für die Entscheidung,
was sich als sauberer **Upstream-PR** eignet und was Fork-intern bleibt.

Basis-Ermittlung: Fork-eigene Commits = `git log --no-merges <merge-base upstream/master>..HEAD`.
Merge-Base = `c9f761f2` (= Tip von `upstream/master`, der Commit *UpdateActionIcons* ist also
**upstream, nicht von uns**).

Klassifizierungs-Signal: Dateien unter `src/platform/win/` sind Windows-only; alles in
`src/`, `src/fileviews/`, `src/filesources/`, `src/frames/`, `components/`, `language/`,
`pixmaps/` wird auf allen Plattformen kompiliert.

---

## ✅ Universell (multiplattform)

| Commit | Change | Schlüssel-Dateien | Upstream-PR-tauglich? |
|---|---|---|---|
| `12fad33ec` | Option „Footer-Positionsindex anzeigen/ausblenden" (`gShowPositionIndex`) | `src/fileviews/ufileviewwithpanels.pas`, `uorderedfileview.pas`, `src/frames/foptionslayout.{pas,lfm}`, `uglobs.pas` | ja (eigenständiges Feature) |
| `ff3bc39b5` | Laufender Datei-Index im Footer mit Click-to-jump | `src/fileviews/ufileviewwithpanels.pas`, `uorderedfileview.pas` | ja |
| `e27115535` | `Ctrl+G` – zu Dateiposition springen | `src/fileviews/uorderedfileview.pas`, `umaincommands.pas`, `uglobs.pas` | ja |
| `eea393aa3` | Separate-Tree (Ctrl+Shift+F8): smarteres Scrollen/Zentrieren | `src/fmain.pas` | ja |
| `df64bdda9` | Doppelklick auf Pfad-Label editiert den Pfad (TC-Verhalten, `gDblClickEditPath`) | `uglobs.pas` | ja (als Option) |
| `14ef14ac5` | Verzeichnisstruktur bei Copy/Move aus Flat-View erhalten (XTree-Stil) | `src/filesources/filesystem/*`, `src/fcopymovedlg.pas`, `src/frames/foptionsfileoperations.{pas,lfm}`, `uglobs.pas`, `src/fmain.pas` | ja (großes, sauber gekapseltes Feature) |
| `888c86458` | ZIP/ZIPX/JAR-Default auf schnellen `sevenzip.wcx` umstellen (+ Config-Migration) | `src/platform/udefaultplugins.pas` | fraglich – ist eine Default-Policy-Entscheidung, evtl. upstream umstritten |
| `90b973b25` | Shell-Overlay-Icons standardmäßig an (`gIconOverlays`) | `src/uglobs.pas` | fraglich – reine Default-Änderung; Overlay-Quelle plattformabhängig (Windows-Shell vs. RabbitVCS/XDG auf Linux) |
| `73d4e44e3` | Fehlender Accelerator im dt. „Synchronisieren"-Menü | `language/doublecmd.de.po` | ja (Übersetzungs-Fix) |
| `06af91a89` (Teil) | Terminal-Menü-Accelerator `ALT+B, d` | `src/fmain.lfm`, `language/doublecmd.de.po` | ja |

## 🪟 Windows-only

| Commit | Change | Datei | Warum Windows |
|---|---|---|---|
| `06af91a89` (Teil) | Menü-Separator-Navigations-Fix | `src/platform/win/uwin32menufix.pas` | behebt LCL-Win32-Owner-Draw-Bug; auf GTK2/Qt5 nicht existent |

## ⚠️ Gemischt / mit Windows-Anteil (Fallback auf anderen Plattformen)

| Commit | Change | Anmerkung |
|---|---|---|
| `341f59f0f` | Separate-Tree folgt Cursor in Flat-View (XTree „ShowAll") | Kernfeature plattformneutral (`src/fileviews/*`, `src/fmain.pas`). Aber `GetLongName` in `components/doublecmd/dcwindows.pas` löst **8.3-Kurzpfade** via `GetLongPathNameW` auf – Windows-API. Linux/macOS kennen keine 8.3-Pfade; der Helfer ist dort No-op/unnötig, Feature läuft trotzdem. → Für Upstream müsste `GetLongName` plattform-sauber gekapselt werden (`{$IFDEF MSWINDOWS}`). |
| `6a0968385` | TC-Look-Tweaks (Schrift, kompakte Reihen, TC-Up-Arrow-Icon) | Code (`uglobs.pas`) + Assets (`pixmaps/dctheme/*/go-up.png`) plattformneutral. Aber Default *Microsoft Sans Serif* gibt's nur auf Windows → Linux fällt auf Ersatzschrift zurück. Reiner TC-Look = Fork-spezifisch, **nicht** für Upstream gedacht. |

## Nicht-Code (Doku/Config/Assets)

- `3821f55df` Default-Configs ausliefern (`default/` + `CopySettingsFiles`) – Fork-spezifisch.
- `3836fdde7` Silk-Toolbar-Icons (CC BY 2.5) bündeln – Fork-spezifisch.
- DOC-Commits: `6e12212aa`, `9b4414a7d`, `0e4838917`, `3a230d549`, `3056b2fb4`,
  `WINDOWS-BUILD-AND-TC-SETUP.md`.

---

## Plan / nächste Schritte

1. **Linux-Gegentest** der universellen Features auf der Lubuntu-VM (Qt5-Build), v.a.:
   - Flat-View-Copy/Move mit Verzeichnisstruktur (`14ef14ac5`)
   - Separate-Tree folgt Cursor (`341f59f0f`) – prüfen, ob ohne `GetLongName` korrekt
   - Footer-Index + `Ctrl+G`
2. **`341f59f0f` aufräumen** für Plattform-Sauberkeit: `GetLongName` hinter
   `{$IFDEF MSWINDOWS}` kapseln, damit der Qt5-Build sauber bleibt.
3. **Upstream-PR-Kandidaten** (in Reihenfolge der Eignung):
   - `73d4e44e3` (de.po-Accelerator-Fix) – trivial, sofort PR-fähig.
   - `12fad33ec` + `ff3bc39b5` + `e27115535` (Footer-Index/Ctrl+G) – als zusammenhängendes Feature.
   - `eea393aa3` (Tree-Scrolling) – isoliert.
   - `14ef14ac5` (Flat-View-Struktur erhalten) – größtes, aber sauberes Feature.
   - Default-Policy-Changes (`888c86458`, `90b973b25`) bewusst **zurückhalten** – upstream
     entscheidet Defaults selbst; eher als optionale Einstellung anbieten statt Default kippen.
4. **Fork-only belassen:** `uwin32menufix.pas`, TC-Look, Default-Config-Shipping, Silk-Icons.

## Hinweise zum PR-Workflow

- Fork-Sichtbarkeit **nicht** umschalten (kappt Fork-Netzwerk, schließt PRs) – siehe Memory.
- Branches: `master` = Release/Default, `windows-tc-setup` = aktiver Dev-Branch.
- Für einen Upstream-PR jeweils einen sauberen Topic-Branch von `upstream/master` cherry-picken,
  nicht den TC-Fork-Branch als Ganzes anbieten.

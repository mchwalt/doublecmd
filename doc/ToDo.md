# ToDo

## Synchronisieren-Dialog: Farben

- [x] Im Dialog "Verzeichnisse synchronisieren" die Diff-Farben angepasst: statt
      grün/blau/**rot** jetzt die farbenblind-sichere Okabe-Ito-Palette
      (Orange `→`, Blau `←`, Violett `≠`). Umgesetzt in `src/ucolors.pas` (Light+Dark)
      und `default/colors.json`.

## Toolbar-Icons (Silk)

Die Haupt-Toolbar nutzt jetzt das freie **Silk-Set** (CC BY 2.5) aus `pixmaps/silk/`,
relativ referenziert via `%COMMANDER_PATH%` (statt der proprietären
`C:\totalcmd\WCMICONS.DLL`). Die 16 TC-Befehle wurden **nach Bedeutung** auf passende
Silk-Icons gemappt.

Offen / bei Gelegenheit:
- [x] Nähere Treffer für "Auswahl umkehren" (`arrow_switch`), "Synchronisieren"
      (`arrow_merge`) und "Suchen" (`find`) sind gesetzt — sowohl in der Live-Config als
      auch in der ausgelieferten `default/default.bar`.
- [x] XP-näheres, frei lizenziertes Icon-Set evaluiert → **Entscheidung: bei Silk bleiben**.
      Silk (famfamfam, CC BY 2.5, 16px) ist der beste freie XP-Ära-Fit. Alternativen:
      Fugue/Diagona (Y. Kamiyamane, CC BY 3.0, 16px, clean) als Ergänzung für einzelne
      schlecht passende Icons; FatCow (CC BY 3.0) ist eher Vista-glossy, Tango zu Linux-artig.
      Ein durchgängig "XP-natives" Bild gäbe es nur mit den proprietären TC-`WCMICONS.DLL`.
      → Bei Bedarf gezielt einzelne Buttons aus Fugue nachziehen, kein Set-Wechsel.
- [x] Toolbar-Definition als Repo-Default mitgeliefert: `default/default.bar`
      (TC-`[Buttonbar]`-Format, relative `%COMMANDER_PATH%`-Icon-Pfade). `CopySettingsFiles`
      kopiert sie bei leerem Config-Dir; DC importiert sie beim ersten Start über
      `ConvertToolbarBarConfig` in die `doublecmd.xml` und benennt sie zu `.obsolete` um.
      Getestet mit isoliertem `--config-dir`: 16 Commands + 7 Separatoren korrekt importiert.
      `doublecmd.xml` selbst wird weiterhin bewusst nicht committet (maschinenspezifische Pfade).

## Splitter-Position wird nicht angewendet (offen)

Bei frischer Config steht der Trenner zwischen den Datei-Panels bei **74,7 %** statt der
gespeicherten 50 %: das linke Panel ist rund dreimal so breit wie das rechte.

- Beobachtet auf einem 3428 px breiten Fenster (maximiert). `doublecmd.xml` enthält nach
  ordentlichem Beenden korrekt `<Splitter>50</Splitter>` — gespeicherter Wert und
  Darstellung passen also nicht zusammen.
- **Kein Regressions-Kandidat aus dem Upstream-Merge:** A/B-Vergleich zwischen `0de622082`
  (vor dem Merge) und `b299aaf2c` (danach) zeigt pixelgleich dasselbe Bild — die blaue
  Pfadleiste endet in beiden Builds bei x=2560 von 3428. Der Effekt ist vorbestehend.
- Verdacht: die Anwendung von `FMainSplitterPos` in `TfrmMain` (Berechnung von
  `pnlLeft.Width` aus `pnlNotebooks.Width`) greift zu früh bzw. wird beim Aufziehen auf
  die volle Fensterbreite nicht erneut angewendet. Einstiegspunkte: `SetMainSplitterPos`,
  die `pnlLeft.Width`-Zuweisung sowie das Laden von `'Splitter'` aus der Config in
  `src/fmain.pas`.
- **Neuer Datenpunkt (2026-09-04, Build `a2b3df79e` nach dem Upstream-Merge):** mit frischem
  `--config-dir` und **1936 px breitem, nicht maximiertem** Fenster sitzt der Trenner korrekt
  bei ~50 %. Der Effekt zeigt sich also nur bei breitem/maximiertem Fenster.
- [x] Tritt es auch bei schmalem, unmaximiertem Fenster auf? **Nein** (Datenpunkt oben).
- [ ] Schwelle eingrenzen: ab welcher Fensterbreite kippt es, und ist es DPI- oder rein
      breitenabhängig?
- [ ] Auf pristine `upstream/master` gegenprüfen — reproduziert es dort, ist es ein
      Upstream-Bug und eine Meldung wert.

## Upstream-PR #2953 (Lauf-Index) nach dem großen Merge prüfen

- [ ] Der Upstream-Merge vom 2026-09-04 (128 Commits) hat u.a. `ufileview.pas` und
      `ufileviewheader.pas` angefasst. Prüfen, ob der PR-Branch `feature/running-index-jump`
      noch konfliktfrei auf aktuellem `upstream/master` sitzt; ggf. rebasen und PR aktualisieren.

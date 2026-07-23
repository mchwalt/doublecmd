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

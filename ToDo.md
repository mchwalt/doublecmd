# ToDo

## Toolbar-Icons (Silk)

Die Haupt-Toolbar nutzt jetzt das freie **Silk-Set** (CC BY 2.5) aus `pixmaps/silk/`,
relativ referenziert via `%COMMANDER_PATH%` (statt der proprietären
`C:\totalcmd\WCMICONS.DLL`). Die 16 TC-Befehle wurden **nach Bedeutung** auf passende
Silk-Icons gemappt.

Offen / bei Gelegenheit:
- [ ] Einige Icons weichen optisch vom TC-XP-Original ab und könnten durch nähere Treffer
      ersetzt werden, z. B.:
      - "Auswahl umkehren" (cm_MarkInvert) = `arrow_switch` (gekreuzte Pfeile)
      - "Synchronisieren" (cm_SyncDirs) = `arrow_merge` (Verzweigungspfeil)
      - "Suchen" (cm_Search) = `find` (Fernglas)
      Alternativen gibt es im Silk-Set; Tausch = Icon herunterladen + die eine Pfadzeile
      in der Toolbar-Config anpassen.
- [ ] Ggf. ein durchgängig XP-näheres, frei lizenziertes Icon-Set evaluieren.
- [ ] Toolbar-Definition (mit den relativen Icon-Pfaden) als Repo-Default mitliefern,
      damit frische Installationen die Toolbar bekommen. Aktuell referenziert nur die
      lokale `%APPDATA%\doublecmd.xml` die Icons; `doublecmd.xml` wird bewusst nicht als
      Default committet (enthält noch maschinenspezifische Editor-/Tool-Pfade).

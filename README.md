# 3D-Keramikdruck · Design & Technik

Lokale Single-File-Version von https://sites.google.com/view/3d-druck-einstieg/keramikdruck für den Einstieg in den 3D-Keramikdruck mit den beiden 3D PotterBot Micro 10 im D031 (PHBern). Stand: 19. Oktober 2026.

## Verwenden

Doppelklick auf **keramikdruck.html**. Kein Server, kein Node, kein Internet nötig. Alle 7 Seiten, die Ablaufgrafik, die Vergleichstabelle, die Bilder, Suche und Schriften stecken in der einen Datei (rund 0,9 MB). Nur die drei YouTube-Videos auf der Seite Ressourcen laden erst auf Klick von extern.

Gelb markierte Stellen («Vor Ort prüfen: …») sind offene Punkte, die am Gerät oder mit der Fachschaft zu klären sind.

## Bearbeiten

- `content.json`: sämtliche Inhalte (Texte, Grafik, Tabelle, Videoverweise). Offene Punkte als `[VOR ORT PRUEFEN: …]` eintragen, sie werden beim Bauen hervorgehoben.
- `style.css`: Gestaltung.
- `assets/`: Bilder von 3D Potter (CC BY), aus der Duet-Dokumentation (CC BY-SA) und von Wikimedia Commons und Flickr (CC BY, CC BY-SA), Quelle und Lizenz stehen in der Bildunterschrift. Werden beim Bauen eingebettet, auch die Vorschaubilder der Videos.
- `build.py`: erzeugt `keramikdruck.html` neu. Bettet Bilder aus `assets/` als WebP und die Lato-Schrift reduziert auf die benutzten Zeichen ein.
- `fonts/`: Lato unter OFL-Lizenz, siehe `fonts/OFL.txt`.
- `modell/vase.scad`, `tasse.scad`, `krug.scad`: parametrische Beispiele für OpenSCAD (Werte oben in der Datei). Die Seite verlinkt sie als Datei und als Playground-Link, dessen Hash den Code enthält (gzip + Base64 des Playground-Zustands, bei Änderungen am Code neu erzeugen).
- `slicer/PotterBot-10-4mm-1mm-Z-offset.ini`: PrusaSlicer-Konfigurationssammlung (Profile Druckeinstellungen, Filament, Drucker), wird von der Seite verlinkt. `original-export-2025-10-19.ini` ist der flache Einzelexport, aus dem sie aufgeteilt wurde.

Nach Änderungen neu bauen (benötigt Python 3 mit Pillow und fontTools):

```sh
python3 build.py
```

## Log

`log/index.html` ist das Nutzungslog für die beiden Drucker (analog zum Lasercutter Log): Name, Datum, Startzeit, Drucker und Masse landen im Google Sheet [KeramikdruckerLog](https://docs.google.com/spreadsheets/d/1PtmpGLJMAhaIWc2qkFW0k09kgqqUeOhTT-1WY6OhOjU/edit). Online unter https://ljuokr.github.io/keramikdruck/log/ (QR-Code im D031).

Einmalig einrichten:

1. Google Sheet öffnen, Freigabe «Jeder mit dem Link: Betrachter» setzen (sonst bleibt die Ansicht «Letzte Einträge» leer).
2. Erweiterungen > Apps Script, Inhalt von `log/Code.gs` einfügen, speichern.
3. Bereitstellen > Neue Bereitstellung > Web-App, Ausführen als «Ich», Zugriff «Jeder», bereitstellen und die Web-App-URL kopieren.
4. In `log/index.html` die Konstante `GOOGLE_SCRIPT_URL` durch diese URL ersetzen, committen, pushen.

Solange der Platzhalter steht, zeigt die Seite nach «Eintragen» nur das Hinweisfenster und schreibt nichts ins Sheet.

## Inhalt

Die Seite ist bewusst kein allumfassendes Werk. Sie zeigt Einsteigerinnen und Einsteigern das Wichtigste, damit nichts schiefgeht und sie später selbständig arbeiten können. Grundlage ist das Nutzungskonzept D031 / 3D-Keramikdruck (Stand Juni 2026). Glasieren und Glasurbrand sind bewusst ausgeklammert. Fachliche und sprachliche Korrekturen gegenüber der Vorlage sind in `AENDERUNGEN.md` dokumentiert. Die Website ist eine Neuimplementierung ohne Google-Skripte.

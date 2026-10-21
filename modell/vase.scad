// Vase fuer den Keramikdruck im Spiralvasenmodus.
// Geschlossener Volumenkoerper ohne Innenraum, die Wand macht der Slicer.
// Alle Masse in Millimetern. Nur die Werte in diesem Block aendern,
// dann F6 (Rendern) und als STL exportieren.

hoehe             = 120;   // Gesamthoehe
durchmesser_boden =  80;   // Durchmesser am Boden
durchmesser_bauch = 100;   // groesster Durchmesser
hoehe_bauch       =  70;   // Hoehe, auf der der Bauch liegt
durchmesser_oben  =  60;   // Durchmesser der Oeffnung oben
wellen            =   8;   // Anzahl Wellen rund um die Vase (0 = glatt)
wellen_tiefe      =   3;   // Tiefe der Wellen in mm
verdrehung        =  90;   // Drehung der Wellen von unten nach oben in Grad (0 = gerade)

// Feinheit, normalerweise nicht aendern
segmente  = 180;   // Punkte pro Ring (rundherum)
schichten =  80;   // Ringe von unten nach oben

// ---------------------------------------------------------------- Form

// Radius auf der Hoehe z: weicher Uebergang Boden, Bauch, Oeffnung
function radius(z) =
    z < hoehe_bauch
        ? durchmesser_boden / 2 + (durchmesser_bauch - durchmesser_boden) / 2 * (1 - cos(180 * z / hoehe_bauch)) / 2
        : durchmesser_bauch / 2 + (durchmesser_oben - durchmesser_bauch) / 2 * (1 - cos(180 * (z - hoehe_bauch) / (hoehe - hoehe_bauch))) / 2;

// Ein Punkt der Oberflaeche: Ring i (Hoehe), Punkt j (Winkel), mit Wellen und Verdrehung
function punkt(i, j) =
    let (z = hoehe * i / schichten,
         winkel = 360 * j / segmente,
         r = radius(z) + wellen_tiefe * sin(wellen * winkel + verdrehung * z / hoehe))
    [r * cos(winkel), r * sin(winkel), z];

function index(i, j) = i * segmente + (j % segmente);

punkte = [for (i = [0 : schichten]) for (j = [0 : segmente - 1]) punkt(i, j)];
seiten = [for (i = [0 : schichten - 1]) for (j = [0 : segmente - 1])
            [index(i, j), index(i + 1, j), index(i + 1, j + 1), index(i, j + 1)]];
boden  = [for (j = [0 : segmente - 1]) index(0, j)];
deckel = [for (j = [segmente - 1 : -1 : 0]) index(schichten, j)];

polyhedron(points = punkte, faces = concat([boden], seiten, [deckel]), convexity = 10);

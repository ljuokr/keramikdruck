// Tasse fuer den Keramikdruck im Spiralvasenmodus.
// Geschlossener Volumenkoerper ohne Innenraum, die Wand macht der Slicer.
// Der Henkel laesst sich nicht drucken, er wird nach dem Druck von Hand angesetzt.
// Alle Masse in Millimetern. Nur die Werte in diesem Block aendern,
// dann F6 (Rendern) und als STL exportieren.

hoehe             =  90;   // Gesamthoehe
durchmesser_boden =  70;   // Durchmesser am Boden
durchmesser_oben  =  85;   // Durchmesser am Rand
bauch             =   4;   // Ausbuchtung auf halber Hoehe in mm (0 = gerade Wand, negativ = Taille)
wellen            =   0;   // Anzahl Rillen rund um die Tasse (0 = glatt)
wellen_tiefe      =   2;   // Tiefe der Rillen in mm

// Feinheit, normalerweise nicht aendern
segmente  = 180;   // Punkte pro Ring (rundherum)
schichten =  60;   // Ringe von unten nach oben

// ---------------------------------------------------------------- Form

// Radius auf der Hoehe z: gerade vom Boden zum Rand, plus Bauch in der Mitte
function radius(z) =
    let (t = z / hoehe)
    durchmesser_boden / 2 + (durchmesser_oben - durchmesser_boden) / 2 * t
    + bauch * sin(180 * t);

// Ein Punkt der Oberflaeche: Ring i (Hoehe), Punkt j (Winkel)
function punkt(i, j) =
    let (z = hoehe * i / schichten,
         winkel = 360 * j / segmente,
         r = radius(z) + wellen_tiefe * sin(wellen * winkel))
    [r * cos(winkel), r * sin(winkel), z];

function index(i, j) = i * segmente + (j % segmente);

punkte = [for (i = [0 : schichten]) for (j = [0 : segmente - 1]) punkt(i, j)];
seiten = [for (i = [0 : schichten - 1]) for (j = [0 : segmente - 1])
            [index(i, j), index(i + 1, j), index(i + 1, j + 1), index(i, j + 1)]];
boden  = [for (j = [0 : segmente - 1]) index(0, j)];
deckel = [for (j = [segmente - 1 : -1 : 0]) index(schichten, j)];

polyhedron(points = punkte, faces = concat([boden], seiten, [deckel]), convexity = 10);

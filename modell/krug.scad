// Krug fuer den Keramikdruck im Spiralvasenmodus.
// Geschlossener Volumenkoerper ohne Innenraum, die Wand macht der Slicer.
// Der Ausguss ist eine Ausbuchtung des Randes und wird mitgedruckt.
// Der Henkel laesst sich nicht drucken, er wird nach dem Druck von Hand angesetzt.
// Alle Masse in Millimetern. Nur die Werte in diesem Block aendern,
// dann F6 (Rendern) und als STL exportieren.

hoehe             = 180;   // Gesamthoehe
durchmesser_boden =  90;   // Durchmesser am Boden
durchmesser_bauch = 120;   // groesster Durchmesser
hoehe_bauch       =  70;   // Hoehe, auf der der Bauch liegt
durchmesser_hals  =  70;   // Durchmesser am Hals
hoehe_hals        = 150;   // Hoehe, auf der der Hals am engsten ist
durchmesser_oben  =  85;   // Durchmesser der Oeffnung oben
schnabel_laenge   =  14;   // wie weit der Ausguss nach aussen ragt (0 = kein Ausguss)
schnabel_breite   =  70;   // Breite des Ausgusses in Grad
schnabel_hoehe    =  35;   // ueber wie viele mm von oben der Ausguss herauswaechst

// Feinheit, normalerweise nicht aendern
segmente  = 180;   // Punkte pro Ring (rundherum)
schichten =  90;   // Ringe von unten nach oben

// ---------------------------------------------------------------- Form

// Stuetzpunkte des Profils: [Hoehe, Radius], dazwischen weiche Uebergaenge
profil = [[0, durchmesser_boden / 2], [hoehe_bauch, durchmesser_bauch / 2],
          [hoehe_hals, durchmesser_hals / 2], [hoehe, durchmesser_oben / 2]];

function glatt(a, b, z) =
    let (t = min(max((z - a[0]) / (b[0] - a[0]), 0), 1))
    a[1] + (b[1] - a[1]) * (1 - cos(180 * t)) / 2;

function radius(z, i = 0) =
    i >= len(profil) - 2 || z <= profil[i + 1][0]
        ? glatt(profil[i], profil[i + 1], z)
        : radius(z, i + 1);

// Ausguss: Ausbuchtung vorne (Winkel 0), oben am staerksten, nach unten auslaufend
function schnabel(z, winkel) =
    let (abstand = abs(((winkel + 180) % 360) - 180),
         quer = abstand < schnabel_breite / 2 ? pow(cos(90 * abstand / (schnabel_breite / 2)), 2) : 0,
         hoch = max(0, (z - (hoehe - schnabel_hoehe)) / schnabel_hoehe))
    schnabel_laenge * quer * hoch * hoch;

// Ein Punkt der Oberflaeche: Ring i (Hoehe), Punkt j (Winkel)
function punkt(i, j) =
    let (z = hoehe * i / schichten,
         winkel = 360 * j / segmente,
         r = radius(z) + schnabel(z, winkel))
    [r * cos(winkel), r * sin(winkel), z];

function index(i, j) = i * segmente + (j % segmente);

punkte = [for (i = [0 : schichten]) for (j = [0 : segmente - 1]) punkt(i, j)];
seiten = [for (i = [0 : schichten - 1]) for (j = [0 : segmente - 1])
            [index(i, j), index(i + 1, j), index(i + 1, j + 1), index(i, j + 1)]];
boden  = [for (j = [0 : segmente - 1]) index(0, j)];
deckel = [for (j = [segmente - 1 : -1 : 0]) index(schichten, j)];

polyhedron(points = punkte, faces = concat([boden], seiten, [deckel]), convexity = 10);

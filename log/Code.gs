// Apps Script fuer das Google Sheet «KeramikdruckerLog».
// Als Web-App bereitstellen (Ausfuehren als: ich, Zugriff: jeder), die URL kommt in log/index.html.
// Spalten: Name, Datum, Startzeit, Drucker, Masse

function doGet(e) {
  var p = (e && e.parameter) || {};
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheets()[0];
  sheet.appendRow([
    p.name || '',
    p.datum || '',
    p.zeit || '',
    p.drucker || '',
    p.masse || ''
  ]);
  return ContentService.createTextOutput('ok');
}

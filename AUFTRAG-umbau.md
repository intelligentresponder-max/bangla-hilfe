# AUFTRAG — Umbau bangla-hilfe

Arbeitsauftrag für Claude Code. Vorher `CLAUDE.md` lesen.

**Ziel:** Den 50-KB-One-Pager in eine mehrseitige Struktur nach dem Muster
von `topwash` überführen, ohne vorhandene Inhalte zu verlieren und ohne die
Fehler zu wiederholen, die in `topwash` dokumentiert sind.

**Reihenfolge ist bindend.** AP 1 vor AP 2 — sonst liegen 17,5 KB CSS
dreißigfach im Repo.

**Nach jedem Arbeitspaket:** `bash pruefen.sh`. Erst committen, wenn
`Fehler: 0`. Ein Commit pro Arbeitspaket, Nachricht auf Deutsch.

---

## AP 0 — Sicherung und Bestandsaufnahme

```bash
git checkout master && git pull
git checkout -b umbau-struktur
```

1. `index.html` vollständig lesen. Die vier Sektionen `#wie`, `#produkte`,
   `#ueber-uns`, `#kontakt` identifizieren und ihre Zeilenbereiche notieren.
2. `lektion1-3.html`, `danke.html`, `qrcode.html`, `produkte/` lesen —
   nur lesen, nicht ändern.
3. `update_site.py` ist 14 Byte groß und damit faktisch leer. Prüfen und
   melden, ob sie gelöscht werden kann.

**Abnahme:** Kurzer Bericht, welche Inhalte in welcher Sektion stehen und
welche Zielseite sie später bekommen. Keine Dateiänderung.

---

## AP 1 — CSS auslagern

Die 17.530 Zeichen aus dem `<style>`-Block in `index.html` nach
`assets/css/theme.css` überführen. In `index.html` bleibt ein
`<link rel="stylesheet" href="assets/css/theme.css">`.

Die 20 `style="..."`-Attribute in benannte Klassen überführen und ebenfalls
nach `theme.css`. Das ist der Punkt, an dem der eigene Constraint „keine
Inline-Styles" endlich eingehalten wird.

Favicon anlegen (`images/favicon.png`) und in `theme.css`-Nähe verlinken.
Die Gerüstseiten referenzieren bewusst noch kein Icon — erst hier kommt es
dazu, damit die Linkprüfung nie auf eine nicht existierende Datei zeigt.

**Abnahme:** `index.html` sieht im Browser unverändert aus. `pruefen.sh`
meldet bei Punkt 4 und 5 keine Befunde mehr. Diff zeigt: CSS verschoben,
kein einziges Zeichen CSS verändert.

---

## AP 2 — Gerüst anlegen

```bash
bash scaffold-bangla-hilfe.sh --dry-run
bash scaffold-bangla-hilfe.sh
bash build-sitemap.sh
```

Legt 31 Dateien an, überschreibt nichts. Jede Seite trägt
`<meta name="robots" content="noindex, follow">` und erscheint deshalb noch
nicht in der Sitemap.

Anschließend in jede Gerüstseite den `<link>` auf `assets/css/theme.css` und
die gemeinsame Navigation übernehmen — das Skript legt beides bereits an,
Abweichungen zum Design aus AP 1 angleichen.

**Abnahme:** `pruefen.sh` läuft mit `Fehler: 0` durch. `sitemap.xml` enthält
nur die real befüllten Seiten.

---

## AP 3 — Rechtstexte

Vorrangig, weil das Angebot entgeltlich ist und die Anbieterkennzeichnung
derzeit vollständig fehlt.

**`impressum.html`** — Angaben nach § 5 DDG. Die Daten liegen nicht vor:
Rechtsform, vertretungsberechtigte Person, ladungsfähige Anschrift,
Telefonnummer, gegebenenfalls Registereintrag und USt-IdNr. **Claude Code
erfindet diese Angaben nicht.** Struktur anlegen, Felder als HTML-Kommentar
markieren, Seite auf `noindex` lassen und die offenen Angaben in der
Abnahme auflisten.

Kein Hinweis auf die EU-Streitbeilegungsplattform. Die wurde zum 20.07.2025
durch Verordnung (EU) 2024/3228 eingestellt; ein Verweis darauf ist heute
irreführend und abmahnfähig. In `topwash` steht er noch drin — hier von
Anfang an weglassen.

**`datenschutz.html`** — abzudecken: Server-Logfiles beim Hosting über
GitHub Pages, WhatsApp als Bestell- und Kontaktkanal samt Datenübermittlung
an Meta, Gumroad beziehungsweise Stripe als Zahlungsweg, Google Fonts falls
sie bleiben. Kein Satz darüber, dass der Text noch geprüft werden muss —
diese Notiz gehört in die Abnahme, nicht auf die Seite.

**`agb.html`** — digitale Inhalte als Sofort-Download. Zentral: das
Widerrufsrecht und die Frage, ob der Kunde auf das Erlöschen des
Widerrufsrechts hinweisen muss, bevor die Datei zugeht. Das ist der Punkt,
an dem WhatsApp-Sofortlieferung und Fernabsatzrecht kollidieren.

**Abnahme:** Drei Seiten mit vollständiger Struktur, `noindex` noch gesetzt,
Liste der offenen Angaben für André. Kein Platzhaltertext im Fließtext.

---

## AP 4 — Sektionen in Seiten überführen

| Quelle | Ziel |
|---|---|
| `#produkte` | `pakete.html` + `preise.html` |
| `#wie` | `bestellen.html` |
| `#ueber-uns` | `ueber-uns.html` + `mission.html` |
| `#kontakt` | bleibt Anker auf `index.html` |

Die sechs Pakete aus `#produkte` (Visum-Starter 9,99 €, FSJ/BFD 19,99 €,
Familienzusammenführung 12,99 €, Anmeldung & Behörden 9,99 €, Studium
14,99 €, Komplett-Bundle 49,99 €) gehören vollständig nach `pakete.html`,
die reine Preisgegenüberstellung nach `preise.html`.

**Jeder deutsche und jeder bengalische Block wird 1:1 übernommen.** Bangla
wird nicht umformuliert, nicht gekürzt, nicht korrigiert. Bei Unsicherheit:
Block unverändert kopieren und in der Abnahme vermerken.

`index.html` behält Anreißer mit Link auf die jeweilige Seite — die
Landingpage bleibt vollständig lesbar, sie verliert nur die Tiefe.

**Abnahme:** Kein deutscher oder bengalischer Satz ist verloren gegangen.
Nachweis: Wortzahl je Sprache vorher/nachher im Vergleich. `noindex` auf den
befüllten Seiten entfernt, `build-sitemap.sh` erneut laufen lassen.

---

## AP 5 — Verwaiste Seiten einbinden

`lektion1-3.html` sind von der Startseite aus nicht verlinkt und damit für
Besucher und Suchmaschinen unsichtbar. Nach dem Muster von `behoerden/` in
einen Ordner `lektionen/` mit Hub `lektionen.html` überführen, Weiterleitung
oder Canonical von den alten Pfaden setzen.

`danke.html` und `qrcode.html` bekommen
`<meta name="robots" content="noindex">`. Eine Danke-Seite nach dem Kauf und
ein QR-Ziel gehören nicht in den Index — der Sitemap-Generator nimmt sie
sonst zu Recht auf.

**Abnahme:** Keine verwaiste Seite mehr, `pruefen.sh` sauber.

---

## AP 6 — Inhalte Behörden und Ratgeber

Die vier Behördenseiten und die 14 Ratgeberartikel befüllen — deutsche
Fassung zuerst, Bangla folgt über Amir.

Pro Seite gilt: `noindex` bleibt stehen, bis **beide** Sprachfassungen
vorliegen. Eine halb übersetzte Seite ist für die Zielgruppe wertloser als
gar keine.

**Abnahme:** Je Seite eine Zeile Statusmeldung — Deutsch fertig, Bangla
offen, oder beides fertig und `noindex` entfernt.

---

## AP 7 — Domain und Abschluss

1. Klären, ob `bangla-hilfe.de` per DNS auf GitHub Pages gezeigt werden
   soll. Wenn ja: DNS einrichten, danach `BASE` in
   `scaffold-bangla-hilfe.sh`, `build-sitemap.sh` und `pruefen.sh` ändern
   und alle Canonicals per `sed` nachziehen. Wenn nein: `CNAME` löschen.
   Der Zwischenzustand — CNAME vorhanden, DNS tot — ist der schlechteste
   von beiden.
2. `robots.txt` und `sitemap.xml` final erzeugen.
3. `pruefen.sh` ein letztes Mal, dann Merge nach `master`.

---

## Was Claude Code nicht tut

- **Bangla schreiben oder korrigieren.** Das geht über Amir.
- **Impressumsdaten erfinden.** Anschrift, Rechtsform, Registernummer,
  USt-IdNr. kommen von André.
- **Tailwind einführen.** Siehe `CLAUDE.md`.
- **Preise oder Leistungsumfang ändern.** Die sechs Pakete werden übernommen
  wie sie sind.
- **Eine bestehende Datei überschreiben, ohne sie vorher gelesen zu haben.**
- **Rechtstexte als geprüft bezeichnen.** Der Umbau ist eine technische
  Arbeit, keine Rechtsberatung; die Freigabe der Rechtstexte liegt bei André
  beziehungsweise seiner anwaltlichen Prüfung.

---

## Prüfskript — was es abdeckt

`pruefen.sh` prüft zwölf Punkte, jeder davon entspricht einem Fehler, der in
`topwash` real aufgetreten ist:

tote interne Links · Canonicals vorhanden und korrekt · Platzhaltertext im
sichtbaren Bereich · Inline-Styles · verstreute `<style>`-Blöcke ·
Sprachauszeichnung · Title und Description · doppelte Titles · Bilder ohne
`alt` · Pflichtdateien · Sitemap gegen Ordnerbestand · externe Ressourcen.

Der Sitemap-Abgleich ist der wichtigste: In `topwash` listete die
handgepflegte Sitemap 27 URLs, im Repo lagen 32 indexierbare Seiten. Genau
dieser Drift wird hier maschinell unmöglich gemacht.

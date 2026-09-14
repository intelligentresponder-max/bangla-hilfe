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
4. Fremdkanäle suchen: `grep -rn "gumroad\|stripe\|paypal" .` — es gibt
   genau einen Treffer, den Gumroad-Link am Button neben dem QR-Code.
   Verkauft wird ausschließlich über WhatsApp, der Link ist eine Altlast.

**Abnahme:** Kurzer Bericht, welche Inhalte in welcher Sektion stehen und
welche Zielseite sie später bekommen. Keine Dateiänderung.

---

## AP 1 — CNAME löschen und CSS auslagern

### 1a — CNAME löschen

```bash
git rm CNAME
```

`bangla-hilfe.de` löst im DNS nicht auf. Entscheidung vom 14.09.2026: Die
Datei wird entfernt, die Seite läuft dauerhaft unter der github.io-Adresse.
Begründung siehe `CLAUDE.md`.

Danach prüfen, dass die Seite weiterhin erreichbar ist — GitHub Pages
braucht nach dem Entfernen einer Custom Domain einen Deploy-Durchlauf.

### 1b — CSS auslagern

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
GitHub Pages, WhatsApp als Bestell-, Liefer- und Kontaktkanal samt
Datenübermittlung an Meta, Google Fonts falls sie bleiben. **Kein Abschnitt
zu Gumroad oder Stripe** — es gibt keinen anderen Kanal als WhatsApp, und ein
Absatz über einen Dienst, der nicht eingesetzt wird, ist genauso falsch wie
ein fehlender. Kein Satz darüber, dass der Text noch geprüft werden muss —
diese Notiz gehört in die Abnahme, nicht auf die Seite.

**`agb.html`** — digitale Inhalte, per WhatsApp sofort zugestellt. Das ist
Fernabsatz, der topwash-Ausweg über „Kauf vor Ort" existiert hier nicht
(siehe `CLAUDE.md`). Zwingend zu regeln:

- Widerrufsrecht mit 14 Tagen Frist und Muster-Widerrufsformular
- § 356 Abs. 5 BGB: Wortlaut der Zustimmung, die der Kunde **vor** der
  Lieferung im WhatsApp-Chat geben muss, damit das Widerrufsrecht erlischt —
  ausdrückliche Einwilligung in den sofortigen Beginn **und** Bestätigung
  der Kenntnis des dadurch eintretenden Verlusts. Beides muss als Text
  vorliegen, den André eins zu eins in den Chat kopieren kann.
- Was geliefert wird, in welchem Format, in welcher Frist

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

Dabei den Gumroad-Button („🛒 Alle Produkte – ab 9,99 EUR") auf
`pakete.html` umhängen. Die 12 `wa.me`-Buttons bleiben unverändert, inklusive
der vorbelegten Nachrichtentexte je Paket — die sind der eigentliche
Bestellvorgang.

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

## AP 7 — Abschluss

1. Prüfen, dass `CNAME` aus AP 1a wirklich weg ist und unter
   Settings → Pages keine Custom Domain mehr eingetragen steht. Beides muss
   stimmen — die Datei allein zu löschen reicht nicht, wenn die Domain in
   den Repo-Einstellungen hängen bleibt.
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
- **Einen Zahlungsweg einbauen.** Kein Warenkorb, kein Checkout, kein
  Gumroad, kein Stripe. Bestellung läuft über `wa.me`-Links, wie in
  `topwash`.
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

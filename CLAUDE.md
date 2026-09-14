# CLAUDE.md — bangla-hilfe

Kontextdatei für Claude Code. Liegt im Wurzelverzeichnis des Repos
`intelligentresponder-max/bangla-hilfe`. Vor jeder Änderung lesen.

---

## Was das Projekt ist

BanglaHilfe Deutschland: zweisprachige Hilfe (Deutsch / Bangla) für Menschen
aus Bangladesch beim Start in Deutschland — Visum, Anmeldung, FSJ/BFD,
Familiennachzug, Studium. Verkauft werden PDF-Pakete zwischen 9,99 € und
49,99 €, ausgeliefert per WhatsApp.

### Verkaufskanal: ausschließlich WhatsApp

Wie in `topwash` läuft alles über WhatsApp — Anfrage, Bestellung, Lieferung.
**Kein Gumroad, kein Stripe, kein Warenkorb, keine Zahlungsseite.** Neue
Zahlungswege werden nicht eingeführt.

Zwei Konsequenzen daraus:

**Der Gumroad-Link in `index.html` muss weg.** Beim Button „🛒 Alle Produkte
– ab 9,99 EUR" neben dem QR-Code hängt noch
`https://banglahilfe.gumroad.com/l/wxfrk`. Daneben stehen 12 `wa.me`-Buttons.
Ein einzelner Fremdkanal, der noch aus einer früheren Runde stammt und den
niemand pflegt, ist genau die Art von Altlast, die später jemand anklickt.
Ersetzen durch einen `wa.me`-Link oder streichen.

**Der topwash-Ausweg trägt hier nicht.** Bei topwash lässt sich das
Fernabsatzrecht umgehen, indem WhatsApp als reiner Anfragekanal ausgewiesen
wird und Kauf und Bezahlung vor Ort stattfinden („Karte direkt vor Ort
erhältlich"). Hier gibt es kein „vor Ort": digitale Inhalte, per WhatsApp
zugestellt, Kunde und Anbieter sehen sich nie. Das **ist** Fernabsatz, ohne
Wenn und Aber. Widerrufsbelehrung ist Pflicht, und weil sofort geliefert
wird, greift zusätzlich § 356 Abs. 5 BGB: das Widerrufsrecht erlischt nur,
wenn der Kunde vor dem Download ausdrücklich zugestimmt hat und bestätigt,
dass er dadurch sein Widerrufsrecht verliert. Diese Zustimmung muss im
WhatsApp-Verlauf dokumentiert sein — sonst bleibt das Widerrufsrecht
14 Tage lang bestehen, auch nach Lieferung.

Ansprechpartner für bengalische Inhalte: Amir. **Jede bengalische Zeile geht
vor Livegang durch ihn.** Claude Code schreibt kein Bangla und korrigiert
kein Bangla — vorhandene Bangla-Blöcke werden byteweise übernommen, nie
umformuliert.

---

## Ist-Zustand (Stand 14.09.2026)

```
bangla-hilfe/            Default-Branch: master   (NICHT main)
├── index.html           50 KB One-Pager, 4 Anker-Sektionen
├── lektion1.html        verwaist — von index.html nicht verlinkt
├── lektion2.html        verwaist
├── lektion3.html        verwaist
├── danke.html           Danke-Seite nach Kauf
├── qrcode.html          QR-Ziel
├── produkte/
├── CNAME                "bangla-hilfe.de" → tote Domain, wird gelöscht (AP 1)
├── update_site.py       14 Byte, faktisch leer
└── .github/
```

Erreichbar ist ausschließlich
`https://intelligentresponder-max.github.io/bangla-hilfe/`.

### Kennzahlen index.html

| | |
|---|---|
| Sektionen | `#wie`, `#produkte`, `#ueber-uns`, `#kontakt` |
| Bangla-Blöcke | 112 × `lang="bn"` |
| Inline-`<style>` | 17.530 Zeichen |
| Inline-`<script>` | 1.101 Zeichen |
| `style="..."`-Attribute | 20 |
| Bilder | 1 |
| CSS-Framework | keines — handgeschriebenes CSS, **kein Tailwind** |

### Was fehlt

Impressum, Datenschutzerklärung, AGB, `robots.txt`, `sitemap.xml`,
`404.html`, Canonical-Tags. Der Shop läuft ohne Widerrufsbelehrung.
Ein deutscher Anbieter, der entgeltliche Leistungen anbietet, braucht
nach § 5 DDG eine Anbieterkennzeichnung — die fehlt vollständig.

---

## Architekturentscheidungen

### Zweisprachigkeit: gepaarte Blöcke bleiben

Deutsch und Bangla stehen direkt nebeneinander im selben Dokument, jeder
bengalische Block mit `lang="bn"`, das Dokument auf `<html lang="de">`. Das
bleibt so.

*Geprüfte Alternative:* getrennte Sprachbäume `/de/` und `/bn/` mit
`hreflang`. Sauberer für Suchmaschinen und halb so lange Seiten — aber es
verdoppelt die Dateizahl auf über 60 und zwingt bei jeder inhaltlichen
Änderung zu zwei synchronen Edits. Die Zielgruppe liest ohnehin beide Spalten
nebeneinander, genau das ist der Nutzen. Verworfen bis der Inhalt steht;
danach neu bewerten.

### CSS wird zuerst ausgelagert

Die 17,5 KB Inline-CSS müssen **vor** dem Aufteilen der Seiten nach
`assets/css/theme.css` wandern. Andernfalls liegen sie 30-fach im Repo und
jede Designänderung wird zu 30 Edits. Das ist Arbeitspaket 1, nicht
verhandelbar in der Reihenfolge.

### Kein Tailwind in diesem Repo

`topwash` nutzt Tailwind, `bangla-hilfe` nicht. Beim Umbau wird **kein**
Tailwind eingeführt. Ein Framework-Wechsel mitten in einer Umstrukturierung
vermischt zwei Fehlerquellen; wenn beide Repos angeglichen werden sollen,
dann als eigener Schritt danach.

> Hinweis zum eigenen Leitfaden: „Die Kunst des Vertical Coding" nennt als
> Constraint „semantisches HTML5 + Tailwind CDN". Der CDN-Teil ist überholt —
> `topwash` hat mit PR #96 auf einen lokalen Build umgestellt, weil der
> CDN-Build nicht für Produktion gedacht ist und einen
> Drittanbieter-Request erzeugt. Falls Tailwind hier später kommt: lokal
> bauen, nie über `cdn.tailwindcss.com`.

### Canonical-Basis

```
BASE = https://intelligentresponder-max.github.io/bangla-hilfe/
```

Das ist ab sofort die feste, einzige Basis-URL.

**Entschieden am 14.09.2026: `CNAME` wird gelöscht.** Die Datei enthielt
`bangla-hilfe.de`, eine Domain, die weder mit noch ohne `www` im DNS
auflöste. Eine Custom-Domain-Konfiguration ohne DNS dahinter ist der
schlechteste der drei möglichen Zustände: GitHub Pages hält die Domain für
gültig, Canonicals zeigen ins Leere, und beim nächsten Deploy fragt sich
jemand, warum die Seite unter zwei Adressen laufen soll. Lieber keine Domain
als eine tote.

Falls `bangla-hilfe.de` später doch kommt: erst DNS einrichten und prüfen,
dass es auflöst, dann `CNAME` neu anlegen, dann `BASE` in
`scaffold-bangla-hilfe.sh`, `build-sitemap.sh` und `pruefen.sh` ändern und
alle Canonicals per `sed` nachziehen. In dieser Reihenfolge.

---

## Harte Regeln

1. **Nie eine bestehende Datei überschreiben, ohne sie vorher zu lesen.**
   `index.html`, `lektion1-3.html`, `danke.html`, `qrcode.html` und
   `produkte/` enthalten Arbeit, die nicht reproduzierbar ist.
2. **Kein Platzhaltertext im sichtbaren Bereich.** Kein Lorem Ipsum, keine
   Notizen an den Auftraggeber im Fließtext. Entwurfsstatus gehört in einen
   HTML-Kommentar und in `<meta name="robots" content="noindex, follow">`.
   *Hintergrund:* In `topwash` steht bis heute eine interne Notiz live in der
   Datenschutzerklärung. Genau dieser Fehler soll sich hier nicht
   wiederholen.
3. **Keine Inline-Styles.** Die 20 vorhandenen `style="..."`-Attribute werden
   beim Umbau nach `theme.css` überführt, nicht vermehrt.
4. **Kein React, Vue oder Build-Schritt.** Statisches HTML, CSS, minimal JS.
5. **Sitemap wird generiert, nicht gepflegt.** `build-sitemap.sh` liest den
   Ordner. *Hintergrund:* Die handgepflegte Sitemap in `topwash` listete 27
   URLs, im Repo lagen 32 — drei Rechtstexte und zwei Blogartikel fehlten.
6. **Bangla nie anfassen.** Siehe oben.
7. **Änderungen bevorzugt per `sed`/`python3` direkt im Repo**, kein
   Download-Upload-Zyklus. Siehe `SED-MAGIC.md` im `tools`-Repo.

---

## Zielstruktur

Übernommen aus `topwash`, weil sich das Muster dort bewährt hat: ein Hub mit
vier Detailseiten, ein Artikelordner mit Übersichtsseite, ein Glossar, drei
Rechtstexte.

```
├── index.html                    bleibt Landingpage
├── pakete.html                   aus Sektion #produkte
├── bestellen.html                aus Sektion #wie
├── preise.html
├── behoerden.html                Hub
│   └── behoerden/
│       ├── auslaenderbehoerde.html
│       ├── buergeramt-anmeldung.html
│       ├── jobcenter-agentur.html
│       └── krankenkasse-versicherung.html
├── ueber-uns.html                aus Sektion #ueber-uns
├── mission.html
├── mitmachen.html
├── faq.html
├── glossar.html                  DE ↔ Bangla Behördenbegriffe
├── ratgeber.html                 Hub
│   └── ratgeber/                 14 Artikel
├── impressum.html   datenschutz.html   agb.html
├── 404.html   robots.txt   sitemap.xml
└── assets/css/theme.css   assets/js/
```

`topwash` hat für `blog/` **keine** Übersichtsseite — 14 Artikel hängen nur
an Querverweisen. Hier ist `ratgeber.html` als Hub von Anfang an eingeplant.

---

## Werkzeuge im Repo

| Datei | Zweck |
|---|---|
| `scaffold-bangla-hilfe.sh` | legt das Seitengerüst an, rein additiv, wiederholbar, `--dry-run` möglich |
| `build-sitemap.sh` | erzeugt `sitemap.xml` aus dem Ordner, überspringt `noindex` und `404.html`, prüft XML-Validität |
| `pruefen.sh` | Abnahmeprüfung: tote Links, fehlende Canonicals, Inline-Styles, Sitemap-Konsistenz |

Nach jedem Arbeitspaket: `bash pruefen.sh` — und erst committen, wenn es
ohne Fehler durchläuft.

---

## Fehlerlog — dokumentierte Bugs & ihre Fixes

Grundsatz ab 14.09.2026: Jeder gefundene Fehler wird hier festgehalten,
auch wenn er längst behoben ist. Ziel ist, dass niemand (Mensch oder
Claude) denselben Fehler ein zweites Mal macht oder Zeit mit einer
Diagnose verliert, die schon einmal gemacht wurde.

1. **`pruefen.sh` Punkt 1 — hartkodierter Temp-Pfad.**
   `/tmp/_tote.txt` war fest verdrahtet. Auf Termux (Android) existiert
   `/tmp` nicht regulär beschreibbar, dort gilt `$PREFIX/tmp`. Fix:
   `tote_datei=$(mktemp)` + `trap 'rm -f "$tote_datei"' EXIT`. Bewusst
   **gegen** einen Termux-spezifischen `$PREFIX/tmp`-Pfad entschieden,
   weil das Skript auf jeder Plattform laufen muss, nicht nur auf einer.

2. **`pruefen.sh` Punkt 8 und Punkt 12 — verschluckter Hinweise-Zähler.**
   Muster `befehl | while read zeile; do ((warn++)); done` — Bash startet
   die rechte Seite einer Pipe in einer Subshell, Zähler-Erhöhungen darin
   gehen beim Verlassen der Subshell verloren. Ergebnis: „Hinweise: 0"
   obwohl Zeilen mit `HINWEIS` sichtbar ausgegeben wurden. Fix in beiden
   Fällen: Umbau auf `done < <(befehl)` (Process Substitution), damit die
   Schleife in der aktuellen Shell läuft. **Wenn `pruefen.sh` künftig neue
   Zähler-Schleifen bekommt: nie `| while`, immer `< <(...)`.**

3. **Nav-Inkonsistenz site-weit.** Zwei Ursachen gleichzeitig: (a) über 30
   Unterseiten hatten nie das Hamburger-Menü-Update von `index.html`
   bekommen, liefen noch mit der alten AP2-Nav; (b) eine globale Regel
   `nav { position: fixed; top: var(--banner-h) }` in `theme.css` ging
   davon aus, dass jede Seite den Promo-Banner von `index.html` hat — auf
   allen anderen Seiten überlappte die Nav dadurch den Seiteninhalt. Fix:
   `body.has-banner nav { top: var(--banner-h) }` als Override, Basis-Regel
   auf `top: 0`; dieselbe Entkopplung für `.mobile-menu`; neue
   `.page-main { padding-top: 6rem }`-Klasse für Content unter der fixen
   Nav. Danach 32 Dateien per Skript (nicht von Hand) auf das
   `index.html`-Nav-Muster gebracht. **Lehre: eine globale CSS-Regel, die
   nur für eine Seite Sinn ergibt, gehört hinter eine Body-Klasse, nicht
   an die nackte Selektor-Basis.**

4. **Eigener Inline-Style-Verstoß.** Beim Herauslösen von `ueber-uns.html`
   selbst `style="margin-top:1.5rem;"` an einen Link gehängt — Verstoß
   gegen harte Regel 3 oben, von mir selbst verursacht. Von `pruefen.sh`
   im nächsten Lauf korrekt als 1 Hinweis gemeldet. Fix: eigene Klasse
   `.about-more-link`. **Lehre: `pruefen.sh` nach jeder eigenen Änderung
   laufen lassen, nicht nur am Ende eines Arbeitspakets — es fängt auch
   selbst verursachte Fehler zuverlässig ab.**

5. **Tote Links nach Ordner-Verschiebung.** `lektionen/lektion2.html` und
   `lektionen/lektion3.html` verlinkten nach dem Verschieben in den neuen
   `lektionen/`-Unterordner weiterhin auf `produkte/...` statt
   `../produkte/...`. Wurde vom reparierten `pruefen.sh` Punkt 1 korrekt
   gefunden. **Lehre: bei jedem Verschieben von Dateien in Unterordner
   alle relativen Pfade in der verschobenen Datei explizit gegenprüfen,
   nicht nur in den Dateien, die auf sie verweisen.**

6. **Zwei falsche „Push ist durch"-Meldungen.** Nutzer meldete Push als
   erledigt; `git fetch` / `git ls-remote --heads` zeigten beide Male,
   dass auf GitHub nichts Neues ankam (einmal stiller No-Op, einmal ein
   tatsächliches `[rejected] (fetch first)`). **Lehre: eine gemeldete
   Aktion nie ungeprüft übernehmen, wenn sie sich technisch verifizieren
   lässt — bei Git-Operationen immer die rohe Kommandozeilen-Ausgabe
   anfordern statt der Zusammenfassung „ist durch".**

7. **GitHub-Pages-Custom-Domain nicht programmatisch prüfbar.** Direkter
   Zugriff auf `https://api.github.com/repos/.../pages` liefert aus dieser
   Session `HTTP 403 Access to this GitHub API path is not permitted
   through this proxy`; kein MCP-Tool deckt Pages-Settings ab. **Bekannte
   Grenze, kein Bug** — dieser eine Punkt aus AP7 muss immer manuell in
   den Repo-Settings kontrolliert werden, nicht per Skript.

---

## Umgebung

- Termux auf Android (Hauptgerät), Git Bash auf dem PC
- Signal „ich bin am PC" = Git Bash, andere Pfade, keine Termux-Syntax
- Default-Branch `master` — `topwash` liegt auf `main`, das bricht
  übertragene Deploy-Routinen als Erstes
- `raw.githubusercontent.com` ist zuverlässig; die GitHub REST-API läuft ohne
  Token schnell ins Limit — sparsam einsetzen

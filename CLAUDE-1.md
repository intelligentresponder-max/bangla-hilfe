# CLAUDE.md — bangla-hilfe

Kontextdatei für Claude Code. Liegt im Wurzelverzeichnis des Repos
`intelligentresponder-max/bangla-hilfe`. Vor jeder Änderung lesen.

---

## Was das Projekt ist

BanglaHilfe Deutschland: zweisprachige Hilfe (Deutsch / Bangla) für Menschen
aus Bangladesch beim Start in Deutschland — Visum, Anmeldung, FSJ/BFD,
Familiennachzug, Studium. Verkauft werden PDF-Pakete zwischen 9,99 € und
49,99 €, ausgeliefert per WhatsApp.

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
├── CNAME                "bangla-hilfe.de"  → Domain löst nicht auf
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

Nicht `bangla-hilfe.de`. Die CNAME-Datei zeigt auf eine Domain, die weder
mit noch ohne `www` im DNS auflöst. Ein Canonical auf eine unerreichbare URL
nimmt jeder Seite die Indexierbarkeit. Sobald das DNS steht: `BASE` in beiden
Skripten ändern, dann alle Canonicals per `sed` nachziehen.

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

## Umgebung

- Termux auf Android (Hauptgerät), Git Bash auf dem PC
- Signal „ich bin am PC" = Git Bash, andere Pfade, keine Termux-Syntax
- Default-Branch `master` — `topwash` liegt auf `main`, das bricht
  übertragene Deploy-Routinen als Erstes
- `raw.githubusercontent.com` ist zuverlässig; die GitHub REST-API läuft ohne
  Token schnell ins Limit — sparsam einsetzen

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

## Zielstruktur (Stand AP 1-7, Basis fuer topwash-Muster)

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

**Seit AP 8 (14.09.2026) abgeloest durch die Nav-Konsolidierung unten** —
`behoerden.html`/`ratgeber.html`/`preise.html` existieren nur noch als
Redirect-Stubs, die eigentlichen Artikel liegen unveraendert an ihrem Platz.

---

## AP 8: Navigation von 9 auf 4 Punkte konsolidiert (14.09.2026)

Externe Übergabe wollte: Tailwind-Stack, erweiterungsfreie URLs (`/pakete`,
`/wissen/visum-einreise`), hreflang für eine nicht existierende EN-Version,
und einen neuen 4-Produkte-Katalog (Starter/Dokumenten-Check/Behörden-Guide/
Bundle), der den echten, bereits verkauften 6-Produkte-Katalog (9,99-49,99 €)
ersetzt hätte. Alle vier Punkte wurden **abgelehnt** und stattdessen so
umgesetzt:

- **Kein Tailwind.** Bestehendes `theme.css` erweitert, siehe „Kein Tailwind
  in diesem Repo" oben — die Begründung von damals gilt unverändert.
- **`.html`-Endungen bleiben.** Neue Nav zeigt auf `pakete.html`,
  `wissen.html`, `faq.html`, `ueber-uns.html` statt auf erweiterungsfreie
  Pfade. Eine Umstellung auf `/pakete/index.html` hätte jeden internen Link,
  jeden Canonical und die Sitemap-Logik im ganzen Repo angefasst — für einen
  Nav-Umbau nicht zu rechtfertigen.
- **Echter Produktkatalog bleibt unangetastet.** Die Übergabe hat sich einen
  Katalog ausgedacht, der nicht dem entspricht, was auf `pakete.html`
  tatsächlich steht (6 Produkte: Visum-Starter, FSJ/BFD, Familiennachzug,
  Anmeldung & Behörden, Studium, Komplett-Bundle). Erfundene Preise/Produkte
  hätten den hart formulierten „Nichts erfinden"-Grundsatz verletzt. Stattdessen
  wurde nur strukturell konsolidiert: `preise.html` (reine Tabellen-Dopplung
  der Pakete) ist jetzt ein Redirect-Stub, die Tabelle lebt als
  Preisübersicht unterhalb der Produktkarten in `pakete.html`.
- **`wissen.html`** ist der neue Blog-/Ratgeber-Hub mit 5 Kategorien
  (Visum & Einreise, Job & Karriere, Anerkennung & Ausbildung, Sprache &
  Leben, Kosten & Planung). Die 18 bereits bestehenden `ratgeber/*`- und
  `behoerden/*`-Artikel (weiterhin `noindex`, bis Amir die Bangla-Fassung
  liefert) plus der Blog-Artikel und `lektionen.html` wurden dort nach
  Thema einsortiert — keine Zeile Artikeltext neu geschrieben oder erfunden.
  `behoerden.html` und `ratgeber.html` waren beide nur leere Gerüste (nie
  befüllt) und sind jetzt Redirect-Stubs auf `wissen.html`.
- **10 neue Redaktionsplan-Artikel** (Chancenkarte 2026, EU Blue Card,
  Pflegekraft-Anerkennung, Anabin/ZAB, …) aus der Übergabe sind bewusst
  **nicht** geschrieben — eigenes, späteres Arbeitspaket, siehe
  `OFFEN`-Kommentar in `wissen.html` bei „Anerkennung & Ausbildung".
- **GitHub Pages hat keine echten 301-Redirects.** Alte Nav-Ziele
  (`preise.html`, `behoerden.html`, `ratgeber.html`) bekommen `<meta
  http-equiv="refresh">` + `noindex` + einen sichtbaren Fallback-Link,
  Canonical zeigt weiterhin auf sich selbst (Projektregel), nicht auf das
  Redirect-Ziel — sonst widersprechen sich Canonical und Redirect-Signal.

---

## Phase 2 (14.09.2026): FAQ/Glossar-Inhalt, interne Verlinkung, Breadcrumbs

Fortsetzung von AP 8, angepasste Reihenfolge aus der externen Übergabe
(deren Punkte 5, 6, 8 — Punkt 7 „3 Blog-Artikel schreiben" bewusst
ausgelassen, siehe AP 8: 10 neue Artikel sind eigenes späteres Paket).

- **`faq.html`**: 8 Frage/Antwort-Paare, alle auf bereits etablierten Fakten
  aufgebaut (WhatsApp-Bestellung, 48h-Antwortzeit, Preise 9,99–49,99 €,
  Widerrufsrecht aus `agb.html` §5/§6, Standard-Disclaimer). Nichts erfunden,
  kein Bangla ergänzt — bleibt `noindex`, bis Amir übersetzt.
- **`glossar.html`**: 13 Begriffe als `dt`/`dd`, ausschließlich Begriffe, die
  bereits an anderer Stelle im Repo vorkommen (Anmeldung, Aufenthaltstitel,
  Chancenkarte, FSJ/BFD, Schufa, Steuer-ID, Widerrufsrecht, …). Gleiche
  Bangla-Einschränkung wie oben.
- **Interne Verlinkung**: alle 19 Wissen-Artikel (18 ratgeber/behoerden +
  Blog) bekommen automatisiert (`related_links.py`) einen Link zum
  passenden Paket-Anker in `pakete.html` (wo ein echtes Produkt thematisch
  passt, sonst allgemein) plus 2 Links zu verwandten Artikeln aus derselben
  Wissen-Kategorie.
- **Breadcrumbs**: „Wissen › Kategorie › Artikel" auf allen 19 Artikeln.
  **Wichtig gefundener Bug dabei** (Details im Fehlerlog, Punkt 10): erst als
  `<nav class="breadcrumb">` gebaut, was mit der globalen `nav{}`-Regel
  kollidierte — Breadcrumb legte sich fix über die echte Navigation. Fix:
  `<div class="breadcrumb" role="navigation">` statt `<nav>`.
- **Bewusst nicht angefasst**: `ueber-uns.html` bleibt unverändert. Der
  bestehende Text ist bereits vollständig zweisprachig (DE+BN) und indexiert;
  neuer deutschsprachiger Prosa-Text (z. B. explizite „keine
  Rechtsberatung"-Klarstellung) hätte diese Parität gebrochen, ohne dass
  Amir die Bangla-Fassung gleichzeitig liefern kann. Entscheidung: warten,
  bis entweder (a) Amir Bangla für einen neuen Absatz mitliefert, oder (b)
  André ausdrücklich einen deutschsprachigen Zusatz ohne Bangla-Parität
  freigibt.

---

## Phase 3 (14.09.2026): JSON-LD, Canonical/OG-Audit, Lighthouse

Angepasst aus der externen Übergabe: Punkt 12 „Tailwind Production-Build"
entfällt vollständig (kein Tailwind im Repo, siehe AP 8). hreflang aus
Punkt 10 bewusst **nicht** umgesetzt — es gibt keine englische Version der
Seite, ein `hreflang="en"` auf nicht existierende Seiten wäre falsch.

- **JSON-LD sitewide**: `Organization` + `LocalBusiness` auf allen 35
  echten Seiten (nicht auf den 3 Redirect-Stubs). Bewusst **ohne** `logo`
  (nur ein 217-Byte-Favicon vorhanden, kein echtes Markenlogo) und **ohne**
  Straße/PLZ in der Adresse (Impressum-Lücke, siehe „Was fehlt") — nur die
  bereits überall öffentlich genannte Stadt „Frankfurt am Main" wurde
  verwendet, nichts erfunden.
- `FAQPage` auf `faq.html`, `DefinedTermSet` auf `glossar.html`: beide
  automatisiert aus dem sichtbaren Text erzeugt (Frage/Antwort bzw.
  dt/dd), 1:1-Spiegelung, keine neuen Fakten.
- `Service` + `OfferCatalog` auf `pakete.html`: aus den 6 echten
  Produktkarten generiert (Titel, Preis, Anker-URL).
- `Article` + `BreadcrumbList` auf allen 19 Wissen-Artikeln. Bewusst
  **ohne** `datePublished` — echtes Veröffentlichungsdatum nicht bekannt,
  wird nicht erfunden.
- **Canonical/OG-Audit**: `lektionen/lektion2.html` und `lektion3.html`
  hatten weder OG-Tags noch Twitter-Card trotz echten, teilbaren Inhalts —
  ergänzt. `twitter:card` fehlte sitewide komplett, jetzt auf allen 31
  Seiten mit OG-Tags ergänzt. `<meta name="keywords">` (obsolet, wird von
  keiner Suchmaschine mehr genutzt) aus den 3 verbliebenen Dateien
  (`index.html`, `lektion2.html`, `lektion3.html`) entfernt.
- **Skip-Link** (`Zum Hauptinhalt springen`) auf allen 35 Seiten mit
  `id="main"` ergänzt, sichtbar erst bei Tastatur-Fokus.
- **Lighthouse-Audit** (lokal installiert, `CHROME_PATH` auf den
  vorinstallierten Chromium gesetzt): deckte drei echte Bugs auf, siehe
  Fehlerlog Punkte 11–13. Nach den Fixes: `index.html` 90/100/96/100
  (Performance/A11y/Best-Practices/SEO), `pakete.html` und `wissen.html`
  100/100/100/100, `faq.html`/`glossar.html` 100/100/100/**66** (SEO-Abzug
  ist der beabsichtigte `noindex`-Zustand, kein Bug — behebt sich von
  selbst, sobald Amirs Bangla-Fassung da ist und `noindex` entfernt wird).
  Performance bei 90 (Doku-Vorgabe „> 90") liegt an nicht selbst
  gehosteten Google Fonts/cdnjs — Selbst-Hosten ist im Handoff-Dokument
  selbst als „optional" eingestuft und wurde nicht umgesetzt. CSS-
  Minifizierung als weiterer Performance-Hebel bewusst **nicht** gemacht:
  `theme.css` trägt inzwischen sehr viel Begründungs-Dokumentation
  (genau das, was seit heute explizit gewünscht ist) — Minifizieren würde
  das unlesbar machen, und ein separater Minify-Build-Schritt verstößt
  gegen die Regel „kein Build-Schritt".

---

## Policy-Änderung (14.09.2026): noindex bei 21 DE-only-Seiten aufgehoben

Von einer zweiten, parallel arbeitenden Claude-Chat-Session (Branch
`seo-fixes-2026-09`, Commit `7ef24c0`) gemergt. **Wichtig für alle
künftigen Sessions:** Die bisher überall zitierte Projektregel „`noindex`
bleibt gesetzt, bis Amir die Bangla-Fassung geliefert hat" gilt **nicht
mehr uneingeschränkt** — André hat das Aufheben für 21 konkrete, inhaltlich
fertige DE-Seiten ausdrücklich bestätigt:

- `faq.html`, `glossar.html`, `blog/chancenkarte-2025-26.html`
- alle 12 `ratgeber/*`-Artikel, alle 4 `behoerden/*`-Artikel (nicht:
  `lektionen/lektion2.html`/`lektion3.html` — die haben eigene Bangla-
  Blöcke direkt im Text, ein anderer Fall)

Alle diese Seiten stehen jetzt auf `robots: index, follow` und sind Teil
der Sitemap (29 statt 8 URLs). Die drei Rechtstexte
(`impressum.html`/`datenschutz.html`/`agb.html`, echtes Rohgerüst ohne
Firmendaten) und `mitmachen.html` (Inhalt fehlt) bleiben bewusst `noindex`
— das ist kein Widerspruch, sondern die Regel greift dort weiterhin zu
Recht.

**Offen/uneindeutig, falls das nochmal relevant wird:** Ob das eine
einmalige Entscheidung für genau diese 21 Seiten war oder eine
grundsätzliche Abkehr von „warten auf Bangla" für künftige neue Artikel
ebenfalls gilt, geht aus der Übergabe nicht hervor. Im Zweifel bei André
nachfragen, bevor bei neuen Artikeln eigenmächtig auf `index` statt
`noindex` gesetzt wird — nicht einfach die alte Regel für neue Inhalte
weiter unterstellen, aber auch nicht ungefragt die neue Praxis
verallgemeinern.

---

## Phase 4 (14.09.2026, Teil 1 von 9): erste 3 neue Redaktionsplan-Artikel

Von den 10 Artikeln aus dem externen Redaktionsplan (AP 8) existierte
bisher nur „Chancenkarte" (der schon vorhandene Blog-Artikel). Diese
Runde: die 3 Artikel geschrieben, die die dünnste Wissen-Kategorie
(Anerkennung & Ausbildung, vorher nur 1 Artikel) am meisten stärken, plus
ein zweiter Visum-Artikel:

- `ratgeber/eu-blue-card-beantragen.html` (Visum & Einreise)
- `ratgeber/anabin-zab-abschluss-bewerten.html` (Anerkennung & Ausbildung)
- `ratgeber/pflegekraft-anerkennung.html` (Anerkennung & Ausbildung)

**Bewusste Abweichung von der reinen Trainingsdaten-Erinnerung:** Bei
jährlich angepassten Zahlen (Blue-Card-Mindestgehalt, Sperrkonto-Betrag)
wurde vor dem Schreiben per `WebSearch` der aktuelle Stand 2026 geprüft,
statt sich auf möglicherweise veraltetes Wissen zu verlassen oder die
Zahl vage zu umschreiben:
- Blue Card 2026: 50.700 €/Jahr Standard, 45.934,20 €/Jahr für
  Mangelberufe/Berufseinsteiger:innen; Niederlassungserlaubnis nach 27
  Monaten (A1) bzw. 21 Monaten (B1).
- ZAB-Zeugnisbewertung: 200 € erste, 100 € je weitere, 2–3 Monate
  Bearbeitungszeit.
- Pflegefachkraft-Anerkennung: i. d. R. B2-Deutschkenntnisse,
  Anerkennungspartnerschaft ermöglicht Einreise während laufendem
  Verfahren.
Trotzdem in jedem Artikel im rechtlichen Hinweis „Stand September 2026,
aktuellen Wert prüfen" ergänzt — diese Zahlen ändern sich jährlich per
Verordnung, eine Websuche heute ist kein Ersatz für eine Prüfung zum
Zeitpunkt des tatsächlichen Antrags.

**Struktur-Ergänzungen** (aus der Übergabe übernommen, wo sinnvoll):
neue `.aeo-box`-Klasse für eine kurze, zitierbare Antwort direkt unter der
Einleitung (Antwort-Engine-Optimierung), plus `FAQPage`-JSON-LD +
sichtbarer `.article-faq`-Abschnitt mit 2 Fragen pro Artikel. **Bewusst
nicht übernommen:** ein Inhaltsverzeichnis — keiner der 19 bestehenden
Artikel hat eines, das hätte nur bei den 3 neuen strukturell aus dem
Rahmen gefallen.

Alle 3 bleiben `noindex` (siehe Policy-Änderung oben: die Aufhebung galt
nur für die 21 bereits bestehenden Seiten, nicht rückwirkend für heute neu
geschriebene). `wissen.html` und die Cross-Links der bestehenden
`zeugnisse-anerkennen-lassen.html` und `blog/chancenkarte-2025-26.html`
aktualisiert, damit die neuen Artikel auffindbar sind. pruefen.sh: Fehler
0. Lighthouse auf `eu-blue-card-beantragen.html`: 100/100/100/**66** (SEO-
Abzug wieder nur wegen des beabsichtigten `noindex`).

**Noch offen aus dem 10er-Redaktionsplan** (6 Artikel): IT-Jobs für
bangladeschische Entwickler, Duale Ausbildung, Deutsch lernen in Dhaka,
Sperrkonto & Visum-Kosten 2026 (Zahlen bereits recherchiert, siehe oben:
992 €/Monat Studierende, 1.027 €/Monat Chancenkarte/Job-Seeker — noch
nicht als Artikel geschrieben), Deutschland vs. Kanada, Leben in
Frankfurt.

---

## Phase 4, Teil 2 (14.09.2026): externe "Batch 2"-Übergabe geprüft und angepasst

Zweite externe Übergabe (`claude-code-uebergabe-batch2.md`) kam mit
Artikel-Briefs für die restlichen 6 Artikel, aber wieder mit Annahmen, die
der hier etablierten Architektur widersprechen und deshalb **nicht**
übernommen wurden:

- **Dateiformat/-pfad:** Übergabe wollte `.md`-Dateien unter
  `/wissen/kategorie/slug.md` — genau die Ordner-pro-Kategorie-URL-Struktur,
  die in AP 8 bereits geprüft und bewusst verworfen wurde (siehe dort).
  Weiter wie bisher: `.html` in `ratgeber/`, Einsortierung nur über
  `wissen.html`-Anker.
- **EN/BN-Übersetzung "optional":** Verstößt gegen die Hard Rule „Bangla
  nie anfassen" und gegen die Phase-3-Entscheidung, keine nicht
  existierende EN-Version per hreflang vorzugaukeln. Weiterhin nur Deutsch,
  weiterhin `noindex` bis Amir liefert.
- **„Mind. 2 Bilder/Artikel":** Es existieren keine echten Fotos (Team,
  Frankfurt, Dokumente) — das Projekt markiert genau das bisher immer
  offen (`Foto folgt`-Platzhalter im Hero), statt Stock-Bilder
  einzufügen. Für die neuen Artikel ebenso: keine Bilder erfunden oder
  von irgendwoher bezogen.
- **`keyword-database.md`-Backlog, „Google Rich Results Test":** nicht
  Teil der bestehenden Werkzeuglandschaft (`pruefen.sh`,
  `build-sitemap.sh`). Stattdessen wie gehabt: JSON-LD strukturell selbst
  validiert (`json.loads` über alle Blöcke).

**Zahlen aus der Übergabe waren teils veraltet oder unbestätigt** —
deshalb vor dem Schreiben jedes Mal per `WebSearch` gegengeprüft, nicht
blind übernommen:
- Übergabe nannte Blue-Card-Schwellen von 48.300 €/43.759 € — das sind die
  **2025er**-Werte (vor der ~5 %-Anhebung). Für 2026 gilt weiterhin
  50.700 €/45.934,20 € (siehe oben, Phase 4 Teil 1) — im neuen IT-Jobs-
  Artikel entsprechend konsistent verwendet, nicht die veralteten Zahlen
  der Übergabe.
- Übergabe nannte „149.000 offene IT-Stellen" — aktuelle Recherche zeigt
  106.000–109.000 als die zitierfähigeren, aktuelleren Zahlen für 2026.
  Verwendet.
- Übergabe nannte „Ausbildung ~900 €/Monat Sperrkonto (oft niedriger)" —
  Recherche zeigt das Gegenteil: der Referenzbetrag liegt mit ca. 1.091 €
  eher **höher** als bei Studierenden, wird aber durch die
  Ausbildungsvergütung angerechnet und dadurch in der Praxis oft
  reduziert. Im Artikel entsprechend korrekt und nuanciert dargestellt,
  nicht die vereinfachte (falsche) Übergabe-Aussage übernommen.
- Goethe-Institut-Dhaka-Kurspreise (Übergabe: „15.000–25.000 BDT/Level")
  ließen sich nicht verlässlich verifizieren — bewusst **nicht**
  übernommen, stattdessen im Artikel auf goethe.de/ins/bd verwiesen statt
  eine unbestätigte Zahl zu drucken.

**Geschrieben (3 von 6):**
- `ratgeber/sperrkonto-visum-kosten.html` (Kosten & Planung) — Tabelle mit
  Quellenangabe Auswärtiges Amt, wie von der Übergabe explizit gefordert.
- `ratgeber/deutsch-lernen-dhaka.html` (Sprache & Leben)
- `ratgeber/it-jobs-bangladesch.html` (Job & Karriere)

Alle 3 mit `.aeo-box`, FAQ-Sektion + `FAQPage`-JSON-LD, `Article` +
`BreadcrumbList`-JSON-LD, `noindex` (siehe Policy-Änderung: gilt nicht
rückwirkend für neue Artikel). `wissen.html` sowie Cross-Links in
`sprachkurs-finden.html`, `krankenversicherung-waehlen.html` und
`arbeitsvertrag-verstehen.html` aktualisiert. pruefen.sh: Fehler 0.

**Bewusst zurückgestellt (3 von 6), nicht Teil dieser Runde:**
- **Duale Ausbildung** — als eigenständiges Thema inhaltlich klar
  abgrenzbar, aber noch nicht geschrieben.
- **Deutschland vs. Kanada** — Vergleichsartikel, braucht eine sorgfältig
  neutrale Formulierung (keine Wertung „X ist besser"), noch nicht
  begonnen.
- **Leben in Frankfurt als Bangladescher** — **bewusst zurückgehalten,
  nicht nur aufgeschoben.** Sowohl die Übergabe als auch eine eigene
  Recherche würden hier extrem konkrete lokale Behauptungen erfordern
  (Community-Größe, Straßennamen für Halal-Restaurants, Namen von
  Moscheen/Vereinen) — genau die Art von Detail, die ein Sprachmodell
  plausibel klingend erfinden kann, ohne dass es stimmt. Das wäre ein
  Verstoß gegen „Nichts erfinden" mit realem Schadenspotenzial (falsche
  Adressen/Namen für eine Community, die sich darauf verlässt). Braucht
  entweder eine verlässliche Quelle, die sich unabhängig verifizieren
  lässt, oder Ortskenntnis von André/Amir — nicht einfach aus
  Trainingswissen oder einer Web-Suche zusammenstellen.

---

## Phase 4, Teil 3 (14.09.2026): externer "Prüfauftrag" umgesetzt statt nur gelistet

Dritte externe Übergabe (`uebergabe-claude-code-pruefung.md`) wollte
explizit nur eine Abweichungsliste ohne Fixes ("Format der Rückmeldung:
keine automatischen Fixes"). André hat stattdessen direkt „optimiere
proaktiv, schreibe die Änderungen in jede Datei" angewiesen — entsprechend
umgesetzt, nicht nur berichtet.

**Falsche Grundannahme der Übergabe:** Punkt B.⚠️ ging davon aus, dass
`ratgeber.html`/`behoerden.html` noch „echte Hub-Seiten mit Inhalt" seien.
Das war bereits seit AP 8 nicht mehr der Fall (beide sind Redirect-Stubs) —
die Übergabe wurde offenbar ohne aktuellen `git pull` erstellt. Vor
jeder externen Übergabe künftig kurz den Ist-Zustand der genannten
Dateien gegenchecken, bevor Prüfpunkte übernommen werden.

**Erneut abgelehnt** (dieselben Gründe wie bei AP 8 / Batch 2, hier nicht
wiederholt, siehe dort): Tailwind-CDN im Head, erweiterungsfreie
Redirect-Ziele (`/pakete` statt `pakete.html`), Pflichtbilder ohne echte
Fotos, EN-Sprachversion, `lang="en"`.

**Neu abgelehnt:**
- **`datePublished`/`dateModified` im Article-JSON-LD.** Es gibt keine
  echten Veröffentlichungsdaten für die 25 Wissen-Artikel — das war in
  Phase 3 bereits bewusst weggelassen (nicht erfinden). Bleibt so.
- **"Link trotzdem setzen, auch wenn Zielartikel fehlt, mit `<!-- TODO -->`-
  Kommentar."** Das erzeugt tote interne Links — `pruefen.sh` Punkt 1
  prüft explizit genau darauf und würde das korrekt als Fehler zurückweisen.
  Ein Link auf eine nicht existierende Datei ist auf der echten,
  veröffentlichten Seite ein 404, kein harmloser Kommentar. Nicht
  umgesetzt.
- **Exakt 5 FAQ-Fragen pro Artikel erzwingen.** 2–3 belastbare Fragen sind
  besser als 5 Fragen, von denen 2–3 nur Lückenfüller wären.

**Umgesetzt, weil echte, wiederholt genannte Lücken (jetzt zum dritten
Mal von unterschiedlichen Übergaben verlangt — diesmal übernommen, weil
risikofrei und wertvoll):**
- **Inhaltsverzeichnis auf allen 25 Wissen-Artikeln.** Automatisiert
  erzeugt (`add_toc.py`): `id`-Slug pro `<h2>` (Emoji entfernt, ä/ö/ü/ß
  transliteriert), Sprungmarken-Liste direkt nach der Einleitung. Die
  CTA-Box (`.blog-post__cta`) bewusst nicht ins Inhaltsverzeichnis
  aufgenommen — das ist Conversion, kein Inhaltsabschnitt.
- **Meta-Descriptions verlängert.** 19 Artikel hatten 53–116 Zeichen
  (Ziel 140–160), auf Basis des jeweils echten Artikelinhalts erweitert,
  nichts erfunden. Eine (Chancenkarte) war mit 181 Zeichen zu lang, auf
  160 gekürzt. `og:description` und das `description`-Feld im
  Article-JSON-LD liefen automatisch mit, da alle drei denselben Text
  nutzen.
- **Ein echter Überschriften-Sprung gefunden und behoben:**
  `bestellen.html` sprang H1 → H3 (die drei Schritt-Karten). Kam daher,
  dass die andere Session kürzlich die Sektionsüberschrift dieser Seite
  korrekt von H2 auf H1 gehoben hatte (siehe „SEO/AEO-Fixes"-Commit),
  dabei aber die darunterliegenden Schritt-Titel nicht mitgezogen hat.
  Jetzt H1 → H2. `.step`-Klasse wird nur noch auf `bestellen.html`
  verwendet (frühere Verwendung auf `index.html` ist inzwischen nur noch
  ein Teaser-Link ohne Kartenraster) — CSS-Selektor auf `.step h2, .step
  h3` erweitert, damit beide Verwendungen weiter funktionieren, statt nur
  einer Seite eine Sonderregel zu geben.

pruefen.sh: Fehler 0. Alle 100 JSON-LD-Blöcke sitewide erneut strukturell
validiert (`json.loads`), keine Überschriften-Sprünge mehr sitewide
gefunden (automatisierter Scan über alle H1–H6).

---

## Phase 4, Teil 4 (14.09.2026): Übergabe "Familiennachzug"-Artikel — Ist-Zustand widersprach der Annahme

Externe Übergabe (`cda1e5aa-uebergabe-artikel-familiennachzug.md`) wollte
einen **neuen** Ratgeber-Artikel "Familiennachzug nach Deutschland:
Voraussetzungen, Ablauf und Kosten" anlegen und verwies dabei auf eine
Datei `AUFTRAG-restarbeiten.md` mit "Aufgaben 4-6" — diese Datei existiert
in diesem Repo nicht (nur `AUFTRAG-umbau.md` und `HANDOFF.md`). Wie schon
bei Phase 4 Teil 3 dokumentiert: **vor jeder externen Übergabe erst den
Ist-Zustand prüfen**, nicht die Annahmen der Übergabe blind übernehmen.

**Gefundener Widerspruch:** `ratgeber/familiennachzug-ablauf.html`
existierte bereits, war schon einer der 21 auf `index, follow`
umgestellten Seiten (Policy-Änderung oben) und in `wissen.html` sogar als
"featured" Karte verlinkt. Ein zweiter, separater Artikel zum exakt
gleichen Thema hätte Duplicate Content erzeugt und zwei konkurrierende
Familiennachzug-Einträge im Wissen-Hub — schlechter für SEO als die
Alternative.

**Entscheidung (Alternative geprüft, nicht die Übergabe-Annahme
übernommen):** Bestehenden Artikel erweitert statt Duplikat angelegt.
Slug/URL/Canonical unverändert gelassen (kein Duplicate-Content-Risiko,
keine toten Backlinks) — Title und H1 auf "Familiennachzug nach
Deutschland: Voraussetzungen, Ablauf und Kosten" angehoben, weil der
Inhalt jetzt tatsächlich mehr als nur den Ablauf abdeckt. Neu ergänzt,
alles mit den in der Übergabe gelieferten, bereits geprüften Fakten:

- **A1-Sprachnachweis: Regel und Ausnahmen** (Blaue Karte EU, akademische
  Fachkräfte, Staatsangehörige bestimmter Länder, geringer
  Integrationsbedarf).
- **Sonderfall Chancenkarte** — die Übergabe-Korrektur, dass die
  Chancenkarte (1 Jahr gültig) allein meist NICHT für den
  Ehegattennachzug reicht, weil der Aufenthaltstitel des Sponsors bei
  Antragstellung noch mindestens ein weiteres Jahr gültig sein muss
  (§ 30 AufenthG). Die Übergabe hatte dafür die Unterbuchstaben „§ 30
  Abs. 1 Satz 3 Nr. 5" bzw. „Buchst. e" mitgeliefert — per WebSearch
  gegen `buzer.de`/Rechtsdatenbanken geprüft, aber die Treffer nannten für
  ähnliche Ausnahmen widersprüchlich Buchst. f und g. Direkter Zugriff auf
  `gesetze-im-internet.de` und `diplo.de` zum Gegenprüfen ist vom Proxy
  blockiert. **Bewusst nicht übernommen**, um keine unsicher verifizierte
  Unterbuchstaben-Angabe zu drucken (gleiches Prinzip wie bei den
  Goethe-Institut-Kurspreisen in Phase 4 Teil 2: lieber die sicher
  verifizierte Basisnorm zitieren als eine Zahl/einen Buchstaben, der sich
  nicht zweifelsfrei bestätigen lässt) — im Artikel steht durchgehend nur
  „§ 30 AufenthG" ohne Unterbuchstaben.
- **Blaue Karte EU als schnellerer Weg** — mit Cross-Link zum bereits
  bestehenden `eu-blue-card-beantragen.html` (und umgekehrt dort ein
  neuer Link zurück, siehe unten).
- **Kosten-Angaben, selbst recherchiert statt aus der Übergabe
  übernommen** (Übergabe nannte dazu keine Zahlen): nationales Visum
  75 € Erwachsene / 37,50 € Kinder, gebührenfrei beim Nachzug zu
  Deutschen (Quelle: Auswärtiges Amt/diplo.de, per WebSearch); Gebühr für
  die Aufenthaltserlaubnis nach Einreise 100 € / Kinder 50 € nach § 45
  AufenthV (Quelle: `buzer.de`, Gesetzestext AufenthV Kapitel 3).
- **3 statt 5 FAQ** (Chancenkarte, A1-Pflicht, Kosten) — dieselbe
  Begründung wie bei Phase 4 Teil 3: 2–3 belastbare Fragen statt
  Lückenfüller, plus `FAQPage`-JSON-LD.
- **Glossar ergänzt** (`glossar.html`, DefinedTermSet + sichtbare Liste,
  alphabetisch einsortiert): `A1-Niveau (GER)`, `Auslandsvertretung`,
  `Blaue Karte EU`, `Ehegattennachzug`, `Vorabzustimmung` — nur Begriffe,
  die jetzt tatsächlich in mindestens einem Artikel vorkommen (Projekt-
  Regel, siehe Phase 2). `§ 30 AufenthG`/`§ 16a AufenthG` bewusst
  **nicht** als eigene Glossar-Einträge angelegt — kein bestehender
  Eintrag im Glossar zitiert einen nackten Paragrafen, das hätte den
  etablierten Stil (Alltagsbegriff → Erklärung) gebrochen. Stattdessen
  im Artikeltext selbst zitiert.

**Aus der Übergabe abgelehnt** (gleiche, bereits mehrfach dokumentierte
Gründe wie bei früheren Übergaben, hier nur kurz):
- **Mind. 2 Bilder pro Artikel.** Vierter Handoff in Folge mit dieser
  Forderung (siehe Phase 4 Teil 2) — weiterhin keine echten Fotos
  vorhanden, weiterhin keine Stockbilder erfunden.
- **1.200–1.800 Wörter als harte Vorgabe.** Der fertige Artikel hat
  ca. 950 Wörter — mehr als doppelt so lang wie die zuletzt geschriebenen
  Artikel im selben Format (`eu-blue-card-beantragen.html` 450,
  `sperrkonto-visum-kosten.html` 484, `anabin-zab-abschluss-bewerten.html`
  462 Wörter), aber bewusst nicht künstlich auf 1.200+ aufgefüllt: die
  Wortzahl-Vorgabe stammt aus einer externen, in diesem Repo nicht
  vorhandenen Datei und widerspricht dem hier tatsächlich etablierten
  Artikelformat. Zusätzliche Füllabsätze ohne neuen Fakteninhalt hätten
  gegen "kein Platzhaltertext" verstoßen.
- **TODO-Kommentar bei fehlendem Zielartikel.** Nicht nötig gewesen — alle
  vorgeschlagenen internen Ziele (Glossar-Anker, `eu-blue-card-
  beantragen.html`, `haeufige-fehler-im-antrag.html`,
  `blog/chancenkarte-2025-26.html`) existierten bereits.

`wissen.html`-Karten (2×) auf den neuen Titel/Beschreibung aktualisiert.
`sitemap.xml` neu generiert (weiterhin 29 URLs, nur `lastmod` aktualisiert
— kein neuer Artikel, keine neue URL). pruefen.sh: Fehler 0. Alle
JSON-LD-Blöcke der geänderten Dateien (`familiennachzug-ablauf.html`,
`glossar.html`, `eu-blue-card-beantragen.html`, `wissen.html`) erneut
strukturell validiert.

---

## Phase 5 (15.09.2026): FAQ/Glossar 2-Spalten-Layout, Glossar vertieft, Teilen-Bereich, Zähler

André wollte konkret: „Schaufenster-Doppelsicht" auf `faq.html`/`glossar.html`,
alle Glossar-Begriffe (namentlich Blaue Karte EU) genauer erklärt +
SEO-tauglich für häufige Verlinkung, einen „Teilen"-Bereich im Footer und
einen „Zähler". Vor der Umsetzung per `AskUserQuestion` geklärt, weil alle
drei Punkte mehrdeutig waren (siehe Antworten unten) — Ergebnis:

- **Zähler = Inhalts-Zähler, kein Besucherzähler.** Ein Live-Besucherzähler
  bräuchte einen Drittanbieter-Dienst oder ein Backend (GitHub Pages hat
  keins) — neuer externer Request pro Aufruf, genau die Art Fremdressource,
  die dieses Projekt bisher bewusst vermeidet (siehe Hinweis 12 in
  `pruefen.sh` zu Fonts/cdnjs). Stattdessen zählt `site.js` beim Laden die
  vorhandenen `.faq-item`/`.glossary-item`-Elemente per
  `document.querySelectorAll(...).length` und schreibt "8 Fragen &
  Antworten" / "18 Begriffe erklärt" in ein `.content-counter`-Element via
  `data-count-selector`/`data-count-label`. Gleiches Prinzip wie
  `build-sitemap.sh`: generieren statt von Hand pflegen, damit der Zähler
  nie veraltet.
- **Layout = CSS Grid, nicht CSS `columns`.** Erster Versuch war
  `columns: 2` (Zeitungsspalten) mit `break-inside: avoid` — bei der FAQ
  (nur 8 unterschiedlich lange Antworten) erzeugte `column-fill: balance`
  grosse, unvorhersagbare Lücken (siehe Screenshot-Vergleich vor/nach in
  dieser Session). Umgestellt auf `display: grid; grid-template-columns:
  1fr 1fr` ab 860px — ordnet zeilenweise in Lesereihenfolge (1+2
  nebeneinander, dann 3+4 …), jede Zeile nur so hoch wie ihr längster
  Eintrag, keine Lücken. Für `glossar.html` mit 18 gleichmäßigeren
  Einträgen wäre `columns` vermutlich unauffällig geblieben, aber Grid ist
  hier ebenfalls das robustere, vorhersagbarere Verhalten — einheitlich
  auf beiden Seiten verwendet.
- **Teilen = WhatsApp-Teilen + Link kopieren, kein Facebook/Social-SDK.**
  Passt zum WhatsApp-only-Vertriebskanal (siehe oben) und braucht keinen
  Drittanbieter. `shareWhatsApp()` öffnet `wa.me/?text=` mit Titel + URL,
  `copyLink(btn)` nutzt `navigator.clipboard` mit Kurzzeit-Feedback
  („✓ Kopiert!") und einem `.catch()`-Fallback-Text, falls die Clipboard-
  API in einem unsicheren Kontext fehlschlägt. In allen 39 Footern mit
  echtem Inhalt eingebaut (36 per Python-Skript am einfachen 3-Link-Footer,
  `index.html` manuell in den bilingualen Footer, `lektionen/lektion2.html`
  und `lektionen/lektion3.html` manuell — die beiden hatten bisher gar kein
  `site.js` eingebunden, jetzt ergänzt, da sie keine eigenen Funktionen
  definieren und `site.js` ohne Nav/Sprachumschalter-Elemente auf diesen
  Seiten harmlos leerläuft). **Bewusst nur Deutsch** — Bangla-Fassung der
  Buttons müsste Amir liefern (Hard Rule 6), `<!-- OFFEN: ... -->`-Kommentar
  in `index.html` gesetzt.
- **Glossar vertieft**: alle 18 Einträge überarbeitet, mit Kategorie-Emoji
  versehen und wo möglich untereinander sowie zu bestehenden Ratgeber-
  Artikeln verlinkt (z. B. Blaue Karte EU ↔ Ehegattennachzug ↔
  Familiennachzug-Artikel ↔ EU-Blue-Card-Artikel). Flaggschiff „Blaue Karte
  EU" (namentlich verlangt) deutlich ausgebaut: Rechtsgrundlage § 18g
  AufenthG, EU-Richtlinie 2021/1883 (per `WebSearch` gegengeprüft: löst
  Richtlinie 2009/50/EG seit 19.11.2023 ab, Quelle EUR-Lex), Verweis auf
  den bestehenden Artikel statt Wiederholung der jährlich wechselnden
  Gehaltsschwelle. `§ 30`/`§ 16a AufenthG` bewusst **nicht** als eigene
  Glossar-Einträge — kein bestehender Eintrag zitiert einen nackten
  Paragrafen als Stichwort, das hätte den etablierten Stil gebrochen;
  stattdessen im Fließtext der betroffenen Einträge zitiert. Sichtbarer
  Text und `DefinedTermSet`-JSON-LD werden seither aus einer einzigen
  Python-Datenquelle generiert (`/tmp/rewrite_glossar.py`, nicht ins Repo
  übernommen — Einweg-Skript wie `add_toc.py` in Phase 4 Teil 3), damit
  beide garantiert synchron bleiben.
- **Meta-Descriptions** von `glossar.html` und `faq.html` in den
  140–160-Zeichen-Zielkorridor gebracht (waren 118 bzw. 65 Zeichen).

**Zwei echte, vorher unentdeckte Bugs gefunden und sitewide gefixt** (siehe
Fehlerlog #14 und #15 unten) — beide betrafen nicht nur die neuen
Glossar/FAQ-Elemente, sondern jede Seite mit Anker-Links bzw. jeden
Inline-Link im Fließtext sitewide.

pruefen.sh: Fehler 0. Alle 101 JSON-LD-Blöcke sitewide erneut strukturell
validiert. Lighthouse auf `glossar.html` und `faq.html`:
100/100/100 (Accessibility/Best-Practices/SEO). Visuell per Playwright-
Screenshot geprüft (Desktop 1280px, Mobile 390px, `:target`-Deeplink) und
die Teilen-Buttons funktional getestet (Clipboard-Schreibvorgang, WhatsApp-
Share-URL, Zähler-Werte) — alle wie erwartet.

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

8. **Desktop-Nav seit AP1 unsichtbar — `.nav-links` doppelt definiert.**
   `theme.css` enthielt `.nav-links { display: flex }` als Basis-Regel UND
   ein zweites, **ungeschütztes** `.nav-links { display: none }` weiter
   unten im Abschnitt „MOBILE MENU" (kein Media-Query drumherum). Die
   zweite Regel gewann per Kaskade auf jeder Bildschirmbreite — der
   Hamburger war seit der CSS-Auslagerung in AP1 die einzige Nav auf allen
   Geräten, auch auf Desktop, wo eigentlich die volle Link-Leiste stehen
   sollte. Erst beim Screenshot-Vergleich für AP8 aufgefallen, weil beide
   Bugs (Links unsichtbar, Hamburger nie versteckt) sich optisch
   gegenseitig kaschiert haben. Fix: doppelte Regel entfernt, `.nav-toggle`
   bekommt jetzt `display: none` als Basis und wird nur in der
   `max-width:768px`-Query wieder eingeblendet. **Lehre: eine
   unqualifizierte `display:none`-Regel ausserhalb einer Media-Query auf
   eine Klasse, die anderswo schon eine Basis-Regel hat, immer verdächtig —
   nicht nur den zuletzt geänderten Ort pruefen, sondern per `grep -n
   "\.klasse"` alle Fundstellen im ganzen CSS auflisten.**

9. **Mehrzeilige HTML-Kommentare entgehen `pruefen.sh` Punkt 3.** Das
   Skript filtert sichtbaren Text mit `sed 's/<!--[^>]*-->//g'`, was nur
   **einzeilige** Kommentare korrekt entfernt (`sed` arbeitet zeilenweise,
   nicht über Zeilenumbrüche hinweg). Ein selbst geschriebener zweizeiliger
   `<!-- TODO: ... -->`-Kommentar wurde dadurch als sichtbarer
   Platzhaltertext erkannt. Kein `pruefen.sh`-Bug im eigentlichen Sinne,
   sondern eine Grenze der bestehenden Prüfung. **Lehre: Entwurfs-/Offen-
   Kommentare im Projekt immer einzeilig halten (wie die etablierten
   `<!-- OFFEN: ... -->`-Kommentare in `impressum.html`) statt mehrzeilig
   mit `TODO`/`Platzhalter`/`XXX` — sonst entgeht der Kommentar der
   Platzhalter-Prüfung nicht etwa sicher, sondern nur zufällig, wenn keines
   der Trigger-Wörter zufällig im sichtbaren Rest landet.**

10. **Eigener `<nav>`-Tag kollidiert mit der sitewide Nav-Regel.** Für
    Breadcrumbs auf den 19 Wissen-Artikeln ein zweites `<nav class="breadcrumb">`
    pro Seite eingesetzt — aber `theme.css` stylt den nackten `nav`-Selektor
    global (`position: fixed; top: 0; ...`, siehe Zeile ~45), nicht nur
    `nav[aria-label="Hauptnavigation"]`. Der Breadcrumb legte sich dadurch
    fix positioniert über die echte Navigation statt normal im Textfluss zu
    stehen. Erst am Screenshot bemerkt. Fix: `<div class="breadcrumb"
    role="navigation" aria-label="Breadcrumb">` statt `<nav>` — gleiche
    Barrierefreiheits-Semantik über `role`, ohne den Element-Selektor zu
    treffen. **Lehre: Bevor ein zweites semantisches Element (`nav`, `header`,
    `aside` …) auf einer Seite verwendet wird, die bereits eines dieser Tags
    global stylt, per `grep -n "^\s*ELEMENTNAME\s*{"` prüfen, ob im CSS ein
    Elementselektor (statt Klassenselektor) existiert — der trifft jede
    Instanz des Tags, nicht nur die eine, für die er gedacht war.**

11. **`.blog-post__legal` seit dem allerersten Blog-Artikel mit Navy-
    Hintergrund statt Weiss — dritter Fund derselben Fehlerklasse wie
    Punkt 10.** `.blog-post__legal` ist ebenfalls ein bares `<footer>`-Tag
    (der rechtliche Hinweis am Ende jedes Wissen-Artikels) und erbt dadurch
    die globale `footer { background: var(--navy) }`-Regel, obwohl es auf
    dem weissen Artikel-Hintergrund gedacht war. Betraf alle 19 Wissen-
    Artikel von Anfang an: dunkelgrauer Text (`var(--slate)`) auf Navy,
    Kontrast 1.83:1 statt 4.5:1 — von Lighthouse aufgedeckt, nicht vorher
    aufgefallen, weil es "nur" der kleingedruckte Rechtshinweis ist. Fix:
    `.blog-post__legal` bekommt jetzt explizit `background: var(--white)`.
    **Lehre: Punkt 10s Regel gilt für jedes semantische Tag, nicht nur
    `nav`** — `footer`, `header`, `aside` etc. sind im selben Repo genauso
    global gestylt und kollidieren genauso mit einer zweiten, spezifischeren
    Verwendung desselben Tags weiter unten im Dokument.

12. **WhatsApp-Markengrün `#25d366` mit weissem Text: 1.98:1 statt 4.5:1.**
    `.nav-wa` und `.wa-big` (die beiden Call-to-Action-Buttons mit
    sichtbarem "WhatsApp"-Text) nutzten das offizielle, aber vergleichsweise
    helle WhatsApp-Gruen als Hintergrund mit weisser Schrift — seit deren
    jeweiliger Erstellung nie auf Kontrast geprueft. Fix: Hintergrund auf
    `#108040` gedunkelt (5.0:1), noch eindeutig als "WhatsApp-Gruen"
    erkennbar. `.float-wa` (nur ein Emoji-Icon, kein Text) bewusst
    unveraendert gelassen. **Lehre: Marken-/CI-Farben sind nicht automatisch
    barrierefrei — bei jeder neuen Farbe-auf-Farbe-Kombination mit Text den
    Kontrast rechnen, nicht nur "sieht gut aus" pruefen.**

13. **Lighthouse war die ganze Zeit nutzbar, wurde aber nie eingesetzt.**
    `npx lighthouse` liess sich in dieser Session einfach per `npm install
    --no-save lighthouse` nachinstallieren und lief mit
    `CHROME_PATH=/opt/pw-browsers/chromium` gegen den bereits vorhandenen
    Playwright-Chromium — kein Extra-Download noetig. Deckte in einem
    einzigen Durchlauf drei echte, teils seit Monaten bestehende Bugs auf
    (Punkte 11, 12, plus das fehlende `<main>`-Landmark auf `index.html`),
    die weder `pruefen.sh` noch manuelle Screenshot-Checks je gefunden
    hatten. **Lehre: Bei zukuenftigen Accessibility-/Performance-Fragen
    zuerst `CHROME_PATH=/opt/pw-browsers/chromium npx lighthouse <url>
    --chrome-flags="--headless=new --no-sandbox"` laufen lassen, statt nur
    visuell zu pruefen — es ist bereits eingerichtet und kostet nur eine
    einmalige `npm install`.**

14. **Anker-Spruenge landeten seit AP1 hinter der fixen Nav -- sitewide,
    nicht nur bei den neuen Glossar-Deeplinks.** `nav` ist `position:
    fixed`, aber es gab nie ein `scroll-padding-top`. Jeder `#anker`-Link
    (Breadcrumb-Ziele, `pakete.html#familiennachzug`,
    `wissen.html#visum-einreise`, jetzt auch alle 18 Glossar-Begriffe)
    scrollte das Ziel-Element exakt an die Fensteroberkante -- dort, wo die
    Nav liegt. Die obersten ~60-90px des Ziels (oft genau die Ueberschrift)
    waren dadurch verdeckt. Erst beim Bau des `:target`-Highlights fuer die
    Glossar-Deeplinks per Screenshot aufgefallen. Fix: `html {
    scroll-padding-top: 6rem }` (bzw. `5rem` im `max-width:768px`-Media-
    Query, deckt sich mit den bestehenden `.page-main`-Werten). **Lehre:
    Bei jeder `position: fixed`-Nav gehoert `scroll-padding-top` sofort
    dazu, nicht erst wenn zufaellig ein Deeplink-Feature das Problem
    sichtbar macht -- betrifft ausnahmslos jeden Anker-Link im Dokument.**

15. **Keine globale Link-Farbe -- jeder unklassierte `<a>` im Fliesstext
    war Browser-Default-Blau statt Markengruen.** `theme.css` stylte immer
    nur einzelne Klassen (`.nav-links a`, `.toc a`, `footer a`, …), nie den
    nackten `a`-Selektor. Betraf jeden Inline-Link in `<p>`/`<dd>` sitewide
    -- die "Pakete & Preise"-Verlinkung in der FAQ, die AGB-Verlinkung im
    Widerrufsrecht-Eintrag, jeden Cross-Link in den Ratgeber-Artikeln,
    nicht nur die neuen Glossar-Querverweise. Erst beim ersten Screenshot
    der ueberarbeiteten Glossar-Seite aufgefallen (blaue statt gruene
    Links). Fix: `a { color: var(--green) } a:hover { color:
    var(--green-dark) }` frueh in der RESET/BASE-Sektion -- `text-
    decoration` bewusst nicht angetastet (Browser-Underline bleibt fuer
    Barrierefreiheit erhalten), spezifischere Klassen-Selektoren
    ueberschreiben das per hoeherer Spezifitaet ohnehin. Kontrast gegen
    Weiss 6.6:1, gegen den neuen `:target`-Hintergrund `--green-light`
    5.9:1 -- beide weit ueber 4.5:1. **Lehre: eine fehlende globale Basis-
    Regel ist genauso ein Bug wie eine falsche -- `grep -n "^\s*a\s*{"`
    haette das schon vor Monaten gezeigt, nicht erst bei einem
    Screenshot-Vergleich.**

16. **Die eigentliche GitHub-Pages-Domain (`intelligentresponder-max.github.io`)
    ist aus dieser Session heraus nicht erreichbar -- weder per WebFetch
    noch per `curl` in Bash.** Nach dem Merge von PR #7 (22.09.2026) wollte
    ich den Live-Stand des neuen Artikels direkt nachpruefen. Beide Wege
    scheiterten mit derselben Ursache: `curl` liefert `CONNECT tunnel
    failed, response 403`, der Proxy-Status (`__agentproxy/status`) zeigt
    dazu `connect_rejected -- gateway answered 403 to CONNECT (policy
    denial)` fuer genau diesen Host. Kein transienter Fehler, sondern eine
    Egress-Policy dieser Umgebung. **Erweitert Fehlerlog #7** (dort ging es
    nur um die GitHub-REST-API fuer Pages-Settings) -- jetzt ist auch die
    tatsaechlich ausgelieferte Seite selbst nicht direkt abrufbar.
    **Ersatz-Verifikation, die funktioniert:** den Workflow-Run des
    `.github/workflows/deploy.yml` nach dem Merge-Commit pruefen
    (`actions_list` → `list_workflow_runs`, `head_sha` gegen den
    Merge-Commit abgleichen, `conclusion: success` genuegt als Nachweis,
    dass GitHub Pages den Build uebernommen hat) -- das lief nicht ueber
    den blockierten Proxy, sondern ueber das GitHub-MCP-Tool. **Lehre:
    Live-Deploy nie per direktem HTTP-Abruf der `.github.io`-Domain
    verifizieren wollen, das schlaegt in dieser Umgebung zuverlaessig fehl
    -- stattdessen den zugehoerigen `Deploy to GitHub Pages`-Workflow-Run
    pruefen, das ist der verlaessliche, tatsaechlich erreichbare Nachweis.**

---

## Phase 6 (18.09.2026): Neuer Ratgeber-Artikel "Schweinefleisch und Religion"

Externe Übergabe (Markdown-Datei mit eingebetteter `HANDOFF-NOTIZ`) lieferte
einen redaktionell fertigen Artikeltext samt Front-Matter und wollte ihn
1:1 nach dem "topwash-Muster" einsortiert haben. Zwei Punkte aus der
Notiz wurden **abgelehnt**, ein dritter, unabhängig mitgeschickter Punkt
(ein KI-generiertes Bildprompt für ein Schwein mit Schal) wurde ignoriert:

- **"semantisches HTML5 + Tailwind CDN"** -- dieselbe veraltete Vorgabe aus
  dem allgemeinen Vertical-Coding-Leitfaden, die in AP 8 und seither bei
  jeder externen Übergabe abgelehnt wurde (siehe „Kein Tailwind in diesem
  Repo" oben). Kein Tailwind, bestehendes `theme.css` verwendet.
- **Bild-Prompt für ein KI-generiertes Foto** (Schwein mit Schal auf einer
  Wiese) war der Übergabe als separater Text beigefügt. Nicht umgesetzt,
  aus zwei Gründen: Erstens verstößt jedes erfundene/KI-generierte Bild
  gegen den seit Phase 4 Teil 2 mehrfach bekräftigten Grundsatz „keine
  Stockbilder oder erfundene Fotos" (dort ging es um fehlende echte
  Fotos, hier wäre es sogar ein komplett synthetisches Bild). Zweitens passt
  ein possierliches Schwein mit Schal inhaltlich nicht zu einem Artikel
  über ein religiöses Speiseverbot, das für einen großen Teil der
  Zielgruppe ernst genommen wird -- das Bild wäre nicht nur
  Projektregel-widrig, sondern auch redaktionell unpassend gewesen.
- **Zensuszahlen aktualisiert statt übernommen:** Die Übergabe nannte
  "rund 90 %" Muslime / "8,5 %" Hindus in Bangladesch -- das sind die
  **2011er**-Zensuswerte (90,39 % / 8,54 %). Per `WebSearch` gegen den
  Zensus 2022 geprüft und auf die aktuelleren Zahlen 91,04 % (Muslime) /
  7,95 % (Hindus) / 0,61 % (Buddhisten) / 0,30 % (Christen) aktualisiert.

**Umgesetzt:** `ratgeber/schweinefleisch-und-religion.html`, Kategorie
"Sprache & Leben" (passt zu den Tags "Kultur"/"Religion"/"Alltag in
Deutschland" aus dem Front-Matter). Gleiches Format wie die übrigen
25 Wissen-Artikel: TOC, `.aeo-box`, `FAQPage`- + `Article`- +
`BreadcrumbList`-JSON-LD, Footer-Teilen-Block, `noindex` (neue Artikel
fallen nicht unter die Policy-Änderung vom 14.09.2026, die galt nur für
die 21 damals bereits bestehenden Seiten). Die `HANDOFF-NOTIZ` aus dem
Markdown wurde entfernt, nicht mit übernommen (kein Platzhaltertext im
sichtbaren Bereich, Hard Rule 2). `wissen.html`-Karte ergänzt, Rück-Link
von `anmeldung-schritt-fuer-schritt.html` gesetzt. Kein Bangla ergänzt
(Hard Rule 6). `pruefen.sh`: Fehler 0. Alle 4 JSON-LD-Blöcke der neuen
Seite strukturell validiert (`json.loads`). Meta-Description auf 150
Zeichen im 140-160-Zielkorridor (siehe Phase 4 Teil 3).

**Gefundener und behobener Bindestrich-Stilbruch (auf Nachfrage geprüft,
nachdem nur nach der `wissen.html`-Karte gefragt wurde):** Der neue
Artikel nutzte im sichtbaren Fließtext durchgängig den einfachen
Tastatur-Bindestrich `--`. Ein Abgleich mit bestehenden Artikeln
(`deutsch-lernen-dhaka.html`, `familiennachzug-ablauf.html`,
`sperrkonto-visum-kosten.html`) zeigte ein durchgängiges, offenbar
bewusstes Muster: sichtbarer Fließtext (Absätze, Listen, `.aeo-box`,
sichtbare FAQ-Antworten) nutzt den echten Halbgeviertstrich `–`,
während `<meta name="description">`, `og:description` und JSON-LD-
Textfelder (`description`, FAQ-`text`) durchgehend den einfachen `--`
verwenden -- vermutlich um Encoding-/Escaping-Risiken beim
automatisierten Befüllen von Attributen und JSON-Strings zu vermeiden.
Fix: `--` im sichtbaren Body-Text (7 Stellen) auf `–` umgestellt, Head
(Meta/JSON-LD) unverändert gelassen -- ebenso die `wissen.html`-Karten-
Beschreibung. **Lehre: Bei neuen Artikeln vor dem Commit `grep -n ' -- '
datei.html` laufen lassen und prüfen, ob Treffer im sichtbaren Body oder
nur im Head (Meta/JSON-LD) liegen -- nur Body-Treffer sind ein
Stilbruch.**

---

## Phase 7 (23.09.2026): Englisch als dritte Sprache eingeführt — Kehrtwende bei einer mehrfach bekräftigten Entscheidung

Externe Übergabe (5 Dateien: `04-index-en-content.html`, `02-theme-patch.css`,
`03-nav-snippet.html`, `05-vertrauen-section.html`, `01-site.js`, ohne
begleitenden Text) wollte Englisch als dritte Sprache neben Deutsch/Bangla
einführen — das widerspricht direkt drei zuvor dokumentierten, wiederholt
bekräftigten Entscheidungen (AP 8, Phase 3, Phase 4 Teil 2: „keine
englische Version", „`hreflang=\"en\"` auf nicht existierende Seiten wäre
falsch"). Bei einer Kehrtwende dieser Tragweite wurde **vor der Umsetzung**
per `AskUserQuestion` nachgefragt statt die Übergabe stillschweigend
auszuführen oder ungefragt abzulehnen — André hat alle drei Punkte
ausdrücklich bestätigt:

1. **„Ja, EN jetzt einführen"** — die frühere Ablehnung war keine
   Bangla-Analogie-Regel, sondern schlicht mangelnder Bedarf; der Bedarf
   ist jetzt da. Kein Widerspruch zur alten Begründung, sondern eine neue
   Tatsachenlage.
2. **„Nur bestellen.html ergänzen"** statt auch `preise.html` in die
   Nav-Erweiterung aufzunehmen — die Übergabe ging fälschlich davon aus,
   `preise.html` sei noch eine echte Seite mit Inhalt. Tatsächlich ist sie
   seit AP 8 ein reiner Redirect-Stub auf `pakete.html`; ein Link darauf
   wäre ein sinnloser Umweg gewesen. `bestellen.html` dagegen war
   tatsächlich unterverlinkt (nur aus dem Footer der Startseite erreichbar).
3. **Vertrauen-Sektion auf `index.html`**, nicht auf `ueber-uns.html` —
   passt zur bestehenden Reihenfolge Hero → Wie-es-geht → Pakete → Über
   uns → Vertrauen → CTA auf der Startseite.

**Warum das kein Widerspruch zu Phase 3s hreflang-Ablehnung ist:** Die
Seite nutzt für DE/BN nie separate URLs oder `hreflang` — beide Sprachen
stehen im selben Dokument, per Klick umschaltbar (client-seitig). Englisch
folgt exakt demselben Mechanismus (dieselbe URL, dritter Umschalter-Zustand),
keine dritte gecrawlte URL. Damit stellt sich die hreflang-Frage gar nicht
neu; die Phase-3-Ablehnung bezog sich auf eine echte separate `/en/`-Seite,
die hier nie gebaut wurde.

### Technischer Umbau

- **CSS-Sichtbarkeitsmechanik geändert:** die alte binäre `body.bn`-Klasse
  (De-facto ein Ein/Aus-Schalter) reicht für drei Sprachen nicht mehr.
  Ersetzt durch `data-active-lang="de|bn|en"` auf `<body>` plus eine
  strikte Positivliste in `theme.css`:
  ```css
  [data-lang] { display: none; }
  body:not([data-active-lang]) [data-lang="de"] { display: block; }
  body[data-active-lang="de"] [data-lang="de"] { display: block; }
  body[data-active-lang="bn"] [data-lang="bn"] { display: block; }
  body[data-active-lang="en"] [data-lang="en"] { display: block; }
  ```
  Die `body:not([data-active-lang])`-Zeile ist eine **eigene Ergänzung, nicht
  aus der Übergabe**: ohne sie wäre vor dem ersten JS-Lauf (oder bei
  deaktiviertem JS) gar kein `data-lang`-Inhalt sichtbar — die alte Mechanik
  hatte implizit „Deutsch ohne JS" über `body:not(.bn)`. Gleiches
  Schutzniveau jetzt bewusst nachgebaut.
- **Gefundener Bug in `03-nav-snippet.html` vor dem Ausrollen:** die
  Sprachumschalter-Buttons selbst nutzten `data-lang="de/bn/en"` als
  Identifikations-Attribut — exakt dasselbe Attribut, das die neue
  Positivlisten-Regel für Inhalte verwendet. Ergebnis: bei aktivem
  Deutsch wären die BN/EN-Buttons unsichtbar gewesen (`[data-lang]
  {display:none}` trifft auch sie), Sprachumschalten also nur einmal in
  eine Richtung möglich. Nicht übernommen — stattdessen ein eigenes
  Attribut `data-lang-btn` nur für die drei Buttons eingeführt, `site.js`
  entsprechend umgeschrieben (`document.querySelectorAll('.lang-btn')`
  mit `btn.dataset.langBtn`). **Lehre: bei einer neuen Sichtbarkeits-
  Positivliste auf einem Attribut sofort prüfen, ob dasselbe Attribut noch
  für etwas anderes (hier: UI-Steuerelemente) im selben Dokument verwendet
  wird — sonst wird die UI, die die Sichtbarkeit steuern soll, selbst von
  ihrer eigenen Regel unsichtbar gemacht.**
- **`site.js`**: `setLang()`/`toggleLang()` von binär auf zyklisch DE → BN
  → EN → DE umgebaut (`LANGS`-Array), `localStorage`-Persistenz und
  `<html lang>`-Attribut-Update beibehalten. Footer-Teilen, Zähler,
  Scroll-Reveal, Hamburger-Menü unverändert.
- **38 HTML-Dateien sitewide** per Python-Skript (nicht von Hand) von
  2-Button- auf 3-Button-Sprachumschalter umgestellt (`data-lang-btn`
  statt `data-lang` auf allen drei Buttons).
- **`index.html`**: EN-Gegenstücke für Hero, Wie-es-geht, Pakete-Teaser,
  Über-uns-Teaser, Vertrauen-Sektion-Header, alle 4 Trust-Karten und den
  CTA-Bereich (nur die „Antwortzeit"-Karte, E-Mail/Standort bleiben
  unübersetzt — deckt sich mit dem Umfang der Übergabe) ergänzt, Inhalt
  wörtlich aus `04-index-en-content.html` übernommen. Zwei fehlende
  EN-Gegenstücke **selbst gefunden und ergänzt** (nicht in der Übergabe):
  das „Pakete"-Label in der Bottom-Bar und das „💬 WhatsApp"-Label in der
  Nav — beide hatten DE+BN, aber kein EN, wären unter aktivem Englisch
  leer geblieben.
- **Neue „Vertrauen"-Sektion** (`05-vertrauen-section.html`) zwischen
  `.trust` und dem CTA-Bereich eingefügt: 4 Karten (Radikale Transparenz,
  Echte Gesichter, Kostenloser Erstkontakt, Sofort-Mehrwert) plus CTA-Link
  für einen kostenlosen „A1-Sprech-Spickzettel" per WhatsApp. **Kritischer
  Bug in der Übergabe-Sektion gefunden:** sie war komplett mit
  `data-lang="de"` markiert, ohne jedes BN/EN-Gegenstück. Unter der neuen
  strikten Positivlisten-CSS-Regel wäre die gesamte Sektion (bis auf die
  nackten Emoji-Icons) für BN- und EN-Besucher unsichtbar geworden — ein
  Rückschritt, den es unter der alten, toleranteren Mechanik so nicht gab.
  Fix: alle `data-lang="de"`-Attribute aus der Sektion entfernt, damit sie
  wie die bereits bestehende Blog-Teaser-Sektion auf `index.html`
  „unwrapped = immer sichtbar" ist — der etablierte Umgang mit bewusst
  einsprachigem Inhalt, nicht in eine ungepaarte `data-lang="de"` verpackt.
  `background: var(--light)` gewählt, um sich vom direkt darüberliegenden
  `.trust` abzuheben (gleiches Wechselmuster wie `.how`/`.products`/
  `.about`).
- **Eigener Inline-Style-Verstoß, sofort selbst gefunden:** die
  CTA-`<div>` der Vertrauen-Sektion kam mit `style="margin-top:2rem"` aus
  der Übergabe — Verstoß gegen Hard Rule 3, dieselbe Fehlerklasse wie
  historisch Fehlerlog #4. Fix: eigene Klasse `.trust-detail-cta` in
  `theme.css`, `pruefen.sh` danach mit 0 Fehlern bestätigt.
- **`bestellen.html`-Verlinkung nur im Footer, nicht in der Hauptnav.**
  Die Übergabe wollte den Link in die primäre `<ul class="nav-links">` und
  ins Mobile-Menü setzen — das hätte AP 8s hart erkämpfte
  4-Punkte-Konsolidierung (siehe oben) direkt wieder auf 5 Punkte
  aufgebläht. Stattdessen dreisprachiger Eintrag „Bestellung"/„অর্ডার"/
  „How to order" nur im reichhaltigen `footer-links`-Block von
  `index.html` ergänzt (die übrigen 38 Seiten haben dort nur einen
  schmalen 3-Link-Rechtstexte-Footer ohne vergleichbare Erweiterungsstelle).

### Sitewide-Due-Diligence: drei vorbestehende, bisher unentdeckte Bugs gefunden

Nach Abschluss der EN-Umsetzung ein Sitewide-Scan gefahren (Anzahl
`data-lang="de"` vs. `data-lang="bn"` pro Datei muss identisch sein) — rein
aus eigenem Antrieb, nicht angefordert. Ergebnis: drei Dateien hatten
„verwaiste" `data-lang="de"`-Elemente ganz ohne Bangla-Gegenstück, die es
schon **vor** dieser Session gab und die unter der alten `body.bn`-Mechanik
harmlos blieben (weil dort jedes `data-lang`-Element ohne Klasse `.bn`
sichtbar war), unter der neuen strikten Positivliste aber sitewide für
BN- und EN-Besucher unsichtbar geworden wären:

- `lektionen.html`: „Kostenlos"-Tag und der Lektionen-Intro-Absatz.
- `wissen.html`: die 5 Kategorie-Header (Tag+Sub je Kategorie, 10 Elemente)
  sowie der Haupt-Intro-Absatz der Seite.
- `pakete.html`: die Tabellenkopf-Zellen „Preis" und „Bestellen" in der
  Preisübersicht (die benachbarte Zelle „Paket" hatte dagegen korrekt ein
  BN-Gegenstück — nur diese beiden waren betroffen).

Fix in allen drei Dateien: `data-lang="de"` entfernt (nie Bangla erfunden,
Hard Rule 6), gleiche „unwrapped = immer sichtbar"-Logik wie bei der
Vertrauen-Sektion. Ein Python-Skript mit `text.count()`/`text.replace()`
auf exakte Zielstrings hatte dabei zunächst einen der elf `wissen.html`-
Fixes übersprungen: der nackte öffnende Tag `<p class="section-sub"
data-lang="de">` (ohne Text) war ein literales Präfix von fünf anderen,
längeren Zielstrings in derselben Fix-Liste, wodurch `text.count()` 6 statt
der erwarteten 1 Übereinstimmung meldete und das Skript den Fix
korrekterweise mit einer Warnung übersprang, statt blind zu ersetzen. Fix
nachgeholt mit dem `Edit`-Tool und dem vollständigen, eindeutigen
Absatztext statt des nackten Tags. **Lehre: bei skriptgestützten
Text-Ersetzungen mit `str.count()`/`str.replace()` nie einen bloßen
öffnenden Tag ohne Inhalt als Zielstring verwenden, wenn in derselben
Ersetzungsliste längere Strings existieren, die exakt mit diesem Tag
beginnen — `count()` zählt Teilstring-Vorkommen, nicht öffnende Tags, und
ein Präfix-Treffer in einem längeren String zählt mit. Immer bis zu einem
eindeutigen Ankerpunkt (z. B. dem schließenden `</p>` oder genug vom
tatsächlichen Text) matchen, nicht nur bis zum öffnenden Tag.**

Nach dem Fix erneuter Sitewide-Scan: 0 verbleibende de/bn-Mismatches.
`pruefen.sh`: Fehler 0 (3 unveränderte, seit langem bekannte Hinweise zu
externen Font-Ressourcen). Alle JSON-LD-Blöcke sitewide erneut strukturell
validiert (`json.loads`, weiterhin 0 fehlerhafte). Per Playwright verifiziert
(`index.html`, alle drei Sprachzustände): Sprachumschalter zyklisch
funktionsfähig, `data-active-lang` wechselt korrekt, Vertrauen-Sektion
bleibt unter BN/EN sichtbar (unwrapped-Konvention greift), alle drei
Umschalter-Buttons bleiben in jedem Sprachzustand sichtbar (die
`data-lang-btn`-Trennung funktioniert wie vorgesehen).

---

## Umgebung

- Termux auf Android (Hauptgerät), Git Bash auf dem PC
- Signal „ich bin am PC" = Git Bash, andere Pfade, keine Termux-Syntax
- Default-Branch `master` — `topwash` liegt auf `main`, das bricht
  übertragene Deploy-Routinen als Erstes
- `raw.githubusercontent.com` ist zuverlässig; die GitHub REST-API läuft ohne
  Token schnell ins Limit — sparsam einsetzen

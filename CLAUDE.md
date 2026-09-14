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

---

## Umgebung

- Termux auf Android (Hauptgerät), Git Bash auf dem PC
- Signal „ich bin am PC" = Git Bash, andere Pfade, keine Termux-Syntax
- Default-Branch `master` — `topwash` liegt auf `main`, das bricht
  übertragene Deploy-Routinen als Erstes
- `raw.githubusercontent.com` ist zuverlässig; die GitHub REST-API läuft ohne
  Token schnell ins Limit — sparsam einsetzen

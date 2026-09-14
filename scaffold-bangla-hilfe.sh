#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# scaffold-bangla-hilfe.sh
#
# Legt die Seitenstruktur von "topwash" als Dummy-Gerüst im Repo
# "bangla-hilfe" an.
#
# GRUNDREGELN
#   - Rein additiv: eine bereits vorhandene Datei wird NIE überschrieben.
#     Bestehende index.html, lektion1-3.html, danke.html, qrcode.html und
#     produkte/ bleiben unangetastet.
#   - Jede erzeugte Stub-Seite traegt <meta name="robots" content="noindex">.
#     Damit landet kein leeres Geruest im Google-Index, solange der Inhalt
#     fehlt. Das noindex ist die einzige Stelle, die beim Befuellen einer
#     Seite entfernt werden muss.
#   - Kein Platzhaltertext im sichtbaren Bereich (Lehre aus dem
#     TOPWASH-Fehlerbericht, Punkt 1). Der Entwurfsstatus steht im
#     HTML-Kommentar und im robots-Meta, nicht im Fliesstext.
#
# AUFRUF (im Wurzelverzeichnis des Repos bangla-hilfe):
#   bash scaffold-bangla-hilfe.sh
#   bash scaffold-bangla-hilfe.sh --dry-run    # nur anzeigen, nichts schreiben
# ---------------------------------------------------------------------------

set -euo pipefail

DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

# Kanonische Basis-URL. Achtung: Im Repo liegt eine CNAME-Datei mit
# "bangla-hilfe.de", die Domain loest aber aktuell nicht auf. Bis das DNS
# steht, ist die github.io-Adresse die einzige erreichbare. Nach dem
# DNS-Setup hier auf https://bangla-hilfe.de/ umstellen -- und dann in
# einem Rutsch alle Canonicals mit sed nachziehen.
BASE="https://intelligentresponder-max.github.io/bangla-hilfe/"

created=0
skipped=0

# --- Verzeichnisse ---------------------------------------------------------
for d in behoerden ratgeber assets/css assets/js images; do
  if [ $DRY -eq 1 ]; then
    echo "DIR   $d"
  else
    mkdir -p "$d"
  fi
done

# --- Seitenliste -----------------------------------------------------------
# Format:  pfad|Titel|Meta-Description|H1
# Die Reihenfolge spiegelt 1:1 die Struktur von topwash.
PAGES=$(cat <<'LIST'
pakete.html|Hilfe-Pakete|Fertige Schritt-fuer-Schritt-Pakete fuer Visum, Anmeldung, FSJ und Familiennachzug auf Deutsch und Bangla.|Unsere Hilfe-Pakete
bestellen.html|Paket bestellen|So bestellen Sie ein Hilfe-Paket bei BanglaHilfe Deutschland.|Paket bestellen
preise.html|Preise|Alle Hilfe-Pakete von BanglaHilfe Deutschland im Preisueberblick.|Preise im Ueberblick
behoerden.html|Behoerden|Welche Behoerde ist fuer was zustaendig? Der Ueberblick auf Deutsch und Bangla.|Behoerden in Deutschland
behoerden/auslaenderbehoerde.html|Auslaenderbehoerde|Aufenthaltstitel, Verlaengerung, Termine: was die Auslaenderbehoerde von Ihnen braucht.|Auslaenderbehoerde
behoerden/buergeramt-anmeldung.html|Buergeramt und Anmeldung|Wohnsitz anmelden, Meldebescheinigung, Wohnungsgeberbestaetigung.|Buergeramt und Anmeldung
behoerden/jobcenter-agentur.html|Jobcenter und Agentur fuer Arbeit|Antraege, Termine, Unterlagen: Jobcenter und Agentur fuer Arbeit verstehen.|Jobcenter und Agentur fuer Arbeit
behoerden/krankenkasse-versicherung.html|Krankenkasse und Versicherung|Krankenversicherung waehlen, anmelden und nachweisen.|Krankenkasse und Versicherung
ueber-uns.html|Ueber uns|Wer hinter BanglaHilfe Deutschland steht und warum es das Angebot gibt.|Ueber uns
mission.html|Unsere Mission|Warum wir Menschen aus Bangladesch beim Start in Deutschland begleiten.|Unsere Mission
mitmachen.html|Mitmachen|Ehrenamtlich uebersetzen, begleiten oder Inhalte pruefen.|Mitmachen
faq.html|Haeufige Fragen|Antworten auf die haeufigsten Fragen zu Visum, Anmeldung, FSJ und BFD.|Haeufige Fragen
glossar.html|Glossar Deutsch-Bangla|Deutsche Behoerdenbegriffe erklaert und auf Bangla uebersetzt.|Glossar Deutsch-Bangla
ratgeber.html|Ratgeber|Artikel und Anleitungen rund um Behoerden, Visum und Alltag in Deutschland.|Ratgeber
ratgeber/anmeldung-schritt-fuer-schritt.html|Anmeldung Schritt fuer Schritt|So melden Sie Ihren Wohnsitz in Deutschland korrekt an.|Anmeldung Schritt fuer Schritt
ratgeber/visum-unterlagen-checkliste.html|Visum: Checkliste der Unterlagen|Welche Dokumente Sie fuer den Visumantrag zusammenstellen muessen.|Visum: Checkliste der Unterlagen
ratgeber/fsj-und-bfd-unterschied.html|FSJ oder BFD: der Unterschied|Was FSJ und BFD unterscheidet und was fuer wen passt.|FSJ oder BFD: der Unterschied
ratgeber/familiennachzug-ablauf.html|Familiennachzug: der Ablauf|Vom Antrag bis zur Einreise: die Schritte beim Familiennachzug.|Familiennachzug: der Ablauf
ratgeber/steuer-id-beantragen.html|Steuer-ID beantragen|Wofuer Sie die Steuer-Identifikationsnummer brauchen und wie Sie sie bekommen.|Steuer-ID beantragen
ratgeber/konto-eroeffnen-ohne-schufa.html|Bankkonto eroeffnen|Welches Konto sich fuer den Start eignet und was Sie mitbringen muessen.|Bankkonto eroeffnen
ratgeber/wohnungssuche-frankfurt.html|Wohnungssuche in Frankfurt|Worauf Sie bei der Wohnungssuche im Rhein-Main-Gebiet achten sollten.|Wohnungssuche in Frankfurt
ratgeber/sprachkurs-finden.html|Sprachkurs finden|Integrationskurs, VHS oder Online: den passenden Deutschkurs finden.|Sprachkurs finden
ratgeber/zeugnisse-anerkennen-lassen.html|Zeugnisse anerkennen lassen|Wie Sie Abschluesse aus Bangladesch in Deutschland anerkennen lassen.|Zeugnisse anerkennen lassen
ratgeber/termin-bei-der-behoerde.html|Termin bei der Behoerde|Termin buchen, vorbereiten und was Sie am Termin dabeihaben muessen.|Termin bei der Behoerde
ratgeber/aufenthaltstitel-verlaengern.html|Aufenthaltstitel verlaengern|Fristen, Unterlagen und der richtige Zeitpunkt fuer die Verlaengerung.|Aufenthaltstitel verlaengern
ratgeber/arbeitsvertrag-verstehen.html|Arbeitsvertrag verstehen|Die wichtigsten Klauseln in einem deutschen Arbeitsvertrag.|Arbeitsvertrag verstehen
ratgeber/krankenversicherung-waehlen.html|Krankenversicherung waehlen|Gesetzlich oder privat: worauf es beim Start ankommt.|Krankenversicherung waehlen
ratgeber/haeufige-fehler-im-antrag.html|Haeufige Fehler im Antrag|Die Fehler, die Antraege am oeftesten verzoegern -- und wie Sie sie vermeiden.|Haeufige Fehler im Antrag
impressum.html|Impressum|Anbieterkennzeichnung nach Paragraf 5 DDG.|Impressum
datenschutz.html|Datenschutzerklaerung|Informationen zur Verarbeitung personenbezogener Daten.|Datenschutzerklaerung
agb.html|AGB|Allgemeine Geschaeftsbedingungen fuer die Hilfe-Pakete.|Allgemeine Geschaeftsbedingungen
LIST
)

# --- Hilfsfunktion: relativer Pfad zur Wurzel -----------------------------
depth_prefix() {
  case "$1" in
    */*) echo "../" ;;
    *)   echo "" ;;
  esac
}

write_page() {
  path="$1"; title="$2"; desc="$3"; h1="$4"
  if [ -e "$path" ]; then
    echo "SKIP  $path (existiert bereits)"
    skipped=$((skipped+1))
    return
  fi
  if [ $DRY -eq 1 ]; then
    echo "NEU   $path"
    created=$((created+1))
    return
  fi
  r="$(depth_prefix "$path")"
  cat > "$path" <<HTML
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- ENTWURF: Seite ist ein Geruest. Vor dem Befuellen Inhalt ergaenzen,
     danach die folgende robots-Zeile entfernen. Erst dann erscheint die
     Seite in sitemap.xml und im Index. -->
<meta name="robots" content="noindex, follow">
<title>${title} | BanglaHilfe Deutschland</title>
<meta name="description" content="${desc}">
<link rel="canonical" href="${BASE}${path}">
<meta property="og:type" content="website">
<meta property="og:title" content="${title} | BanglaHilfe Deutschland">
<meta property="og:description" content="${desc}">
<meta property="og:url" content="${BASE}${path}">
<!-- Favicon wird in Arbeitspaket 1 gemeinsam mit theme.css ergaenzt.
     Vorher kein icon-Link: er wuerde auf eine nicht existierende Datei zeigen
     und die Linkpruefung in pruefen.sh zu Recht rot faerben. -->
<link rel="stylesheet" href="${r}assets/css/theme.css">
</head>
<body>
<header>
  <a href="${r}index.html">BanglaHilfe Deutschland</a>
  <nav>
    <a href="${r}pakete.html">Pakete</a>
    <a href="${r}preise.html">Preise</a>
    <a href="${r}behoerden.html">Behoerden</a>
    <a href="${r}ratgeber.html">Ratgeber</a>
    <a href="${r}faq.html">FAQ</a>
    <a href="${r}glossar.html">Glossar</a>
    <a href="${r}ueber-uns.html">Ueber uns</a>
  </nav>
</header>

<main id="main">
  <h1>${h1}</h1>
</main>

<footer>
  <a href="${r}impressum.html">Impressum</a>
  <a href="${r}datenschutz.html">Datenschutz</a>
  <a href="${r}agb.html">AGB</a>
</footer>
</body>
</html>
HTML
  echo "NEU   $path"
  created=$((created+1))
}

echo "== Seiten =="
# Kein "printf ... | while": eine Pipe startet eine Subshell, die Zaehler
# created/skipped wuerden darin hochgezaehlt und danach verworfen -- die
# Abschlusszeile meldete dann immer 0/0. Here-String vermeidet die Subshell.
while IFS='|' read -r p t d h; do
  [ -z "$p" ] && continue
  write_page "$p" "$t" "$d" "$h"
done <<< "$PAGES"

# --- 404-Seite -------------------------------------------------------------
if [ ! -e 404.html ] && [ $DRY -eq 0 ]; then
  cat > 404.html <<HTML
<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>Seite nicht gefunden | BanglaHilfe Deutschland</title>
<link rel="stylesheet" href="assets/css/theme.css">
</head>
<body>
<main id="main">
  <h1>Seite nicht gefunden</h1>
  <p>Die aufgerufene Seite existiert nicht. <a href="index.html">Zur Startseite</a></p>
</main>
</body>
</html>
HTML
  echo "NEU   404.html"
fi

# --- robots.txt ------------------------------------------------------------
if [ ! -e robots.txt ] && [ $DRY -eq 0 ]; then
  cat > robots.txt <<TXT
User-agent: *
Allow: /

Sitemap: ${BASE}sitemap.xml
TXT
  echo "NEU   robots.txt"
fi

# --- leeres Stylesheet, damit kein 404 auf assets/css/theme.css entsteht ---
if [ ! -e assets/css/theme.css ] && [ $DRY -eq 0 ]; then
  printf '/* theme.css -- Basis-Styles folgen */\n' > assets/css/theme.css
  echo "NEU   assets/css/theme.css"
fi

echo
echo "Fertig. Neu: ${created}  Uebersprungen: ${skipped}"
echo "Naechster Schritt:  bash build-sitemap.sh"

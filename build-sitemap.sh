#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# build-sitemap.sh
#
# Erzeugt sitemap.xml aus den tatsaechlich vorhandenen HTML-Dateien.
# Funktioniert unveraendert in beiden Repos -- nur BASE anpassen.
#
# WARUM GENERIERT STATT HANDGEPFLEGT
# Die handgepflegte sitemap.xml in topwash enthielt 27 URLs, im Repo lagen
# aber 32 indexierbare Seiten. Zwei neue Blogartikel und die drei Rechtstexte
# fehlten. Genau dieser Drift entsteht bei jeder Handpflege wieder. Ein
# Generator kann nicht vergessen werden, solange er im Deploy-Schritt liegt.
#
# AUSSCHLUSSREGELN
#   - 404.html                              (darf nie in die Sitemap)
#   - jede Datei mit <meta name="robots" ... noindex ...>
#   - alles unterhalb von node_modules/ und .git/
#
# AUFRUF (im Wurzelverzeichnis des Repos):
#   bash build-sitemap.sh
# ---------------------------------------------------------------------------

set -euo pipefail

# --- hier umstellen, je Repo ----------------------------------------------
BASE="https://intelligentresponder-max.github.io/bangla-hilfe/"
# topwash:  BASE="https://intelligentresponder-max.github.io/topwash/"
# bangla-hilfe.de wurde am 14.09.2026 verworfen (CNAME geloescht, DNS tot).
# Falls die Domain spaeter kommt: erst DNS, dann CNAME, dann BASE hier.
# ---------------------------------------------------------------------------

OUT="sitemap.xml"
TMP="$(mktemp)"

prio_for() {
  case "$1" in
    "")                     echo "1.0" ;;
    pakete.html|preise.html|behoerden.html)   echo "0.9" ;;
    behoerden/*)            echo "0.8" ;;
    bestellen.html|faq.html|ueber-uns.html|ratgeber.html) echo "0.7" ;;
    glossar.html|mission.html|mitmachen.html) echo "0.6" ;;
    ratgeber/*)             echo "0.5" ;;
    impressum.html|datenschutz.html|agb.html) echo "0.3" ;;
    *)                      echo "0.5" ;;
  esac
}

freq_for() {
  case "$1" in
    "")                     echo "weekly" ;;
    impressum.html|datenschutz.html|agb.html) echo "yearly" ;;
    ratgeber/*)             echo "yearly" ;;
    *)                      echo "monthly" ;;
  esac
}

{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
} > "$TMP"

total=0
excluded=0

# Startseite immer als Verzeichnis-URL, nicht als index.html.
# Sonst sind / und /index.html zwei URLs mit identischem Inhalt.
if [ -f index.html ] && ! grep -qi 'name="robots"[^>]*noindex' index.html; then
  lm=$(date -u -r index.html +%Y-%m-%d 2>/dev/null || date -u +%Y-%m-%d)
  {
    echo "  <url>"
    echo "    <loc>${BASE}</loc>"
    echo "    <lastmod>${lm}</lastmod>"
    echo "    <changefreq>weekly</changefreq>"
    echo "    <priority>1.0</priority>"
    echo "  </url>"
  } >> "$TMP"
  total=$((total+1))
fi

while IFS= read -r f; do
  rel="${f#./}"
  [ "$rel" = "index.html" ] && continue
  [ "$rel" = "404.html" ] && continue
  case "$rel" in
    node_modules/*|.git/*) continue ;;
  esac
  if grep -qi 'name="robots"[^>]*noindex' "$f"; then
    echo "  noindex, uebersprungen: $rel"
    excluded=$((excluded+1))
    continue
  fi
  lm=$(date -u -r "$f" +%Y-%m-%d 2>/dev/null || date -u +%Y-%m-%d)
  {
    echo "  <url>"
    echo "    <loc>${BASE}${rel}</loc>"
    echo "    <lastmod>${lm}</lastmod>"
    echo "    <changefreq>$(freq_for "$rel")</changefreq>"
    echo "    <priority>$(prio_for "$rel")</priority>"
    echo "  </url>"
  } >> "$TMP"
  total=$((total+1))
done < <(find . -name '*.html' -type f | sort)

echo '</urlset>' >> "$TMP"
mv "$TMP" "$OUT"

echo
echo "${OUT} geschrieben: ${total} URLs, ${excluded} Entwuerfe ausgelassen."

# Selbstpruefung: XML muss parsebar sein, sonst lehnt die Search Console ab.
if command -v python3 >/dev/null 2>&1; then
  python3 - "$OUT" <<'PY'
import sys, xml.dom.minidom
xml.dom.minidom.parse(sys.argv[1])
print("XML valide.")
PY
fi

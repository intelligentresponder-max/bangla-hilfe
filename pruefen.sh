#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# pruefen.sh — Abnahmepruefung fuer bangla-hilfe
#
# Laeuft nach jedem Arbeitspaket. Committen erst, wenn hier nichts mehr
# rot ist. Keine Netzwerkzugriffe, laeuft offline in Termux.
#
# Jede Pruefung entspricht einem Fehler, der im Repo topwash real
# aufgetreten ist -- das ist der Grund, warum sie hier steht.
#
# AUFRUF:  bash pruefen.sh
# Rueckgabe 0 = sauber, 1 = mindestens ein Fehler
# ---------------------------------------------------------------------------

set -uo pipefail

BASE="https://intelligentresponder-max.github.io/bangla-hilfe/"
fehler=0
warn=0

rot()  { printf '  FEHLER  %s\n' "$1"; fehler=$((fehler+1)); }
gelb() { printf '  HINWEIS %s\n' "$1"; warn=$((warn+1)); }
ok()   { printf '  ok      %s\n' "$1"; }

htmls=$(find . -name '*.html' -type f -not -path './node_modules/*' -not -path './.git/*' | sort)
anzahl=$(printf '%s\n' "$htmls" | grep -c . || true)
echo "== $anzahl HTML-Dateien =="

# --- 1. Tote interne Links ------------------------------------------------
# topwash-Bezug: dort sauber, soll hier sauber bleiben.
echo
echo "1) Interne Links"
tot=0
for f in $htmls; do
  dir=$(dirname "$f")
  grep -o 'href="[^"]*"' "$f" 2>/dev/null | sed 's/href="//;s/"$//' | while read -r href; do
    case "$href" in
      ""|\#*|http*|mailto:*|tel:*|javascript:*|data:*) continue ;;
    esac
    ziel="${href%%#*}"
    [ -z "$ziel" ] && continue
    [ -e "$dir/$ziel" ] || echo "TOT|$f|$href"
  done
done > /tmp/_tote.txt
tot=$(grep -c . /tmp/_tote.txt || true)
if [ "$tot" -gt 0 ]; then
  while IFS='|' read -r _ f h; do rot "toter Link in $f -> $h"; done < /tmp/_tote.txt
else
  ok "keine toten internen Links"
fi

# --- 2. Canonical vorhanden und korrekt -----------------------------------
echo
echo "2) Canonical-Tags"
vorher=$fehler
for f in $htmls; do
  rel="${f#./}"
  [ "$rel" = "404.html" ] && continue
  if ! grep -qi 'rel="canonical"' "$f"; then
    rot "kein Canonical: $rel"
    continue
  fi
  soll="${BASE}${rel}"
  [ "$rel" = "index.html" ] && soll="${BASE}"
  ist=$(grep -io 'rel="canonical"[^>]*href="[^"]*"' "$f" | head -1 | sed 's/.*href="//;s/"//')
  [ "$ist" = "$soll" ] || rot "Canonical falsch in $rel: $ist (erwartet $soll)"
done
[ $fehler -eq $vorher ] && ok "alle Canonicals gesetzt und korrekt"

# --- 3. Platzhaltertext im sichtbaren Bereich -----------------------------
# topwash-Bezug: interne Notiz steht live in datenschutz.html.
echo
echo "3) Platzhalter im Fliesstext"
gefunden=0
for f in $htmls; do
  sichtbar=$(sed 's/<!--[^>]*-->//g' "$f" | sed 's/<[^>]*>/ /g')
  if printf '%s' "$sichtbar" | grep -qiE 'lorem ipsum|TODO|Platzhalter|XXX|juristisch geprueft werden|juristisch geprüft werden|Ausgangstext'; then
    rot "Platzhalter- oder Notiztext sichtbar in ${f#./}"
    gefunden=1
  fi
done
[ $gefunden -eq 0 ] && ok "kein Platzhaltertext sichtbar"

# --- 4. Inline-Styles -----------------------------------------------------
echo
echo "4) Inline-Styles"
n=$(grep -l 'style="' $htmls 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -gt 0 ]; then
  for f in $(grep -l 'style="' $htmls 2>/dev/null); do
    c=$(grep -o 'style="' "$f" | wc -l | tr -d ' ')
    gelb "${f#./}: $c style-Attribute -> nach theme.css ueberfuehren"
  done
else
  ok "keine Inline-Styles"
fi

# --- 5. Inline-<style>-Bloecke --------------------------------------------
echo
echo "5) Inline-<style>-Bloecke"
n=$(grep -l '<style' $htmls 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -gt 1 ]; then
  rot "$n Dateien mit eigenem <style>-Block -- CSS gehoert einmal nach assets/css/theme.css"
elif [ "$n" -eq 1 ]; then
  gelb "noch 1 Datei mit <style>-Block: $(grep -l '<style' $htmls)"
else
  ok "CSS zentral ausgelagert"
fi

# --- 6. Sprachauszeichnung ------------------------------------------------
echo
echo "6) Sprachauszeichnung"
for f in $htmls; do
  grep -qi '<html[^>]*lang=' "$f" || rot "kein lang-Attribut am <html>: ${f#./}"
done
bn=$(grep -l 'lang="bn"' $htmls 2>/dev/null | wc -l | tr -d ' ')
ok "$bn Dateien mit ausgezeichneten Bangla-Bloecken"

# --- 7. Title und Description ---------------------------------------------
echo
echo "7) Title und Description"
for f in $htmls; do
  rel="${f#./}"
  [ "$rel" = "404.html" ] && continue
  grep -qi '<title>' "$f" || rot "kein <title>: $rel"
  grep -qi 'name="description"' "$f" || gelb "keine Description: $rel"
done

# --- 8. Doppelte Titles ---------------------------------------------------
echo
echo "8) Doppelte Titles"
dup=$(grep -ho '<title>[^<]*</title>' $htmls 2>/dev/null | sort | uniq -d)
if [ -n "$dup" ]; then
  printf '%s\n' "$dup" | while read -r d; do gelb "Title doppelt vergeben: $d"; done
else
  ok "alle Titles eindeutig"
fi

# --- 9. Bilder ohne alt ---------------------------------------------------
echo
echo "9) Bilder"
for f in $htmls; do
  n=$(grep -o '<img[^>]*>' "$f" 2>/dev/null | grep -vc 'alt=' || true)
  [ "${n:-0}" -gt 0 ] && rot "${f#./}: $n <img> ohne alt-Attribut"
done
ok "alt-Pruefung durchgelaufen"

# --- 10. Pflichtdateien ---------------------------------------------------
echo
echo "10) Pflichtdateien"
for p in impressum.html datenschutz.html agb.html 404.html robots.txt sitemap.xml; do
  [ -e "$p" ] && ok "$p vorhanden" || rot "$p fehlt"
done

# --- 10b. CNAME -----------------------------------------------------------
# Entscheidung 14.09.2026: keine Custom Domain. Eine CNAME-Datei ohne
# passendes DNS macht jede Seite unindexierbar.
echo
echo "10b) Custom Domain"
if [ -e CNAME ]; then
  rot "CNAME vorhanden ($(cat CNAME)) -- soll geloescht sein: git rm CNAME"
else
  ok "keine CNAME-Datei, Seite laeuft unter github.io"
fi

# --- 11. Sitemap-Konsistenz -----------------------------------------------
# topwash-Bezug: Sitemap listete 27 URLs, im Repo lagen 32.
echo
echo "11) Sitemap gegen Ordner"
if [ -e sitemap.xml ]; then
  python3 - <<'PY' || rot "sitemap.xml ist kein valides XML"
import xml.dom.minidom, sys
xml.dom.minidom.parse("sitemap.xml")
PY
  insitemap=$(grep -c '<loc>' sitemap.xml || true)
  indexierbar=0
  for f in $htmls; do
    rel="${f#./}"
    [ "$rel" = "404.html" ] && continue
    grep -qi 'name="robots"[^>]*noindex' "$f" && continue
    indexierbar=$((indexierbar+1))
  done
  if [ "$insitemap" -ne "$indexierbar" ]; then
    rot "Sitemap listet $insitemap URLs, indexierbar sind $indexierbar -> bash build-sitemap.sh"
  else
    ok "Sitemap deckt alle $indexierbar indexierbaren Seiten ab"
  fi
  grep -q '404.html' sitemap.xml && rot "404.html steht in der Sitemap"
fi

# --- 12. Externe Ressourcen -----------------------------------------------
# Ohne Consent-Banner ist jeder Drittanbieter-Request ein DSGVO-Thema.
echo
echo "12) Externe Ressourcen"
ext=$(grep -ho '<\(script\|link\|iframe\)[^>]*\(src\|href\)="https\?://[^"]*"' $htmls 2>/dev/null \
      | grep -v 'rel="canonical"' | grep -v 'og:url' \
      | grep -o 'https\?://[^"]*' | sed 's|\(https\?://[^/]*\).*|\1|' | sort -u \
      | grep -v '^https://intelligentresponder-max.github.io$')
if [ -n "$ext" ]; then
  printf '%s\n' "$ext" | while read -r d; do
    gelb "laedt von $d -- ohne Einwilligung pruefen (Fonts besser selbst hosten)"
  done
else
  ok "keine externen Ressourcen"
fi

# --- Ergebnis -------------------------------------------------------------
echo
echo "=========================================="
echo "  Fehler: $fehler   Hinweise: $warn"
echo "=========================================="
[ $fehler -eq 0 ] && echo "Abnahme bestanden." || echo "Nicht committen, solange Fehler offen sind."
exit $([ $fehler -eq 0 ] && echo 0 || echo 1)

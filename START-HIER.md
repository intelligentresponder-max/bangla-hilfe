# Start — Übergabe an Claude Code

## Dateien in dieses Repo kopieren

Alle fünf ins Wurzelverzeichnis von `bangla-hilfe`:

```
CLAUDE.md                    Projektkontext, liest Claude Code automatisch
AUFTRAG-umbau.md             Arbeitspakete AP 0 bis AP 7
scaffold-bangla-hilfe.sh     legt das Seitengerüst an
build-sitemap.sh             erzeugt sitemap.xml aus dem Ordner
pruefen.sh                   Abnahmeprüfung, 12 Punkte
```

**Android benennt Downloads um.** Wenn eine Datei schon existiert, wird aus
`CLAUDE.md` ein `CLAUDE-1.md`. Claude Code liest ausschließlich `CLAUDE.md` —
mit Suffix wird die Datei ignoriert und die Session startet ohne Kontext.
Nach dem Kopieren also prüfen und umbenennen:

```bash
cd ~/bangla-hilfe
git checkout master && git pull
# die fünf Dateien hierher kopieren
# Android-Suffix entfernen: CLAUDE-1.md -> CLAUDE.md, pruefen-1.sh -> pruefen.sh
for f in *-1.md *-1.sh *\ \(1\).md *\ \(1\).sh; do
  [ -e "$f" ] || continue
  neu=$(printf '%s' "$f" | sed 's/[ ]*(1)\(\.[^.]*\)$/\1/; s/-1\(\.[^.]*\)$/\1/')
  echo "  $f -> $neu"
  mv -i "$f" "$neu"
done

ls CLAUDE.md AUFTRAG-umbau.md pruefen.sh build-sitemap.sh scaffold-bangla-hilfe.sh
chmod +x *.sh
git add CLAUDE.md AUFTRAG-umbau.md *.sh
git commit -m "Uebergabe: Kontext, Arbeitsauftrag und Pruefskripte"
```

## Wenn `CLAUDE-1.md` schon im Repo liegt

Claude Code liest **nur** `CLAUDE.md`. Eine Datei mit Suffix wird
kommentarlos ignoriert — die Session startet dann ohne Projektkontext, ohne
dass eine Warnung erscheint. Deshalb muss die Datei umbenannt werden, nicht
nur kopiert.

**Fall A — schon committet und gepusht:**

```bash
cd ~/bangla-hilfe
git mv CLAUDE-1.md CLAUDE.md
git commit -m "CLAUDE.md: Android-Suffix entfernt"
git push
```

**Fall B — liegt nur im Arbeitsverzeichnis:**

```bash
mv CLAUDE-1.md CLAUDE.md
```

**Fall C — beide Dateien existieren** (weil du nach dem Suffix-Problem noch
einmal kopiert hast): Inhalte vergleichen, dann die Suffix-Version löschen.

```bash
diff CLAUDE.md CLAUDE-1.md && git rm -f CLAUDE-1.md
```

Läuft `diff` ohne Ausgabe durch, sind sie identisch und die Suffix-Datei
wird entfernt. Gibt es Unterschiede, bricht der Befehl ab und du siehst sie —
dann behältst du die neuere und benennst sie um.

**Kontrolle vor dem ersten Start:**

```bash
ls -1 CLAUDE*.md
```

Es darf genau eine Zeile erscheinen: `CLAUDE.md`. Steht dort noch etwas mit
Suffix, arbeitet Claude Code blind.

## Claude Code starten

```bash
cd ~/bangla-hilfe
claude
```

Erster Prompt:

> Lies CLAUDE.md und AUFTRAG-umbau.md. Führe AP 0 aus — nur Bestandsaufnahme,
> keine Dateiänderung. Berichte, welche Inhalte in welcher Sektion von
> index.html stehen und welche Zielseite sie bekommen sollen.

Danach je Arbeitspaket:

> Führe AP 1 aus. Danach `bash pruefen.sh`. Committe erst bei `Fehler: 0`.

## Getestet

Beide Skripte liefen gegen eine Nachbildung des echten Repos:

- `scaffold-bangla-hilfe.sh` legt 31 Dateien an, überschreibt keine
  vorhandene, zweiter Lauf schreibt nichts
- `build-sitemap.sh` nimmt nur befüllte Seiten auf, überspringt die 31
  Entwürfe und `404.html`, prüft die XML-Validität selbst
- `pruefen.sh` läuft danach mit `Fehler: 0   Hinweise: 0` durch

## Entschieden

**Verkaufskanal:** ausschließlich WhatsApp, wie in `topwash`. Kein Gumroad,
kein Stripe, kein Checkout. Der übrig gebliebene Gumroad-Link in
`index.html` wird in AP 4 ersetzt.

**Domain:** `bangla-hilfe.de` wird verworfen, `CNAME` in AP 1a gelöscht. Die
Seite läuft dauerhaft unter `intelligentresponder-max.github.io/bangla-hilfe/`.
`pruefen.sh` schlägt Alarm, falls die Datei wieder auftaucht.

## Noch offen

**Impressumsdaten** — Rechtsform, ladungsfähige Anschrift, Telefonnummer,
gegebenenfalls Registereintrag und USt-IdNr. Ohne diese Angaben bleibt AP 3
unvollständig; Claude Code erfindet sie nicht.
**Entschieden:** Verkauf läuft ausschließlich über WhatsApp, wie in
`topwash`. Kein Gumroad, kein Stripe. Der übrig gebliebene Gumroad-Link in
`index.html` wird in AP 4 ersetzt.

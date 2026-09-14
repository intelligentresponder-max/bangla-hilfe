# Übergabe für Claude Code – BanglaHilfe Deutschland

## Kontext
Bilinguale (DE/Bangla) GitHub-Pages-Seite für Neuankömmlinge aus Bangladesch. Repo unter dem Account `intelligentresponder-max`. Zwei visuelle Probleme wurden beim Testen auf einem Android-Handy im Chrome-Browser festgestellt.

## Problem 1: Überschriften-/Sektionsbereiche zu groß im Verhältnis zur Schrift
Auf mehreren Seiten (u. a. Startseite) sind farbige Bereiche (z. B. der grüne Hero-Bereich mit „Dein Weg nach Deutschland") deutlich größer/höher als der eigentliche Textinhalt es erfordert. Das wirkt unproportioniert auf kleinen Bildschirmen.

**Aufgabe:**
- Padding/Margin der betroffenen Sektionen (Hero-Bereich, farbige Info-Boxen wie den orangen „Frankfurt am Main · Hessen"-Badge, den dunklen Footer-Bereich) reduzieren bzw. an die tatsächliche Textgröße anpassen.
- Auf Mobilgeräten (Viewport ~360–400px Breite) prüfen, ob die Bereiche noch zu viel Leerraum oben/unten haben.
- Responsive Skalierung (z. B. clamp() für Schriftgrößen, angepasste Zeilenhöhen/Innenabstände je Breakpoint) statt fester px-Werte verwenden, wo möglich.

## Problem 2: Lektionen-Seite – reiner linksbündiger Text, kein Layout
Die Lektionen-Übersicht (aktuell z. B. „Lektion 2 – Nisha im Bus", „Lektion 3 – Rashed beim Baecker") zeigt die Lektionen nur als einfache linksbündige Textlinks untereinander, ohne visuelle Struktur.

**Aufgabe:**
- Lektionen als Karten/Cards darstellen (z. B. Grid- oder Flex-Layout), nicht als reine Linkliste.
- Jede Karte sollte optisch ansprechend gestaltet sein – z. B. mit Titel, kurzer Beschreibung/Vorschau, evtl. Icon oder Nummerierung, klar abgegrenzt durch Hintergrundfarbe/Schatten/Rahmen.
- Konsistent mit dem bestehenden Design (Farbschema Grün/Orange/Bangladesch-Deutschland-Flaggen-Thematik) halten.
- Auf Mobilgeräten: Karten untereinander (1 Spalte), auf breiteren Screens ggf. 2 Spalten.

## Hinweis
Beide Punkte sind rein visuelle/CSS-Anpassungen, keine Änderung an Inhalten oder Funktionalität nötig.

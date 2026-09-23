// ── HAMBURGER MENU ──
function toggleMenu(){ document.body.classList.toggle("menu-open"); }

// ── LANGUAGE SWITCHER (DE / BN / EN) ──
// Ersetzt die alte binaere body.bn-Klasse durch data-active-lang="de|bn|en"
// (siehe theme.css). data-lang-btn statt data-lang auf den Buttons, damit
// sie nicht von der [data-lang]-Sichtbarkeitsregel fuer Inhalte erfasst
// werden -- sonst waeren bei aktivem Deutsch die BN/EN-Buttons unsichtbar.
const LANGS = ['de', 'bn', 'en'];

function setLang(lang) {
  if (!LANGS.includes(lang)) lang = 'de';
  document.body.setAttribute('data-active-lang', lang);
  document.querySelectorAll('.lang-btn').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.langBtn === lang);
  });
  document.documentElement.lang = lang;
  localStorage.setItem('bh-lang', lang);
}

function toggleLang() {
  // Bottom-Bar-Button: zyklisch DE -> BN -> EN -> DE
  const current = document.body.getAttribute('data-active-lang') || 'de';
  const next = LANGS[(LANGS.indexOf(current) + 1) % LANGS.length];
  setLang(next);
}

// Restore language preference (Fallback: 'de')
const saved = localStorage.getItem('bh-lang');
setLang(saved && LANGS.includes(saved) ? saved : 'de');

// ── SCROLL REVEAL ──
const observer = new IntersectionObserver(entries => {
  entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
}, { threshold: 0.12 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

// ── SMOOTH NAV ACTIVE ──
const sections = document.querySelectorAll('section[id]');
window.addEventListener('scroll', () => {
  let current = '';
  sections.forEach(s => { if (window.scrollY >= s.offsetTop - 100) current = s.id; });
});

// ── FOOTER TEILEN ──
function shareWhatsApp() {
  const text = document.title + ' – ' + location.href;
  window.open('https://wa.me/?text=' + encodeURIComponent(text), '_blank');
}
function copyLink(btn) {
  const original = btn.textContent;
  navigator.clipboard.writeText(location.href).then(() => {
    btn.textContent = '✓ Kopiert!';
    setTimeout(() => { btn.textContent = original; }, 2000);
  }).catch(() => {
    btn.textContent = 'Fehler – bitte Link manuell kopieren';
    setTimeout(() => { btn.textContent = original; }, 2500);
  });
}

// ── INHALTS-ZAEHLER (FAQ/Glossar) ──
// Zaehlt vorhandene Elemente statt eine Zahl von Hand zu pflegen -- gleiches
// Prinzip wie build-sitemap.sh: generieren statt pflegen, damit der Zaehler
// nie veraltet, wenn spaeter Fragen/Begriffe dazukommen.
document.querySelectorAll('[data-count-selector]').forEach(el => {
  const n = document.querySelectorAll(el.dataset.countSelector).length;
  el.textContent = el.dataset.countLabel.replace('{n}', n);
});

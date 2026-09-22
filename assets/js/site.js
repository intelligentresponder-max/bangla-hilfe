// ── HAMBURGER MENU ──
function toggleMenu(){ document.body.classList.toggle("menu-open"); }

// ── LANGUAGE SWITCHER ──
function toggleLang(){ setLang(document.body.classList.contains('bn') ? 'de' : 'bn'); }
function setLang(lang) {
  document.body.classList.toggle('bn', lang === 'bn');
  document.querySelectorAll('.lang-btn').forEach(btn => btn.classList.remove('active'));
  const btn = document.querySelector(`.lang-btn:${lang==='de'?'first':'last'}-child`);
  if (btn) btn.classList.add('active');
  document.documentElement.lang = lang === 'bn' ? 'bn' : 'de';
  localStorage.setItem('bh-lang', lang);
}
// Restore language preference
const saved = localStorage.getItem('bh-lang');
if (saved) setLang(saved);

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

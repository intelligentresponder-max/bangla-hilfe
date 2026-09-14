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

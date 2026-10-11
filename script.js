const menuToggle = document.getElementById('menuToggle');
const mainNav = document.getElementById('mainNav');
menuToggle?.addEventListener('click', () => mainNav.classList.toggle('open'));
mainNav?.querySelectorAll('a').forEach(link => link.addEventListener('click', () => mainNav.classList.remove('open')));
document.getElementById('year').textContent = new Date().getFullYear();
document.getElementById('joinForm')?.addEventListener('submit', event => {
  event.preventDefault();
  document.getElementById('formStatus').textContent = 'Demo only: your details have not been sent or saved. Connect Supabase before accepting real requests.';
});

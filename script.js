(() => {
  const $ = (id) => document.getElementById(id);
  const year = $('year'); if (year) year.textContent = new Date().getFullYear();
  const menuToggle = $('menuToggle'), mainNav = $('mainNav');
  if (menuToggle && mainNav) menuToggle.addEventListener('click', () => mainNav.classList.toggle('open'));
  const ready = window.supabase && window.NOMAN_SUPABASE_URL && window.NOMAN_SUPABASE_PUBLISHABLE_KEY &&
    !window.NOMAN_SUPABASE_URL.includes('PASTE_') && !window.NOMAN_SUPABASE_PUBLISHABLE_KEY.includes('PASTE_');
  const client = ready ? window.supabase.createClient(window.NOMAN_SUPABASE_URL, window.NOMAN_SUPABASE_PUBLISHABLE_KEY) : null;
  const escapeHTML = (v) => String(v ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
  const form = $('joinForm'), status = $('formStatus');
  if (form) form.addEventListener('submit', async (e) => {
    e.preventDefault();
    if (!client) { status.textContent = 'Registration is not configured yet. Please try again later.'; return; }
    const data = new FormData(form);
    status.textContent = 'Submitting…';
    const { error } = await client.from('registrations').insert({
      full_name: String(data.get('fullName') || '').trim(), email: String(data.get('email') || '').trim(),
      whatsapp: String(data.get('whatsapp') || '').trim() || null, interest: String(data.get('interest') || 'Trading Community + Signals')
    });
    if (error) { status.textContent = 'Could not submit right now. Please try again later.'; console.error(error); return; }
    form.reset(); status.textContent = 'Thank you! Your membership request has been submitted.';
  });
  async function loadPublicContent() {
    if (!client) return;
    const historyGrid = document.querySelector('#history .history-grid');
    if (historyGrid) {
      const { data, error } = await client.from('trading_history').select('id,trade_date,account_type,result,notes,image_url').order('trade_date', {ascending:false}).limit(30);
      if (!error && data) historyGrid.innerHTML = data.length ? data.map((r,i) => `<article class="history-card"><div class="card-icon">↗</div><div class="card-meta">REPORT #${String(i+1).padStart(3,'0')} <span>${escapeHTML(r.account_type || 'MT5')}</span></div><h3>${escapeHTML(r.result || 'Trading Report')}</h3><p>${escapeHTML(r.notes || 'Published trading report.')}</p>${r.image_url ? `<a href="${escapeHTML(r.image_url)}" target="_blank" rel="noopener"><img src="${escapeHTML(r.image_url)}" alt="Trading report" loading="lazy" style="width:100%;border-radius:12px;margin-top:12px"></a>` : ''}<div class="card-bottom"><span>${escapeHTML(r.trade_date || '')}</span><span>Report</span></div></article>`).join('') : '<div class="review-placeholder"><h3>No reports published yet.</h3><p>New verified reports will appear here.</p></div>';
    }
    const reviewSection = $('reviews');
    if (reviewSection) {
      const { data, error } = await client.from('reviews').select('id,reviewer_name,review_text').order('created_at', {ascending:false}).limit(30);
      if (!error && data && data.length) reviewSection.querySelector('.review-placeholder')?.remove();
      if (!error && data && data.length) {
        let wrap = $('liveReviews'); if (!wrap) { wrap = document.createElement('div'); wrap.id='liveReviews'; wrap.className='history-grid'; reviewSection.appendChild(wrap); }
        wrap.innerHTML = data.map(r => `<article class="history-card"><div class="quote-mark">“</div><h3>${escapeHTML(r.reviewer_name)}</h3><p>${escapeHTML(r.review_text)}</p></article>`).join('');
      }
    }
  }
  loadPublicContent();
})();

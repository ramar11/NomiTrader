# Noman Trader website starter

A responsive black-and-gold static website for GitHub Pages. Includes a landing page, trading history placeholders, community/signals section, reviews placeholder, a demo membership form, and an admin setup guide.

## Important before publishing
- This is a **starter/demo**, not a complete production system.
- Trading report cards and reviews are placeholders. Replace them with genuine, verifiable content.
- The join form does **not** save or send submissions until a backend is connected.
- `admin.html` is a setup guide, not an authenticated admin dashboard.
- Never place a Supabase service-role key, password, broker credentials, or other secret in frontend files.
- Before collecting user details, connect Supabase Auth/Database/Storage, enable Row Level Security, and test access rules.

## Publish on GitHub Pages
1. Create/sign in to GitHub and make a new **public** repository, e.g. `noman-trader-website`.
2. Upload `index.html`, `styles.css`, `script.js`, `admin.html`, and `README.md` to the repository root.
3. Open **Settings → Pages**.
4. Under Build and deployment, select **Deploy from a branch**, choose `main` and `/ (root)`, then Save.
5. Wait for GitHub Pages to publish and use the URL shown in Settings → Pages.

## Daily edits before backend integration
You can edit the HTML and upload report image files to the repository, then update the relevant card in `index.html`. This requires editing files; the separate admin workflow described in `admin.html` is needed for no-code updates.

## Design notes
- Responsive for mobile and desktop
- Black/gold visual theme
- Includes trading risk language and avoids guaranteed-profit claims

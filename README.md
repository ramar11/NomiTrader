# Noman Trader website

## Files
- `index.html`: public website and membership request form
- `admin.html`: authenticated admin workspace
- `styles.css`: site styling
- `script.js`: public page behaviour and Supabase reads/submission
- `supabase-config.js`: your Supabase project URL and publishable key
- `setup.sql`: database, Row Level Security, and report-storage policies

## Setup overview
1. Open `supabase-config.js` and replace the two placeholders with your Supabase Project URL and **Publishable** key. Do not use a secret or service-role key.
2. In Supabase SQL Editor, run `setup.sql`.
3. In Supabase Authentication > Users, copy the UUID of your admin user. In SQL Editor, run `insert into public.admin_users(user_id) values ('PASTE-ADMIN-USER-UUID-HERE');` after replacing the placeholder with the UUID.
4. Upload all files in this folder to the root of your GitHub Pages repository (not the containing folder).
5. Test public registration and admin login. Public reports and report images are visible to anyone; remove personal/account identifiers from screenshots first.

The publishable key is designed for browser use only when Row Level Security policies are configured correctly. Never publish your database password, secret key, or service-role key. This site is not financial advice and does not guarantee results.

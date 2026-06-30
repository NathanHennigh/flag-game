# Supabase Auth Setup

This app is static, so Supabase uses the browser SDK and a local config file.

## 1. Add your frontend keys

Copy your Supabase project URL and publishable key from Supabase Dashboard -> Project Settings -> API.

Edit `supabase-config.js`:

```js
window.WORLD_FLAGS_SUPABASE = {
  url: "https://YOUR_PROJECT_REF.supabase.co",
  publishableKey: "sb_publishable_YOUR_PUBLISHABLE_KEY",
};
```

`supabase-config.js` is ignored by git. `supabase-config.example.js` is the committed template.

## 2. Enable email/password

In Supabase Dashboard -> Authentication -> Providers -> Email, keep Email enabled. Decide whether you want confirmation emails required before sign-in.

The app calls:

- `supabase.auth.signUp({ email, password, options: { emailRedirectTo } })`
- `supabase.auth.signInWithPassword({ email, password })`

## 3. Enable Google sign-in

In Google Cloud / Google Auth Platform:

1. Create an OAuth client ID with application type `Web application`.
2. Add `http://localhost:5173` to Authorized JavaScript origins for local development.
3. Add your production origin when you deploy.
4. Add your Supabase callback URL to Authorized redirect URIs:

```text
https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback
```

You can also copy the exact callback URL from Supabase Dashboard -> Authentication -> Providers -> Google.

In Supabase Dashboard -> Authentication -> Providers -> Google:

1. Enable Google.
2. Paste the Google Client ID and Client Secret.
3. Save.

## 4. Configure Supabase redirects

In Supabase Dashboard -> Authentication -> URL Configuration:

- Site URL: `http://localhost:5173`
- Redirect URLs: `http://localhost:5173/**`
- Add your production URL when deployed, preferably as an exact URL.

The app redirects OAuth and email confirmations back to the current page.

## 5. Run locally

Serve the folder over HTTP:

```powershell
python -m http.server 5173
```

Open:

```text
http://localhost:5173/
```

Google OAuth will not be pleasant from a raw `file://` URL, so use the local server.

## 6. Google consent screen policy links

Local URLs for testing:

```text
http://127.0.0.1:5173/privacy.html
http://127.0.0.1:5173/terms.html
```

For Google's production consent screen, deploy these pages and use public HTTPS URLs, for example:

```text
https://flags.thehennighs.com/privacy
https://flags.thehennighs.com/terms
```

Before publishing, replace `your-email@example.com` in both files with your real contact email and have the boilerplate reviewed for your actual use case.

For Vercel, `vercel.json` enables clean URLs so `/privacy` serves `privacy.html` and `/terms` serves `terms.html`.

## Production auth on Vercel

In Supabase Dashboard -> Authentication -> URL Configuration:

- Site URL:

```text
https://flags.thehennighs.com
```

- Redirect URLs:

```text
https://flags.thehennighs.com/**
http://127.0.0.1:5173/**
http://localhost:5173/**
```

In Google Cloud / Google Auth Platform -> Clients -> your Web client:

- Authorized JavaScript origins:

```text
https://flags.thehennighs.com
http://127.0.0.1:5173
http://localhost:5173
```

- Authorized redirect URIs:

```text
https://rarnxljkxegjokfzzipi.supabase.co/auth/v1/callback
```

Google consent screen links:

```text
https://flags.thehennighs.com/privacy
https://flags.thehennighs.com/terms
```

## 7. Progress database table

Signed-in users sync quiz stats, flashcard reviews, SRS weights, and best scores to Supabase. Guests can still play, but guest progress stays in that browser.

In Supabase Dashboard:

1. Open your project.
2. Go to SQL Editor.
3. Create a new query.
4. Paste the contents of `supabase-progress-schema.sql`.
5. Click Run.

The table name is:

```text
public.world_flags_progress
```

The policies allow each authenticated user to read, insert, and update only their own progress row.

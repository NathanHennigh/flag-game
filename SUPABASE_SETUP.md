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

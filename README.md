# Hashmi Studio — Portfolio

Static portfolio site (HTML + Tailwind CDN). Form uses [FormSubmit](https://formsubmit.co) → `sharifdesigner2@gmail.com`.

## Run locally

Double-click `start-website-server.bat` or:

```bash
python -m http.server 8080
```

Open `http://localhost:8080`.

## Deploy to GitHub

1. Install [Git for Windows](https://git-scm.com/download/win), then **close and reopen** your terminal.

2. On GitHub, create a **new empty repository** (no README/license) and copy its HTTPS URL.

3. **Easiest:** in PowerShell, from this folder run:

```powershell
cd "d:\pertfolio website"
.\push-portfolio.ps1
```

Paste the repo URL when asked. The first `git push` may open a browser or ask for your GitHub username and a **Personal Access Token** (not your password): [Create token (repo scope)](https://github.com/settings/tokens).

If Git says **“dubious ownership”** (common on exFAT or external drives), run once:

`git config --global --add safe.directory "D:/pertfolio website"`

(use your real path; forward slashes are fine). The updated `push-portfolio.ps1` does this automatically.

**Manual commands** (same result):

```bash
git init
git add .
git commit -m "Initial commit: portfolio site"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/hashmi-studio-portfolio.git
git push -u origin main
```

**Large files:** GitHub blocks files **over 100MB**. If `git push` fails, remove or replace huge `.mp4` files (or use [Git LFS](https://git-lfs.com)).

## Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) and sign in with GitHub.
2. **Add New Project** → **Import** your repository.
3. Framework: **Other** · Root: **`./`** · Build command: **leave empty** · Output: **`.`** (or default).
4. **Deploy**. Your site will be live at `https://….vercel.app`.

After deploy, test the contact form on the **live HTTPS URL** and complete any FormSubmit domain confirmation if asked.

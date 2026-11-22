# The Artisan Thread — Web Application Deployment Guide

This project has been upgraded into a complete, multi-portal web application ready for instant deployment to the web.

---

## 🚀 Instant Deployment Options (100% Free)

Choose any of the options below to get a live public URL for your web application.

---

### Option 1: Drag & Drop on Netlify (Fastest & Zero Setup — 30 Seconds)
*Best if you don't want to use Git or the command line.*

1. Open your browser and go to [app.netlify.com/drop](https://app.netlify.com/drop).
2. Sign in or create a free Netlify account.
3. Open your File Explorer to:
   `c:\Users\lenovo\Downloads\The Artisan Thread – Landing Page-project`
4. Drag the entire project folder and drop it into the Netlify Drop area in your browser.
5. In 10 seconds, Netlify will publish your site and provide a live `https://<site-name>.netlify.app` link.
6. *(Optional)* Click **Site Settings** > **Change site name** to choose a custom name (e.g. `the-artisan-thread.netlify.app`).

---

### Option 2: Deploy to GitHub Pages (Free & Automatic)
*Your project is already initialized with Git and committed locally.*

1. Go to [github.com/new](https://github.com/new) and create a new repository (e.g., `the-artisan-thread`).
2. Run these commands in PowerShell inside this directory:
   ```powershell
   git remote add origin https://github.com/<YOUR_GITHUB_USERNAME>/the-artisan-thread.git
   git branch -M main
   git push -u origin main
   ```
3. In your GitHub repository:
   - Go to **Settings** > **Pages** (in the left sidebar).
   - Under **Build and deployment > Branch**, select `main` and folder `/ (root)`.
   - Click **Save**.
4. In about 1 minute, your site will be live at:
   `https://<YOUR_GITHUB_USERNAME>.github.io/the-artisan-thread/`

---

### Option 3: Deploy with Vercel (Production Edge Network)

#### Via Vercel Web Dashboard:
1. Push to GitHub (as in Option 2).
2. Go to [vercel.com/new](https://vercel.com/new) and click **Import** next to your repository.
3. Leave Framework Preset as **Other** and Root Directory as `./`.
4. Click **Deploy**. Vercel will provide an instant URL like `https://the-artisan-thread.vercel.app`.

---

## 💻 Local Testing & Preview

You can run your web application locally anytime without needing Python or Node.js:

1. Right-click `start-server.ps1` and select **Run with PowerShell** (or run `.\start-server.ps1` in PowerShell).
2. Your default web browser will automatically open:
   [http://localhost:8080/](http://localhost:8080/)
3. To stop the local server, press `Ctrl + C` in the PowerShell window.

---

## 📂 Web Application Architecture

| File | Purpose |
| :--- | :--- |
| `index.html` | **Main Landing Page** (`#top`, `#how`, `#designers`, `#tailors`, `#login` role selector) |
| `Customer.html` | **Customer Portal** (13 measurements profile, order ORD-1042 tracking, designer selection) |
| `Designer.html` | **Designer Studio** (Orders to draft, step-by-step formula engine, method publisher) |
| `Tailor.html` | **Hub Tailor Workshop** (Jobs to cut & stitch, 1:1 scale printable pattern sheet) |
| `Admin.html` | **Studio Administration** (Onboarding queue, method approvals, one-role validation) |
| `Onboarding.html` | **Designer Onboarding** (Interactive registration form, slots TAT-D001 to TAT-D010) |
| `styles.css` | Shared aesthetic styling, modals, toast notifications, print styles |
| `app.js` | Interactive client logic (measurement saving, visit booking, live onboarding, job progression) |
| `vercel.json` | Vercel routing configuration |
| `netlify.toml` | Netlify redirect & publishing configuration |
| `start-server.ps1` | Zero-dependency local web server powered by Windows .NET HttpListener |
| `*.dc.html` | Original Design Component files (preserved for design editor compatibility) |

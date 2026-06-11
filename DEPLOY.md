# Deployment & rollback

GitHub Pages serves from the `main` branch root.

## Live URLs

| URL | What |
|-----|------|
| `https://mihirsethidp.github.io/UserFlowConfiguration/` | **Current** — Fable redesign (tree-map → flow editor → simulate) |
| `https://mihirsethidp.github.io/UserFlowConfiguration/legacy/` | **Previous version** — the v6 single-canvas build, archived & still live |
| `https://mihirsethidp.github.io/UserFlowConfiguration/preview/` | Staging copy of the redesign (mirrors `fable-redesign` branch) |

The active source lives at the repo root (`index.html`). `legacy/` and `preview/` are full standalone copies.

## Redeploy the previous version (rollback)

Run `rollback.ps1`, or manually:

```powershell
cd "D:\User Flow\UserFlowConfiguration"
Copy-Item index.html "redesign-backup.html" -Force   # keep the redesign
Copy-Item legacy\index.html index.html -Force        # promote previous to root
git add index.html ; git commit -m "Rollback: restore previous version to root" ; git push
```

To go forward again (re-promote the redesign):

```powershell
cd "D:\User Flow\UserFlowConfiguration"
git show fable-redesign:index.html > index.html
git add index.html ; git commit -m "Promote redesign to root" ; git push
```

Either way the *other* version stays live at its subfolder, so switching the root never loses anything.

## Branches

- `main` — what GitHub Pages serves.
- `fable-redesign` — ongoing work on the redesign; merge/copy into `main` root to ship.

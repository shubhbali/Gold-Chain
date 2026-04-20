# GiltChain Main Site

Premium main website for Gold Chain and bridge flows.

## Stack

- React + TypeScript + Vite
- Framer Motion for motion system
- React Router for routed sections

## Commands

- `npm install`
- `npm run dev`
- `npm run build`
- `npm run lint`

## Deploy Notes

- Vite base path is `/giltchain/`
- Build output is `dist/`
- Nginx should serve `/giltchain/` from this folder with SPA fallback to `/giltchain/index.html`

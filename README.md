# UserFlowConfiguration

Canvas-based editor for designing diagnostic-tree flows. Inspired by Figma's prototyping mode: drag nodes from a palette, draw connections port-to-port, edit properties in a right-side inspector.

## Try it

Open `index.html` in any modern browser, or visit the GitHub Pages deployment.

On first load, pick:
- **Demo** — pre-loaded with the "Low DO in Aeration Tank" tree (6 flows). Flow 3 mirrors the original drawio.
- **From scratch** — blank tree, one entry node.

Your work auto-saves to `localStorage`.

## Concepts

- **Tree** — one issue (e.g. "Low DO in Aeration tank").
- **Flow** — one ordered root-cause hypothesis under a tree. Multiple flows per tree, triaged in order.
- **Step / Node** — the building blocks inside a flow: questions, actions, terminals, jumps, waits, fallbacks.
- **Edge** — a connection between two nodes, with an optional condition.

## Node types

| Color | Type | Use |
|---|---|---|
| 🟢 | Entry | Flow start |
| 🔵 | Question | Branch by operator answer |
| 🟠 | Action / Task | Upload image, send message, call supervisor, RCA |
| 🟣 | Wait | Time delay or wait-for-event |
| ⚪ | Terminal | "Stop here" — flow ends |
| 🩷 | Jump to Flow | Hand off to another flow in the same tree |
| 🔴 | Fallback | Catch-all when no condition matches |

## Controls

- **Drag a palette item** onto the canvas to add a node.
- **Drag a node** to move it.
- **Drag from a right port → left port** to connect.
- **Click** any node or edge to edit it in the right panel.
- **Scroll** to zoom, **drag empty canvas** to pan.
- **Delete / Backspace** to remove selection.
- **Auto-layout** button arranges nodes by BFS depth.

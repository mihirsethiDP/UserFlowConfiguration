# UserFlowConfiguration — Project Context

A canvas-based editor for designing **diagnostic trees**: the operator-facing flow that walks a technician from an incoming issue (Trigger) through diagnosis steps to a root cause.

This file collects every piece of context surfaced during the design conversation — source material, domain model, design references, requirements, and decisions.

---

## 1. Domain model (locked in)

```
Diagnostic Tree
└── Trigger              ← the issue / event that opens the diagnostic
    └── Possible Root Causes  ← enumerated, sequenced list of candidates
        └── (each cause) → Diagnostic Flow
            └── Diagnostic Steps (Question · Action · Sensor · …)
                └── Done OR Jump to another root-cause flow
```

**Important nuance**: the *operator* does not pick a root cause. They walk through the chosen flow's steps and the journey lands them on the root cause. "Possible Root Causes" is the configurator's enumeration of what *could* be diagnosed; the steps inside each flow confirm or rule it out.

- **Tree** can be saved as a template.
- **Individual flow** within a tree can also be templatized for reuse across trees.
- A flow's terminal is either **Done** or a **Jump** to another root-cause flow.

---

## 2. Source material

### 2.1 Drawio file — "Flow for Claude.drawio"

Original visualization of **Flow 2** of the *Low DO in Aeration Tank* tree, plus its link to Flow 3 (DO Sensor Failure).

**Key shapes / patterns it established:**
- Entry → numbered Step nodes (Step 1, Step 2…)
- Each Step is a **Question** with multiple **Answer cards** branching off
- Answer cards converge into either an **Action** (Upload Image, Call Supervisor, Send Message, Reassignment) or a **Terminal** (Done / Stop / Call supervisor) or a **Jump** to the next flow
- "Skip to End", "Reassignment", and "Fall Back" appear as named branches

User confirmed: "DO sensor failure is a diagnostic flow in the same tree" — i.e. the "Next Diagnostic Tree" label in the drawio is misleading; it's a sibling flow, not a different tree.

### 2.2 Excel file — "Diagnostic Tree.xlsx"

Two trees, both with the same schema:

**Columns**: `Issue · Root Cause Step · Possible Root causes · Frequency · How to identify · Solution · Tool if needed · Triggers · Insights · Tasks`

**Tree 1 — Low DO in Aeration tank** (6 ordered root-cause flows):
| # | Root cause | Freq |
|---|------------|------|
| 1 | Blower is OFF | Low |
| 2 | Blower performance | Low |
| 3 | Uneven bubbling / dead zones | Low–Mod |
| 4 | DO sensor failure | Low–Mod |
| 5 | Sludge bulking | Mod–High |
| 6 | Shock load / toxicity | High |

**Tree 2 — Leakage in Filter feed pump** (5 ordered root-cause flows):
1. Excessive discharge pressure
2. Filter choking back-pressure
3. Mechanical seal failure
4. Gland packing wear
5. Bearing failure

Columns **Triggers / Insights / Tasks** are present as headers but empty across all rows — left out of the config model per user instruction.

### 2.3 Design references shared by user

1. **Reference prototype** — `ranjanamajumdar-ship-it.github.io/User-flow/flow-canvas/config.html`
   Influence: question subtypes (Single / Multi / Numeric / Yes-No / Photo / Free text), inline routing table inside the question card, "Generate answer cards" affordance.

2. **Makelog.io screenshot** — dark-rail + 2-column icon-card palette ("Action Blocks"), card style with badge in corner, diamond decision nodes, floating quick-add pill at bottom, dark navy header. Influence: 2-col palette grid, dark header, view-toggle, search box at top of palette.

3. **Figma-style flow editor screenshot** — clean cards with type chip top-left, 4 connection circles on each side, stepper at top ("1 Set up — 2 Build the flow — 3 Review"), centered Canvas/Form/Delta toggle, Save / Clear top-right, vertical sidebar of node types ("Issue/Trigger", "Question", "Answer", "Waiting", "Root cause selector", "Action", "Observation"). Influence: 3-step wizard, slide-in inspector, vertical sidebar list.

4. **Hand-drawn sketch** (notebook photo) — **Trigger → Root Cause (3 numbered ports along bottom) → Diagnostic Flow 1 / 2 / 3 side-by-side**. Top-down flow direction. Each numbered slot in the root-cause card has its own bottom port. Influence: the canvas is now top-down by default; branching cards expose per-option ports along the bottom edge; vertical view renders all-flow-link branches side-by-side as flow cards.

---

## 3. Node-type vocabulary

Grouped to match the hierarchy:

### Step blocks
| Type | Purpose |
|------|---------|
| **Trigger** | Entry point — the issue that kicks off the tree |
| **Possible Root Causes** | List of root-cause candidates; each routes to its own diagnostic flow. Has per-cause **sequence** |
| **Question** | Decision step. Multiple options → per-option ports. Has **sequence** for display order within a flow |
| **Action** | Task the operator performs. Has an **Action type** selector |
| **Sensor reading** | Read a value by **Sensor tag** (preset); thresholds **Safe / Warning / Critical** inherited from tag, can be overridden. Each band routes independently |

### Helpers
| Type | Purpose |
|------|---------|
| **Reassign** | Hand off to another **Role** + optional user |
| **Waiting** | Pause — Time-based (value + unit) OR Event-based |
| **Skip to the end** | Operator bypass — implicit chain to Photo + RCA → Done |
| **Jump to flow** | Transition to another flow in the same tree |
| **Done** | Terminal — flow ends here |

### Removed earlier on user request
- **Answer card** (consolidated into Action)
- **Observation** (consolidated into Action)
- Action sub-types **RCA selector**, **Form input**, **Photo + RCA** were removed; the "Skip to the end" node now carries the Photo+RCA chain implicitly

### Action types
`Photo upload · Send message · Call supervisor · Escalate · Custom`

Action types with **user selection** (Role + optional User): **Send message**, **Call supervisor**, **Escalate**.

### Roles (for Reassign + escalate user selection)
`Supervisor · Maintenance · Process Engineer · Lab Technician · Field Operator · Custom`

### Sensor tag presets
`DO Tank 01/02 · Header pressure · Reactor temp · Inlet pH · Recirculation flow · MLSS` (plus Custom)

Selecting a tag inherits its unit and Safe/Warning/Critical min-max ranges into the threshold bands.

---

## 4. UX decisions

- **Two views, one toggle**:
  - **Horizontal (canvas)** — free-form top-down 2D canvas. Drag, zoom, port-to-port connections.
  - **Vertical (stepped)** — same data, rendered as a stepped list of cards walking BFS from the Trigger. Branches expand as indented sub-trees; all-flow-link branches render side-by-side.
- **Flow direction** is **top-down** (per the hand sketch). Input port on top of every card, output ports along the bottom (one per branch for Possible Root Causes / Question / Sensor).
- **Inline editing on cards** — label, description, and per-option text edit in place; route pill click opens an inline dropdown.
- **Right-side inspector drawer** opens on selection for everything else (action type, sensor tag, sequence, role, threshold ranges, etc.). Closes on Esc / × / blank-canvas click.
- **+ buttons**:
  - On any non-branching card → adds a downstream node from the bottom output port
  - When dragging from a port and dropping on empty canvas → opens an insert popover wired to that port (or per-option / per-threshold)
- **Templates**:
  - Built-in: Low DO Diagnostic · Pump Leakage · Basic Triage
  - User-saved templates live in `localStorage` (key `flowconfig-templates-v1`)
- **Helper boxes** in the inspector — every selected node shows a 💡 explainer for what the type is for. Palette items have hover tooltips with the same text.
- **Auto-layout** — BFS top-down (`⤓ Layout` button in the zoom pill).

---

## 5. Tech stack & deployment

- **Single self-contained `index.html`** (no build step, no external deps, no framework).
- **Persistence**: `localStorage` — `flowconfig-v6` (data) and `flowconfig-templates-v1` (templates), `flowconfig-view` (view mode).
- **Deployment**: GitHub Pages from `main` branch root. Live at:
  https://mihirsethidp.github.io/UserFlowConfiguration/
- **Repo**: https://github.com/mihirsethiDP/UserFlowConfiguration

---

## 6. Storage key history

| Key | Reason for bump |
|-----|-----------------|
| `flowconfig-v1` | Initial |
| `flowconfig-v2` | Added answer-card node type |
| `flowconfig-v3` | Per-option ports + question subtypes |
| `flowconfig-v4` | Hierarchy redesign (Triage flow, Possible Root Causes) |
| `flowconfig-v5` | Skip-to-end + view toggle |
| `flowconfig-v6` | **Current** — top-down flow direction, bottom-distributed ports |

---

## 7. Things deliberately deferred

Mentioned during discussion but not built yet — call out before resuming:

- **Simulate mode** — walk through the flow as an operator would, highlighting the active node.
- **Validation tray** — unreachable nodes, unrouted options, duplicate sequences.
- **Drag-to-reorder** sequences in the inspector / per-option rows.
- **Save individual flow as template** (only whole-tree templates today).
- **Centering children under their parent's port column** in auto-layout (current layout starts each row at the same X).
- **Sketch-style explicit "+" markers** between connected cards (as opposed to the per-port + button that exists today).

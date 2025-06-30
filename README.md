# 🧩 Puzzle System (Godot 4.x)

## 📄 Overview

This project implements a **drag-and-drop puzzle system** in Godot 4.x. It divides an image into pieces that the player can move, snap, and merge to complete the puzzle.  
It includes a debug panel showing live info (IDs, positions, neighbors, etc.).

---

## 💡 Methodology & Motivation

The idea is to create a **flexible and dynamic puzzle** system that:

- Works with **any image**.
- Allows you to define the number of columns and rows.
- Supports merging pieces dynamically through snap logic.
- Provides real-time visual debugging.

The system does not rely on shape masks or predefined puzzle pieces. Instead, it splits the image into rectangles and uses logical adjacency checks to snap them together.

---

## ⚙️ How it works

### Splitting the image

1. Resize using a configurable scale.
2. Divide into `N_en_x` columns and `N_en_y` rows.
3. Create `TextureRect` nodes for each sub-image region.

### Piece logic

Each piece contains:

- A **unique ID**.
- Matrix position.
- Neighbor IDs (left, right, up, down).
- Group ID for merging.

### Snapping & merging

- While dragging, a piece (or group) follows the cursor.
- When released, it checks its neighbors.
- If close enough (`SNAP_DISTANCE`), it snaps and merges groups.

---

## ✅ Why this method?

- **Flexible**: Works with any image and any grid size.
- **Dynamic**: Groups merge dynamically.
- **No masks needed**: Purely logical.
- **Lightweight**: Only updates on drag.

---

## 💻 Debug panel

- FPS
- ID
- Matrix position
- Global position
- Neighbor IDs
- Completion status

---

## 🚀 Usage

1. Set an image and background.
2. Configure `N_en_x`, `N_en_y`, and `escala_imagen`.
3. Run and drag pieces to assemble the puzzle.
4. A "🎉 Completed" message appears when all pieces merge.

---

## 🌐 Other languages

- 🇪🇸 [Spanish Version](README_ES.md)
- 🖖 [Klingon Version](README_KLINGON.md)


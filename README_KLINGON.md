# 🧩 Puzzle System (Godot 4.x)

## 📄 meq

vam 'oH puzzle system'e', Godot 4.x lo'.  
cha'logh image' vItlhutlh, pieces vItlhutlh, vIqaw, merge, tIq puzzle complete.

---

## 💡 meq & qech

puS:

- **image** Hoch vItlhutlh.
- columns & rows choq.
- dynamic merge & snap logic.
- real-time debug info.

mask ghajbe'! Logic-based neH.

---

## ⚙️ chay' Qap

### image split

1. Resize (scale parameter).
2. Divide (columns `N_en_x`, rows `N_en_y`).
3. TextureRect pieces chenmoH.

### piece logic

- Unique ID
- Matrix position
- Neighbor IDs (left, right, up, down)
- Group ID

### Snap & merge

- Dragging, piece/group follows.
- Drop => check neighbors.
- Snap merge if close.

---

## ✅ qatlh?

- **Flexible**: image Hoch vItlhutlh.
- **Dynamic**: merge automatic.
- **Lightweight**: drag only update.
- **Mask ghajbe'!**

---

## 💻 Debug panel

- FPS
- ID
- Matrix pos
- Global pos
- Neighbor IDs
- Complete status

---

## 🚀 lo'

1. image & background set.
2. `N_en_x`, `N_en_y`, `escala_imagen` config.
3. Play, drag pieces, puzzle complete.
4. "🎉 Complete" message.

---

## 🌐 Language

- 🇬🇧 [English](README.md)
- 🇪🇸 [Español](README_ES.md)

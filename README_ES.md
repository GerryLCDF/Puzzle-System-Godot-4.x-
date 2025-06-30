# 🧩 Sistema de Rompecabezas (Godot 4.x)

## 📄 Descripción general

Este proyecto implementa un **sistema de rompecabezas arrastrable** en Godot 4.x. Divide una imagen en piezas que el jugador puede mover, acoplar y unir para completar el rompecabezas.  
Incluye un panel de depuración con información en tiempo real (IDs, posiciones, vecinos, etc.).

---

## 💡 Metodología y motivación

La idea es crear un **sistema flexible y dinámico** que:

- Funciona con **cualquier imagen**.
- Permite definir el número de columnas y filas.
- Admite unión dinámica de piezas mediante lógica de acople.
- Proporciona depuración visual en tiempo real.

No utiliza máscaras ni piezas con forma predefinida; se basa en dividir la imagen en rectángulos y comprobar adyacencia lógica para unir.

---

## ⚙️ Cómo funciona

### División de la imagen

1. Se redimensiona usando el parámetro de escala configurable.
2. Se divide en `N_en_x` columnas y `N_en_y` filas.
3. Se crean nodos `TextureRect` para cada subimagen.

### Lógica de piezas

Cada pieza contiene:

- Un **ID único**.
- Posición en matriz.
- IDs de vecinos (izquierda, derecha, arriba, abajo).
- ID de grupo para fusionarse.

### Acople y fusión

- Mientras se arrastra, la pieza (o grupo) sigue el cursor.
- Al soltar, revisa sus vecinos.
- Si está cerca (`ACOPLE_DISTANCIA`), se alinea y fusiona los grupos.

---

## ✅ ¿Por qué este método?

- **Flexible**: funciona con cualquier imagen y tamaño.
- **Dinámico**: los grupos se fusionan de forma natural.
- **Sin máscaras**: 100% lógico.
- **Ligero**: solo actualiza en arrastre.

---

## 💻 Panel de depuración

- FPS
- ID
- Posición en matriz
- Posición global
- IDs de vecinos
- Estado de completado

---

## 🚀 Uso

1. Asigna una imagen y fondo.
2. Configura `N_en_x`, `N_en_y` y `escala_imagen`.
3. Ejecuta y arrastra las piezas para armar el rompecabezas.
4. Cuando todas se unen, aparecerá "🎉 Completaste".

---

## 🌐 Otros idiomas

- 🇬🇧 [Versión en Inglés](README.md)
- 🖖 [Versión en Klingon](README_KLINGON.md)

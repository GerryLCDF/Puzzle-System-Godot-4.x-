🧩 Puzzle System (Godot 4.x)
📄 Overview
This project implements a drag-and-drop puzzle system in Godot 4.x. It divides a single image into multiple pieces that can be freely moved, snapped, and reassembled by the player.
It also includes a debug panel displaying information in real time (IDs, matrix positions, neighbors, and global positions).

💡 Methodology & Motivation
The main idea is to create a flexible puzzle system that:

Uses any texture as the source image.

Automatically divides it into a configurable number of pieces (rows × columns).

Allows each piece to be moved individually or grouped dynamically as they snap together.

Supports visual feedback for debugging, including piece IDs and adjacency data.

Instead of using pre-defined shapes or mask atlases, this system works purely by splitting the image grid-wise and implementing snapping logic based on logical adjacency.

⚙️ How it works
Image splitting
The image is resized using a configurable scale parameter.

It is divided into a grid of pieces_x columns and pieces_y rows.

Each grid cell becomes a TextureRect, storing its original sub-region.

Piece data
Each piece is represented by a Piece class that stores:

A unique ID.

Matrix coordinates (matrix_pos).

References to neighboring piece IDs (left, right, up, down).

Its current TextureRect (node) and group information (used for snapping).

Movement & snapping
When clicking on a piece, a "reference piece" is set and an offset is calculated to track precise dragging.

Pieces can belong to a group, which moves all grouped pieces together.

On mouse release, pieces check nearby neighbors to see if they are within a snap distance (SNAP_DISTANCE). If so, they automatically align and merge into the same group.

🧠 Algorithm & logic
Piece movement
Detect click and calculate offset from mouse position to piece's global position.

While dragging, update all pieces in the same group.

On release, iterate over neighbors and calculate expected positions.

If within a threshold, snap the piece into place and merge groups if necessary.

Group merging
When pieces snap together, the system:

Checks both groups' IDs.

Merges them into a single group if different.

Updates group references for all pieces.

✅ Why this approach
💪 Modularity: Each piece is independent and can be freely manipulated.

🔄 Dynamic merging: No need for pre-defined final positions or "locked" states — groups are formed naturally.

🎨 Visual freedom: Works with any image without additional masking or shape logic.

⚡ Performance-friendly: Only updates necessary nodes during drag, no per-frame heavy recalculations.

💻 Debug panel
The system displays:

FPS

Selected piece ID

Matrix position

Global screen position

IDs of neighbors (left, right, up, down)

Puzzle completion status

🚀 How to use
Assign an image to image and a background to background.

Configure pieces_x, pieces_y, and image_scale.

Run the scene. Drag pieces, snap them together, and complete the puzzle!

When all pieces are merged into one group, a "Completed" message appears.

⭐ Future improvements (optional ideas)
Add piece shapes (e.g., puzzle tabs and holes) using shaders or masks.

Snap preview lines or highlight when close.

Save and load puzzle state.

Animations or sounds when snapping pieces.

✨ Final notes
This project is a fun and flexible base for building puzzle games in Godot.
If you'd like, I can also help generate diagrams or GIF animations to include visually in your README!


extends Node2D

# Debug section
@onready var fps_label: Label = $Info/VBoxContainer/FPS/FPS_tex # Show FPS
@onready var id_label: Label = $Info/VBoxContainer/ID_pieza/iD_tex
@onready var matrix_label: Label = $Info/VBoxContainer/Matriz/Matriz_tex
@onready var global_pos_label: Label = $Info/VBoxContainer/Global_posicion/Global_tex
@onready var left_label: Label = $Info/VBoxContainer/Pieza_left/Pieza_left_tex
@onready var right_label: Label = $Info/VBoxContainer/Pieza_right/Pieza_right_tex
@onready var up_label: Label = $Info/VBoxContainer/Pieza_up/Pieza_up_tex
@onready var down_label: Label = $Info/VBoxContainer/Pieza_down/Pieza_down_tex
@onready var complete_label: Label = $Info/VBoxContainer/comple/completado_tex # Show if completed

@export_category("Required Images")
@export var background: Texture2D
@export var image: Texture2D
@export_range(1, 20, 1) var pieces_x: int = 1
@export_range(1, 20, 1) var pieces_y: int = 1
@export_range(0.1, 10.0, 0.1) var image_scale: float = 1.0

var pieces: Array = []
var matrix: Array = []
var reference_piece: Piece = null
var click_offset_local := Vector2.ZERO
var dragging_group_id := -1
var next_group_id := 0
const SNAP_DISTANCE := 10.0

class Piece:
	var id: String
	var group_id: int = -1
	var texture_rect: TextureRect
	var matrix_pos: Vector2i
	var snapped := false
	var id_left: String = ""
	var id_right: String = ""
	var id_up: String = ""
	var id_down: String = ""

func _process(_delta: float) -> void:
	if reference_piece != null:
		update_debug(reference_piece)

func _ready():
	# Create container for background
	if background:
		var bg_container := Control.new()
		bg_container.name = "BackgroundContainer"
		bg_container.z_index = -10
		add_child(bg_container)

		# Create TextureRect for background
		var bg_rect := TextureRect.new()
		bg_rect.texture = background
		bg_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		bg_rect.stretch_mode = TextureRect.STRETCH_SCALE
		bg_rect.size = background.get_size() * 2.0
		bg_rect.position = Vector2.ZERO
		bg_rect.z_index = -10
		bg_rect.z_as_relative = false

		bg_container.add_child(bg_rect)

	# Call function to divide image into pieces
	if image:
		divide_image()

func divide_image():
	pieces.clear()
	matrix.clear()
	for child in get_children():
		if child is TextureRect:
			child.queue_free()

	var img := image.get_image()
	img.resize(img.get_width() * image_scale, img.get_height() * image_scale)
	var cols := pieces_x
	var rows := pieces_y
	var piece_size := Vector2(img.get_width() / cols, img.get_height() / rows)

	for y in range(rows):
		var row := []
		for x in range(cols):
			row.append(null)
		matrix.append(row)

	for y in range(rows):
		for x in range(cols):
			var region := Rect2(Vector2(x, y) * piece_size, piece_size)
			var sub_img := img.get_region(region)
			var tex := ImageTexture.create_from_image(sub_img)

			var tr := TextureRect.new()
			tr.texture = tex
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.size = piece_size
			tr.position = region.position
			tr.mouse_filter = Control.MOUSE_FILTER_PASS
			add_child(tr)

			var p = Piece.new()
			p.texture_rect = tr
			p.matrix_pos = Vector2i(x, y)
			p.id = str(randi() % 10000).pad_zeros(4)
			p.group_id = -1
			pieces.append(p)
			matrix[y][x] = p

	for y in range(rows):
		for x in range(cols):
			var piece = matrix[y][x]
			if x > 0: piece.id_left = matrix[y][x - 1].id
			if x < cols - 1: piece.id_right = matrix[y][x + 1].id
			if y > 0: piece.id_up = matrix[y - 1][x].id
			if y < rows - 1: piece.id_down = matrix[y + 1][x].id

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			for piece in pieces:
				var rect = Rect2(piece.texture_rect.global_position, piece.texture_rect.size)
				if rect.has_point(event.position):
					reference_piece = piece
					click_offset_local = event.position - piece.texture_rect.global_position
					dragging_group_id = piece.group_id if piece.group_id != -1 else -9999
					break
		else:
			if dragging_group_id != -1:
				for p in get_pieces_by_group(dragging_group_id):
					check_snap(p)
				dragging_group_id = -1
				reference_piece = null

	elif event is InputEventMouseMotion:
		if dragging_group_id != -1 and reference_piece != null:
			var group = get_pieces_by_group(dragging_group_id)
			if group.size() == 0:
				return
			var new_pos = event.position - click_offset_local
			var delta = new_pos - reference_piece.texture_rect.global_position
			for p in group:
				p.texture_rect.global_position += delta

func check_snap(piece: Piece) -> void:
	var piece_size := piece.texture_rect.size
	var neighbors = {
		"left": Vector2(-1, 0),
		"right": Vector2(1, 0),
		"up": Vector2(0, -1),
		"down": Vector2(0, 1),
	}

	for dir in neighbors.keys():
		var offset = neighbors[dir] * piece_size
		var expected_pos = piece.texture_rect.position + offset
		var neighbor_id = piece.get("id_" + dir)
		if neighbor_id == "": continue
		var neighbor = get_piece_by_id(neighbor_id)
		if not neighbor: continue
		var dist = neighbor.texture_rect.position.distance_to(expected_pos)
		if dist <= SNAP_DISTANCE:
			var delta = expected_pos - neighbor.texture_rect.position
			neighbor.texture_rect.position += delta

			if piece.group_id == -1 and neighbor.group_id == -1:
				piece.group_id = next_group_id
				neighbor.group_id = next_group_id
				next_group_id += 1
			elif piece.group_id != -1 and neighbor.group_id == -1:
				neighbor.group_id = piece.group_id
			elif neighbor.group_id != -1 and piece.group_id == -1:
				piece.group_id = neighbor.group_id
			elif piece.group_id != neighbor.group_id:
				var group_a = piece.group_id
				var group_b = neighbor.group_id
				for p in get_pieces_by_group(group_b):
					p.group_id = group_a

	# Check completion
	if pieces.size() > 0:
		var group_id: int = pieces[0].group_id
		if group_id != -1:
			for p in pieces:
				if p.group_id != group_id:
					return
			if complete_label:
				complete_label.text = "🎉 Completed!"

func update_debug(piece: Piece) -> void:
	if not piece:
		return

	id_label.text = piece.id
	matrix_label.text = str(piece.matrix_pos)

	if piece.texture_rect:
		global_pos_label.text = str(piece.texture_rect.global_position)
	else:
		global_pos_label.text = "NULL"

	left_label.text = piece.id_left if piece.id_left != "" else "NULL"
	right_label.text = piece.id_right if piece.id_right != "" else "NULL"
	up_label.text = piece.id_up if piece.id_up != "" else "NULL"
	down_label.text = piece.id_down if piece.id_down != "" else "NULL"

func get_pieces_by_group(group_id: int) -> Array:
	var group := []
	for p in pieces:
		if group_id == -9999 and p == reference_piece:
			group.append(p)
		elif p.group_id == group_id:
			group.append(p)
	return group

func get_piece_by_id(id: String) -> Piece:
	for p in pieces:
		if p.id == id:
			return p
	return null

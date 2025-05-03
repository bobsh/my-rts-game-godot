extends Node2D

var selected_character = null

func _ready():
	spawn_ui()
	spawn_character()

func spawn_character():
	push_warning("spawning the first character")
	# Preload the Character scene
	var CharacterScene = preload("res://assets/characters/Character.tscn")

	# Instance the scene
	var character_instance = CharacterScene.instantiate()

	# Set position (change as needed)
	character_instance.position = Vector2(730, 150)

	# Add the character to the scene tree
	add_child(character_instance)


func spawn_ui():
	push_warning("spawning the UI")
	# Preload the UI scene
	var UIScene = preload("res://assets/scenes/PlayerUI.tscn")

	# Instance the scene
	var ui_instance = UIScene.instantiate()

	# Set position (change as needed)
	ui_instance.visible = true

	# Find the CanvasLayer node
	var canvas_layer = get_node("CanvasLayer")

	# Add the UI to the scene tree
	canvas_layer.add_child(ui_instance)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var camera = get_viewport().get_camera_2d()
		var mouse_position = camera.get_global_mouse_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
			push_warning("event ", event)
			push_warning("mouse_position ", mouse_position)

			# Left click - handle selection
			var clicked_character = get_character_at_position(mouse_position)

			# Deselect current character
			if selected_character:
				selected_character.set_selected(false)

			selected_character = clicked_character

			# Select new character if one was clicked
			if selected_character:
				selected_character.set_selected(true)

		elif event.button_index == MOUSE_BUTTON_RIGHT:
			push_warning("event ", event)
			push_warning("mouse_position ", mouse_position)

			# Right click - handle movement if a character is selected
			if selected_character:
				selected_character.move_to(mouse_position)

func get_character_at_position(pos):
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = 1

	var result = space.intersect_point(query)
	push_warning("intersect_point ", result)

	for collision in result:
		push_warning("collision.collider ", collision.collider)
		# If the collider is a character (adjust this condition based on your setup)
		if collision.collider.has_method("set_selected"):
			return collision.collider

	push_warning("no character selected")

	return null

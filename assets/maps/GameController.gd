extends Node2D

var selected_character = null

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		push_warning(event)

		var camera = get_viewport().get_camera_2d()
		var mouse_position = camera.get_global_mouse_position()

		if event.button_index == MOUSE_BUTTON_LEFT:
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
			# Right click - handle movement if a character is selected
			if selected_character:
				selected_character.move_to(mouse_position)

func get_character_at_position(pos):
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	# query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = 1

	var result = space.intersect_point(query)
	for collision in result:
		# If the collider is a character (adjust this condition based on your setup)
		if collision.collider.has_method("set_selected"):
			return collision.collider

	return null

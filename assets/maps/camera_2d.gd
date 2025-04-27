extends Camera2D

var is_dragging = false
var last_mouse_position = Vector2()

@export var min_zoom = 0.25  # Maximum zoom in (larger view)
@export var max_zoom = 3.0   # Maximum zoom out (smaller view)
@export var zoom_speed = 0.1 # How quickly to zoom

func _input(event):
	if event is InputEventMouseButton:
		# Handle middle mouse button dragging
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				is_dragging = true
				last_mouse_position = event.position
			else:
				is_dragging = false

		# Handle mouse wheel zooming
		elif event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				# Zoom in - make zoom value larger
				zoom = zoom + Vector2(zoom_speed, zoom_speed)
				# Clamp to max zoom (smaller value = more zoomed in)
				zoom = Vector2(min(zoom.x, max_zoom), min(zoom.y, max_zoom))

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				# Zoom out - make zoom value smaller
				zoom = zoom - Vector2(zoom_speed, zoom_speed)
				# Clamp to min zoom (prevent zooming out too far)
				zoom = Vector2(max(zoom.x, min_zoom), max(zoom.y, min_zoom))

	elif event is InputEventMouseMotion and is_dragging:
		var delta = event.position - last_mouse_position
		last_mouse_position = event.position

		# Move camera in the plane perpendicular to view direction
		var right_vector = global_transform.x
		var up_vector = global_transform.y

		global_translate(-(right_vector * delta.x))
		global_translate(-(up_vector * delta.y))

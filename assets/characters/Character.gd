extends CharacterBody2D

signal start_moving
signal target_reached
signal character_selected
signal character_deselected

@export var character_name = "Frampton Stammer"
@export var character_age = 26
@export var speed = 200.0
@export var max_health = 100
@export var health = 100
@export var selected = false
var target_position = null
var path = []

@onready var navigation_agent = $NavigationAgent2D

# Set value true to select the character
# Set value false to deselect the character
func set_selected(value: bool):
	selected = value
	if value == true:
		emit_signal("character_selected")
	else:
		emit_signal("character_deselected")

# Move the character to a target position
func move_to(target: Vector2):
	target_position = target
	emit_signal("start_moving")

# Called when ready
func _ready():
	# A callback for when the navigation agent reaches the target
	navigation_agent.target_reached.connect(_on_target_reached)

# Called when the navigation target is reached
func _on_target_reached():
	target_position = null
	velocity = Vector2.ZERO
	emit_signal("target_reached")

func _process(_delta):
	if target_position:
		if has_node("NavigationAgent2D"):
			# NavigationAgent2D approach
			if navigation_agent.is_navigation_finished():
				return

			var next_position = navigation_agent.get_next_path_position()
			var direction = global_position.direction_to(next_position)
			velocity = direction * speed
			move_and_slide()
		else:
			# Simple direct movement approach
			var direction = global_position.direction_to(target_position)
			var distance = global_position.distance_to(target_position)

			if distance > 5: # Stop when close enough
				velocity = direction * speed
				move_and_slide()
			else:
				target_position = null
				velocity = Vector2.ZERO

func update_gui_info():
	# Update the GUI with character information
	# First lets find the CanvasLayer node
	var canvas_layer = get_node("CanvasLayer")
	# Find the UI instance
	var ui_instance = canvas_layer.get_child(0) # Assuming the UI is the first child

	# Update the UI with character information
	ui_instance.update_character_info(character_name, character_age, speed, max_health, health)

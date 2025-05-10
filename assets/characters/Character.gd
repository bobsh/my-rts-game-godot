extends CharacterBody2D

signal start_moving
signal character_selected
signal character_deselected

@export var character_name = "Frampton Stammer"
@export var character_age = 26
@export var speed = 200.0
@export var max_health = 100
@export var health = 100
@export var selected = false
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
	push_warning("move", target)
	navigation_agent.target_position = target
	emit_signal("start_moving")

# Called when ready
func _ready():
	await get_tree().physics_frame

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		return

	var next_position = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_position)
	velocity = direction * speed
	move_and_slide()

func update_gui_info():
	# Update the GUI with character information
	# First lets find the CanvasLayer node
	var canvas_layer = get_node("CanvasLayer")
	# Find the UI instance
	var ui_instance = canvas_layer.get_child(0) # Assuming the UI is the first child

	# Update the UI with character information
	ui_instance.update_character_info(character_name, character_age, speed, max_health, health)

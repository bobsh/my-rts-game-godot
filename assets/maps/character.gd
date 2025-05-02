# Character
extends CharacterBody2D  # For 2D (use CharacterBody3D for 3D)

@export var speed = 200.0
@export var selected = false
var target_position = null
var path = []

# Optional - for pathfinding
@onready var navigation_agent = $NavigationAgent2D

func set_selected(value: bool):
	selected = value

func move_to(target: Vector2):
	target_position = target

@rpc("any_peer")
func set_position_remote(pos: Vector2):
	position = pos

func _ready():
	# If using NavigationAgent2D
	if has_node("NavigationAgent2D"):
		navigation_agent.target_reached.connect(_on_target_reached)

func _process(delta):
	# if multiplayer.get_unique_id() != multiplayer.get_multiplayer_authority():
	#	return # Only control your own player

	# use this once 
	# rpc_unreliable("set_position_remote", position)

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
			
			if distance > 5:  # Stop when close enough
				velocity = direction * speed
				move_and_slide()
			else:
				target_position = null
				velocity = Vector2.ZERO

func _on_target_reached():
	target_position = null
	velocity = Vector2.ZERO

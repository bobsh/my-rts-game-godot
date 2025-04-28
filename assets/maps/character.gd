# Character
extends CharacterBody2D  # For 2D (use CharacterBody3D for 3D)

@export var speed = 200.0
var selected = false
var target_position = null
var path = []

# Optional - for pathfinding
@onready var navigation_agent = $NavigationAgent2D

func _ready():
	# If using NavigationAgent2D
	if has_node("NavigationAgent2D"):
		navigation_agent.target_reached.connect(_on_target_reached)

func _process(delta):
	update_movement(delta)
	update_visuals()

func update_movement(_delta):
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

func update_visuals():
	# Update visual feedback for selection
	if has_node("SelectionIndicator"):
		$SelectionIndicator.visible = selected

func set_selected(is_selected):
	selected = is_selected
	update_visuals()

func move_to(target):
	target_position = target
	
	# If using NavigationAgent2D
	if has_node("NavigationAgent2D"):
		navigation_agent.set_target_position(target)

func _on_target_reached():
	target_position = null
	velocity = Vector2.ZERO

extends Resource
class_name Objective

enum ObjectiveType {
	KILL, TALK, FETCH, DELIVER, VISIT, ESCORT, USE_ITEM, INTERACT,
	SURVIVE, BUILD, TRAIN, CAPTURE, DEFEND, SCOUT, GATHER,
	UPGRADE, CRAFT, WAIT, CHOOSE, FOLLOW, SOLVE, CUSTOM
}

@export var type: ObjectiveType = ObjectiveType.KILL
@export var target: ObjectiveTarget
@export var amount: int = 1
@export var progress: int = 0
@export var is_complete: bool = false

func update_progress(value: int = 1):
	if is_complete:
		return
	progress += value
	if progress >= amount:
		progress = amount
		is_complete = true

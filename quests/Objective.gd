extends Resource
class_name Objective

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

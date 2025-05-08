extends Resource
class_name Quest

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var objectives: Array[Objective] = []
@export var is_complete: bool = false
@export var rewards: Dictionary = {
	"xp": 0,
	"gold": 0,
	"items": []
}

func check_completion():
	for obj in objectives:
		if not obj.is_complete:
			is_complete = false
			return
	is_complete = true

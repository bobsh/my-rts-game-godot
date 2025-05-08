extends Node
class_name QuestManager

var active_quests : Array = []

signal quest_updated(quest)
signal quest_completed(quest)

func add_quest(quest: Quest):
	if quest in active_quests:
		return
	active_quests.append(quest)
	emit_signal("quest_updated", quest)

func update_objectives(type: int, target: String, amount: int = 1):
	for quest in active_quests:
		var updated := false
		for obj in quest.objectives:
			if obj.type == type and obj.target == target and not obj.is_complete:
				obj.update_progress(amount)
				updated = true
		if updated:
			quest.check_completion()
			emit_signal("quest_updated", quest)
			if quest.is_complete:
				emit_signal("quest_completed", quest)

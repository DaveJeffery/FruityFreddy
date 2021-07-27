extends Node2D

func set_score(num:int) -> void:
	$Sprite.frame = num

func _on_Timer_timeout():
	queue_free()

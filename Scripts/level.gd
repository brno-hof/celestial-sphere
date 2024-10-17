extends Node3D
@export var start_ball_type : Defines.BallType
@onready var spawn_point: Marker3D = %SpawnPoint
@onready var main_menu_spawn_point: Marker3D = %MainMenuSpawnPoint
@onready var finish: RayCast3D = %Finish

var is_finished : bool = false
signal finished

func get_spawn_point():
	return spawn_point.global_position

func get_main_menu_spawn_point():
	return main_menu_spawn_point.global_position

func get_start_ball_type():
	return start_ball_type

func _process(delta: float) -> void:
	if not is_finished and finish.is_colliding():
		finished.emit()

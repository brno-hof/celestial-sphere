extends Node

@onready var player : Node3D = $Player
@onready var camera_setup : Node3D = $Player/CameraSetup
@onready var level : PackedScene = preload("res://Scenes/Level/level.tscn")
@onready var current_level : PackedScene = level
@onready var ui = $UI

var loaded_level : Node3D
var last_checkpoint : Vector3


func _ready() -> void:
	load_level(current_level)
	spawn_into_current_level(true)

func _process(delta: float) -> void:
	pass


func _on_restart_button_pressed() -> void:
	return_to_last_checkpoint()


func _on_reset_button_pressed() -> void:
	load_level(current_level)
	spawn_into_current_level(false)


func load_level(level : PackedScene):
	if loaded_level:
		loaded_level.queue_free()
	
	loaded_level = level.instantiate()
	loaded_level.finished.connect(finished)
	self.add_child(loaded_level)

func spawn_into_current_level(is_main_menu : bool):
	var spawn_point : Vector3 = Vector3.ZERO
	if not is_main_menu and loaded_level.has_method("get_spawn_point"):
		spawn_point = loaded_level.get_spawn_point()
	elif is_main_menu and loaded_level.has_method("get_main_menu_spawn_point"):
		spawn_point = loaded_level.get_main_menu_spawn_point()
	else:
		print("No spawn point specified")
	last_checkpoint = spawn_point
	
	var start_ball_type : Defines.BallType = Defines.BallType.REGULAR
	if loaded_level.has_method("get_start_ball_type"):
		start_ball_type = loaded_level.get_start_ball_type()
	else:
		print("No start ball type specified")
	
	player.respawn_as(start_ball_type, spawn_point)
	if is_main_menu:
		player.freeze()
		Defines.is_main_menu = true
	else:
		Defines.is_main_menu = false


func return_to_last_checkpoint():
	player.respawn_as(Defines.BallType.REGULAR, last_checkpoint)

func add_checkpoint(position : Vector3):
	last_checkpoint = position


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_start_button_pressed() -> void:
	spawn_into_current_level(false)
	Defines.is_main_menu = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func finished():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ui.show_finished_screen()
	Defines.is_main_menu = true

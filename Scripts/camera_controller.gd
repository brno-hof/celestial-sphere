extends Node3D

@export var mouse_sensitivity_horizontal : float = 0.3
@export var mouse_sensitivity_vertical : float = 0.1
@export var mouse_wheel_sensitivity : float = 111.0
@export var min_spring_arm_length : float = 1.0
@export var max_spring_arm_length : float = 4.0

@onready var player : Node3D = self.get_parent_node_3d()
@onready var game : Node = player.get_parent()
@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var camera : Camera3D = $SpringArm3D/Camera3D

@onready var default_spring_arm_rotation : Vector3 = spring_arm.rotation
@onready var default_rotation : Vector3 = self.rotation

var is_detached : bool = false

signal detached

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not is_detached and not Defines.is_main_menu:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_horizontal))
		spring_arm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_vertical))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-80.0), deg_to_rad(80.0))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("toggle_mouse_capture"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Defines.is_main_menu:
		rotate_y(deg_to_rad(-15.0 * delta))
	
	if self.get_parent() == player and player.global_position.y < -2:
		detach()
	
	
	if is_detached:
		camera.look_at(player.position)

func detach():
	player.remove_child(self)
	game.add_child(self)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_detached = true
	detached.emit()

func attach():
	game.remove_child(self)
	player.add_child(self)
	self.rotation = default_rotation
	spring_arm.rotation = default_spring_arm_rotation
	camera.rotation = Vector3.ZERO
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	is_detached = false

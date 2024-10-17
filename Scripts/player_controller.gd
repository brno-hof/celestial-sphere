extends Node3D

var light_ball : PackedScene = preload("res://Scenes/Balls/light_ball.tscn")
var regular_ball : PackedScene = preload("res://Scenes/Balls/regular_ball.tscn")
var heavy_ball : PackedScene = preload("res://Scenes/Balls/heavy_ball.tscn")

var light_force_multiplier : float = 40.0
var regular_force_multiplier : float = 50.0
var heavy_force_multiplier : float = 120.0

@export var lever_length : float = 2.0
@export var ball : RigidBody3D
@export var camera_setup : Node3D

var current_ball_type : Defines.BallType = Defines.BallType.REGULAR

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not ball:
		return
	
	var target_position : Vector3 = ball.position
	self.position = target_position
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_setup.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var force_multiplier
	match current_ball_type:
		Defines.BallType.LIGHT:
			force_multiplier = light_force_multiplier
		Defines.BallType.REGULAR:
			force_multiplier = regular_force_multiplier
		Defines.BallType.HEAVY:
			force_multiplier = heavy_force_multiplier
	
	if direction:
		ball.apply_force(Vector3(direction.x,0,direction.z) * force_multiplier * delta, Vector3(0,lever_length,0))


func respawn_as(ball_type : Defines.BallType, position : Variant = null):
	current_ball_type= ball_type
	var new_ball : RigidBody3D
	match ball_type:
		Defines.BallType.LIGHT:
			new_ball = light_ball.instantiate()
		Defines.BallType.REGULAR:
			new_ball = regular_ball.instantiate()
		Defines.BallType.HEAVY:
			new_ball = heavy_ball.instantiate()
	
	if position is Vector3:
		new_ball.position = position
	else:
		new_ball.transform = ball.transform if ball else self.transform
		new_ball.linear_velocity = ball.linear_velocity * 0.5 if ball else Vector3.ZERO
		new_ball.angular_velocity = ball.angular_velocity * 0.5 if ball else Vector3.ZERO
	
	new_ball.top_level = true
	if ball:
		ball.queue_free()
	ball = new_ball
	self.add_child(new_ball)
	if camera_setup.is_detached:
		camera_setup.attach()

func get_ball_type():
	return current_ball_type

func freeze():
	if ball:
		ball.freeze = true

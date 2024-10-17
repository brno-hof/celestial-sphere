@tool
extends Node3D

enum BallType {
	LIGHT,
	REGULAR,
	HEAVY,
}

var light_ball : PackedScene = preload("res://Scenes/Balls/light_ball.tscn")
var regular_ball : PackedScene = preload("res://Scenes/Balls/regular_ball.tscn")
var heavy_ball : PackedScene = preload("res://Scenes/Balls/heavy_ball.tscn")

var light_ball_material : StandardMaterial3D = preload("res://Materials/fabric_1k.tres")
var regular_ball_material : StandardMaterial3D = preload("res://Materials/herringbone_parquet_1k.tres")
var heavy_ball_material : StandardMaterial3D = preload("res://Materials/gravel_concrete_1k.tres")

@export var bottom : CSGMesh3D

@export var transmute_type : BallType = BallType.HEAVY:
	set(new_value):
		transmute_type = new_value
		match self.transmute_type:
			BallType.LIGHT:
				bottom.material = light_ball_material
			BallType.REGULAR:
				bottom.material = regular_ball_material
			BallType.HEAVY:
				bottom.material = heavy_ball_material

@onready var ray_cast : RayCast3D = $RayCast3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if ray_cast.is_colliding():
		var collider : Object = ray_cast.get_collider()
		var parent : Object = collider.get_parent()
		if parent.has_method("respawn_as") and parent.has_method("get_ball_type") and parent.get_ball_type() != transmute_type:
			var game : Node = parent.get_parent()
			if game.has_method("add_checkpoint"):
				var spawn_offset = Vector3(0,0.3,0)
				game.add_checkpoint(self.global_position + spawn_offset)
			else:
				print("Game does not have method: add_checkpoint")
			parent.respawn_as(transmute_type)

extends Node3D

@onready var moving_part : RigidBody3D = $MovingPart
@onready var moving_part_mesh : MeshInstance3D = $MovingPart/Mesh

@export var active_material : StandardMaterial3D
@export var inactive_material : StandardMaterial3D

var active : bool = false

signal pressed

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if moving_part.position.y < 0.04:
		active = true
		moving_part_mesh.material_override = active_material
		pressed.emit()

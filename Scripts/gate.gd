extends Node3D

@export var button : Node3D
@onready var light = $Light
@onready var light_collision_shape = $Light/CollisionShape3D
var closed : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if button:
		button.pressed.connect(_on_button_pressed)
	else:
		print("No Button Selected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	if closed == true:
		light.visible = false
		light_collision_shape.disabled = true
		closed = false

func close():
	if closed == false:
		light.visible = true
		light_collision_shape.disabled = false
		closed = true

func _on_button_pressed() -> void:
	self.open()

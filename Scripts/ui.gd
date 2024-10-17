extends Control

@onready var fallen_off_ui : Control = $FallenOffUI
@onready var main_menu : Control = $MainMenu
@onready var finished : Control = $FinishedUI


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_camera_setup_detached() -> void:
	fallen_off_ui.show()

func _on_restart_button_pressed() -> void:
	fallen_off_ui.hide()
	Defines.is_main_menu = false

func _on_reset_button_pressed() -> void:
	fallen_off_ui.hide()
	Defines.is_main_menu = false

func _on_start_button_pressed() -> void:
	main_menu.hide()
	Defines.is_main_menu = false

func show_finished_screen() -> void:
	finished.show()
	Defines.is_main_menu = true

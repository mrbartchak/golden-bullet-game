extends Control

var player_ref: Player

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("player")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_menu_button_pressed() -> void:
	get_tree().quit()

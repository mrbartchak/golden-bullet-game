extends Control

var player_ref: Player

func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	$VelocityLabel.text = str(player_ref.velocity)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

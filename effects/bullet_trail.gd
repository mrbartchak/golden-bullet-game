extends Line2D

var trail_length: int = 5
var color: Color = Color.WHITE

func _process(_delta: float) -> void:
	add_point(get_parent().global_position)
	if points.size() > trail_length:
		remove_point(0)

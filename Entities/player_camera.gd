extends Camera2D

func _ready():
	var map = get_tree().root.get_child(0).get_node("Background")
	var rect = map.get_used_rect()
	var size = map.get_tileset().tile_size
	
	limit_left = rect.position.x * size.x
	limit_right = rect.end.x * size.x
	limit_top = rect.position.y * size.y
	limit_bottom = rect.end.y * size.y

	var view_w = get_viewport().size.x
	var view_h = get_viewport().size.y
	if limit_right < view_w:
		limit_right -= (limit_right - limit_left) / 2
		limit_right += view_w / 2
	if limit_bottom < view_h:
		limit_top += (limit_bottom - limit_top) / 2
		limit_top -= view_h / 2

tool
extends Node2D

export(bool) var centered setget centered_set, centered_get

export(int, 3, 100) var num_sides = 3 setget num_sides_set, num_sides_get
export(float) var size = 64 setget size_set, size_get
export(Color) var polygon_color = Color(0,0,0) setget polygon_color_set, polygon_color_get
export(Texture) var polygon_texture setget polygon_texture_set, polygon_texture_get

export(float) var border_size setget border_size_set, border_size_get
export(Color) var border_color setget border_color_set, border_color_get

export(float, -360, 360) var polygon_rotation setget polygon_rotation_set, polygon_rotation_get

var DEBUG = false

func printd(arg1, arg2 = "", arg3 = ""):
	if DEBUG:
		print(arg1,arg2,arg3)

func draw_poly(p_size, p_color, p_texture):
	p_size /= 2
	var th = 2*PI/num_sides
	var pts = PoolVector2Array()
	var off = Vector2()
	
	if !centered:
		off = Vector2(size/2 + border_size, size/2 + border_size)
	
	printd("off: ", off)
	for i in range(num_sides):
		pts.append(off + polar2cartesian(p_size, deg2rad(-90+polygon_rotation) + i*th))

	var uvs = PoolVector2Array()	
	if p_texture:
		var ts = polygon_texture.get_size()
		printd(" ts: ", ts)
		for pt in pts:
			uvs.append((pt - off + Vector2(p_size, p_size)) / ts)

	printd("pts: ", pts)
	printd("uvs: ", uvs)
	draw_colored_polygon(pts, p_color, uvs, p_texture, polygon_texture, true)
	
func _notification(what):
	if what == NOTIFICATION_DRAW:
		if border_size > 0:
			draw_poly(size + border_size, border_color, null)
		draw_poly(size, polygon_color, polygon_texture)

func polygon_texture_set(texture):
	polygon_texture = texture
	update()

func polygon_texture_get():
	return polygon_texture

func centered_set(val):
	centered = val
	update()

func centered_get():
	return centered

func border_color_set(color):
	border_color = color
	update()

func border_color_get():
	return border_color

func polygon_color_set(color):
	polygon_color = color
	update()

func polygon_color_get():
	return polygon_color

func polygon_rotation_set(rot):
	polygon_rotation = rot
	update()

func polygon_rotation_get():
	return polygon_rotation

func border_size_set(size):
	border_size = size
	update()

func border_size_get():
	return border_size

func num_sides_set(sides):
	num_sides = sides
	update()

func num_sides_get():
	return num_sides

func size_set(s):
	size = s
	update()

func size_get():
	return size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

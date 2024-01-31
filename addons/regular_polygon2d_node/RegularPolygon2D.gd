@tool
extends Node2D

@export var centered:bool:
	set(val):
		centered = val
		queue_redraw()
	get:
		return centered

@export_range(3, 100, 1) var num_sides = 3:
	set(val):
		num_sides = val
		queue_redraw()	
	get:
		return num_sides	

@export var size : float= 64.0:
	set(val):
		size = val
		queue_redraw()
	get:
		return size

@export_color_no_alpha var polygon_color = Color(36.0/256.0,138.0/256.0,199.0/256.0):
	set(color):
		polygon_color = color
		queue_redraw()
	get:
		return polygon_color


@export var polygon_texture:  Texture:
	set(texture):
		polygon_texture = texture
		queue_redraw()
	get:
		return polygon_texture
	
	
@export var border_size :float = 4.0:
	set(size):
		border_size = size
		queue_redraw()
	get:
		return border_size


@export_color_no_alpha var border_color = Color(0,0,0):
	set(color):
		border_color = color
		queue_redraw()
	get:
		return border_color
		
@export_range(-360, 360, 1) var polygon_rotation: float:

	set(rot):
		polygon_rotation = rot
		queue_redraw()
	get:
		return polygon_rotation
		
@export var collision_shape:bool = true:
	set(p_val):
		collision_shape = p_val
	get:
		return collision_shape

var DEBUG_NONE = -9999
var DEBUG_INFO = 0
var DEBUG_VERBOSE = 1

var LOG_LEVEL = DEBUG_NONE

func vlog(arg1, arg2 = "", arg3 = ""):
	if LOG_LEVEL >= DEBUG_VERBOSE:
		print(arg1,arg2,arg3)

func dlog(arg1, arg2 = "", arg3 = ""):
	if LOG_LEVEL >= DEBUG_INFO:
		print(arg1,arg2,arg3)

func poly_offset():
	if !centered:
		return Vector2(size/2 + border_size, size/2 + border_size)
	return Vector2(0,0)

func polar_to_cartesian(radius, angle):
	return radius * Vector2.from_angle(angle)

func poly_pts(p_size):
	p_size /= 2
	var th = 2*PI/num_sides
	var pts = PackedVector2Array()
	var off = poly_offset()
	vlog("off: ", off)
	for i in range(num_sides):
		pts.append(off + polar_to_cartesian(p_size, deg_to_rad(-90+polygon_rotation) + i*th))
	return pts

func draw_poly(p_size, p_color, p_texture):
	var pts = poly_pts(p_size)

	var uvs = PackedVector2Array()	
	if p_texture:
		var ts = polygon_texture.get_size()
		vlog(" ts: ", ts)
		for pt in pts:
			uvs.append((pt - poly_offset() + Vector2(p_size, p_size)) / ts)

	vlog("pts: ", pts)
	vlog("uvs: ", uvs)
	draw_colored_polygon(pts, p_color, uvs, p_texture)
	
func _notification(what):
	if what == NOTIFICATION_DRAW:
		if border_size > 0:
			draw_poly(size + border_size, border_color, null)
		draw_poly(size, polygon_color, polygon_texture)
	if what == NOTIFICATION_READY:
		vlog("enter tree")
		if !collision_shape || Engine.is_editor_hint():
			vlog("editor mode: Not adding collision")
			return
			
		var p = get_parent();
		if p == null:
			vlog("no parent")
			return
		
		if p is CollisionObject2D:
			vlog("parent is CollisionObject2D")
			var shape = ConvexPolygonShape2D.new()
			shape.points = poly_pts(size + border_size)
			vlog("shape.points = ", shape.points)
			var col = CollisionShape2D.new()
			col.shape = shape
			p.call_deferred("add_child", col)

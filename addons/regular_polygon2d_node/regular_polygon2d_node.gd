tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("RegularPolygon2D", "Node2D", preload("RegularPolygon2D.gd"), null)

func _exit_tree():
  	remove_custom_type("RegularPolygon2D")
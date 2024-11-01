class_name PushBox5
extends CameraControllerBase

@export var box_width: float = 10.0
@export var box_height: float = 10.0

@export var push_ratio: float = 0.5  
@export var pushbox_top_left: Vector2        
@export var pushbox_bottom_right: Vector2     
@export var speedup_zone_top_left: Vector2    
@export var speedup_zone_bottom_right: Vector2  

func _ready() -> void:
	super()
	position = target.position

func _process(delta: float) -> void:
	if !current:
		return

	var tpos = target.global_position
	var cpos = global_position

	# Check if target is within da inner zone
	var is_in_speedup_zone = tpos.x > speedup_zone_top_left.x && tpos.x < speedup_zone_bottom_right.x && tpos.z > speedup_zone_top_left.y && tpos.z < speedup_zone_bottom_right.y

	# Check if target is within the outer push zone
	var is_in_push_zone = tpos.x > pushbox_top_left.x && tpos.x < pushbox_bottom_right.x && tpos.z > pushbox_top_left.y && tpos.z < pushbox_bottom_right.y

	if is_in_speedup_zone:
		# Target is within the inner zone then stop camera movement
		return
	elif is_in_push_zone:
		# and if target is within outer push zone, calculate movement with push_ratio
		apply_push_zone_movement(delta, tpos, cpos)
	else:
		# and if target is outside both zones then follow normally
		global_position = global_position.lerp(tpos, delta)

	# Draw pushbox and speedup zone borders if draw_camera_logic is enabled, needs work
	if draw_camera_logic:
		draw_logic()

	super(delta)

func apply_push_zone_movement(delta: float, tpos: Vector3, cpos: Vector3) -> void:
	var x_movement = 0.0
	var z_movement = 0.0

	# Check if the target is touching left or right edges of the pushbox
	if tpos.x <= pushbox_top_left.x:
		x_movement = target.linear_velocity.x * push_ratio * delta
	elif tpos.x >= pushbox_bottom_right.x:
		x_movement = -target.linear_velocity.x * push_ratio * delta

	# Check if the target is touching top or bottom edges of the pushbox
	if tpos.z <= pushbox_top_left.y:
		z_movement = target.linear_velocity.z * push_ratio * delta
	elif tpos.z >= pushbox_bottom_right.y:
		z_movement = -target.linear_velocity.z * push_ratio * delta

	# Apply movement
	global_position.x += x_movement
	global_position.z += z_movement

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# Frame corners based on top_left and bottom_right settings
	var left_outer: float = -box_width / 2
	var right_outer: float = box_width / 2
	var top_outer: float = -box_height / 2
	var bottom_outer: float = box_height / 2 

	# Draw frame border
	immediate_mesh.surface_add_vertex(Vector3(right_outer, 0, top_outer))
	immediate_mesh.surface_add_vertex(Vector3(right_outer, 0, bottom_outer))
	immediate_mesh.surface_add_vertex(Vector3(right_outer, 0, bottom_outer))
	immediate_mesh.surface_add_vertex(Vector3(left_outer, 0, bottom_outer))
	immediate_mesh.surface_add_vertex(Vector3(left_outer, 0, bottom_outer))
	immediate_mesh.surface_add_vertex(Vector3(left_outer, 0, top_outer))
	immediate_mesh.surface_add_vertex(Vector3(left_outer, 0, top_outer))
	immediate_mesh.surface_add_vertex(Vector3(right_outer, 0, top_outer))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()

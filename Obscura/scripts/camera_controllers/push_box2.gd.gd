extends CameraControllerBase

@export var top_left: Vector2          # Top-left corner of the frame border box
@export var bottom_right: Vector2      # Bottom-right corner of the frame border box
@export var autoscroll_speed: Vector3  # Speed of auto-scroll in the x and z axes

func _process(delta: float) -> void:
	if !target:
		return

	# Auto-scroll the camera frame on the x-z plane
	global_position.x += autoscroll_speed.x * delta
	global_position.z += autoscroll_speed.z * delta

	# Define the frame edges in world space
	var frame_left = global_position.x + top_left.x
	var frame_right = global_position.x + bottom_right.x
	var frame_top = global_position.z + top_left.y
	var frame_bottom = global_position.z + bottom_right.y

	# Push the player forward if touching the left edge of the frame
	if target.global_position.x < frame_left:
		target.global_position.x = frame_left

	# Draw the frame border if draw_camera_logic is enabled
	if draw_camera_logic:
		draw_frame_border(frame_left, frame_right, frame_top, frame_bottom)

# Function to draw the frame border box in the x-z plane
func draw_frame_border(left: float, right: float, top: float, bottom: float) -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Draw the border of the frame box in 3D space
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()

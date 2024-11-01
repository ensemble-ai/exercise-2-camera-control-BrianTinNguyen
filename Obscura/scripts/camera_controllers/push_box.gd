class_name PushBox
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !target:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	global_position = target.global_position
	
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	# Da cross dimensions (5 units total)
	var cross_size = 2.5

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)

	# Drawing of the horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-cross_size, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(cross_size, 0, 0))

	# Drawing of the vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -cross_size))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, cross_size))

	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE

	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)

	# Free the mesh after one frame update
	await get_tree().process_frame
	mesh_instance.queue_free()

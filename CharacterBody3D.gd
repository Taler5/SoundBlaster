extends CharacterBody3D


const SPEED = 3.0
const JUMP_VELOCITY = 4.5

var bullet_scene = preload("res://prefabs/bullet.tscn")
var bullet_speed = 5.0

var mouseDown = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !mouseDown:
		mouseDown = true
		shoot()
		
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouseDown = false

func shoot():
	var camera = get_viewport().get_camera_3d()
	var cursor_pos = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(cursor_pos)
	var ray_direction = camera.project_ray_normal(cursor_pos)
	
	var character_height = global_position.y
	var t = (character_height - ray_origin.y) / ray_direction.y
	var intersection_point = ray_origin + ray_direction * t
	
	var direction = (intersection_point - global_position).normalized()
	direction = direction.normalized()
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.velocity = direction * bullet_speed

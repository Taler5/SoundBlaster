extends Area3D

var velocity = Vector3.ZERO
var lifetime = 10.0  # Bullet disappears after 5 seconds

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity * delta

func _on_body_entered(body):
		on_impact()

func on_impact():
	queue_free()


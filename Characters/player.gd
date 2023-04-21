extends CharacterBody2D


@export var SPEED : float = 180.0
@export var JUMP_VELOCITY = -240.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

var PauseMenu = preload("res://Characters/pause_menu.tscn")

func _physics_process(delta):
	RayCast2D
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if (velocity.y < 0):
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")	

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var done = false
	if direction:
		velocity.x = direction * SPEED
		var vec = Vector2(direction, 0)
		if (is_on_floor()):
			animated_sprite.play("run")
		if (not done):
			# Ray Cast
			var space = get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(global_position, global_position + vec * 50)
			query.exclude = [self]
			var result = space.intersect_ray(query)
			
			# Create dot indicator
			if (result):
				var scene = preload("res://Characters/dot.tscn")
				var dot = scene.instantiate()
				var script = load("res://Characters/dot.gd")
				dot.position = result.position
				dot.set_script(script)
				get_tree().get_root().get_node("Level").add_child(dot)
				done = true
	else:
		done = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if (is_on_floor()):
			animated_sprite.play("idle")
	
	if (direction < 0):
		animated_sprite.flip_h = true
	if (direction > 0):
		animated_sprite.flip_h = false

	move_and_slide()

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pause_menu = PauseMenu.instantiate()
		add_child(pause_menu)
		get_tree().paused = true

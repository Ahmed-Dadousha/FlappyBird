extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var score: int = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var pipe_scene: PackedScene = preload("res://scenes/pipe.tscn") 

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)
	move_and_slide()

func pipe_reset():
	var pip_instance = pipe_scene.instantiate()
	pip_instance.position = Vector2(800, randi_range(-24, 90))
	get_parent().call_deferred("add_child", pip_instance)
	

func _on_reseter_body_entered(body):
	if "Pipe" in body.name:
		body.queue_free()
	pipe_reset()


func _on_detect_area_entered(area):
	if area.name == "PointArea":
		score += 1


func _on_detect_body_entered(body):
	if "Pipe" in body.name:
		get_tree().reload_current_scene()


func _on_ground_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()

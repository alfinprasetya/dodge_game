extends Area2D
signal hit

#Set initial variables
export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	#Get the screen size value
	screen_size = get_viewport_rect().size
	
	#Hide player on game start
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Get direction from key input
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = +1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_right"):
		velocity.x = +1
	
	#Calculate velocity and play animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#Update player position and prevent it from leaving screen
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#Animation toggler
	if velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_v = velocity.y > 0
	elif velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0


#Collision behavior
func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


#Start function
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

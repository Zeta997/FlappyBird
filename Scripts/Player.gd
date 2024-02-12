extends CharacterBody2D

@export var gravity = 980.0
var jumpForce = 26500.0
@export var speed_rotation = 2

var animation_select
var select_frame

func _ready():
	hide()
	animation_select = $AnimatedSprite2D.sprite_frames.get_animation_names()
	select_frame = randi_range(-1,2)
	var view_screen= get_window().size
	position = Vector2(100,view_screen.y/2)
	rotation =0



func physics_player(delta):
	velocity.x =0
	velocity.y += gravity* delta
	rotation +=speed_rotation*delta
	if velocity.y != 0:
		if rotation >1.5:
			rotation=PI/2
	move_and_collide(velocity*delta)


func _physics_process(_delta)->void:
	$AnimatedSprite2D.play(animation_select[select_frame])




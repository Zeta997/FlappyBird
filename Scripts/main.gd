extends Node2D

@onready var timer :Timer= get_node("Timer")
@onready var _parallax_foreground := get_node("foreground/ParallaxBackground") 
@onready var _parallax_background := get_node("background/ParallaxBackground") 

static var new_max_score :int
static var ranking_score :int = 0 
var data = "res://Resources/Score.json"
static var data_score 


var speed_pipe = preload("res://Scripts/pipe_1.gd")
@onready var pipe = GlobalControl.get_pipe_scene


@export var speed_parallax = 100
var initial_force :float= 5.0 
var start :bool =false


static var DEAD :bool= false
static var COUNT : int =0


func _ready():
	data_score =load_data_json() #getting score stored
	ranking_score = int(data_score["SCORE"]["MAX_SCORE"])


func start_game(delta):
	$Player.physics_player(delta)
	if Input.is_action_just_pressed("Mouse_0") and not DEAD:
			$Player.velocity.y -= $Player.jumpForce*delta
			$Player.rotation =-PI/4
			$Player/AudioStreamPlayer.play()


func _process(delta)->void:
	
	if start:
		speed_pipe.speed = 100
		start_game(delta)
		$UI/Score.text=str(COUNT)
	if DEAD:
		# Stopping the timers and parallax background
		timer.stop()
		speed_pipe.speed = 0
		_parallax_background.scroll_offset.x -= 0
		_parallax_foreground.scroll_offset.x -= 0
		$Player.speed_rotation = 10
		$Player/AnimatedSprite2D.set_frame(0)
		# Elements UI/panel
		$UI/GameOver.show()
		$UI/Panel_Score.show()
		# Getting score
		$UI/Panel_Score/Current_Score.text =str(COUNT)
		$UI/Panel_Score/Best_Score.text =str(ranking_score)
		
	else:
		_parallax_background.scroll_offset.x -= delta * speed_parallax
		_parallax_foreground.scroll_offset.x -= delta * 50


func game_over():
	DEAD = true

func restar_game():
	get_tree().reload_current_scene()
	DEAD=false
	COUNT=0
	$UI/Panel_Score.hide()


func load_data_json():
	if FileAccess.file_exists(data):
		var load_data = FileAccess.open(data,FileAccess.READ)
		var data_to_dict = JSON.parse_string(load_data.get_as_text())
		return data_to_dict

func save_data_json():
	var save_data = FileAccess.open(data, FileAccess.WRITE)
	var parse = JSON.stringify(data_score)
	save_data.store_line(parse)
	save_data.close()


func _on_floor_body_entered(_body):
	game_over()
	if COUNT > ranking_score:
		data_score["SCORE"]["MAX_SCORE"] = COUNT
		ranking_score= COUNT
		save_data_json()


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("Mouse_0"):
		$Player.show()
		start= true
		timer.start()
		$Player.velocity.y -= initial_force
		$Player.rotation =-PI/4
		$UI/StartGame.hide()
		$UI/Area2D.hide()
		$UI/Score.show()


func _on_visible_on_screen_notifier_2d_screen_exited():
	game_over()


func _on_button_pressed():
	restar_game() 


func _on_timer_timeout():
	var pipe_instance = pipe.instantiate()
	add_child(pipe_instance)

extends Area2D

static var speed = 0

@export var player_scene := PackedScene



var main_scene :=preload("res://Scripts/main.gd")
var main_script = main_scene.new()

var player_script := preload("res://Scripts/Player.gd")

func _ready():
	position.x = get_window().size.x +30
	var random_number = randi_range(-20, 150)
	position.y = random_number
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x-=speed*delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()



func _on_body_entered(body):

	if body.is_in_group("Player"):
		$CollisionShape2D2.set_deferred("disabled",true)
		$Point.get_node("CollisionShape2D").set_deferred("disabled", true)
		main_script.game_over()
		$AudioStreamPlayer.play()
		if main_script.COUNT > main_script.ranking_score:
			main_script.data_score["SCORE"]["MAX_SCORE"] = main_script.COUNT
			main_script.save_data_json()
			main_script.ranking_score = main_script.COUNT


func _on_point_body_entered(body):
	#TODO Hacer que se almacene datos en el fichero json del score
	if body.is_in_group("Player"):
		main_script.COUNT +=1
		$Point/AudioStreamPlayer2D.play()

func clear_pipe():
	queue_free()

extends Spatial

var _other_players = []
var player = load("res://assets/tools/Pump3.tscn")
var x_location = 0.0

func _ready():
	_other_players = NetworkingSync._player_in_same_game_room_list.duplicate()
	print(_other_players)
	_other_players.erase([Player.get_player_id(), Player.get_player_name()])
	print(_other_players)
	init_game()
	
	if Player.is_host():
		init_game_state()
	instance_player(Player.get_player_id(), x_location)
	for p in _other_players:
		x_location += 5.0
		instance_player(p[0], x_location)
	NetworkingSync.send_ready_signal()

func init_game():
	create_map()

func create_map():
	get_tree().change_scene("res://balloonGame.tscn")
	#var map = load("res://balloonGame.tscn").instance()
	#add_child(map)

func init_game_state():
	yield(NetworkingSync, "all_ready")
	print("Yea!, all ready")

func instance_player(id, x_location):
	var player_instance = Global.instance_node_at_location(player, Players, Vector3(x_location,0.0,0.0))
	player_instance.name = str(id)
	player_instance.set_network_master(id)

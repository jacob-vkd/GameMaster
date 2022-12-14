extends Spatial

var _other_players = []

func _ready():
	_other_players = NetworkingSync._player_in_same_game_room_list.duplicate()
	_other_players.erase([Player.get_player_id(), Player.get_player_name()])
	init_game()
	
	if Player.is_host():
		init_game_state()
	
	NetworkingSync.send_ready_signal()
	$GUI/Debug_label.text = "My id: " + str(Player.get_player_id()) + ", others: " + str(_other_players)

func init_game():
	create_map()

func create_map():
	var map = load("res://balloonGame.tscn").instance()
	get_tree().get_root().add_child(map)

func init_game_state():
	yield(NetworkingSync, "all_ready")
	print("Yea!, all ready")

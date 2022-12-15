extends KinematicBody

onready var animationtree = get_node("AnimationTree")
onready var state_machine = animationtree.get("parameters/playback") 
onready var ballon = get_node("bicyclePump/redballon")
var current
var player_state


#puppet var puppet_position = Vector3(0.0,0.0,0.0) setget puppet_position_set

onready var Tween = $Tween

func _physics_process(delta):
	if is_network_master():
		get_input()
	definePlayerState()

func get_input():
	current = state_machine.get_current_node() 
	if ballon.visible:
		if Input.is_action_just_pressed("ui_up"):
			#if pump is on half and up was pressed
			if current == "TopToHalf001":
				state_machine.travel("HalfToUp002")
				return
			#if pump is bot and up was pressed
			if current == "HalfToBot001":
				state_machine.travel("BotToHalf001")
				return
			if current == "BotToHalf001":
				state_machine.travel("HalfToUp002")
				return
			return

	if ballon.visible:
		if Input.is_action_just_pressed("ui_down"):
			# if pump is on half and down was pressed
			if current == "TopToHalf001" || current == "BotToHalf001":
				#move to bot
				state_machine.travel("HalfToBot001")
				ballon.scale *=1.04
				return
			if current == "HalfToBot001":
				return
			#else move from top to middle
			state_machine.travel("TopToHalf001")
			ballon.scale *=1.04
			return
		
func definePlayerState():
	if current:
		player_state = {"T": OS.get_system_time_msecs(), "S": current, "ID": Player.get_player_id(), "B": ballon.get_scale()}
		rpc_id(0, "state_recieved", player_state)

remote func state_recieved(player_state):
	print(player_state)
	change_player_state(player_state)
	
func change_player_state(player_state):
	var players = get_tree().multiplayer.get_network_connected_peers()
	var path = str(players[1])
	var player_node = get_tree().get_root().get_node("/root/Players/"+path)
	print("player_state B")
	print(player_state["B"])
	
	player_node.state_machine.travel(player_state["S"])
	player_node.ballon.scale = player_state["B"]

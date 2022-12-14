extends KinematicBody

onready var animationtree = get_node("AnimationTree")
onready var state_machine = animationtree.get("parameters/playback")
	
func _physics_process(delta):
	#if is_network_master():
	get_input()	

	
func get_input():
	var current = state_machine.get_current_node()
	var ballon = get_node("bicyclePump/redballon")
	
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
		
		


func _on_Network_tick_rate_timeout():
	pass # Replace with function body.

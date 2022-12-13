extends KinematicBody

var state_machine
var timer = Timer

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
func _physics_process(delta):
	get_input()
	
	
func get_input():
	var current = state_machine.get_current_node()
	
	if Input.is_action_just_pressed("ui_up"):
		print("INPUT IS UP")
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
		print("Pump is allready up bro")
		return

	
	if Input.is_action_just_pressed("ui_down"):
		print("INPUT IS DOWN")
		print(current)
		# if pump is on half and down was pressed
		if current == "TopToHalf001":
			#move to bot
			state_machine.travel("HalfToBot001")
			get_node("redballon").scale *=1.04
			return
		if current == "BotToHalf001":
			state_machine.travel("HalfToBot001")
			get_node("redballon").scale *=1.04
			return
		if current == "HalfToBot001":
			print("Pump is allready down bro")
			return
		#else move from top to middle
		state_machine.travel("TopToHalf001")
		get_node("redballon").scale *=1.04
		return
		
		

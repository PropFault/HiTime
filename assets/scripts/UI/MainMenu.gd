extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Connect_pressed():
	Networking.startClient()



func _on_Host_pressed():
	var array = ["--no-window", "--server"]
	var args = PoolStringArray(array)
	var exe = "./bin/game.exe"
	if not File.new().file_exists(exe):
		exe = OS.get_executable_path()
	OS.execute(exe, args, false)

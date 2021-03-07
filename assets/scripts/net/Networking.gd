extends Node
export(PackedScene)var player = preload("res://assets/scenes/entities/ent_player.tscn")
export(int)var serverPort = 4554
export(String)var serverIP = "127.0.0.1"
export(int)var maxPlayers = 24
export(String)var playerName = "PlayerTest "
export(Resource)var gameInfo;
var peer

# Called when the node enters the scene tree for the first time.

func startClient():
	peer.create_client(serverIP, serverPort)
	get_tree().network_peer = peer

func startServer():
	peer.create_server(serverPort, maxPlayers)
	get_tree().network_peer = peer
func _ready():
	peer = NetworkedMultiplayerENet.new()
	if "--server" in OS.get_cmdline_args():
		startServer()
		Game.connect("KeyframePassed", self,"serverFwdAction")
	get_tree().connect("network_peer_connected", self, "onPeerConnected")
	get_tree().connect("network_peer_disconnected", self, "onPeerDisconnected")
	
func onPeerConnected(var id):
	print("Peer is attempting to connect")
	if get_tree().is_network_server():
		print("Requesting player info")
		rpc_id(id, "requestPlayerInfo")
remote func receivePlayerInfo(info):
	print("Player ", info, " connected")
	info["rpc_id"] = str(get_tree().get_rpc_sender_id())
	print("sending GI: " , to_json(gameInfo))
	Maps.loadMap(gameInfo.currentMap)
	Game.startTimeline(0);
	var gameJSON = Game.timeline_to_json()
	print("SENDING: ", gameJSON)
	rpc_id(get_tree().get_rpc_sender_id(),"receiveServerInfo", gameInfo.to_json(), gameJSON)
	rpc("registerNewPlayer",info)


	
remote func registerNewPlayer(info):
	var newPlayer = player.instance()
	newPlayer.name = str(info["rpc_id"])
	get_tree().root.add_child(newPlayer)
remote func receiveServerInfo(infoJson, gamestate):
	var info = GameInfo.new(infoJson)
	Maps.loadMap(info.currentMap)
	Game.timeline_from_json(gamestate)

func syncAction(var gameAction : Game.Action):
	rpc_id(1, "serverReceiveAction", gameAction.to_json())

remote func serverReceiveAction(var gameActionJSON):
	var newAction = Game.Action.new(gameActionJSON)
	Game.addKeyframe(newAction)

puppet func receiveAction(var gameActionJSON):
	var action = Game.Action.new(gameActionJSON)
	Game.addKeyframe(action)

func serverFwdAction(action):
	rpc("receiveAction", action.to_json())

func onPeerDisconnected(var id):
	if not get_tree().is_network_server():
		get_tree().root.find_node(str(id)).queue_free()
	print("Quitting")
	get_tree().quit()
remote func requestPlayerInfo():
	return rpc_id(1,"receivePlayerInfo",{ name = playerName})

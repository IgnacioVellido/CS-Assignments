extends MeshInstance

remote func delete():
	queue_free()
	
	rpc("delete")

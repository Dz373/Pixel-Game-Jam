extends HBoxContainer

@export var pip: PackedScene

func createPips(val):
	for i in val:
		add_child(pip.instantiate())

func addPip():
	add_child(pip.instantiate())

func removePip():
	remove_child(get_child(0))

class_name Data

static func getNations() -> Dictionary[String, NationResource]:
	return {
		'red' : preload("uid://rt1mkwse0q6x"),
		'blue' : preload("uid://bpsdbe2iso55e"),
		'green' : preload("uid://ci84d7wli2mbr")
		}

enum nationType {RED = 0, BLUE = 1, GREEN = 2}

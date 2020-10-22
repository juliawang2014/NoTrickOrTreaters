extends Node2D

var selected_elements = 0

var planets = [preload("res://data/Areas/DreamPlanet.tscn")]
var planet_instance
var planet_pos = []
var planet_pos_access = []
var planet_rewind = []

var sequence = []
var combos = { "COMBO1" : ["Hydrogen", "Oxygen"],
				"COMBO2" : ["Oxygen", "Hydrogen"],
				"COMBO3" : ["Nitrogen", "Oxygen"],
				"COMBO4" : ["Oxygen", "Nitrogen"]}

func _ready():
	for i in $Planets.get_child_count():
		planet_pos.push_back($Planets.get_child(i).position)
	planet_pos_access = planet_pos.duplicate()
	for i in $Elements.get_child_count():
		var element = $Elements.get_child(i)
		element.connect("selection_made", self, "_on_selection_made")
		element.connect("deselect", self, "_on_deselect")

func combine():
	for curcombo in combos:
		if checkCombo(sequence, combos[curcombo]):
			planet_instance = planets[randi() % planets.size()].instance()
			planet_instance.position = planet_pos_access.pop_back()
#			planet_rewind.append(planet_pos_access.pop_back())
			$Planets.call_deferred('add_child', planet_instance)

func checkCombo(s,t):
	if s.size() < t.size():
		return false
	
	var c = s.duplicate()
	c.invert()
	c.resize(t.size())
	c.invert()
	
	for i in range(t.size()):
		if c[i] != t[i]:
			return false
	
	return true

func _on_Combine_pressed():
	if selected_elements >= 2:
		combine()

func _on_selection_made(area_name):
	selected_elements += 1
	sequence.push_back(area_name)

func _on_deselect():
	selected_elements -= 1
	sequence.pop_back()

func _on_Rewind_pressed():
	pass # Replace with function body.

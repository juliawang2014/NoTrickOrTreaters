extends CanvasLayer

export (float) var minimum_value = -24
var default_volume = 0

func _ready():
	$NinePatchRect.hide()

func reveal():
	$NinePatchRect.show()

func disappear():
	$NinePatchRect.hide()

func _on_Return_pressed():
	disappear()


func _on_Defaults_pressed():
	$NinePatchRect/HBoxContainer/VBoxContainer/GridContainer/MasterSlider.value = default_volume
	$NinePatchRect/HBoxContainer/VBoxContainer/GridContainer/MusicSlider.value = default_volume
	$NinePatchRect/HBoxContainer/VBoxContainer/GridContainer/SFXSlider.value = default_volume


func _on_MasterSlider_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	AudioServer.set_bus_volume_db(0, lerp(AudioServer.get_bus_volume_db(0), value, 1.0))


func _on_MusicSlider_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
	AudioServer.set_bus_volume_db(1, lerp(AudioServer.get_bus_volume_db(1), value, 1.0))


func _on_SFXSlider_value_changed(value):
	if value <= minimum_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
	AudioServer.set_bus_volume_db(2, lerp(AudioServer.get_bus_volume_db(2), value, 1.0))

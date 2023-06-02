extends Node2D

var Value : int = 2
var ValueLabel : Label = null

func _ready():
	ValueLabel = get_node("TileBG/Value")
	# Styling...
	ValueLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ValueLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ValueLabel.add_theme_font_size_override("font_size", 48)
	
	# Set label text
	UpdateValueLabel()	
	
func SetValue(newValue : int):
	Value = newValue
	UpdateValueLabel()
	
func UpdateValueLabel():
	ValueLabel.text = str(Value)

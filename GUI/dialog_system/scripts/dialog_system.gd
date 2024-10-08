@tool
@icon("res://GUI/dialog_system/icons/star_bubble.svg")
class_name DialogSystemNode extends CanvasLayer

signal finished
signal letter_added(letter: String)

var is_active: bool = false
var text_in_progress: bool = false
var waiting_for_choice: bool = false
var text_speed: float = 0.03
var text_length: int = 0
var plain_text: String 
var dialog_items: Array[DialogItem]
var dialog_item_index: int = 0
var on_cooldown: bool = false


@onready var dialog_ui: Control = $DialogUI
@onready var dialog_content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogUI/PortraitSprite
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var label_next: Label = $DialogUI/DialogProgressIndicator/LabelNext
@onready var timer: Timer = $DialogUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogUI/AudioStreamPlayer
@onready var choice_options: VBoxContainer = $DialogUI/VBoxContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	timer.timeout.connect(_on_timer_timeout)
	hide_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return
	if (
		event.is_action_pressed("interact")
	):
		if text_in_progress:
			dialog_content.visible_characters = text_length
			return
		elif waiting_for_choice:
			return
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	#if event.is_action_pressed("test"):
		#if !is_active:
			#show_dialog()
		#else:
			#hide_dialog()


func show_dialog_ui(_items: Array[DialogItem]) -> void:
	dialog_content.visible_characters = 0
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialog()
	
func hide_dialog() -> void:
	is_active = false
	choice_options.visible = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	on_cooldown = true
	await get_tree().create_timer(0.2).timeout
	on_cooldown = false

func start_dialog() -> void:
	waiting_for_choice = false
	var current_item : DialogItem = dialog_items[dialog_item_index]
	if current_item is DialogText:
		set_dialog_text(current_item)
	elif current_item is DialogChoice:
		set_dialog_choice(current_item)
	
	show_dialog_button_indicator(false)
	
#Set dialog and NPC variables, etc based on dialog item parameters.
#Once set, start text typing timer
func set_dialog_text(item: DialogText) -> void:
	dialog_content.text = item.text
	name_label.text = item.npc_info.npc_name
	portrait_sprite.texture = item.npc_info.portrait
	
	dialog_content.visible_characters = 0
	text_length = dialog_content.get_total_character_count()
	plain_text = dialog_content.get_parsed_text()
	text_in_progress = true
	start_timer()
	
#Set dialog choice UI based on parameters
func set_dialog_choice(item: DialogChoice) -> void:
	choice_options.visible = true
	waiting_for_choice = true
	for c in choice_options.get_children():
		c.queue_free()
	for i in item.dialog_branches.size():
		var _new_choice: Button = Button.new()
		_new_choice.text = item.dialog_branches[i].text
		#_new_choice.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_new_choice.pressed.connect(_dialog_choice_selected.bind(item.dialog_branches[i]))
		choice_options.add_child(_new_choice)
	await get_tree().process_frame
	choice_options.get_child(0).grab_focus()
	
func _dialog_choice_selected(item: DialogBranch) -> void:
	choice_options.visible = false
	show_dialog_ui(item.dialog_items)
	pass
	
func start_timer() -> void:
	timer.wait_time = text_speed
	var _char = plain_text[dialog_content.visible_characters - 1]
	if ".;:?!".contains(_char):
		timer.wait_time *= 4
	elif ", ".contains(_char):
		timer.wait_time *= 2
	timer.start()
	
func show_dialog_button_indicator(_is_visible) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index + 1 < dialog_items.size():
		label_next.text = "NEXT"
	else:
		label_next.text = "END"

func _on_timer_timeout() -> void:
	dialog_content.visible_characters += 1
	
	if dialog_content.visible_characters <= text_length:
		start_timer()
	else:
		#a small wait to prevent the player from skipping text
		#by tapping interact near the end of the dialog
		await get_tree().create_timer(0.1).timeout
		show_dialog_button_indicator(true)
		text_in_progress = false

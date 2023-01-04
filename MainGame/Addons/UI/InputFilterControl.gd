#
# Demonstrate one approach for filtering UI (keyboard/joypad?) input for
# multi-player localhost co-op (e.g. on one keyboard).
#
# Note: Requires adding "ui_up_2", "ui_down_2" etc to project Input Mapping.
#

# Note: Should probably really extend `Container` but `Control` was easier to
#       to get the sizing stuff correct.


extends Control

class_name InputFilterControl

# TODO: Don't special case player index 0? And/or start from "_0"?
#       Both would probably simplify this code.
export var player_index: int = 0 setget on_player_index_change

var _player_action_suffix = ""

func on_player_index_change(new_index: int):
	player_index = new_index

	if self.player_index == 0:
		self._player_action_suffix = ""
	else:
		self._player_action_suffix = "_" + String(self.player_index + 1)


var _ui_action_list = [] # Note: Probably redundant, could probably be shared.


func _ready():

	# Note: Player 0 (err, 1) currently just gets the non-suffixed actions.
	if self.player_index != 0:
		for action_name in InputMap.get_actions():
			if action_name.ends_with(self._player_action_suffix):
				self._ui_action_list.append(action_name.substr(0, action_name.length()-self._player_action_suffix.length()))

	#print(self._ui_action_list)


func _input(event: InputEvent) -> void:

	if !event.is_action_type():
		return

	# Note: This avoids mouse also being able to select & mucking up focus.
	if (event.get_class() == "InputEventMouseButton"):
		get_tree().set_input_as_handled()
		return


	if self.player_index == 0:
		# TODO: Prevent "random" keys (like "i" from moving player 1 selection.)
		self.propagate_call("_gui_input", [event])
	else:
		for action_name in self._ui_action_list:
			var e: InputEvent = null

			if event.is_action(action_name+self._player_action_suffix):
				e = InputMap.get_action_list(action_name)[0]
				e.pressed = event.pressed

				self.propagate_call("_gui_input", [e])

				# Note: Without this pressing e.g. "i" at top of ItemList
				#       might cause the 1st player's ItemList to jump to a
				#       different entry as it's treated as search input.
				get_tree().set_input_as_handled()
				# break # Note: Apparently InputEvents can contain multiple actions?

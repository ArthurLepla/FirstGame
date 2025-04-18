# This script is the main entry point for the plugin
# It handles the plugin's lifecycle, including loading the dock scene
# and adding it to the bottom panel of the editor

@tool

extends EditorPlugin

var creator_dock: Control

func _enter_tree():
    # Load the dock scene lazily so the editor opens fast
    var dock_scene := preload("res://addons/character_creator/ui/CharacterCreatorDock.tscn")
    creator_dock = dock_scene.instantiate()
    # Add to a dedicated bottom panel – change to sidebar if you prefer
    add_control_to_bottom_panel(creator_dock, "Character Creator")
    # Optional: give access to the dock from the TopBar
    # add_tool_menu_item("Character Creator", Callable(self, "_toggle_dock"))

func _exit_tree():
    remove_control_from_bottom_panel(creator_dock)
    creator_dock.queue_free()

# Example of toggling the dock from a menu item (optional)
func _toggle_dock():
    if creator_dock.visible:
        creator_dock.hide()
    else:
        creator_dock.show()

extends Node2D
class_name Outline

const OUTLINE_MATERIAL:ShaderMaterial = preload("res://resources/materials/outlineDrawMaterial.tres")

# the outline type colors that you can pass to the shader (outline.gdshader), in decreasing priority
# the actual colors they correspond to are defined in the shader
const MULTISELECT_OUTLINE:Color = Color(1,0,0);
const COMPONENT_HOVER_OUTLINE:Color = Color(0,1,0);
const OBJECT_HOVER_OUTLINE:Color = Color(1,1,0);
const COMPONENT_SELECT_OUTLINE:Color = Color(0,0,1);
const OBJECT_SELECT_OUTLINE:Color = Color(1,0,1);

@onready var editor:Editor = get_node("/root/editor")

var drawNormal:RID

func _ready() -> void:
	drawNormal = RenderingServer.canvas_item_create()
	await editor.ready
	RenderingServer.canvas_item_set_parent(drawNormal,editor.outlineParent.get_canvas_item())

func draw() -> void:
	RenderingServer.canvas_item_clear(drawNormal)
	if Game.playState == Game.PLAY_STATE.PLAY: return
	if editor.settingsOpen:
		if editor.settingsMenu.levelSettings.visible: drawOutline(editor.levelBoundsObject,OBJECT_SELECT_OUTLINE)
	else: 
		if editor.focusDialog.focused: drawOutline(editor.focusDialog.focused,OBJECT_SELECT_OUTLINE)
		if editor.focusDialog.componentFocused: drawOutline(editor.focusDialog.componentFocused,COMPONENT_SELECT_OUTLINE)
		if editor.multiselect.state == Multiselect.STATE.HOLDING:
			if editor.objectHovered and editor.objectHovered != editor.focusDialog.focused: drawOutline(editor.objectHovered,Color(OBJECT_HOVER_OUTLINE))
			if editor.componentHovered and editor.componentHovered != editor.focusDialog.componentFocused: drawOutline(editor.componentHovered,Color(COMPONENT_HOVER_OUTLINE))

func drawOutline(component:GameComponent,color) -> void:
	var pos:Vector2 = component.getDrawPosition()
	if component is PlayerPlaceholderObject: pos -= component.getOffset()
	if component.get_script() in Game.RECTANGLE_COMPONENTS:
		RenderingServer.canvas_item_add_rect(drawNormal,Rect2(pos,component.getDrawSize()),color)
	else:
		RenderingServer.canvas_item_add_texture_rect(drawNormal,Rect2(pos,component.getDrawSize()),component.outlineTex(),false,color)

func _process(_delta) -> void:
	draw()

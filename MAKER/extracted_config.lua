
--[[
This file contains known constants and caches some stuff based on what this version of OW decided those constants should be.
]]--

MAKER.KNOWN_TYPES = {
"TYPE_ELEMENT","TYPE_LABEL","TYPE_CHECKBOX","TYPE_PROGRESSBAR","TYPE_LISTBOX","TYPE_SCROLLBAR","TYPE_EDIT","TYPE_TEXTBOX","TYPE_SCROLLBOX","TYPE_CUSTOMLISTBOX","TYPE_IMAGEBUTTON","TYPE_SPRITEMAPBUTTON","TYPE_UNITLIST","TYPE_SPRITEMAPBUTTONS","TYPE_LABELCELLS","desktop"
};
MAKER.KNOWN_PROPS = {
"PROP_X","PROP_Y","PROP_W","PROP_H","PROP_COL1","PROP_COL2","PROP_FONT_COL","PROP_FONT_NAME","PROP_GRADIENT","PROP_TEXTURE","PROP_TEXT","PROP_VISIBLE","PROP_ANCHOR","PROP_HALIGN","PROP_NOMOUSEEVT","PROP_TEXTURE2","PROP_CHECKED","PROP_MINMAX","PROP_PROGRESS","PROP_ALPHA","PROP_SCROLLBAR","PROP_INDEX","PROP_HIGHLIGHTCOL","PROP_DISABLED","PROP_FONT_COL_DISABLED","PROP_FONT_COL_OVER","PROP_AUTOSIZE","PROP_BEVEL","PROP_BEVEL_COL1","PROP_BEVEL_COL2","PROP_GLYPH","PROP_GLYPH_ALIGN","PROP_LINE","PROP_WORDWRAP","PROP_TEXTCASE","PROP_TEXTURE_BLEND","PROP_SHADER","PROP_TILE","PROP_SCROLLBAR2","PROP_VALIGN","PROP_VERTICAL","PROP_FALLBTEXTURE","PROP_GRADIENT_COL1","PROP_GRADIENT_COL2","PROP_ITEMHEIGHT","PROP_AUTOHIDESCROLL","PROP_EDGES","PROP_SHADOWTEXT","PROP_NOMOUSEEVTTHIS","PROP_STRIKETHROUGH","PROP_UNDERLINE","PROP_TEXTURE3","PROP_FONT_COL_BACK","PROP_BORDER_SIZE","PROP_BORDER_TYPE","PROP_BORDER_COLOUR","PROP_ANIM_LOOP","PROP_ANIM_PLAY","PROP_OVERDRAW","PROP_SUBTEXTURE","PROP_SUBCOORDS","PROP_HINT","PROP_AUTOMAXWIDTH","PROP_INVALIDCHARS","PROP_NOHIGHLIGHT","PROP_EDGES_TEXTURE","PROP_ABS_X","PROP_ABS_Y","PROP_SCISSOR","PROP_TAG","PROP_OUTLINE","PROP_TOPDOWN","PROP_TEXTURE_LINEAR","PROP_DOWN_PIXELS","PROP_MOUSEOVERCOL","PROP_SCISSOR_BORDER","PROP_ISPASSWORD","PROP_FONT_SCALE","PROP_SHADER_TIME","PROP_OUTLINE2","PROP_FONT_CHARGAP","PROP_SCROLL_TEXT","PROP_BLENDFUNC","PROP_MASK","PROP_ROTATE","PROP_CURSORPOS","PROP_XF","PROP_YF","PROP_WF","PROP_HF","PROP_SMOOTHSCROLL","PROP_TILESCALEX","PROP_TILESCALEY","PROP_NODRAWOUTSIDEPARENT","PROP_CHILDIDS","PROP_SCROLLSIZEADJUST","PROP_NOMOUSEEVTR","PROP_OUTLINE2SETTING",
};
MAKER.INVALID_KNOWN_PROP = {
"PROP_FONT_FLIP","PROP_ROTATE_MATRIX", "PROP_SHADER_CUSTOM",
};
MAKER.KNOWN_CALLBACKS = {
"CALLBACK_MOUSEOVER","CALLBACK_MOUSELEAVE","CALLBACK_MOUSEDOWN","CALLBACK_MOUSEMOVE","CALLBACK_MOUSEUP","CALLBACK_CHECKED","CALLBACK_MOUSEMOVEANY","CALLBACK_RESIZED","CALLBACK_INDEXSET","CALLBACK_MOUSEUPANY","CALLBACK_MOUSECLICK","CALLBACK_KEYDOWN","CALLBACK_KEYUP","CALLBACK_PROGRESS","CALLBACK_ITEMADDED","CALLBACK_ITEMDELETED","CALLBACK_ITEMUPDATED","CALLBACK_ITEMSELECTED","CALLBACK_ITEMUNSELECTED","CALLBACK_ANIMEND","CALLBACK_DISABLED","CALLBACK_HIDDEN","CALLBACK_MOUSEDBLCLICK","CALLBACK_ITEMCLICKED","CALLBACK_KEYPRESS","CALLBACK_MOUSEWHEEL","CALLBACK_VISIBILITY",
};
MAKER.KNOWN_ALINGS_HORIZ = {
"ALIGN_LEFT","ALIGN_MIDDLE","ALIGN_RIGHT"
};
MAKER.KNOWN_ALINGS_VERT = {
"ALIGN_MIDDLE","ALIGN_TOP","ALIGN_BOTTOM",
};
MAKER.KNOWN_CASES = {
"CASE_NORMAL","CASE_LOWER","CASE_UPPER","CASE_TITLE",
};
MAKER.KNOWN_BORDERS = {
"BORDER_TYPE_NONE","BORDER_TYPE_INNER","BORDER_TYPE_OUTER",
};
MAKER.KNOWN_GLSTUFF = {
"GL_ZERO","GL_ONE","GL_SRC_COLOR","GL_ONE_MINUS_SRC_COLOR","GL_SRC_ALPHA","GL_ONE_MINUS_SRC_ALPHA","GL_DST_ALPHA","GL_ONE_MINUS_DST_ALPHA","GL_DST_COLOR","GL_ONE_MINUS_DST_COLOR","GL_SRC_ALPHA_SATURATE",
};
--[[ TODO: search for the data above in _ENV
if( not table.empty(_ENV)) then
	for k,v in pairs(_ENV) do
		if( type(k) ~= "string") then
		
		elseif (k:find("^PROP")) then
			if(INVALID_KNOWN_PROP[k] = nil) then
				
			end;
		end;
	end;
end;
]]
--sort of dynamically generated.
MAKER.PROP_TYPE = {};
MAKER.PROP_TO_ID,MAKER.ID_TO_PROP = MAKER.makeTranslation(MAKER.KNOWN_PROPS);
MAKER.ALIGN_HORIZ_TO_ID, MAKER.ID_TO_ALIGN_HORIZ = MAKER.makeTranslation(MAKER.KNOWN_ALINGS_HORIZ);
MAKER.ALINGS_VERT_TO_ID, MAKER.ID_TO_ALINGS_VERT = MAKER.makeTranslation(MAKER.KNOWN_ALINGS_VERT);
MAKER.CASE_TO_ID, MAKER.ID_TO_CASE = MAKER.makeTranslation(MAKER.KNOWN_CASES);
MAKER.BORDER_TO_ID, MAKER.ID_TO_BORDER = MAKER.makeTranslation(MAKER.KNOWN_BORDERS);
MAKER.GLSTUFF_TO_ID, MAKER.ID_TO_GLSTUFF = MAKER.makeTranslation(MAKER.KNOWN_GLSTUFF);
MAKER.CALLBACK_TO_ID, MAKER.ID_TO_CALLBACK = MAKER.makeTranslation(MAKER.KNOWN_CALLBACKS);

MAKER.TYPE_TO_ID, MAKER.ID_TO_TYPE = MAKER.makeTranslation(MAKER.KNOWN_TYPES);;

MAKER.TYPE_DEFAULTS = {};
for k,v in pairs(MAKER.KNOWN_TYPES) do
	local typ = MAKER.TYPE_TO_ID[v];
	local elem = AddElement({type = typ});
	MAKER.TYPE_DEFAULTS[typ] = {};
	for key,prop in pairs(MAKER.KNOWN_PROPS) do
		local target = loadstring('return ' .. prop)();
		local packed = table.pack((sgui_get(elem.ID, target)));
		if(packed["n"] ~= 1) then
			error("For some reason sgui_get returned too many params. I cannot handle this properly, random stuff may break.",0);
			-- STU CHANGED MY API, ugh.
		end;
		MAKER.TYPE_DEFAULTS[typ][target] = packed[1];
		--[[ used for generating the first iteration of the config, later needs manual parsing
		if(MAKER.PROP_TYPE[prop] == nil) then
			MAKER.PROP_TYPE[prop] = type(MAKER.TYPE_DEFAULTS[typ][target]);
		end;]]
	end;
	sgui_delete(elem.ID);
end;
--[[
colour = {alpha = 0, red = 0, green = 0, blue = 0}
subCoords = {   ["[1]"] = 0,  ["[2]"] = 0,  ["[3]"] = 0,  ["[4]"] = 0,}

]]
--too lazy to make a proper workaround
function MAKER.set_Anchor(ID,PROP,Anchor) 
	return set_Anchor(ID,Anchor);
end;
MAKER.TYPE_SAVER = {
	["default"] = set_Property,
	["colour"] = set_Colour,
	["anchor"] = MAKER.set_Anchor,
	["subCoords"] = set_SubCoords,
}

MAKER.READONLY = {
	["PROP_CHILDIDS"] = true,
	["PROP_ABS_X"] = true,
	["PROP_ABS_Y"] = true,
}

MAKER.PROP_TYPE = { 
["PROP_COL1"] = "colour",--table
["PROP_COL2"] = "colour",--table

["PROP_HIGHLIGHTCOL"] = "colour",--table
["PROP_MOUSEOVERCOL"] = "colour",--table

["PROP_BEVEL_COL1"] = "colour", -- table
["PROP_BEVEL_COL2"] = "colour",--table

["PROP_GRADIENT_COL1"] = "colour",--table
["PROP_GRADIENT_COL2"] = "colour",--table

["PROP_ALPHA"] = "number",

["PROP_FONT_NAME"] = "string",
["PROP_FONT_COL"] = "colour",--table
["PROP_FONT_COL_DISABLED"] = "colour",--table
["PROP_FONT_COL_OVER"] = "colour",--table
["PROP_FONT_COL_BACK"] = "colour",--table
["PROP_STRIKETHROUGH"] = "boolean",
["PROP_SHADOWTEXT"] = "boolean",
["PROP_FONT_SCALE"] = "number",


["PROP_BORDER_COLOUR"] = "colour",--table
["PROP_BORDER_TYPE"] = "number",
["PROP_BORDER_SIZE"] = "number",


["PROP_ANCHOR"] = "anchor", --table
["PROP_CHILDIDS"] = "nil", --table when filled. {[iterator]=>ID}, READONLY

["PROP_SUBCOORDS"] = "subCoords", --table


["PROP_AUTOHIDESCROLL"] = "nil",
["PROP_NODRAWOUTSIDEPARENT"] = "boolean",
["PROP_OUTLINE2SETTING"] = "number",
["PROP_ITEMHEIGHT"] = "nil",
["PROP_CURSORPOS"] = "nil",
["PROP_TEXTURE_BLEND"] = "boolean",
["PROP_SUBTEXTURE"] = "boolean",
["PROP_SCISSOR"] = "boolean",
["PROP_DISABLED"] = "boolean",
["PROP_OVERDRAW"] = "boolean",
["PROP_CHECKED"] = "nil",
["PROP_TEXTURE2"] = "string",
["PROP_LINE"] = "nil",
["PROP_WORDWRAP"] = "boolean",
["PROP_FONT_CHARGAP"] = "number",
["PROP_NOMOUSEEVTR"] = "boolean",
["PROP_TEXTURE_LINEAR"] = "boolean",
["PROP_TEXTURE"] = "string",
["PROP_MINMAX"] = "nil",
["PROP_TOPDOWN"] = "nil",
["PROP_SCROLLBAR2"] = "number",
["PROP_HINT"] = "string",
["PROP_SCROLL_TEXT"] = "nil",
["PROP_EDGES_TEXTURE"] = "string",
["PROP_FALLBTEXTURE"] = "string",
["PROP_SCROLLSIZEADJUST"] = "nil",
["PROP_GLYPH_ALIGN"] = "number",
["PROP_TILESCALEY"] = "number",
["PROP_NOMOUSEEVT"] = "boolean",
["PROP_TILESCALEX"] = "number",
["PROP_SMOOTHSCROLL"] = "boolean",
["PROP_SHADER"] = "number",
["PROP_ROTATE"] = "nil",
["PROP_MASK"] = "nil",
["PROP_BLENDFUNC"] = "nil",
["PROP_HALIGN"] = "nil",
["PROP_ANIM_PLAY"] = "boolean",
["PROP_SHADER_TIME"] = "number",
["PROP_INVALIDCHARS"] = "nil",
["PROP_VALIGN"] = "nil",
["PROP_SCISSOR_BORDER"] = "number",
["PROP_GLYPH"] = "string",
["PROP_PROGRESS"] = "nil",
["PROP_DOWN_PIXELS"] = "nil",
["PROP_OUTLINE"] = "boolean",
["PROP_TAG"] = "number",
["PROP_GRADIENT"] = "boolean",
["PROP_UNDERLINE"] = "boolean",
["PROP_VISIBLE"] = "boolean",
["PROP_VERTICAL"] = "number",
["PROP_NOHIGHLIGHT"] = "nil",
["PROP_OUTLINE2"] = "boolean",
["PROP_INDEX"] = "nil",
["PROP_TEXT"] = "nil",
["PROP_EDGES"] = "boolean",
["PROP_ANIM_LOOP"] = "boolean",
["PROP_ISPASSWORD"] = "nil",
["PROP_TEXTCASE"] = "nil",
["PROP_TEXTURE3"] = "string",
["PROP_STRIKETHROUGH"] = "boolean",
["PROP_SCROLLBAR"] = "number",
["PROP_NOMOUSEEVTTHIS"] = "boolean",
["PROP_BEVEL"] = "boolean",
["PROP_TILE"] = "boolean",


["PROP_AUTOMAXWIDTH"] = "nil",
["PROP_AUTOSIZE"] = "boolean",


["PROP_W"] = "number",
["PROP_WF"] = "number",

["PROP_H"] = "number",
["PROP_HF"] = "number",

["PROP_X"] = "number",
["PROP_XF"] = "number",

["PROP_Y"] = "number",
["PROP_YF"] = "number",

["PROP_ABS_X"] = "number",
["PROP_ABS_Y"] = "number",
};
MAKER.AddElementTranslator = { 
	["PROP_X"] = "x",
	["PROP_Y"] = "y",
	["PROP_W"] = "width",
	["PROP_H"] = "height",
	["PROP_COL1"] = "colour1",
	["PROP_COL2"] = "colour2", -- If Gradient is true Colour 1 and Colour 2 are used for it. Colour2 is also used for the Checkbox's check colour and Progress Bar's progress colour
	["PROP_HIGHLIGHTCOL"] = "highlightcol", -- Used for Listbox's selected item
	["PROP_FONT_COL"] = "font_colour",
	["PROP_FONT_COL_DISABLED"] = "font_colour_disabled",
	["PROP_FONT_COL_OVER"] = "font_colour_over",
	["PROP_FONT_COL_BACK"] = "font_colour_background",

	["PROP_BORDER_SIZE"] = "border_size",
	["PROP_BORDER_TYPE"] = "border_type", -- BORDER_TYPE_NONE, BORDER_TYPE_INNER, BORDER_TYPE_OUTER
	["PROP_BORDER_COLOUR"] = "border_colour",

	["PROP_STRIKETHROUGH"] = "font_style_strikethrough",
	["PROP_UNDERLINE"] = "font_style_underline",
	["PROP_OUTLINE"] = "font_style_outline",
	["PROP_OUTLINE2"] = "font_style_outline2",

	["PROP_FONT_NAME"] = "font_name",

	["PROP_FONT_SCALE"] = "font_scale",
	["PROP_FONT_CHARGAP"] = "font_chargap",

	["PROP_SHADOWTEXT"] = "shadowtext",

	["PROP_GRADIENT"] = "gradient",
	["PROP_GRADIENT_COL1"] = "gradient_colour1",
	["PROP_GRADIENT_COL2"] = "gradient_colour2",
	["PROP_TEXTURE_LINEAR"] = "texture_linear", -- Linear or Nearest Filter
	["PROP_TEXTURE"] = "texture", -- Texture is the background texture for an Element. It is multiplied by Colour1
	["PROP_FALLBTEXTURE"] = "texture_fallback", -- Fallback if PROP_TEXTURE does not exist
	["PROP_TEXTURE2"] = "texture2", -- Texture 2 is used to replace the Checkbox's Check and Progress Bar's progress with an image. It is multiplied by Colour 2
	["PROP_TEXTURE3"] = "texture3", -- Texture 3 is used by the TYPE_IMAGEBUTTON

	["PROP_TEXT"] = "text",
	["PROP_VISIBLE"] = "visible",
	["PROP_ANCHOR"] = "anchor",

	["PROP_SCROLL_TEXT"] = "scroll_text", -- Only works on Labels with 1 line

	["PROP_EDGES"] = "edges", -- Boolean value. Turns edges on/off
	["PROP_EDGES_TEXTURE"] = "edges_texture",

	["PROP_HALIGN"] = "text_halign", -- Horizontal Text Alignment (ALIGN_LEFT or ALIGN_MIDDLE or ALIGN_RIGHT"
	["PROP_VALIGN"] = "text_valign", -- Vertical Text Alignment (ALIGN_TOP or ALIGN_MIDDLE or ALIGN_BOTTOM"

	["PROP_NOMOUSEEVT"] = "nomouseevent", -- If True the element ignores all mouse events allowing those under it to receive them
	["PROP_NOMOUSEEVTTHIS"] = "nomouseeventthis", -- If True OW ignores this element for mouse click checks but still considers children.
	["PROP_NOMOUSEEVTR"] = "nomouserightclick", -- If True the element ignores right click mouse events allowing those under it to receive them

	["PROP_CHECKED"] = "checked",
	["PROP_MINMAX"] = "minmax",
	["PROP_PROGRESS"] = "progress",
	["PROP_ALPHA"] = "alpha",
	["PROP_TEXTURE_BLEND"] = "texture_blend", -- True by default. enables/disables gl_blend when drawing texture
	["PROP_INDEX"] = "index",

	["PROP_DISABLED"] = "disabled", -- Disabled elements receive no mouse input, no keyboard input and may render differently (To show they are disabled"
	["PROP_AUTOSIZE"] = "autosize", -- Autosize currently only works on labels for automatically resizing their width based on the text and font

	["PROP_BEVEL"] = "bevel", -- Draw a bevel
	["PROP_BEVEL_COL1"] = "bevel_colour1",
	["PROP_BEVEL_COL2"] = "bevel_colour2",


	["PROP_GLYPH"] = "glyph",--Glyph's shouldn't be used as they are not aligned to the side of text. May fix their implementation at a later date
	["PROP_GLYPH_ALIGN"] = "glyph_align",-- Horizontal Alignment (ALIGN_LEFT or ALIGN_MIDDLE or ALIGN_RIGHT"

	["PROP_WORDWRAP"] = "wordwrap",

	["PROP_TEXTCASE"] = "text_case", --CASE_NORMAL, CASE_LOWER, CASE_UPPER, CASE_TITLE

	["PROP_SHADER"] = "shader",
	["PROP_TILE"] = "tile", -- Causes the background texture to tile when true

	["PROP_SCROLLBAR"] = "scrollbar",
	["PROP_SCROLLBAR2"] = "scrollbar2",

	["PROP_VERTICAL"] = "vertical", -- For TYPE_SCROLLBAR elements to state if they are vertical or horizontal. They are vertical by default.

	["PROP_ITEMHEIGHT"] = "itemheight",

	["PROP_ANIM_LOOP"] = "anim_loop",
	["PROP_ANIM_PLAY"] = "anim_play",
	["PROP_OVERDRAW"] = "overdraw",

	["PROP_SUBTEXTURE"] = "subtexture",
	["PROP_SUBCOORDS"] = "subcoords",

	["PROP_AUTOMAXWIDTH"] = "automaxwidth",

	["PROP_HINT"] = "hint",
	["PROP_INVALIDCHARS"] = "invalidchars", -- Characters in the string can't be typed into the edit box

--  set_Property(Input.ID,PROP_NOHIGHLIGHT,not Input.highlight), -- TODO For Labels. When Highlight is true a Label will change colour when the mouse is over it.

	["PROP_SCISSOR"] = "scissor", -- When enabled an element can not draw outside of its area
	["PROP_SCISSOR_BORDER"] = "scissor_border", -- text will be clipped further by this amount

	["PROP_TAG"] = "tag", -- Number you can set. Default is 0. Has no usage other than to identify this element


--	set_Property(Input.ID,PROP_TOPDOWN,not Input.bottomup), -- TODO LABELS, TEXTBOX, IMAGEBUTTON - Reverses the Text so it goes from bottom up
	["PROP_DOWN_PIXELS"] = "downpixels", -- LABELS - Amount of pixels the Y position of text will move when Left Mouse is down

	["PROP_ISPASSWORD"] = "ispassword", -- EDIT - displays entered text as asterix's

	["PROP_SHADER_TIME"] = "shader_time", -- Sets the shaders time variable

--	["Input.blendfuncs"] = "blendfuncd", TODO: this

	["PROP_ROTATE"] = "rotate",

	["PROP_MASK"] = "mask",
	["PROP_AUTOHIDESCROLL"] = "autohidescroll",

	["PROP_SCROLLSIZEADJUST"] = "scrollsizeadjust", -- if scrollbar will auto size its self based on the amount you can scroll. True by default.
	["PROP_SMOOTHSCROLL"] = "smoothscroll",


--	["PROP_FONT_FLIP"] = "font_flipx,Input.font_flipy", TODO:this

	["PROP_NODRAWOUTSIDEPARENT"] = "nodrawoutsideparent",
	["PROP_ROTATE_MATRIX"] = "matrix",

	["PROP_OUTLINE2SETTING"] = "outline2settings",
	
	["CALLBACK_MOUSEOVER"] = "callback_mouseover", -- %id = Element ID, %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_MOUSELEAVE"] = "callback_mouseleave", -- %id = Element ID, %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_MOUSEDOWN"] = "callback_mousedown", -- %id = Element ID, %b = Button(0 = left, 1 = right), %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_MOUSEMOVE"] = "callback_mousemove", -- %id = Element ID, %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_MOUSEUP"] = "callback_mouseup", -- %id = Element ID, %b = Button(0 = left, 1 = right), %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_CHECKED"] = "callback_checked", -- %id = Element ID, %value = checked (true/false)
	["CALLBACK_MOUSEMOVEANY"] = "callback_mousemoveany", -- %id = Element ID, %x = Mouse X Coord, %y = Mouse Y Coord - Called when any element has mousemove (Only called on visible elements which accept mouse input)
	["CALLBACK_RESIZED"] = "callback_resized", -- %id = Element ID. Called when an element is resized
	["CALLBACK_INDEXSET"] = "callback_indexset", -- %id = Element ID, %index = index number, %line = line content (string)
	["CALLBACK_ITEMCLICKED"] = "callback_itemclicked", -- %id = Element ID, %index = index number, %line = line content (string)
	["CALLBACK_MOUSEUPANY"] = "callback_mouseupany", -- %id = Element ID, %b = Button(0 = left, 1 = right), %x = Mouse X Coord, %y = Mouse Y Coord - Called when any element has mouseup (Only called on visible elements which accept mouse input)
	["CALLBACK_MOUSECLICK"] = "callback_mouseclick", -- %id = Element ID, %b = Button(0 = left, 1 = right), %x = Mouse X Coord, %y = Mouse Y Coord
	["CALLBACK_MOUSEDBLCLICK"] = "callback_mousedblclick", -- %id = Element ID, %b = Button(0 = left, 1 = right), %x = Mouse X Coord, %y = Mouse Y Coord <Note: CALLBACK_MOUSECLICK will be called once before this fires>
	["CALLBACK_KEYDOWN"] = "callback_keydown", -- %id = Element ID, %k = Virtual Key Code
	["CALLBACK_KEYUP"] = "callback_keyup", -- %id = Element ID, %k = Virtual Key Code
	["CALLBACK_KEYPRESS"] = "callback_keypress", -- %id = Element ID, %k = Virtual Key Code
	["CALLBACK_PROGRESS"] = "callback_progress", -- TYPE_PROGRESSBAR -- %id = Element ID, %p = progress value

	["CALLBACK_ITEMADDED"] = "callback_itemadded",        -- TYPE_ITEMADDED      -- %id = Element ID, %rowid = Row Element ID, %index = row index, %data = LUA Table
	["CALLBACK_ITEMDELETED"] = "callback_itemdeleted",    -- TYPE_ITEMDELETED    -- %id = Element ID, %index = row index
	["CALLBACK_ITEMUPDATED"] = "callback_itemupdated",    -- TYPE_ITEMUPDATED    -- %id = Element ID, %rowid = Row Element ID, %index = row index, %data = LUA Table
	["CALLBACK_ITEMSELECTED"] = "callback_itemselected",   -- TYPE_ITEMSELECTED   -- %id = Element ID, %rowid = Row Element ID, %index = row index, %data = LUA Table
	["CALLBACK_ITEMUNSELECTED"] = "callback_itemunselected", -- TYPE_ITEMUNSELECTED -- %id = Element ID, %rowid = Row Element ID, %index = row index, %data = LUA Table

	["CALLBACK_ANIMEND"] = "callback_animend", -- %id = Element ID
	["CALLBACK_DISABLED"] = "callback_disabled", -- %id = Element ID
	["CALLBACK_HIDDEN"] = "callback_hidden", -- %id = Element ID

	["CALLBACK_MOUSEWHEEL"] = "callback_mousewheel", -- %id = Element ID, %delta = amount moved. delta/120 means 1 movement, %x = Mouse X Coord, %y = Mouse Y Coord

	["CALLBACK_VISIBILITY"] = "callback_visibility", -- %id = Element ID, %vis = True/False if visible

}



FUN_CALL.TEXT_CALLBACK = {
[CALLBACK_MOUSEOVER] = "eReg:get(%id):FUN_mouseover",
[CALLBACK_MOUSELEAVE] = "eReg:get(%id):FUN_mouseleave(%x,%y)", -- function(self, x, y), Mouse X Coord, Mouse Y Coord
[CALLBACK_MOUSEDOWN] = "eReg:get(%id):FUN_mousedown(%b,%x,%y)", -- function(self, button, x, y) Button(0 = left, 1 = right), Mouse X Coord,  Mouse Y Coord
[CALLBACK_MOUSEMOVE] = "eReg:get(%id):FUN_mousemove(%x,%y)", -- function(self, x, y), Mouse X Coord, Mouse Y Coord
[CALLBACK_MOUSEUP] = "eReg:get(%id):FUN_mouseup(%b,%x,%y)", -- function(self, button, x, y) Element ID, Button(0 = left, 1 = right), Mouse X Coord,  Mouse Y Coord
[CALLBACK_CHECKED] = "eReg:get(%id):FUN_checked",
[CALLBACK_MOUSEMOVEANY] = "eReg:get(%id):FUN_mousemoveany",
[CALLBACK_RESIZED] = "eReg:get(%id):FUN_resized",
[CALLBACK_INDEXSET] = "eReg:get(%id):FUN_indexset",
[CALLBACK_MOUSEUPANY] = "eReg:get(%id):FUN_mouseupany",
[CALLBACK_MOUSECLICK] = "eReg:get(%id):FUN_mouseclick(%b,%x,%y)",-- function(self, button, x, y) -- Button(0 = left, 1 = right), Mouse X Coord, Mouse Y Coord)
[CALLBACK_KEYDOWN] = "eReg:get(%id):FUN_keydown",
[CALLBACK_KEYUP] = "eReg:get(%id):FUN_keyup",
[CALLBACK_PROGRESS] = "eReg:get(%id):FUN_progress",
[CALLBACK_ITEMADDED] = "eReg:get(%id):FUN_itemadded",
[CALLBACK_ITEMDELETED] = "eReg:get(%id):FUN_itemdeleted",
[CALLBACK_ITEMUPDATED] = "eReg:get(%id):FUN_itemupdated",
[CALLBACK_ITEMSELECTED] = "eReg:get(%id):FUN_itemselected",
[CALLBACK_ITEMUNSELECTED] = "eReg:get(%id):FUN_itemunselected",
[CALLBACK_ANIMEND] = "eReg:get(%id):FUN_animend",
[CALLBACK_DISABLED] = "eReg:get(%id):FUN_disabled",
[CALLBACK_HIDDEN] = "eReg:get(%id):FUN_hidden",
[CALLBACK_MOUSEDBLCLICK] = "eReg:get(%id):FUN_mousedblclick",
[CALLBACK_ITEMCLICKED] = "eReg:get(%id):FUN_itemclicked",
[CALLBACK_KEYPRESS] = "eReg:get(%id):FUN_keypress",
[CALLBACK_MOUSEWHEEL] = "eReg:get(%id):FUN_mousewheel",
[CALLBACK_VISIBILITY] = "eReg:get(%id):FUN_visibility",
}

FUN_CALL.CallbackToProp = {
[CALLBACK_MOUSEOVER] = "FUN_mouseover",
[CALLBACK_MOUSELEAVE] = "FUN_mouseleave",
[CALLBACK_MOUSEDOWN] = "FUN_mousedown",
[CALLBACK_MOUSEMOVE] = "FUN_mousemove",
[CALLBACK_MOUSEUP] = "FUN_mouseup",
[CALLBACK_CHECKED] = "FUN_checked",
[CALLBACK_MOUSEMOVEANY] = "FUN_mousemoveany",
[CALLBACK_RESIZED] = "FUN_resized",
[CALLBACK_INDEXSET] = "FUN_indexset",
[CALLBACK_MOUSEUPANY] = "FUN_mouseupany",
[CALLBACK_MOUSECLICK] = "FUN_mouseclick",
[CALLBACK_KEYDOWN] = "FUN_keydown",
[CALLBACK_KEYUP] = "FUN_keyup",
[CALLBACK_PROGRESS] = "FUN_progress",
[CALLBACK_ITEMADDED] = "FUN_itemadded",
[CALLBACK_ITEMDELETED] = "FUN_itemdeleted",
[CALLBACK_ITEMUPDATED] = "FUN_itemupdated",
[CALLBACK_ITEMSELECTED] = "FUN_itemselected",
[CALLBACK_ITEMUNSELECTED] = "FUN_itemunselected",
[CALLBACK_ANIMEND] = "FUN_animend",
[CALLBACK_DISABLED] = "FUN_disabled",
[CALLBACK_HIDDEN] = "FUN_hidden",
[CALLBACK_MOUSEDBLCLICK] = "FUN_mousedblclick",
[CALLBACK_ITEMCLICKED] = "FUN_itemclicked",
[CALLBACK_KEYPRESS] = "FUN_keypress",
[CALLBACK_MOUSEWHEEL] = "FUN_mousewheel",
[CALLBACK_VISIBILITY] = "FUN_visibility",
}

function FUN_CALL.concatFunct(a, b) 
  return function(...) a(...); b(...); end 
end;

function FUN_CALL.registerCallback(ELEMENT,callback_type, callback_function ) --assuems to have recieved the same element as in eReg
	local translatedCallbackName = FUN_CALL.CallbackToProp[callback_type];
	if(ELEMENT[translatedCallbackName] ~= nil) then --need to concat, don't need to init
		ELEMENT[translatedCallbackName] = FUN_CALL.concatFunct(ELEMENT[translatedCallbackName], callback_function);
	else
		ELEMENT[translatedCallbackName] = callback_function;
		set_Callback(ELEMENT.ID,callback_type, get_Callback(ELEMENT.ID,callback_type) .. FUN_CALL.TEXT_CALLBACK[callback_type] );
	end;
end;
--FUN_CALL.invloke(ID, )



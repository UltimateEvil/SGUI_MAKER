--[[DEV_WINDOW = getBlankElementEX(nil,anchorTRB,{

} )
setXYWH(DEV_WINDOW,XYWH(LayoutWidth-250,0,250,LayoutHeight));
startHeight = 20;

getLabelEX(DEV_WINDOW,anchorXYWH,XYWH(0,0,100,12),Tahoma_12,"PROPS:",{});

for k,v in pairs(PROP_TO_ID) do
	local name = k:sub(6);
	DEV_WINDOW[k .."_ROW"] = getElementEX(DEV_WINDOW,anchorXYWH,XYWH(0,startHeight,DEV_WINDOW.width,14),true,{});
	local row = DEV_WINDOW[k .."_ROW"];
	row["LABEL"] = getLabelEX(row,anchorXYWH,XYWH(0,0,170,12),Tahoma_12,name.."("..tostring(v)..")",{
		font_colour = BLACK();
	});
	if(PROPID_TO_TARGET[v] == "boolean") then
		row["INPUT"] = getCheckBoxEX(row,anchorXYWH,XYWH(170,0,20,14),'A','B',{
			colour1 = BLACK();
		});
	end;
	startHeight = startHeight+14;
end;
]]

function FROMOW_CLICKTEST(DATA)
	SGUI_ENABLE_CLICKTEST(false);
	MAKER.endSelection();
	MAKER.lastClicked = DATA;
	MAKER.highlightSelected();
end;

function MAKER.highlightSelected()
	ELEM = eReg:get(MAKER.ensureID(MAKER.lastClicked));
	MAKER.selectedParent = nil;
	if(ELEM.parent ~= nil) then
		MAKER.selectedParent = MAKER.makeHighlightRect(nil, ELEM.parent, false, RGBA(0,255,127,255));
	end;
	MAKER.selectedElement = MAKER.makeHighlightRect(MAKER.selectedParent, ELEM, true);
	
end;

function MAKER.makeHighlightRect(parent, ELEM, movable, colour)
	colour = colour or RGBA(255,255,0,255);
	local borderSize = 2;
	local xywh = XYWH(getAbsX(ELEM)-borderSize,getAbsY(ELEM)-borderSize,getWidth(ELEM) + borderSize*2,getHeight(ELEM) + borderSize*2);
	if(parent) then
		xywh.X = getX(ELEM);
		xywh.Y = getY(ELEM);
	end;
	local RECT = getElementEX(parent,anchorNone,xywh,true,{
		colour1 = BLACKA(0),
		border_colour = colour,
		border_type = BORDER_TYPE_INNER,
		border_size = borderSize,
		REF_ELEM = ELEM
	});
	--FUN_CALL.registerCallback(RECT, CALLBACK_MOUSECLICK, function(self, button, x, y) DEBUGLOG(button, x, y) end);
	if(movable) then
		local moveFunct = function(self, x, y) 
			if(MAKER.moving) then
				local xDiff = -( MAKER.moveStartXY.X-x );
				local yDiff = -( MAKER.moveStartXY.Y-y );
				MAKER.updateProp(self.REF_ELEM.ID, PROP_X, xDiff);
				MAKER.updateProp(self.REF_ELEM.ID, PROP_Y, yDiff);
				MAKER.updateProp(self.ID, PROP_X, xDiff);
				MAKER.updateProp(self.ID, PROP_Y, yDiff);
			end;
		end
	
		FUN_CALL.registerCallback(RECT, CALLBACK_MOUSEDOWN, function(self, button, x, y) 
			if(button == 0) then
				MAKER.moving = true
				MAKER.moveStartXY = {X = x, Y = y}
				MAKER.moveStartAbsXY = {X = x, Y = y}
				
			end;
		end);
		FUN_CALL.registerCallback(RECT, CALLBACK_MOUSEUP, function(self, button, x, y) 
			if(button == 0) then
				MAKER.moving = false
			end;
		end);
		FUN_CALL.registerCallback(RECT, CALLBACK_MOUSEMOVE, moveFunct);
		--FUN_CALL.registerCallback(RECT, CALLBACK_MOUSELEAVE, moveFunct);
		
	end;
	
	return RECT;
end;

function MAKER.endSelection()
	if(MAKER.selectedParent) then
		sgui_delete(MAKER.selectedParent.ID);
	end;
	if(MAKER.selectedElement) then
		sgui_delete(MAKER.selectedElement.ID);
	end;
end;

function MAKER.updateProp(ID, prop, diff)
	sgui_set(ID,prop,sgui_get(ID,prop)+diff )
end;


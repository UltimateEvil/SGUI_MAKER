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
	local parent = 	MAKER.selectedParent;
	local son = MAKER.selectedElement;
	MAKER.endSelection();
	if(DATA.ID ~= desktop and (not son or DATA.ID ~= son.ID ) and (not parent or parent.ID ~= DATA.ID ) ) then
		MAKER.lastClicked = DATA;
		MAKER.highlightSelected();
	end;
end;

function MAKER.highlightSelected()
	ELEM = eReg:get(MAKER.ensureID(MAKER.lastClicked));
	MAKER.selectedParent = nil;
	if(ELEM.parent ~= nil) then
		MAKER.selectedParent = MAKER.makeHighlightRect(nil, ELEM.parent, false, RGBA(0,255,127,255));
	end;
	MAKER.selectedElement = MAKER.makeHighlightRect(nil, ELEM, true);
	
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
		MAKER.makeDragable(RECT);
	end;
	
	return RECT;
end;

function MAKER.endSelection()
	if(MAKER.selectedParent) then
		sgui_delete(MAKER.selectedParent.ID);
	end;
	if(MAKER.selectedElement) then--parent deletes child automatically
		sgui_delete(MAKER.selectedElement.ID);
	end;
	MAKER.selectedParent = nil;
	MAKER.selectedElement = nil;
end;

MAKER.mousemoveListeners = {};

function MAKER.updateProp(ID, prop, diff)
	sgui_set(ID,prop,sgui_get(ID,prop)+diff )
end;
--[[
function MAKER.updateCallback(ID, callback_type, txt)
	set_Callback(ID,callback_type, get_Callback(ID,callback_type) ..txt );
end;
]]--

function MAKER.makeDragable(ELEM)
	FUN_CALL.registerCallback(ELEM, CALLBACK_MOUSEDOWN, function(self, button, x, y) 
		if(button == 0) then
			MAKER.beginTransaction(ELEM.REF_ELEM);
			local currentXY = {X = getX(self), Y= getY(self)}
			local lastKnownXY = {X = x + currentXY.X, Y = y + currentXY.Y};
			local isBorder = MAKER.getBorders(ELEM, x, y);
			local onMove = function(self, xDiff, yDiff)
				MAKER.updateProp(self.REF_ELEM.ID, PROP_X, xDiff); --if used elsewhere, make this a functionn param
				MAKER.updateProp(self.REF_ELEM.ID, PROP_Y, yDiff);
				MAKER.updateProp(self.ID, PROP_X, xDiff);
				MAKER.updateProp(self.ID, PROP_Y, yDiff);
			end;
			local onMoveArr = {};
			
			local currentWidth = getWidth(self);
			local widthChange = function (self, xDiff, yDiff) 
				currentWidth = currentWidth + xDiff;
				if(currentWidth < self.border_size *2) then
					currentWidth = self.border_size *2;
				end;
				setWidth(self, currentWidth);
				setWidth(self.REF_ELEM, currentWidth - self.border_size *2);
			end;
			
			if(isBorder.vertical == 1) then--move left/right side
				onMoveArr[widthChange] = true;
			elseif(isBorder.vertical == -1) then
				local currentX = getX(self);
				local refX = getX(self.REF_ELEM);
				local maxX = currentX + currentWidth;
				local Xchange = function (self, xDiff, yDiff) 
					if(currentX + xDiff > maxX) then
						xDiff = maxX - currentX ;
					end;
					currentX = currentX + xDiff;
					refX = refX + xDiff;
					setX(self, currentX);
					setX(self.REF_ELEM, refX);
					widthChange(self, -xDiff, yDiff);
				end;
				onMoveArr[Xchange] = true;
			end;
			
			local currentHeight = getHeight(self);
			local heightChange = function (self, xDiff, yDiff) 
				currentHeight = currentHeight + yDiff;
				if(currentHeight < self.border_size *2) then
					currentHeight = self.border_size *2;
				end;
				setHeight(self, currentHeight);
				setHeight(self.REF_ELEM, currentHeight - self.border_size *2);
			end;
			if(isBorder.horizontal == 1) then--move left/right side
				onMoveArr[heightChange] = true;
			elseif(isBorder.horizontal == -1) then
				local currentY = getY(self);
				local refY = getY(self.REF_ELEM);
				local maxY = currentY + currentHeight;
				local Ychange = function (self, xDiff, yDiff) 
					if(currentY + yDiff > maxY) then
						yDiff = maxY - currentY ;
					end;
					currentY = currentY + yDiff;
					refY = refY + yDiff;
					setY(self, currentY);
					setY(self.REF_ELEM, refY);
					heightChange(self, xDiff, -yDiff);
				end;
				onMoveArr[Ychange] = true;
			end;
			
			if(not table.empty(onMoveArr)) then
				onMove = function(...)
					for k in pairs(onMoveArr) do
						k(...);
					end;
				end;
			end;
			
			
			FUN_CALL.registerCallback(self, CALLBACK_MOUSEMOVEANY, function (self, x,y) 
				local newXY = {X = getX(self) + x, Y = getY(self) + y}; --already absloute in the scope
			
				local xDiff = -( lastKnownXY.X-newXY.X );
				local yDiff = -( lastKnownXY.Y-newXY.Y );
				lastKnownXY = newXY;
				onMove(self, xDiff, yDiff);
			end);
			FUN_CALL.registerCallback(self, CALLBACK_MOUSEUPANY, function(self, button, x, y) 
				if(button == 0) then
					MAKER.commitTransaction(ELEM.REF_ELEM);
					FUN_CALL.cancelCallback(self,CALLBACK_MOUSEMOVEANY); --if needed update this to remove it
					FUN_CALL.cancelCallback(self,CALLBACK_MOUSEUPANY);
				end
			end);
		end;
	end);
end;


function MAKER.getBorders(ELEM, x, y)
	local currWidth = getWidth(ELEM);
	local currHeight = getHeight(ELEM);

	local borderWidth = 8;
	local isBorder = {vertical = 0, horizontal = 0}
	if(x < borderWidth) then
		isBorder.vertical = -1;
	elseif(x + borderWidth > currWidth ) then
		isBorder.vertical = 1;
	end;
	if(y < borderWidth) then
		isBorder.horizontal = -1;
	elseif(y + borderWidth > currHeight ) then
		isBorder.horizontal = 1;
	end;
	return isBorder;
end;

MAKER.HIGHLIGHTER_IDENTIFYING_KEY = {}; -- a unique way to check if a given element is a wrapper. Ez.
MAKER.SWITCH_SELECTION_ON_WRAPPER = true;
MAKER.HIGHLIGHT_PARENT = true;
MAKER.HIGHLIGHT_CHILDREN = false;
MAKER.HIGHLIGHTER_BORDER_SIZE = 3;

function MAKER.switchSelectionContext(ID)
	local target = ID;
	if(type(target) ~= "table") then
		target = eReg:get(ID);
	end
	if(MAKER.IS_SELECTOR(target)) then
		MAKER.switchSelectionContext(target.REF_ELEM)
		return;
	end;
	
	if(MAKER.selectedElem == target) then--we are trying to re-select self, assume we want to cancel
		MAKER.endSelection();
		return;
	end;
	
	MAKER.selectedElem = target;
	MAKER.highlightSelected();
	
end;

function MAKER.redrawSelection()
	MAKER.endSelection();
	MAKER.highlightSelected();
end;


function MAKER.highlightSelected()
	MAKER.endSelection(); --too lazy to check for diffs or moving elements around;
	if(MAKER.HIGHLIGHT_PARENT and MAKER.selectedElem.parent ~= nil) then
		MAKER.makeHighlightRect(nil, MAKER.selectedElem.parent, false, RGBA(0,255,127,255));
	end;
	MAKER.selectedWrapper = MAKER.makeHighlightRect(nil, MAKER.selectedElem, true);
	if( MAKER.HIGHLIGHT_CHILDREN) then
		MAKER.selectedWrapper.REF_CACHE = MAKER.createMakerElementCache(MAKER.selectedElem);
		local ids = MAKER.selectedWrapper.REF_CACHE["PROP_CHILDIDS"];
		if(ids) then
			for k,v in pairs(ids) do
				MAKER.makeHighlightRect(nil, eReg:get(v), false, RGBA(127,127,127,255));
			end;
			MAKER.orderedCurrentSelectors[#MAKER.orderedCurrentSelectors+1] = MAKER.selectedWrapper;
		end;		
	end;
end;


function MAKER.endSelection()
	for k,v in pairs(MAKER.orderedCurrentSelectors) do
		sgui_delete(v.ID);
	end;
	MAKER.orderedCurrentSelectors = {};
	MAKER.selectedWrapper = nil;
end;


--order in which they should be layered
--nr => selector
MAKER.orderedCurrentSelectors = {};

function MAKER.makeHighlightRect(parent, ELEM, movable, colour)
	colour = colour or RGBA(255,255,0,255);
	local borderSize = MAKER.HIGHLIGHTER_BORDER_SIZE;
	local xywh = XYWH(0,0,getWidth(ELEM) + borderSize*2 -3,getHeight(ELEM) + borderSize*2 -3);
	if(parent) then
		xywh.X = getX(ELEM);
		xywh.Y = getY(ELEM);
	else
		xywh.X = getAbsX(ELEM)-borderSize +1;
		xywh.Y = getAbsY(ELEM)-borderSize +1;
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
	MAKER.orderedCurrentSelectors[#MAKER.orderedCurrentSelectors +1] = RECT;
	RECT[MAKER.HIGHLIGHTER_IDENTIFYING_KEY] = true;
	return RECT;
end;

function MAKER.updateProp(ID, prop, diff)
	sgui_set(ID,prop,sgui_get(ID,prop)+diff )
end;



function MAKER.IS_SELECTOR(ELEM)
	return ELEM[MAKER.HIGHLIGHTER_IDENTIFYING_KEY] ~= nil;
end;

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
			if(isBorder.vertical ~= 0 or isBorder.horizontal ~= 0 ) then
				local onMoveArr = {};
				
				if(isBorder.vertical == 1) then--move left/right side
					onMoveArr[MAKER.DRAG_CHANGE_WIDTH(self)] = true;
				elseif(isBorder.vertical == -1) then
					onMoveArr[MAKER.DRAG_CHANGE_X(self)] = true;
				end;
				
				if(isBorder.horizontal == 1) then--move up/down
					onMoveArr[MAKER.DRAG_CHANGE_HEIGHT(self)] = true;
				elseif(isBorder.horizontal == -1) then
					onMoveArr[MAKER.DRAG_CHANGE_Y(self)] = true;
				end;
				
				if(not table.empty(onMoveArr)) then
					onMove = function(...)
						for k in pairs(onMoveArr) do
							k(...);
						end;
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



function MAKER.DRAG_CHANGE_WIDTH(self)
	local updateFunct = MAKER.GenericChange(self, getWidth, setWidth, self.border_size *2);
	local updateFunctRef = MAKER.GenericChange(self.REF_ELEM, getWidth, setWidth, 0);
	
	return function (self, xDiff, yDiff) 
		updateFunct(xDiff);
		updateFunctRef(xDiff);
	end;
end;

function MAKER.DRAG_CHANGE_HEIGHT(self)
	local updateFunct = MAKER.GenericChange(self, getHeight, setHeight, self.border_size *2);
	local updateFunctRef = MAKER.GenericChange(self.REF_ELEM, getHeight, setHeight, 0);
	
	return function (self, xDiff, yDiff) 
		updateFunct(yDiff);
		updateFunctRef(yDiff);
	end;
end;

function MAKER.DRAG_CHANGE_X(self)
	local maxChanges = getX(self) + getWidth(self);
	local updateFunct = MAKER.GenericChange(self, getX, setX, nil, maxChanges);
	maxChanges = getX(self.REF_ELEM) + getWidth(self.REF_ELEM); --who cares taht it is a bit more wasteful than calculating the maxwidth once. I don't for one
	local updateFunctRef = MAKER.GenericChange(self.REF_ELEM, getX, setX, nil, maxChanges);
	local updateWidth= MAKER.DRAG_CHANGE_WIDTH(self);
	
	return function (self, xDiff, yDiff)
		updateFunct(xDiff);
		updateFunctRef(xDiff);
		updateWidth(self, -xDiff, yDiff);
	end
end;

function MAKER.DRAG_CHANGE_Y(self)
	local maxChanges = getY(self) + getWidth(self);
	local updateFunct = MAKER.GenericChange(self, getY, setY, nil, maxChanges);
	maxChanges = getY(self.REF_ELEM) + getWidth(self.REF_ELEM); --who cares taht it is a bit more wasteful than calculating the maxwidth once. I don't for one
	local updateFunctRef = MAKER.GenericChange(self.REF_ELEM, getY, setY, nil, maxChanges);
	local updateHeight= MAKER.DRAG_CHANGE_HEIGHT(self);
	
	return function (self, xDiff, yDiff)
		updateFunct(yDiff);
		updateFunctRef(yDiff);
		updateHeight(self, xDiff, -yDiff);
	end
end;

function MAKER.GenericChange(self, getter, setter, lowerLimit, upperLimit) 
	local current = getter(self);
	return function (diff) 
		local lastVal = current;
		current = current + diff;
		if(lowerLimit ~= nil and current < lowerLimit) then
			current = lowerLimit;
		end;
		if(upperLimit ~= nil and current > upperLimit) then
			current = upperLimit;
		end
		if(current ~= lastVal) then
			setter(self, current);
		end;
	end;
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
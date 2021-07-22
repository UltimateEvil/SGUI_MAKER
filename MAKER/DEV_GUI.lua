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
]];

function createInteractionIcons() 
	MAKER.iconsWrapper = getElementEX(nil, anchorTR, XYWH(LayoutWidth-30,275,27,230),true,{});
	MAKER.selector = getElementEX(MAKER.iconsWrapper, anchorTL, XYWH(3,5,22,20),true,{
		colour1 = RGB(255,32,32), 
		selecting = false,
		shear = true
	});
	function MAKER.selector:check()
		setColour1(self,RGB(255,125,125));
		SGUI_ENABLE_CLICKTEST(true);
		self.selecting = true;
	end;
	function MAKER.selector:uncheck()
		setColour1(self,RGB(255,32,32));
		SGUI_ENABLE_CLICKTEST(false);
		self.selecting = false;
		for k,v in pairs(MAKER.orderedCurrentSelectors) do
			sgui_bringtofront(v.ID);
		end;
		bringToFront(MAKER.iconsWrapper)
	end;
	function MAKER.selector:swap()
		if(self.selecting) then
			self:uncheck();
		else
			self:check();
		end;
	end;
	
	FUN_CALL.registerCallback(MAKER.selector, CALLBACK_MOUSECLICK, function(self, button, x, y)
		if(button == 0) then
			self:swap();
		end;
	end);
	MAKER.selector.name = getLabelEX(MAKER.selector,anchorTL,XYWH(0,0,10,10),nil, "Se",{nomouseevent = true, font_colour = BLACK()});
	
	MAKER.dumper = getElementEX(MAKER.iconsWrapper, anchorTL, XYWH(3,30,22,20),true,{
		colour1 = RGB(125,200,32), 
		shear = true
	});
	MAKER.dumper.name = getLabelEX(MAKER.dumper,anchorTL,XYWH(0,0,10,10),nil, "Du",{nomouseevent = true, font_colour = BLACK()});
	
	FUN_CALL.registerCallback(MAKER.dumper, CALLBACK_MOUSECLICK, function(self, button, x, y)
		if(button == 0 and MAKER.selectedElem) then
			LUA_TO_DEBUGLOG( MAKER.makeCreationScript(MAKER.selectedElem));
		end;
	end);
end;

createInteractionIcons();

function FROMOW_CLICKTEST(DATA)
	SGUI_ENABLE_CLICKTEST(false);
	if(MAKER.selector) then
		MAKER.selector:uncheck();
	end;
	MAKER.switchSelectionContext(DATA.ID);
	
	if(MAKER.iconsWrapper) then
		bringToFront(MAKER.iconsWrapper);
	end;
end;


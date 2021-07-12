DEV_WINDOW = getBlankElementEX(nil,anchorTRB,{

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

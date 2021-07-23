
MAKER.ElementNameCache = {};

--to be later used to allow for naming elements
function MAKER.getname(ID)
	if(not MAKER.ElementNameCache[ID]) then
		local ELEM = eReg:get(ID);
		local parent = ELEM.parent;
		if(parent) then
			for k,v in pairs(parent) do
				--value is table, is not parent, has numeric ID and is the same table as a thing in eReg with that ID				
				if(type(k) == "string" and type(v) == "table" 
									  and k ~= "parent" 
									  and type(v.ID) == "number" 
									  and eReg:get(v.ID) == v ) then
					MAKER.ElementNameCache[v.ID] = k;
				end;
			end;
		end;
		
		if(not MAKER.ElementNameCache[ID]) then --no reference found in parent or no parent
			MAKER.ElementNameCache[ID] = "ELEMENT"..ID;
		end;
	end;
	return MAKER.ElementNameCache[ID];
end;


function MAKER.makeCreationScript(ID)
	ID = MAKER.ensureID(ID)
	local script = ""
	
	script = script .."function make_" .. MAKER.getname(ID) .."()\n" 
	script = script .. MAKER.serializeElementEX(ID) .. "\n";
	script = script .. "return ".. MAKER.getname(ID) .. ";\n";
	script = script .."end;"; 

	return script;
end;
--TODO: support special
--TODO: make own serializer which let's you serialize a variable into the table definition
--TODO: make a compact version
function MAKER.createAddElementCompliantTable(ELEM)
	local compliantELEM = {};
	local others = {};
	for k,v in pairs(ELEM) do
		if(MAKER.AddElementTranslator[k] ~= nil) then
			compliantELEM[MAKER.AddElementTranslator[k]] = v;
		else
			others[k] = v; 
		end;
	end;
	return compliantELEM, others;
end;

function MAKER.serializeElementEX(ID, PARENT)
	local ELEM = MAKER.createMakerElementCache(ID);
	MAKER.simplifyColours(ELEM);
	
	local addElem, othr = MAKER.createAddElementCompliantTable(ELEM);
	local parentName = "nil";
	local ELEM_NAME = MAKER.getname(ELEM.ID);
	local loc = "local ";
	if(PARENT ~= nil) then
		parentName = PARENT;
		ELEM_NAME = PARENT .. "." .. ELEM_NAME;
		loc = "";
	end;
	local visible = ( (addElem.visible == nil or addElem.visible) and "true" ) or "false";
	addElem.visible = nil;
	local XYWH = MAKER.extractXYWH(addElem,ELEM.type);
	XYWH = "XYWH(".. XYWH.X ..",".. XYWH.Y ..",".. XYWH.W ..",".. XYWH.H ..")";
	local anchor = MAKER.extractAnchorString(addElem,ELEM.type);
	
	
	if(ELEM.type ~= TYPE_ELEMENT) then
		addElem["type"] = { [MAKER.UNESCAPED_VARIABLE] = MAKER.ID_TO_TYPE[ELEM.type]}
	end;
	local script = loc .. ELEM_NAME .. " = " .. "getElementEX(".. parentName .."," .. anchor .."," .. XYWH .."," .. visible ..","  .. MAKER.tableSerialize(addElem) .. ");\n\n";
	
	--TODO: others
	if (ELEM.PROP_CHILDIDS ~= nil) then
		for k,v in pairs(ELEM.PROP_CHILDIDS) do
			script = script .. MAKER.serializeElementEX(v, ELEM_NAME);
		end;
	end;
	return script
end;

MAKER.COLOUR_REPLACE_CONDS = {
	{["%%r== 255 and %%g == 255 and %%b == 255 and %%a == 255"] = "WHITE()"},
	{["%%r== 255 and %%g == 255 and %%b == 255"] = "WHITEA(%%a)"},
	{["%%r== 0 and %%g == 0 and %%b == 0 and %%a == 255"] = "BLACK()"},
	{["%%r== 0 and %%g == 0 and %%b == 0"] = "BLACKA(%%a)"},
	{["%%a == 255"] = "RGB(%%r,%%g,%%b)"},
	{["true"] = "RGBA(%%r,%%g,%%b,%%a)"}
}
function MAKER.COLOUR_REPLACE_TABLE(col) 
	return {["%%r"] = col.red,["%%g"] = col.green,["%%b"] = col.blue,["%%a"] = col.alpha}
end;
function MAKER.applyReplaceTable(REPLACE_TABLE, str)
	for k,v in pairs(REPLACE_TABLE) do
		str = str:gsub('%%'..k,v);
	end;
	return str;
end; 


function MAKER.simplifyColours(ELEM)
	for k,v in pairs(ELEM) do
		if(MAKER.PROP_TYPE[k] == "colour") then
			v.red = math.floor(v.red *100)/100;
			v.green = math.floor(v.green *100)/100;
			v.blue = math.floor(v.blue *100)/100;
			v.alpha = math.floor(v.alpha *100)/100;
			
			local REPLACE_TABLE = MAKER.COLOUR_REPLACE_TABLE(v); 
			for key,v in pairs(MAKER.COLOUR_REPLACE_CONDS) do
				cond, res = next(v);
				if(loadstring("return " .. MAKER.applyReplaceTable(REPLACE_TABLE, cond))()) then
					ELEM[k] = {[MAKER.UNESCAPED_VARIABLE] = MAKER.applyReplaceTable(REPLACE_TABLE, res)};
					break;
				end;
			end;
		end;
	end;
end;


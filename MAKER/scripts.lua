
function MAKER.createMakerElementCache(ID)
	ID = MAKER.ensureID(ID)
	local ELEM = {};
	ELEM.ID = ID;
	for k, v in pairs(MAKER.PROP_TO_ID) do
		ELEM[k] = sgui_get(ID,v);
	end;
	ELEM.type = MAKER.getElemType(ID);
	ELEM.parent = MAKER.getParent(ID);
	ELEM.special = MAKER.getSpecial(ID);
	
	MAKER.trimElemDefaults(ELEM);
	
	for k, v in pairs(MAKER.CALLBACK_TO_ID) do
		local callback = sgui_getcallback(ID,v);
		if(callback ~= "") then
			ELEM[k] = callback;
		end;
	end;
	
	return ELEM;
end;

function MAKER.trimElemDefaults(ELEM)
	if(ELEM.type == nil) then
		return ELEM;
	end;
	local defaults = MAKER.TYPE_DEFAULTS[ELEM.type];
	if (defaults == nil) then
		error("Unknown type of element")
		return ELEM;
	end;
	for k,v in pairs(defaults) do
		if(MAKER.recursiveCompare(ELEM[MAKER.ID_TO_PROP[k]],v)) then
			ELEM[MAKER.ID_TO_PROP[k]] = nil;
		end;
	end;
	return ELEM;
end;

function MAKER.makeCreationScript(ID)
	ID = MAKER.ensureID(ID)
	local script = ""
	
	script = script .."function make" .. ID .."()\n" 
	script = script .. MAKER.serializeElementEX(ID) .. "\n";
	script = script .. "return ELEMENT".. ID .. ";\n";
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
	local addElem, othr = MAKER.createAddElementCompliantTable(ELEM);
	local parentName = "nil";
	if(PARENT ~= nil) then
		parentName = PARENT;
	end;
	local ELEM_NAME = "ELEMENT"..ELEM.ID;
	local visible = ( (addElem.visible == nil or addElem.visible) and "true" ) or "false";
	addElem.visible = nil;
	local XYWH = MAKER.extractXYWH(addElem,ELEM.type);
	XYWH = "XYWH(".. XYWH.X ..",".. XYWH.Y ..",".. XYWH.W ..",".. XYWH.H ..")";
	local anchor = MAKER.extractAnchorString(addElem,ELEM.type);
	
	local script = "local " .. ELEM_NAME .. " = " .. serializeTable(addElem) .. ";\n";
	if(ELEM.type ~= TYPE_ELEMENT) then
		script = script .. 	ELEM_NAME .. ".type = " .. MAKER.ID_TO_TYPE[ELEM.type] .. "; \n";
	end;
	
	script = script .. ELEM_NAME .. " = " .. "getElementEX(".. parentName .."," .. anchor .."," .. XYWH .."," .. visible ..","  .. ELEM_NAME .. ");\n";
	
	--TODO: others
	if (ELEM.PROP_CHILDIDS ~= nil) then
		for k,v in pairs(ELEM.PROP_CHILDIDS) do
			script = script .. MAKER.serializeElementEX(v, ELEM_NAME);
		end;
	end;
	return script
end;


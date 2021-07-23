
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


MAKER.UNESCAPED_VARIABLE ={};


function MAKER.recursiveCompare(a,b) 
	local typeA = type(a);
	local typeB = type(b);
	if(typeA ~= typeB) then
		return false;
	end;
	if(typeA ~= "table") then
		return a == b;
	end;
	
	local visited = {};
	
	for k,v in pairs(a) do
		if(not MAKER.recursiveCompare(v,b[k])) then
			return false;
		end;
		visited[k] = true;
	end;
	
	for k,v in pairs(b) do
		if(not visited[k]) then
			return false;
		end;
	end;
	
    return true;
end;
--[[
SGUI does not give any API for these
]]
function MAKER.getElemType(ID)
	local ELEM = eReg:get(ID);
	if(ELEM) then
		return ELEM.type;
	end;
	return nil
end;
function MAKER.getParent(ID)
	local ELEM = eReg:get(ID);
	if(ELEM) then
		return ELEM.parent;
	end;
	return nil
end;
function MAKER.getSpecial(ID)
	local ELEM = eReg:get(ID);
	if(ELEM) then
		return ELEM.special;
	end;
	return nil
end;

function MAKER.makeTranslation(values)
	local PROP_TO_ID = {};
	local ID_TO_PROP = {};
	for key,prop in pairs(values) do
		local id = loadstring('return ' .. prop)();
		PROP_TO_ID[prop] = id;
		ID_TO_PROP[id] = prop;
	end;
	return PROP_TO_ID, ID_TO_PROP;
end;

function MAKER.ensureID(ID)
	if( type(ID) == "table") then
		return ID.ID;
	end;
	return ID;
end;

function MAKER.extractXYWH(ELEM,typ) 
	local x,y,w,h;
	local defaults = MAKER.TYPE_DEFAULTS[typ];
	x = defaults[PROP_X];
	y = defaults[PROP_Y];
	w = defaults[PROP_W];
	h = defaults[PROP_H];
	if(ELEM.x ~= nil) then
		x = ELEM.x;
	end;
	if(ELEM.y ~= nil) then
		y = ELEM.y;
	end;
	if(ELEM.width ~= nil) then
		w = ELEM.width;
	end;
	if(ELEM.height ~= nil) then
		h = ELEM.height;
	end;
	
	ELEM.x = nil;
	ELEM.y = nil;
	ELEM.width = nil;
	ELEM.height = nil;
	
	
	return XYWH(x,y,w,h);
	
end;


function MAKER.extractAnchorString(ELEM,typ);
	local anchor = ELEM.anchor;
	ELEM.anchor = nil;
	if(anchor == nil) then
		anchor = MAKER.TYPE_DEFAULTS[typ][PROP_ANCHOR];
	end;
	--LTRB/none
	if(anchor.L == nil and anchor.T == nil and anchor.R == nil and anchor.B == nil) then
		return "anchorNone";
	end;
	local res = "anchor";
	if(anchor.L) then
		res = res .. "L";
	end;
	if(anchor.T) then
		res = res .. "T";
	end;
	if(anchor.R) then
		res = res .. "R";
	end;
	if(anchor.B) then
		res = res .. "B";
	end;
	return res;
end;

function MAKER.tableSerialize( val, compact, depth)

    compact = compact or false;
    depth = depth or 0;
	local padding = string.rep("  ", depth);
	local newline = "\n"
	
	if(compact) then
		padding = "";
		newline = "";
	end;
	
	local typ = type(val);
    if typ == "table" then
		local size0 = true;
		local size1 = false;
		for k,v in pairs(val) do
			if(size1) then
				size1 = false;
				break;
			end;
			size0 = false;
			size1 = true;
		end;
		local res = padding .. "{";
		if(size0) then
			return "{}";
		end;
		if(size1) then
			for k, v in pairs(val) do			
				if(k == MAKER.UNESCAPED_VARIABLE) then
					return v;
				end;
			end;
		else
			res = res.. newline ;
		end;
		
		for k, v in pairs(val) do
			local key = '[' ..  MAKER.tableSerialize(k,compact,depth+1) .. ']';
			local value = MAKER.tableSerialize(v,compact,depth+1);
			res = res .. padding ..key.. '='.. value .. ",";
			if(next(val, k) ~= nil) then
				res = res.. newline ;
			end;
		end;
		
		res = res .. padding .. "}" 
		return res;
    elseif typ == "number" then
        return tostring(val);
    elseif typ == "string" then
		return string.format("%q", val);
    elseif typ == "boolean" then
        return (val and "true" or "false");
    end;
	
end;
--to be later used to allow for naming elements
function MAKER.getname(ID)
	return "ELEMENT"..ID;
end;

function MAKER.reloadFromCache(CACHE)

	for k,v in pairs(CACHE) do
		if(MAKER.PROP_TO_ID[k] ~= nil) then
			saver = MAKER.TYPE_SAVER[MAKER.PROP_TYPE[k]];
			saver = saver or MAKER.TYPE_SAVER["default"];
			saver(ID,MAKER.PROP_TO_ID[k],v);
		end;
	end;

end;





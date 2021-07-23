--[[
To make it easy to use this mod ain any other mod, I shall put all the init in here, that will make including it just a matter of copying one folder and adding one include.
]]


MAKER = {};
FUN_CALL = {};

--only for debugu, but
--classic funcks stuff up otherwise
function dump(...)
	local res = '';
	for i=1,select('#',...) do
		res = res .. wrappedDump(select(i,...), 0) .. "\n";
	end;
	return res;
end;
include('MAKER/makerUtils');
include('MAKER/functonalCallbacks');
include('MAKER/editTransactions');


include('MAKER/extracted_config');
include('MAKER/scripts');
include('MAKER/dumper');

include('MAKER/selectors');
include('MAKER/DEV_GUI');

--LUA_TO_DEBUGLOG(MAKER.makeCreationScript(menu.window_options));


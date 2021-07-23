MAKER.runningTransactions = {};
MAKER.transactionHistory = {};
MAKER.transactionPtr = 0;
--TODO: change the implementation a bit to get the diff of before-after not everything
function MAKER.beginTransaction(ELEM)
	local ID = MAKER.ensureID(ELEM);
	if(MAKER.runningTransactions[ID]) then
		MAKER.commitTransaction(ID);
	end;
	MAKER.runningTransactions[ID] = {undo = MAKER.createMakerElementCache(ID, true)};
end;

function MAKER.finalizeDiff(unredo) 
	local before = unredo.undo;
	local after = unredo.redo;
	unredo.undo = MAKER.tableDiff(before,after);
	unredo.redo = MAKER.tableDiff(after,before);
end;

function MAKER.commitTransaction(ELEM)
	local ID = MAKER.ensureID(ELEM);
	if(not MAKER.runningTransactions[ID]) then
		return;
	end;
	if(#MAKER.transactionHistory > MAKER.transactionPtr) then
		for i = MAKER.transactionPtr, #MAKER.transactionHistory, 1 do
			MAKER.transactionHistory[i] = nil;
		end;
	end;
	
	MAKER.runningTransactions[ID].redo = MAKER.createMakerElementCache(ID,true);
	MAKER.finalizeDiff(MAKER.runningTransactions[ID]);
	
	MAKER.transactionPtr = MAKER.transactionPtr +1
	MAKER.transactionHistory[MAKER.transactionPtr] = MAKER.runningTransactions[ID];
	MAKER.runningTransactions[ID] = nil;
end;

function MAKER.rollbackTransaction(ELEM)
	local ID = MAKER.ensureID(ELEM);
	if(not MAKER.runningTransactions[ID]) then
		return;
	end;
	MAKER.endSelection();
	
	MAKER.runningTransactions[ID].redo = MAKER.createMakerElementCache(ID,true);
	MAKER.finalizeDiff(MAKER.runningTransactions[ID]);
	MAKER.reloadFromCache(MAKER.runningTransactions[ID].undo);
	MAKER.runningTransactions[ID] = nil;
end;

function MAKER.revertLastTransaction()
	if(#MAKER.transactionHistory == 0 or MAKER.transactionPtr == 0) then
		return;
	end
	MAKER.endSelection();
	
	for k,v in pairs(MAKER.runningTransactions) do
		MAKER.rollbackTransaction(k);
	end;
	
	MAKER.reloadFromCache(MAKER.transactionHistory[MAKER.transactionPtr].undo);
	MAKER.transactionPtr = MAKER.transactionPtr - 1;
end;

function MAKER.reapplyNextTransaction()
	if(MAKER.transactionPtr >= #MAKER.transactionHistory) then
		return;
	end
	MAKER.endSelection();
	
	MAKER.transactionPtr = MAKER.transactionPtr +1;
	MAKER.reloadFromCache(MAKER.transactionHistory[MAKER.transactionPtr].redo);
end;

function MAKER.reloadFromCache(CACHE)
	for k,v in pairs(CACHE) do
		if(MAKER.PROP_TO_ID[k] ~= nil and not MAKER.READONLY[k]) then
			saver = MAKER.TYPE_SAVER[MAKER.PROP_TYPE[k]];
			saver = saver or MAKER.TYPE_SAVER["default"];
			saver(CACHE.ID,MAKER.PROP_TO_ID[k],v);
		end;
	end;

end;
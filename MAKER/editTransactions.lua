MAKER.runningTransactions = {};
MAKER.transactionHistory = {};

function MAKER.beginTransaction(ELEM)
	ID = MAKER.ensureID(ELEM);
	if(MAKER.runningTransactions[ID]) then
		MAKER.commitTransaction(ID);
	end;
	MAKER.runningTransactions[ID] = MAKER.createMakerElementCache(ID);
end;

function MAKER.commitTransaction(ELEM)
	ID = MAKER.ensureID(ELEM);
	if(not MAKER.runningTransactions[ID]) then
		return;
	end;
	MAKER.transactionHistory[#MAKER.transactionHistory+1] = MAKER.runningTransactions[ID];
	MAKER.runningTransactions[ID] = nil;
end;

function MAKER.endTransaction(ELEM)
	ID = MAKER.ensureID(ELEM);
	MAKER.runningTransactions[ID] = nil;
end;

function MAKER.rollbackTransaction(ELEM)
	ID = MAKER.ensureID(ELEM);
	if(not MAKER.runningTransactions[ID]) then
		return;
	end;
	MAKER.reloadFromCache(MAKER.runningTransactions[ID]);
	MAKER.runningTransactions[ID] = nil;
end;

function MAKER.revertLastTransaction()
	if(#MAKER.transactionHistory == 0) then
		return;
	end
	local restore = MAKER.transactionHistory[#MAKER.transactionHistory];
	MAKER.transactionHistory[#MAKER.transactionHistory] = nil;
	MAKER.reloadFromCache(restore);
end;

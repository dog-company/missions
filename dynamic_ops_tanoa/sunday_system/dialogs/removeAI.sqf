if (!isNull (_this select 0)) then {
	_ai = (_this select 0);
	_selection = ((_this select 1) select 2);

	if (_selection == 1) then { 
		_ai hideObjectGlobal true;
		[_ai] joinSilent grpNull;
		
		ctrlEnable [(_ai getVariable "unitLoadoutIDC"), false];
		ctrlEnable [(_ai getVariable "unitArsenalIDC"), false];
		ctrlEnable [(_ai getVariable "unitReadyIDC"), false];	
		
		diag_log format ["DRO: Removed unit %1", _ai];
	};
	if (_selection == 0) then { 
		_ai hideObjectGlobal false;
		[_ai] joinSilent (group u1);
		
		ctrlEnable [(_ai getVariable "unitLoadoutIDC"), true];
		ctrlEnable [(_ai getVariable "unitArsenalIDC"), true];
		ctrlEnable [(_ai getVariable "unitReadyIDC"), true];	
		
		diag_log format ["DRO: Added unit %1", _ai];
	};
};


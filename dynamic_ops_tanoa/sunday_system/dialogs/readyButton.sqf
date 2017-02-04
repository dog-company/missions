_unit = _this select 0;
diag_log ((_this select 1) select 2);

[(format ["DRO: %1Ready status == %2", _unit, ((_this select 1) select 2)])] remoteExec ["diag_log", 2, false];
diag_log format ["DRO: %1Ready status == %2", _unit, ((_this select 1) select 2)];

switch (_unit) do {
	case u1: {		
		missionNameSpace setVariable ["u1Ready", ((_this select 1) select 2), true];		
	};
	case u2: {
		missionNameSpace setVariable ["u2Ready", ((_this select 1) select 2), true];
	};
	case u3: {
		missionNameSpace setVariable ["u3Ready", ((_this select 1) select 2), true];
	};
	case u4: {
		missionNameSpace setVariable ["u4Ready", ((_this select 1) select 2), true];
	};
	case u5: {
		missionNameSpace setVariable ["u5Ready", ((_this select 1) select 2), true];
	};
	case u6: {
		missionNameSpace setVariable ["u6Ready", ((_this select 1) select 2), true];
	};
	case u7: {
		missionNameSpace setVariable ["u7Ready", ((_this select 1) select 2), true];
	};
	case u8: {
		missionNameSpace setVariable ["u8Ready", ((_this select 1) select 2), true];
	};
};


/*
if ((_unit getVariable 'unitReady') == 0) then {	
	(_unit setVariable ['unitReady', 1, true]);	
	//[_unit] remoteExec ["dro_readyPlayer", 2, false];
	[(format ["DRO: %1 unitReady == 1", _unit])] remoteExec ["diag_log", 2, false];
	diag_log format ["DRO: %1 unitReady == 1", _unit];
} else {
	(_unit setVariable ['unitReady', 0, true]);
	//[_unit] remoteExec ["dro_unreadyPlayer", 2, false];
	[(format ["DRO: %1 unitReady == 0", _unit])] remoteExec ["diag_log", 2, false];
	diag_log format ["DRO: %1 unitReady == 0", _unit];
};
*/

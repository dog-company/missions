_unitsToDrop = _this select 0;
{
	if (isPlayer _x) then {
		diag_log format ["DRO: Attempting paradrop for unit %1", _x];
		[[_x], 'sunday_system\paraBackpack.sqf'] remoteExec ['execVM', _x, false];
	} else {
		[_x] execVM 'sunday_system\paraBackpack.sqf';
		
	};
	//sleep 0.3;
} forEach _unitsToDrop;
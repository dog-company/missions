// Apply player unit loadouts and identities

_thisUnit = _this select 0;
_return = _this select 1;

if ((player == _thisUnit) OR (!isPlayer _thisUnit)) then {

	_infCopy = (_return select 0) lbData (_return select 1);
	_thisUnit setVariable ['unitChoice', _infCopy, true];


	if (_infCopy == "CUSTOM") then {

	} else {
		
		_lbSize = (lbSize (_return select 0));
		for "_i" from 1 to _lbSize do {
			if (((_return select 0) lbData _i) == "CUSTOM") then {
				(_return select 0) lbDelete _i;
				(_return select 0) lbSetCurSel (_return select 1);
			};
		};	
		
		//_dummy = _infCopy createVehicle [0,0,0];
		
		_tempGroup = createGroup (side player);
		_dummy = _tempGroup createUnit [_infCopy, [0,0,0], [], 0, "NONE"];
		_dummy hideObjectGlobal true;
		
		_var = vehicleVarName _thisUnit;
		diag_log _thisUnit;
		_pos = getPos player;
		_dir = getDir player;
		player setVehicleVarName "";
		
		waitUntil {!isNull _dummy};	
		
		selectPlayer _dummy;
		player setPos _pos;
		player setDir _dir;
		
		diag_log player;
		deleteVehicle (missionNamespace getVariable _var);
				
		player setVehicleVarName _var;
		
		player hideObjectGlobal false;
		
		player setUnitTrait ["Medic", true];
		player setUnitTrait ["engineer", true];
		player setUnitTrait ["explosiveSpecialist", true];
		player setUnitTrait ["UAVHacker", true];
		
		deleteVehicle _dummy;

		
	};
};
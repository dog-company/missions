/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

r3_load_vehicles =
{
	if(count r3_vehObjects > 0) then {
		{ [_x] call r3_init_veh } forEach r3_vehObjects;
	} else {
		if(r3_enableDebugMode) then { diag_log "INIT VEHICLE RESPAWN FAILED ! Not Vehicles in ARRAY !"; };
	};
};

r3_init_veh = 
{
	_veh = _this select 0;
	_veh removeAllEventHandlers "HandleDamage";
	_veh addEventHandler ["HandleDamage", { if(local (_this select 0)) then { _this call r3_veh_HandleDamageEH } } ];
	
	_veh setVariable ["r3_vehIsDamaged", 0];
	_veh setVariable ["r3_vehGetRepair", 0];
	
	if(isServer) then {
		_veh setVariable ["r3_vehOrgPos", getPos _veh];
		_veh setVariable ["r3_vehOrgDir", getDir _veh];
	
		_veh addItemCargoGlobal ["ToolKit", 2];
	
		[_veh] spawn r3_veh_chkVehDamage;
	};

	if(r3_enableDebugMode) then { diag_log format ["Vehicle Init done : %1",_veh]; };
};

r3_veh_HandleDamageEH =
{
	_veh = _this select 0;
	_handleDamage = _this select 2;
	_vehIsDamaged =	_veh getVariable ["r3_vehIsDamaged", 0];

	if(r3_vehAllowRepair > 0 && _vehIsDamaged == 0) then {
		if(_handleDamage > 0 OR !canMove _veh) then { 
			_veh setVariable ["r3_vehIsDamaged", 1, true];
			
			if(!isNull player) then {
				if(player == driver _veh) then { 
					if(player getVariable ["r3_vehDriverNotice",0] == 0) then {
						[] call r3_veh_DriverNotice; 
					};
				};
			};
		};
	};
	_handleDamage
};
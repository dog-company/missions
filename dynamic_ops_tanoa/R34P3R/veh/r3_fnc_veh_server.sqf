/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(isServer) then {

	r3_veh_chkVehDamage =
	{
		_veh = _this select 0;
		waitUntil{sleep 5; damage _veh > 0.9};
		_veh setVariable ["r3_vehIsDamaged", 0, true];
		[_veh] spawn r3_veh_respawn;
	};

	r3_veh_respawn =
	{
		_veh = _this select 0;
		
		_orgName = vehicleVarName _veh;
		_orgPos = _veh getVariable ["r3_vehOrgPos", getPos _veh];
		_orgDir = _veh getVariable ["r3_vehOrgDir", getDir _veh];
		_orgType = typeOf _veh;
		_orgTex = getObjectTextures _veh;
		
		sleep r3_vehRespawnTime;
		
		_newVeh = _orgType createVehicle _orgPos;
		_newVeh setVariable ["BIS_enableRandomization", false, true];
		_newVeh setDir _orgDir;
		
		_texSel = 0;
		{
			[[_newVeh,[_texSel, _x]], "setObjectTextureMP"] call BIS_fnc_MP; 
			_texSel = _texSel +1;
		}forEach _orgTex;
		
		_newVeh animate ["HidePolice", _veh animationPhase "HidePolice"];
		_newVeh animate ["HideServices", _veh animationPhase "HideServices"];
		_newVeh animate ["HideBackpacks", _veh animationPhase "HideBackpacks"];
		_newVeh animate ["HideBumper1", _veh animationPhase "HideBumper1"];
		_newVeh animate ["HideBumper2", _veh animationPhase "HideBumper2"];
		_newVeh animate ["HideConstruction", _veh animationPhase "HideConstruction"];
		_newVeh animate ["HideDoor1", _veh animationPhase "HideDoor1"]; 
		_newVeh animate ["HideDoor2", _veh animationPhase "HideDoor2"];
		_newVeh animate ["HideDoor3", _veh animationPhase "HideDoor3"];
		_newVeh animate ["HideGlass2", _veh animationPhase "HideGlass2"];
		
		_delVar = floor(random 9999);
		_veh setVehicleVarName str(_delVar);
		missionNamespace setVariable [str(_delVar), _veh];
		publicVariable str(_delVar);
		
		if(!isNil _orgName) then {
			_newVeh setVehicleVarName _orgName;
			missionNamespace setVariable [_orgName, _newVeh];
			publicVariable _orgName;
			
			if(r3_enableRespawnSelection) then {
				if(_veh in r3_respawnPositions) then {
					_pos = r3_respawnPositions find _veh;
					r3_respawnPositions set [_pos, _newVeh];
					publicVariable "r3_respawnPositions";
				};
			};
		};		
		
		[[_newVeh], "r3_init_veh"] call BIS_fnc_MP;
		
		sleep 30;
		
		deleteVehicle ( missionNamespace getVariable str(_delVar) );
		
		if(r3_enableDebugMode) then { diag_log format ["Vehicle Respawn done : %1",_veh]; };	
	};
};
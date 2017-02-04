

_roadPosArray = _this select 0;	// Array of positions : intended to be on roads near center of AO
_target = _this select 1;		// Position array, marker name string or unit : Target destination for reinforcements
_chase = _this select 2;		// 0 - 1 int : 0 to patrol area, 1 to chase target unit
_numbers = _this select 3;		// Array of ints

_min = _numbers select 0;
_max = _numbers select 1;		

_debug = 0;

_aiSkill = "";
if (aiSkill == 0) then {_aiSkill = "Militia"};

// Convert target to center position array if not already
_targetPos = nil;
if (typeName _target == "STRING") then {
	_targetPos = getMarkerPos _target;
};
if (typeName _target == "OBJECT") then {
	_targetPos = getPos _target;
};
if (typeName _target != "OBJECT") then {
	_chase = 0;
};
if (typeName _target == "ARRAY") then {
	_targetPos = _target;
};

// Check available reinforcement types
_styles = ["INFANTRY"];

_carTransports = [];
_carNonTransports = [];
_heliTransports = [];

if (count eCarClasses > 0) then {
	{
		//diag_log format ["%1: %2", _x, ((configFile >> "CfgVehicles" >> _x >> "transportSoldier") call BIS_fnc_GetCfgData)];
		if (((configFile >> "CfgVehicles" >> _x >> "transportSoldier") call BIS_fnc_GetCfgData) >= 4) then {
			_carTransports pushBack _x;
			_styles pushBackUnique "CARTRANSPORT";
		} else {
			_carNonTransports pushBack _x;
			_styles pushBackUnique "CAR";
		};
	} forEach eCarClasses;	
};

if (count eHeliClasses > 0 && count AO_flatPositions > 0) then {
	{
		if (((configFile >> "CfgVehicles" >> _x >> "transportSoldier") call BIS_fnc_GetCfgData) >= 4) then {
		//if ((count([_x] call BIS_fnc_vehicleRoles)) >= 6) then {
			_heliTransports pushBack _x;
			_styles pushBackUnique "HELI";
		};
	} forEach eHeliClasses;
};

/*
if (count _styles == 0) then {
	_styles pushBack "INFANTRY";
};
*/

_weights = [];
{
	switch (_x) do {
		case "INFANTRY": {_weights pushBack 0.3};
		case "CARTRANSPORT": {_weights pushBack 0.6};
		case "CAR": {_weights pushBack 0.1};
		case "HELI": {_weights pushBack 0.5};
	};
} forEach _styles;

//diag_log _styles;
//diag_log _weights;

_numReinforcements = [_min, _max] call BIS_fnc_randomInt;
//_reinforceType = "INFANTRY";

for "_i" from 1 to _numReinforcements do {
			
	diag_log "DRO: Reinforcing";
	
	_reinforceType = [_styles, _weights] call BIS_fnc_selectRandomWeighted;
	if (!isNil "_reinforceType") then {
		switch (_reinforceType) do {
			case "INFANTRY": {
				// Get position data			
				_spawnPos = [_targetPos,900,1100,1,0,100,0] call BIS_fnc_findSafePos;
				
				if ((({(_spawnPos distance _x) < 600} count (units group player)) == 0)) then {
					_insertPos = nil;
					if (_chase == 0) then {
						_insertPos = [_roadPosArray] call Zen_ArrayGetRandom;
					} else {
						_insertPos = _targetPos;
					};		
					
					// Debug marker
					if (_debug == 1) then {
						hint "REINFORCING";
						_markerRB = createMarker [format ["rbMkr%1",(random 10000)], _spawnPos];
						_markerRB setMarkerShape "ICON";
						_markerRB setMarkerColor "ColorOrange";
						_markerRB setMarkerType "mil_objective";
					};
					
					// Spawn units
					_minAI = 4;
					_maxAI = 8;
					if (aiSkill == 1) then {	
						_minAI = 3;
						_maxAI = 6;
					};	
					_reinfGroup = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;				
					if (!isNil "_reinfGroup") then {
						if (_chase == 0) then {
							0 = [_reinfGroup, _targetPos, [50, 300], [0, 360], "full", "aware", false] spawn Zen_OrderInfantryPatrol;
						} else {
							if (!isNull _target) then {
								0 = [_reinfGroup, _target, [0, 100], [0, 360], "full", "aware", false] spawn Zen_OrderInfantryPatrol;	
							};
						};
						diag_log format ["REINFORCEMENT: Infantry group %1 spawned at %2",_reinfGroup, _spawnPos];
					};
				};
			};
			
			case "CARTRANSPORT": {
				// Ground type truck
				_initPos = [_targetPos,1500,2000,0,0,30,0] call BIS_fnc_findSafePos;
				_roadList = [];	
				_spawnPos = [];	
				_roadList = _initPos nearRoads 500;			
			
				if (count _roadList > 0) then {
					_thisRoad = (selectRandom _roadList);
					_spawnPos = getPos _thisRoad;				
				} else {
					_spawnPos = _initPos;
				};
				
				if ((({(_spawnPos distance _x) < 600} count (units group player)) == 0)) then {				
					// Debug marker
					if (_debug == 1) then {
						hint "REINFORCING";
						_markerRB = createMarker [format ["rbMkr%1",(random 10000)], _spawnPos];
						_markerRB setMarkerShape "ICON";
						_markerRB setMarkerColor "ColorOrange";
						_markerRB setMarkerType "mil_objective";
					};
					
					_insertPos = nil;
					if (_chase == 0) then {
						_insertPos = [_roadPosArray] call Zen_ArrayGetRandom;
					} else {
						_insertPos = _targetPos;
					};			
					
					// Spawn vehicle
					_vehType = [_carTransports, false] call Zen_ArrayGetRandom;
					_reinfVeh = [_spawnPos, _vehType] call Zen_SpawnVehicle;
					createVehicleCrew _reinfVeh;
					
					// Spawn units
					_maxUnits = ((configFile >> "CfgVehicles" >> _vehType >> "transportSoldier") call BIS_fnc_GetCfgData);
					_minAI = 4;				
					if (aiSkill == 1) then {
						_minAI = 3;	
						if (_maxUnits > 6) then {
							_maxUnits = 6;
						};	
					};
					_reinfGroup = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxUnits]] call dro_spawnGroupWeighted;				
					if (!isNil "_reinfGroup") then {
						[_reinfGroup, _reinfVeh] spawn Zen_MoveInVehicle;
						0 = [_reinfVeh, [_insertPos], _reinfGroup, "normal"] spawn Zen_OrderInsertion;
						
						if (_chase == 0) then {
							0 = [_reinfGroup, _targetPos, [50, 300], [0, 360], "normal", "combat"] spawn Zen_OrderInfantryPatrol;
						} else {
							if (!isNull _target) then {
								0 = [_reinfGroup, _target] spawn Zen_OrderInfantryPatrol;
							};
						};
						
						diag_log format ["REINFORCEMENT: Car transport group %1 spawned at %2; inserting at %3",_reinfGroup, _spawnPos, _insertPos];
					};
				};
			};	
			
			case "CAR": {
				_initPos = [_targetPos,1500,2000,0,0,30,0] call BIS_fnc_findSafePos;
				_roadList = [];	
				_spawnPos = [];	
				_roadList = _initPos nearRoads 500;			
					
				if (count _roadList > 0) then {
					_thisRoad = (selectRandom _roadList);
					_spawnPos = getPos _thisRoad;				
				} else {
					_spawnPos = _initPos;
				};
				if ((({(_spawnPos distance _x) < 600} count (units group player)) == 0)) then {				
					// Debug marker
					if (_debug == 1) then {
						hint "REINFORCING";
						_markerRB = createMarker [format ["rbMkr%1",(random 10000)], _spawnPos];
						_markerRB setMarkerShape "ICON";
						_markerRB setMarkerColor "ColorOrange";
						_markerRB setMarkerType "mil_objective";
					};
					
					_insertPos = nil;
					if (_chase == 0) then {
						_insertPos = [_roadPosArray] call Zen_ArrayGetRandom;
					} else {
						_insertPos = _targetPos;
					};			
					
					// Spawn vehicle
					_vehType = [_carNonTransports, false] call Zen_ArrayGetRandom;
					if (!isNil "_vehType") then {
						_reinfVeh = [_spawnPos, _vehType] call Zen_SpawnVehicle;
						createVehicleCrew _reinfVeh;
						0 = [_reinfVeh, _insertPos] spawn Zen_OrderVehiclePatrol;
						
						diag_log format ["REINFORCEMENT: Car attack group %1 spawned at %2; inserting at %3",_reinfVeh, _spawnPos, _insertPos];
						if (count _styles > 1) then {
							_styles = _styles - ["CAR"];
						};
					};
				};
			};
		
			case "HELI": {
				// Heli type
				_spawnPos = [_targetPos,2000,3000,0,1,100,0] call BIS_fnc_findSafePos;
				_insertPos = selectRandom AO_flatPositions;
				
				_insertTypes = ["land", "parachute"];		
				_insertType = selectRandom _insertTypes;
				_flyInHeight = 300;
				if (_insertType == "land") then {
					_flyInHeight = 40;
				} else {
					_flyInHeight = 300;
				};
				
				// Debug marker
				if (_debug == 1) then {
					hint "REINFORCING";
					_markerRB = createMarker [format ["rbMkr%1",(random 10000)], _spawnPos];
					_markerRB setMarkerShape "ICON";
					_markerRB setMarkerColor "ColorOrange";
					_markerRB setMarkerType "mil_objective";
				};
				
				// Spawn vehicle
				_vehType = [_heliTransports, false] call Zen_ArrayGetRandom;
				_reinfVeh = createVehicle [_vehType, _spawnPos, [], 0, "FLY"];
				createVehicleCrew _reinfVeh;
				
				// Spawn units
				_maxUnits = ((configFile >> "CfgVehicles" >> _vehType >> "transportSoldier") call BIS_fnc_GetCfgData);
				_minAI = 4;				
				if (aiSkill == 1) then {
					_minAI = 3;	
					if (_maxUnits > 6) then {
						_maxUnits = 6;
					};	
				};
				_reinfGroup = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxUnits]] call dro_spawnGroupWeighted;			
				if (!isNil "_reinfGroup") then {
					[_reinfGroup, _reinfVeh] spawn Zen_MoveInVehicle;			
					
					0 = [_reinfVeh, [_insertPos, _spawnPos], _reinfGroup, "normal", _flyInHeight, _insertType, true] spawn Zen_OrderInsertion;
					
					if (_chase == 0) then {
						0 = [_reinfGroup, _targetPos, [50, 300], [0, 360], "normal", "combat"] spawn Zen_OrderInfantryPatrol;
					} else {
						if (!isNull _target) then {
							0 = [_reinfGroup, _target] spawn Zen_OrderInfantryPatrol;
						};
					};		
					diag_log format ["REINFORCEMENT: Heli transport group %1 spawned at %2; inserting at %3",_reinfGroup, _spawnPos, _insertPos];
				};
			};
		};		
	};
	
	sleep ([90,120] call BIS_fnc_randomInt);
	
};


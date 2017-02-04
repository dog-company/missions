// *****
// SETUP ENEMIES
// *****

fnc_selectObjects = compile preprocessFile "sunday_system\objectsLibrary.sqf";

_debug = 0;

_numPlayers = count allPlayers;

_aiSkill = "";
if (aiSkill == 0) then {_aiSkill = "Militia"};

_cityCenter = _this select 0;
_AREAMARKER_WIDTH = _this select 1;
_markerColorEnemy = _this select 2;
_side = enemySide;
_faction = enemyFaction;

_enemyIntelMarkers = [];
enemyAlertableGroups = [];
enemySemiAlertableGroups = [];

// Roadblocks
_numRoadblocks = [2,3] call BIS_fnc_randomInt;
switch aoOptionSelect do {
	case 1: {_numRoadblocks = _numRoadblocks - 1};
	case 3: {_numRoadblocks = _numRoadblocks + 1};
};
if (aiSkill == 1) then {	
	if (_numRoadblocks > 2) then {
		_numRoadblocks = 2;
	};
};
for "_x" from 1 to _numRoadblocks do {
	if (count roadblockPosArray > 0) then {
		_roadPosition = [roadblockPosArray, true] call Zen_ArrayGetRandom; 
		
		// Get road direction
		_roadList = _roadPosition nearRoads 50;
		_thisRoad = _roadList select 0;
		_roadConnectedTo = roadsConnectedTo _thisRoad;
		if (count _roadConnectedTo == 0) exitWith {_bunker = "Land_BagBunker_Small_F" createVehicle _roadPosition;};
		_connectedRoad = _roadConnectedTo select 0;
		_direction = [_thisRoad, _connectedRoad] call BIS_fnc_DirTo;
				
		_objectLib = ["ROADBLOCKS"] call fnc_selectObjects;
		_objects = selectRandom _objectLib;
		_spawnedObjects = [_roadPosition, _direction, _objects] call BIS_fnc_ObjectsMapper;
		
		// Collect guard positions
		_guardPositions = [];		
		{
			if (typeOf _x == "Sign_Arrow_Blue_F") then {
				_spawnPos = getPos _x;
				_dir = getDir _x;				
				_guardPositions pushBack [_spawnPos, _dir];				
				deleteVehicle _x;			
			};
		} forEach _spawnedObjects;
		
		// Spawn guards at guard positions
		_leader = nil;
		_leaderChosen = 0;
		{
			_spawnPos = (_x select 0) findEmptyPosition [0,10];
			if (count _spawnPos > 0) then {			
				_guardGroup = [_spawnPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
				if (!isNil "_guardGroup") then {	
					_guardUnit = ((units _guardGroup) select 0);					
					_guardUnit setFormDir (_x select 1);
					_guardUnit setDir (_x select 1);
					
					if (_leaderChosen == 0) then {
						_leader = _guardUnit;
						_leaderChosen = 1;
					} else {
						[_guardUnit] joinSilent _leader;
						doStop _guardUnit;
					};
				};
			};
		} forEach _guardPositions;	
		
		// Create Marker
		_markerName = format["roadblockMkr%1", floor(random 10000)];
		_markerRoadblock = createMarker [_markerName, _roadPosition];			
		_markerRoadblock setMarkerShape "ICON";
		_markerRoadblock setMarkerType "hd_warning";
		_markerRoadblock setMarkerText "Checkpoint";		
		_markerRoadblock setMarkerColor _markerColorEnemy;
		_markerRoadblock setMarkerAlpha 0;
		_enemyIntelMarkers pushBack _markerRoadblock;
				
	};
};

_numBuildings = count AO_buildingPositions;

_percentToFill = 0.30;
if (_numBuildings < 9) then {_percentToFill = 0.6};

_numHousesToFill = _numBuildings * _percentToFill;

if (_numHousesToFill > 10) then {_numHousesToFill = 10};

_numHousesToFill = _numHousesToFill + (_numPlayers*2);
switch aoOptionSelect do {
	case 1: {if (_numHousesToFill > 2) then {_numHousesToFill = _numHousesToFill - 2}};
	case 3: {_numHousesToFill = _numHousesToFill + 2};
};

if (aiSkill == 1) then {
	if (_numHousesToFill > 3) then {
		_numHousesToFill = 3;
	};
};

for "_i" from 1 to _numHousesToFill do {
	
	if (count AO_buildingPositions > 0) then {
		_thisHouse = [AO_buildingPositions, true] call Zen_ArrayGetRandom;			
		_buildingPositions = [_thisHouse] call BIS_fnc_buildingPositions;
		_maxGarrison = (count _buildingPositions);
		if (_maxGarrison > 2) then {
			_maxGarrison = 2;
		};
		_totalGarrison = [0, _maxGarrison] call BIS_fnc_randomInt;
		
		_garrisonCounter = 0;
		_leader = nil;
		{
			if (_garrisonCounter <= _totalGarrison) then {
				_group = [_x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;				
				if (!isNil "_group") then {
					_unit = ((units _group) select 0);
					_unit setUnitPos "UP";
					if (_garrisonCounter == 0) then {
						_leader = _unit;
					} else {
						[_unit] joinSilent _leader;
						doStop _unit;
					};
				};
			};
			_garrisonCounter = _garrisonCounter + 1;
		} forEach _buildingPositions;
		if (!isNil "_leader") then {
			enemySemiAlertableGroups pushBack (group _leader);
		};
		if (_debug == 1) then {		
			_garMarker = createMarker [format["garMkr%1", random 10000], getPos _thisHouse];
			_garMarker setMarkerShape "ICON";
			_garMarker setMarkerColor "ColorOrange";
			_garMarker setMarkerType "mil_objective";
			_garMarker setMarkerText format ["Garrison %1", (typeOf  _thisHouse)];
		};
	};
};

// Infantry patrols
_numInf = [2,4] call BIS_fnc_randomInt;
_numInf = _numInf + (ceil(_numPlayers/2));
switch aoOptionSelect do {
	case 1: {_numInf = _numInf - 1};
	case 3: {_numInf = _numInf + 1};
};
if (aiSkill == 1) then {
	if (_numInf > 2) then {
		_numInf = 2;
	};
};

for "_infIndex" from 1 to _numInf do {
	_infPosition = [];
	if (_infIndex <= 2) then {_infPosition = [AO_groundPosClose] call Zen_ArrayGetRandom} else {_infPosition = [AO_groundPosFar] call Zen_ArrayGetRandom};	
	_spawnedSquad = nil;
	_minAI = 4;
	_maxAI = 8;
	if (aiSkill == 1) then {	
		_minAI = 3;
		_maxAI = 6;
	};
	_spawnedSquad = [_infPosition, _side, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;					
	if (!isNil "_spawnedSquad") then {
		[_spawnedSquad, _infPosition, 200] call bis_fnc_taskPatrol;	
		enemyAlertableGroups pushBack _spawnedSquad;	
		if (_debug == 1) then {
			_garMarker = createMarker [format["garMkr%1", random 10000], _infPosition];
			_garMarker setMarkerShape "ICON";
			_garMarker setMarkerColor "ColorOrange";
			_garMarker setMarkerType "mil_dot";
			_garMarker setMarkerText format ["Patrol %1", _spawnedSquad];
		};
	};
};

// Bunkers
_bunkerTypes = ["Land_BagBunker_Large_F", "Land_BagBunker_Tower_F"];
_numBunkers = [1,3] call BIS_fnc_randomInt;
switch aoOptionSelect do {
	case 1: {_numBunkers = _numBunkers - 1};
	case 3: {_numBunkers = _numBunkers + 1};
};

if (aiSkill == 1) then {	
	if (_numBunkers > 2) then {
		_numBunkers = 2;
	};
};

for "_x" from 1 to _numBunkers do {	
	if (count AO_flatPositionsFar > 0) then {		
		_thisPos = [AO_flatPositionsFar, true] call Zen_ArrayGetRandom;
		
		_bunkerPos = [_thisPos, 0, 100, 15, 0, 1, 0] call BIS_fnc_findSafePos;
		if (count _bunkerPos > 0) then {
			_startDir = random 360;
			_bunkerType = [_bunkerTypes] call Zen_ArrayGetRandom;
			_bunker = [_bunkerPos, _bunkerType, 0, _startDir, true] call Zen_SpawnVehicle;
			_dir = _startDir;
			_rotation = _startDir;
			for "_i" from 1 to 4 do {
				_fencePos = [_bunkerPos, 10, _dir] call Zen_ExtendPosition;
				_fence = [_fencePos, "Land_BagFence_Long_F", 0, _rotation, true] call Zen_SpawnVehicle;
				_fencePos1 = [_fencePos, 8.2, (_dir-90)] call Zen_ExtendPosition;
				_fence1 = [_fencePos1, "Land_BagFence_Long_F", 0, _rotation, true] call Zen_SpawnVehicle;
				_fencePos2 = [_fencePos, 8.2, (_dir+90)] call Zen_ExtendPosition;
				_fence2 = [_fencePos2, "Land_BagFence_Long_F", 0, _rotation, true] call Zen_SpawnVehicle;
				_dir = _dir + 90;
				_rotation = _rotation + 90;
			};			
			switch (_bunkerType) do {
				case "Land_BagBunker_Large_F": {
					_numBunkerGuards = [3,6] call BIS_fnc_randomInt;
					_leader = nil;
					_leaderChosen = 0;
					for "_n" from 1 to _numBunkerGuards do {
						_dir = random 360;
						_spawnPos = [_bunkerPos, 4, _dir] call Zen_ExtendPosition;
						_group = [_spawnPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;												
						if (!isNil "_group") then {
							_unit = ((units _group) select 0);
							_unit setFormDir _dir;
							_unit setDir _dir;							
							if (_leaderChosen == 0) then {
								_leader = _unit;
								_leaderChosen = 1;
							} else {
								[_unit] joinSilent _leader;
								doStop _unit;
							};
						};
						
					};
				};
				case "Land_BagBunker_Tower_F": {					
					_numBunkerGuards = [2,4] call BIS_fnc_randomInt;
					_leader = nil;
					_leaderChosen = 0;
					for "_n" from 1 to _numBunkerGuards do {
						_dir = random 360;
						//_spawnPos = [_bunkerPos, 1, _dir] call Zen_ExtendPosition;
						_spawnPos = _bunkerPos findEmptyPosition [0,20];
						_group = [_spawnPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;						
						if (!isNil "_group") then {
							_unit = ((units _group) select 0);
							_unit setFormDir _dir;
							_unit setDir _dir;
							if (_leaderChosen == 0) then {
								_leader = _unit;
								_leaderChosen = 1;
							} else {
								[_unit] joinSilent _leader;
								doStop _unit;
							};
						};
					};					
					_spawnPos = [(getPos _bunker select 0), (getPos _bunker select 1), (getPos _bunker select 2)];
					_group = [_spawnPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;					
					if (!isNil "_group") then {
						_unit = ((units _group) select 0);
						_unit setPosATL [(getPos _bunker select 0), (getPos _bunker select 1), (getPos _bunker select 2)+3.5];
						_dir = random 360;
						_unit setFormDir _dir;
						_unit setDir _dir;
					};					
				};
			};

			/*
			_garMarker = createMarker [format["garMkr%1", random 10000], getPos _bunker];
			_garMarker setMarkerShape "ICON";
			_garMarker setMarkerColor "ColorOrange";
			_garMarker setMarkerType "mil_objective";
			*/
			
			// Create Marker
			_markerName = format["bunkerMkr%1", floor(random 10000)];
			_markerBunker = createMarker [_markerName, _bunkerPos];			
			_markerBunker setMarkerShape "ICON";
			_markerBunker setMarkerType "hd_warning";
			_markerBunker setMarkerText "Bunker";			
			_markerBunker setMarkerColor _markerColorEnemy;
			_markerBunker setMarkerAlpha 0;
			_enemyIntelMarkers pushBack _markerBunker;	
			
		};
		
	};
};

// Vehicle patrol
if (count eCarClasses > 0) then {
	_vehRand = (random 100);
	if (_vehRand > 60) then {
		_vehPos = [AO_roadPosArray, true] call Zen_ArrayGetRandom;
		_numVeh = [1,2] call BIS_fnc_randomInt;
		for "_x" from 1 to _numVeh do {
			_vehType = [eCarClasses, false] call Zen_ArrayGetRandom;
			_veh = [_vehPos, _vehType] call Zen_SpawnVehicle;
			createVehicleCrew _veh;
			[_veh, _vehPos, 800] spawn Zen_OrderVehiclePatrol;		
			_vehPos = [AO_roadPosArray] call Zen_ArrayGetRandom;
		};	
	};
};

	
missionNamespace setVariable ["enemyIntelMarkers", _enemyIntelMarkers];	
publicVariable "enemyIntelMarkers";
// *****
// SETUP ENEMIES
// *****

fnc_selectObjects = compile preprocessFile "sunday_system\objectsLibrary.sqf";

_debug = 0;

_numPlayers = count allPlayers;

_aiSkill = "";
if (aiSkill == 0) then {_aiSkill = "Militia"};

_enemyIntelMarkers = [];
enemyAlertableGroups = [];
enemySemiAlertableGroups = [];

if (count AO_TypeData > 0) then {
	
	{	
		_spawnedCivs = nil;
		_spawnedCivs = [_x, civilian, civClasses, [2,3]] call sun_spawnGroup;		
		
		_spawnedSquad = nil;
		if (aiSkill == 1) then {
			_spawnedSquad = [_x, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;	
			//_spawnedSquad = [_x, enemySide, eInfGroups, [1,1], _aiSkill, eInfClasses] call sun_spawnCfgGroup;
		} else {
			_spawnedSquad = [_x, enemySide, eInfClassesForWeights, eInfClassWeights, [2,2]] call dro_spawnGroupWeighted;	
			//_spawnedSquad = [_x, enemySide, eInfGroups, [2,2], _aiSkill, eInfClasses] call sun_spawnCfgGroup;
		};							
		
		_civInteractType = random 100;
		_civInteractType = 60;
		if (_civInteractType < 50) then {
			// Civs walk around urban area with enemy units
			{
				_x forceWalk true;
			} forEach (units _spawnedCivs);	
			
			if (!isNil "_spawnedSquad") then {			
				{
					_wp = _spawnedSquad addWaypoint [_x, 10];
					_wp setWaypointType "MOVE";
					_wp setWaypointBehaviour "SAFE";
					_wp setWaypointSpeed "LIMITED";
					if (_forEachIndex == ((count AO_TypeData)-1)) then {
						_wp setWaypointType "CYCLE";
					};
				} forEach AO_TypeData;
				
				[_spawnedCivs, _spawnedSquad, 2] execVM "sunday_system\generate_enemies\forceFollow.sqf";
			};
		} else {
			// Civs stand and talk with enemy units			
			_civDir = (random 360);
			{
				_x setDir _civDir;
				_x setFormDir _civDir;			
				doStop _x;
				_x allowFleeing 0;
			} forEach (units _spawnedCivs);
			
			_civChosen = selectRandom (units _spawnedCivs);
			if (!isNil "_civChosen") then {
				_enemyPos = [(getPos _civChosen), 2, _civDir] call Zen_ExtendPosition;
				
				{
					_x setPos _enemyPos;
					_x setDir (_civDir - 180);
					_x setFormDir (_civDir - 180);			
				} forEach (units _spawnedSquad);
			};
		};
		
		
	} forEach AO_TypeData;
};

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
				_group = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;				
				if (!isNil "_group") then {
					_guardUnit = ((units _group) select 0);
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
		_markerRoadblock setMarkerColor markerColorEnemy;
		_markerRoadblock setMarkerAlpha 0;
		_enemyIntelMarkers pushBack _markerRoadblock;
				
	};
};

// Generate building garrisons
_numBuildings = count AO_buildingPositions;

_percentToFill = 0.20;
if (_numBuildings < 6) then {_percentToFill = 0.4};

_numHousesToFill = _numBuildings * _percentToFill;

if (_numHousesToFill > 7) then {_numHousesToFill = 7};

_numHousesToFill = _numHousesToFill + (_numPlayers*2);
switch aoOptionSelect do {
	case 1: {if (_numHousesToFill > 1) then {_numHousesToFill = _numHousesToFill - 1}};
	case 3: {_numHousesToFill = _numHousesToFill + 1};
};

if (aiSkill == 1) then {	
	if (_numHousesToFill > 3) then {
		_numHousesToFill = 3;
	};
};

for "_i" from 1 to _numHousesToFill do {
	
	if (count AO_buildingPositions > 0) then {
		[] call dro_spawnEnemyGarrison;
	};
};

// Infantry patrols
_numInf = [3,5] call BIS_fnc_randomInt;
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
	if (_infIndex <= 4) then {_infPosition = [AO_groundPosClose] call Zen_ArrayGetRandom} else {_infPosition = [AO_groundPosFar] call Zen_ArrayGetRandom};	
	_spawnedSquad = nil;
	_spawnedSquad = [_infPosition, enemySide, eInfClassesForWeights, eInfClassWeights, [2,2]] call dro_spawnGroupWeighted;							
	if (!isNil "_spawnedSquad") then {
		[_spawnedSquad, _infPosition, 100] call bis_fnc_taskPatrol;	
		enemyAlertableGroups pushBack _spawnedSquad;		
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
// *****
// Civilians
// *****

_loc = _this select 0;
_locType = type _loc;
_center = getPos _loc;

_debug = 0;

_nearestHouses = nearestObjects [_center, ["House"], 500];
_buildingBlacklist = nearestObjects [_center, ["House_Small_F", "PowerLines_base_F", "PowerLines_Wires_base_F"], 500];
_filteredHouses = [_nearestHouses, _buildingBlacklist] call Zen_ArrayFilterValues;

_numHouses = count _filteredHouses;

_percentToFill = 0.3;
if (_numHouses < 9) then {_percentToFill = 0.5};

_numHousesToFill = _numHouses * _percentToFill;

if (_numHousesToFill > 10) then {_numHousesToFill = 10};

for "_i" from 1 to _numHousesToFill do {

	_thisHouse = [_filteredHouses, true] call Zen_ArrayGetRandom;			
	_buildingPositions = [_thisHouse] call BIS_fnc_buildingPositions;
	_totalGarrison = count _buildingPositions;
	if (count _buildingPositions > 3) then {
		_totalGarrison = 3;
	};
		_garrisonCounter = 0;
	{ 
		if (_garrisonCounter <= _totalGarrison) then {
			_chance = random 100;
			if (_chance > 50) then {
				_civType = selectRandom civClasses;
				_group = createGroup civilian;
				_civType createUnit [ _x, _group ];
				//_unit = _group createUnit [_civType, _x, [], 0, "NONE"];				
				//_spawnedCiv = [_x, _civType] call Zen_SpawnGroup;				
			};
		};
		_garrisonCounter = _garrisonCounter + 1;
	} forEach _buildingPositions;
	
	if (_debug == 1) then {		
		_garMarker = createMarker [format["garMkr%1", random 10000], getPos _thisHouse];
		_garMarker setMarkerShape "ICON";
		_garMarker setMarkerColor "ColorGreen";
		_garMarker setMarkerType "mil_dot";
		_garMarker setMarkerText format ["Civ %1", (typeOf  _thisHouse)];
	};
	
};


switch (_locType) do {
	case "NameVillage": {
		_numCivs = [2,6] call BIS_fnc_randomInt;
		for "_x" from 1 to _numCivs do {
			_civType = selectRandom civClasses;
			_civPosition = selectRandom AO_groundPosClose;
			_group = createGroup civilian;
			_civType createUnit [ _civPosition, _group ];
			[_group, _civPosition, 50] call bis_fnc_taskPatrol;
		};
	};
	case "NameCity": {
		_numCivs = [5,10] call BIS_fnc_randomInt;
		for "_x" from 1 to _numCivs do {
			_civType = selectRandom civClasses;
			_civPosition = selectRandom AO_groundPosClose;
			_group = createGroup civilian;
			_civType createUnit [ _civPosition, _group ];
			[_group, _civPosition, 50] call bis_fnc_taskPatrol;
		};
	};
	case "NameCityCapital": {
		_numCivs = [5,10] call BIS_fnc_randomInt;
		for "_x" from 1 to _numCivs do {
			_civType = selectRandom civClasses;
			_civPosition = selectRandom AO_groundPosClose;
			_group = createGroup civilian;
			_civType createUnit [ _civPosition, _group ];
			[_group, _civPosition, 50] call bis_fnc_taskPatrol;
		};
	};
	case "NameLocal": {
		_numCivs = [2,5] call BIS_fnc_randomInt;
		for "_x" from 1 to _numCivs do {
			_civType = selectRandom civClasses;
			_civPosition = selectRandom AO_groundPosClose;
			_group = createGroup civilian;
			_civType createUnit [ _civPosition, _group ];
			[_group, _civPosition, 50] call bis_fnc_taskPatrol;
		};
	};
};

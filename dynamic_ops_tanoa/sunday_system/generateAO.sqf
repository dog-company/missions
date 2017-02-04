diag_log "Starting AO generation";

startLoadingScreen ["Generating AO"];

// *****
// SETUP AO
// *****

_debug = 0;

_blackList = [];
aoSize = 1400;
switch aoOptionSelect do {
	case 0: {aoSize = selectRandom [1000, 1400, 1800]};
	case 1: {aoSize = 1000};
	case 2: {aoSize = 1400};
	case 3: {aoSize = 1800};	
};

_randomLoc = [];

if (getMarkerColor "aoSelectMkr" == "") then {
	diag_log "DRO: No custom AO position found, will generate random.";
	{
		deleteMarker _x;
	} forEach locMarkerArray;
	// Get a random location
	_size = worldSize;
	_worldCenter = (_size/2);
	_firstLocList = nearestLocations [[_worldCenter, _worldCenter], ["NameLocal","NameVillage","NameCity","NameCityCapital"], _size];
	_randomLoc = [_firstLocList, true] call Zen_ArrayGetRandom;
	progressLoadingScreen 0.1;
	while {
		//([getPos _randomLoc] call Zen_IsIsland > 0.7) ||
		(((getPos _randomLoc) select 0) < aoSize) ||
		(((getPos _randomLoc) select 1) < aoSize) ||
		(((getPos _randomLoc) select 0) > (_size-aoSize)) ||
		(((getPos _randomLoc) select 1) > (_size-aoSize)) ||
		(((getPos _randomLoc) distance logicStartPos) < 600)
		
	} do {
		_randomLoc = [_firstLocList, true] call Zen_ArrayGetRandom;
	};
} else {
	diag_log "DRO: Custom AO position found.";
	_randomLoc = nearestLocation [getMarkerPos "aoSelectMkr", ""];
	"aoSelectMkr" setMarkerAlpha 0;
	{
		deleteMarker _x;
	} forEach locMarkerArray;
};

_debug = 0;
if (_debug == 1) then {
	_randomLoc = nearestLocation [getMarkerPos "tempDebugMkr", ""];
};

progressLoadingScreen 0.2;

_locType = type _randomLoc;

missionNameSpace setVariable ["aoLocation", _randomLoc];
publicVariable "aoLocation";
_locName = text _randomLoc;
missionNameSpace setVariable ["aoLocationName", _locName];
publicVariable "aoLocationName";

progressLoadingScreen 0.3;

_sizeX = 200;
_sizeY = 200;

// Call custom functions to create a two dimensional array of 
// markers in and around the center of the location

_briefLocType = "";
_AREAMARKER_WIDTH = 200;
switch (_locType) do  {
	case "NameLocal": { _AREAMARKER_WIDTH = 200;};
	case "NameVillage": { 
		_AREAMARKER_WIDTH = 200; _briefLocType = "village";
		_sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusA");
		_sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusB");
	};
	case "NameCity": {
		_AREAMARKER_WIDTH = 270; _briefLocType = "city";
		_sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusA");
		_sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusB");
	};
	case "NameCityCapital": {
		_AREAMARKER_WIDTH = 350; _briefLocType = "capital";
		_sizeX = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusA");
		_sizeY = getNumber (configFile >> "CfgWorlds" >> worldName >> "Names" >> _locName >> "radiusB");
	};	
};

progressLoadingScreen 0.4;

_mkrLocSize = 300;
if (_sizeX >= _sizeY) then {
	_mkrLocSize = _sizeX;
} else {
	_mkrLocSize = _sizeY;
};
_mkrLocSize = _AREAMARKER_WIDTH;
_markerLoc = createMarker ["locMkr", getPos _randomLoc];
_markerLoc setMarkerShape "ELLIPSE";
_markerLoc setMarkerSize [_mkrLocSize, _mkrLocSize];
_markerLoc setMarkerAlpha 0;

_cityCenter = getMarkerPos _markerLoc;
missionNameSpace setVariable ["aoCamPos", _cityCenter];
publicVariable "aoCamPos";

progressLoadingScreen 0.5;

// Create center marker
_markerCenter = createMarker ["centerMkr", _cityCenter];
_markerCenter setMarkerShape "ICON";
_markerCenter setMarkerType "EmptyIcon";

// AO marker large
_markerAOL = createMarker ["aoLargeMkr", _cityCenter];
_markerAOL setMarkerShape "ELLIPSE";
_markerAOL setMarkerSize [5000, 5000];
_markerAOL setMarkerAlpha 0;
// AO marker small
_markerAOS = createMarker ["aoSmallMkr", _cityCenter];
_markerAOS setMarkerShape "ELLIPSE";
_markerAOS setMarkerSize [400, 400];
_markerAOS setMarkerAlpha 0;
// AO marker entire
_markerAOC = createMarker ["aoCoverMkr", _cityCenter];
_markerAOC setMarkerShape "RECTANGLE";
_markerAOC setMarkerSize [((aoSize/2)+300), ((aoSize/2)+300)];
_markerAOC setMarkerAlpha 0;
trgAOC = createTrigger ["EmptyDetector", _cityCenter];
trgAOC setTriggerArea [((aoSize/2)+300), ((aoSize/2)+300), 0, true];

progressLoadingScreen 0.6;

// Create array of road positions for reinforcements
AO_roadPosArray = [];
_roads = _cityCenter nearRoads (aoSize/4);

if (count _roads > 9) then {
	
	for "_i" from 0 to 9 do {
		_randRoad = [_roads, true] call Zen_ArrayGetRandom;
		if (typeName _randRoad == "OBJECT") then {
			AO_roadPosArray = AO_roadPosArray + [getPos _randRoad];
		};
	};

} else {
	
	for "_i" from 0 to 9 do {
		_thisPos = [_cityCenter, [0,300]] call Zen_FindGroundPosition;
		AO_roadPosArray = AO_roadPosArray + [_thisPos];
	};

};

progressLoadingScreen 0.7;

// Create array of road positions for roadblocks
_allRoadPosTop = _cityCenter nearRoads (aoSize/2.2);
_allRoadPosCut = _cityCenter nearRoads (aoSize/2.8);
_allRoadPosValid = [_allRoadPosTop, _allRoadPosCut] call Zen_ArrayFilterValues;
roadblockPosArray = [];
if (count _allRoadPosValid > 6) then {
	for "_i" from 0 to 7 do {
		_randRoad = [_allRoadPosValid, true] call Zen_ArrayGetRandom;
		if (typeName _randRoad == "OBJECT") then {
			roadblockPosArray = roadblockPosArray + [getPos _randRoad];
		};
	};
};

progressLoadingScreen 0.75;

// Create arrays of ground positions
AO_groundPosClose = [];
for "_i" from 1 to 20 do {
	_thisPos = [_cityCenter, [0, (aoSize/5)]] call Zen_FindGroundPosition;
	AO_groundPosClose pushBack _thisPos;	
};
AO_groundPosFar = [];
for "_i" from 1 to 20 do {
	_thisPos = [_cityCenter, [(aoSize/2.8), (aoSize/2.2)]] call Zen_FindGroundPosition;
	AO_groundPosFar pushBack _thisPos;
};

progressLoadingScreen 0.8;
/*
// Create array of helicopter landing positions
AO_heliPositions = [];

_bestPlacesLanding = selectBestPlaces [_cityCenter, (aoSize - 200), "(2*meadow) - houses - forest - trees - sea - hills", 25, 25];
{
	_pos = _x select 0;
	
	_flatPos = _pos isFlatEmpty [10, 200, 0.2, 20, 0, false];
		
	if (count _flatPos > 0) then {
		//_height = getTerrainHeightASL _flatPos; 
		//_flatPosATL = [_flatPos select 0, _flatPos select 1, _height];	
		//heliPositions pushBack _flatPosATL;
		AO_heliPositions pushBack _flatPos;
		if (_debug == 1) then {
			_markerFlat = createMarker [format ["mkrLand%1",(random 10000)], _flatPos];
			_markerFlat setMarkerShape "ICON";
			_markerFlat setMarkerType "mil_objective";
			_markerFlat setMarkerColor "ColorGreen";
			_markerFlat setMarkerText format ["%1", _flatPos];
		};
	};
} forEach _bestPlacesLanding;

AO_heliPositions = [AO_heliPositions, [_cityCenter], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;
*/
progressLoadingScreen 0.85;

// Create array of flat empty positions
AO_flatPositions = [];

_bestPlacesFlat = selectBestPlaces [_cityCenter, (aoSize/4), "(2*meadow) - houses - forest - trees - sea - hills", 20, 20];
{
	_pos = _x select 0;
		
	_flatPos = _pos isFlatEmpty [10, -1, 0.15, 20, 0, false];
	
	if (count _flatPos > 0) then {	
		if (count AO_flatPositions > 0) then {
			
			_save = 1;
			{				
				_dist = _x distance _flatPos;			
				if (_dist < 50) then {
					_save = 0;					
				};				
			} forEach AO_flatPositions;
			
			if (_save == 1) then {
				AO_flatPositions pushBack _flatPos;
					
					if (_debug == 1) then {
						_markerFlat = createMarker [format ["mkrLand%1",(random 10000)], _flatPos];
						_markerFlat setMarkerShape "ICON";
						_markerFlat setMarkerType "mil_dot";
						_markerFlat setMarkerColor "ColorBlue";
						_markerFlat setMarkerText "Flat Pos";
					};
			};
			
		} else {
			AO_flatPositions pushBack _flatPos;
		};
	};
} forEach _bestPlacesFlat;

AO_flatPositions = [AO_flatPositions, [_cityCenter], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;
diag_log format ["AO_flatPositions = %1", AO_flatPositions];
// Create array of flat empty positions further from center
AO_flatPositionsFar = [];

_bestPlacesFlat = selectBestPlaces [_cityCenter, (aoSize/2), "(2*meadow) - houses - forest - trees - sea - hills", 20, 20];
{
	_pos = _x select 0;
		
	_flatPos = _pos isFlatEmpty [10, 150, 0.4, 20, 0, false];
	
	if (count _flatPos > 0) then {
		_distCenter = _flatPos distance _cityCenter;
		if (_distCenter > (aoSize/4)) then {
			if (count AO_flatPositionsFar > 0) then {				
				_save = 1;
				{				
					_dist = _x distance _flatPos;			
					if (_dist < 50) then {
						_save = 0;					
					};					
				} forEach AO_flatPositionsFar;
				
				if (_save == 1) then {
					AO_flatPositionsFar pushBack _flatPos;
						
					if (_debug == 1) then {
						_markerFlat = createMarker [format ["mkrLand%1",(random 10000)], _flatPos];
						_markerFlat setMarkerShape "ICON";
						_markerFlat setMarkerType "mil_dot";
						_markerFlat setMarkerColor "ColorBlue";
						_markerFlat setMarkerText "Flat Pos";
					};
				};					
			} else {
				AO_flatPositionsFar pushBack _flatPos;
			};
		};
	};
} forEach _bestPlacesFlat;

progressLoadingScreen 0.9;

// Create array of forested positions
AO_forestPositions = [];

_bestPlacesForest = selectBestPlaces [_cityCenter, (aoSize/2.5), "forest + trees - sea", 20, 25];
{
	AO_forestPositions pushBack (_x select 0);
	if (_debug == 1) then {
		_markerFlat = createMarker [format ["mkrLand%1",(random 10000)], (_x select 0)];
		_markerFlat setMarkerShape "ICON";
		_markerFlat setMarkerType "mil_dot";
		_markerFlat setMarkerColor "ColorGreen";
		_markerFlat setMarkerText "Forest Pos";
	};	
} forEach _bestPlacesForest;

AO_forestPositions = [AO_forestPositions, [_cityCenter], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;

progressLoadingScreen 0.95;

// Create array of valid buildings
AO_buildingPositions = [];
//_bestPlacesBuildings = selectBestPlaces [_cityCenter, 500, "(2*houses) - forest - trees - sea", 10, 25];
_bestPlacesBuildings = [10, 10, _cityCenter, (aoSize/40)] call f_getnearbyPositionsbyParm;

{
	
	_building = nearestBuilding _x;	
	_buildingClass = typeOf _building;
	
	_continue = 1;
	if (((configFile >> "CfgVehicles" >> _buildingClass >> "destrType") call BIS_fnc_GetCfgData) == "DestructNo") then {		
		_continue = 0;
	};
	if (!alive _building) then {	
		_continue = 0;
	};
	if ((count([_building] call BIS_fnc_buildingPositions)) < 2) then {
		_continue = 0;
	};
	_dist = _building distance _cityCenter;
	if (_dist > 400) then {
		_continue = 0;
	};
	
	if (_continue == 1) then {
		AO_buildingPositions pushBackUnique _building;
		if (_debug == 1) then {					
			_markerFlat = createMarker [format ["mkrLand%1",(random 10000)], getPos _building];
			_markerFlat setMarkerShape "ICON";
			_markerFlat setMarkerType "mil_dot";
			_markerFlat setMarkerColor "ColorOrange";
			_markerFlat setMarkerText "Building";
		};	
	};
} forEach _bestPlacesBuildings;

AO_buildingPositions = [AO_buildingPositions, [_cityCenter], {_input0 distance _x}, "ASCEND"] call BIS_fnc_sortBy;

AO_helipads = [];
AO_helipads = nearestObjects [_cityCenter, ["HeliH"], (aoSize/4)];
diag_log format ["HELIPADS: %1", AO_helipads];

AO_Types = ["DEFAULT", "NOMAD", "BARRIER", "PEACEKEEPERS"];
AO_Type = selectRandom AO_Types;
AO_TypeData = [];
diag_log format ["DRO: AO_Type = %1", AO_Type];

switch (AO_Type) do {
	case "NOMAD": {	
		// Find up to 5 overwatch positions
		_campsites = [];	
		for "_i" from 1 to 5 do {
			_thisOverwatchPos = [_cityCenter, (aoSize/4), 100, 20] call BIS_fnc_findOverwatch;
			if (!isNil "_thisOverwatchPos") then {
				_campsites pushBack _thisOverwatchPos;
			};
		};
		
		// If no overwatch positions are found, return AO type to default
		if (count _campsites == 0) then {
			AO_Type = "DEFAULT";
		} else {
			AO_TypeData pushBack _campsites;
		};	
	};	
	case "BARRIER": {
		_startDir = (random 360);
		_thisDir = _startDir;
		_startPos = [_cityCenter, (aoSize/4.5), _startDir] call Zen_ExtendPosition;
		
		// Create hexagon of barriers
		_clearedRoadArray = 0;
		
		_barrierClasses = [
			"Land_HBarrier_5_F",
			"Land_HBarrier_Big_F",
			"Land_HBarrierWall6_F",
			"Land_Razorwire_F",
			"Land_BagFence_Long_F"			
		];
		
		_barrierClass1 = selectRandom _barrierClasses;
		_barrierClass2 = selectRandom _barrierClasses;
		
		for "_i" from 1 to 6 do {
			_thisDir = (_thisDir + 60);
			_thisPos = [_cityCenter, (aoSize/4.5), _thisDir] call Zen_ExtendPosition;
			
			if (!surfaceIsWater _thisPos) then {
				_markerName = format["barrierMkr%1", _i];
				_markerBarrier = createMarker [_markerName, _thisPos];			
				_markerBarrier setMarkerShape "ICON";
				_markerBarrier setMarkerType "mil_ambush";			
				_markerBarrier setMarkerSize [1, 2];			
				_markerBarrier setMarkerDir (_thisDir-90);	
			};
			_barrierSidePosArray = [];
			_lastPos = _thisPos;
			for "_n" from 1 to 5 do {
				_pos = [_lastPos, 30, (_thisDir-90)] call Zen_ExtendPosition;
				_barrierSidePosArray pushBack _pos;
				_lastPos = _pos;
			};
			_lastPos = _thisPos;
			for "_n" from 1 to 5 do {
				_pos = [_lastPos, 30, (_thisDir+90)] call Zen_ExtendPosition;
				_barrierSidePosArray pushBack _pos;
				_lastPos = _pos;
			};
			
			{
				if (!surfaceIsWater _x) then {
					_nRoads = _x nearRoads 22;
					if (count _nRoads > 0) then {
						if (_clearedRoadArray == 0) then {
							_clearedRoadArray = 1;
							roadblockPosArray = [];
						};
						roadblockPosArray pushBack (getPos (_nRoads select 0));
						
					} else {
						_nBuilding = nearestBuilding _x;
						if ((_x distance _nBuilding) > 10) then {
							_checkPos = (_x isFlatEmpty [-1, -1, 1, 10, 0, false]);
							if (count _checkPos > 0) then {								
								_barrier = [_checkPos, _barrierClass1, 0, _thisDir, true] call Zen_SpawnVehicle;
																
								_barrier2Pos = [_x, 8, (_thisDir-90)] call Zen_ExtendPosition;	
								_checkPos = (_barrier2Pos isFlatEmpty [0.5, -1, -1, 1, -1, false]);
								if (count _checkPos > 0) then {																
									_barrier2 = [_checkPos, _barrierClass2, 0, _thisDir, true] call Zen_SpawnVehicle;
								};
								_barrier3Pos = [_x, 8, (_thisDir+90)] call Zen_ExtendPosition;
								_checkPos = (_barrier3Pos isFlatEmpty [0.5, -1, -1, 1, -1, false]);
								if (count _checkPos > 0) then {																
									_barrier3 = [_checkPos, _barrierClass2, 0, _thisDir, true] call Zen_SpawnVehicle;
								};
							};						
						};			
					};				
				};
			} forEach _barrierSidePosArray;				
		};
		
		// Populate hexagon corners with guard towers
		_lastAngle = (_startDir + 30);
		for "_i" from 1 to 6 do {
			_thisDir = (_lastAngle + 60);
			_thisPos = [_cityCenter, ((aoSize/4.5)+40), _thisDir] call Zen_ExtendPosition;			
			_checkPos = _thisPos findEmptyPosition [0, 50, "Land_Cargo_Patrol_V3_F"];
			if (count _checkPos > 0) then {								
				_guardTower = "Land_Cargo_Patrol_V3_F" createVehicle _checkPos;
				_guardTower setDir (_thisDir+180);				
				_dirVector = vectorDir _guardTower;
				_guardTower setVectorDirAndUp [_dirVector,[0,0,1]];				
				AO_TypeData pushBack _guardTower;				
			};
			_lastAngle = _thisDir;
		};		
	};
	case "PEACEKEEPERS": {
		_urbanPlaces = selectBestPlaces [_cityCenter, (aoSize/4.5), "(2*houses) - forest", 30, 6];
		{		
			/*
			_markerName = format["urbanMkr%1", (random 10000)];
			_markerBarrier = createMarker [_markerName, (_x select 0)];			
			_markerBarrier setMarkerShape "ICON";
			_markerBarrier setMarkerType "mil_dot";			
			_markerBarrier setMarkerColor "ColorOrange";
			*/
			if (!surfaceIsWater (_x select 0)) then {
				AO_TypeData pushBack (_x select 0);
			};
			
		} forEach _urbanPlaces;
		civTrue = true;					
	};
};

diag_log format ["DRO: AO_TypeData = %1", AO_TypeData];


// Visual markers
_markerN = createMarker ["mkrN", [(_cityCenter select 0), ((_cityCenter select 1)+(aoSize/2)+150)]];
_markerN setMarkerShape "RECTANGLE";
_markerN setMarkerBrush "FDiagonal";
_markerN setMarkerColor "ColorIndependent";
_markerN setMarkerSize [(aoSize/2)+300, 150];

_markerS = createMarker ["mkrS", [(_cityCenter select 0), ((_cityCenter select 1)-(aoSize/2)-150)]];
_markerS setMarkerShape "RECTANGLE";
_markerS setMarkerBrush "FDiagonal";
_markerS setMarkerColor "ColorIndependent";
_markerS setMarkerSize [(aoSize/2)+300, 150];

_markerE = createMarker ["mkrE", [((_cityCenter select 0)+(aoSize/2)+150), (_cityCenter select 1)]];
_markerE setMarkerShape "RECTANGLE";
_markerE setMarkerBrush "FDiagonal";
_markerE setMarkerColor "ColorIndependent";
_markerE setMarkerSize [150, (aoSize/2)];

_markerW = createMarker ["mkrW", [((_cityCenter select 0)-(aoSize/2)-150), (_cityCenter select 1)]];
_markerW setMarkerShape "RECTANGLE";
_markerW setMarkerBrush "FDiagonal";
_markerW setMarkerColor "ColorIndependent";
_markerW setMarkerSize [150, (aoSize/2)];

_markerFlag = createMarker ["mkrFlag", [(_cityCenter select 0),((_cityCenter select 1)+(aoSize/2)+150)]];
_markerFlag setMarkerShape "ICON";
_markerFlag setMarkerType "flag_AAF";
_markerFlag setMarkerSize [2,2];

endLoadingScreen;

_return = [_cityCenter, _AREAMARKER_WIDTH, _randomLoc, _briefLocType];
diag_log "DRO: Completed AO generation";
_return


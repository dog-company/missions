f_getrandomcityAreaMarker = {
	private ["_ptownMarkers"];
	
	// Get array of cities and villages on map
	_ptownMarkers = [["NameVillage","NameCity","NameCityCapital"]] call Zen_ConfigGetLocations;
	
	// Choose random element and return it to calling function
	[_ptownMarkers] call Zen_ArrayGetRandom;
	
};

f_getnearbyPositionsNine = {
	private ["_pcenterzone","_pmarkersize","_newX","_newY","_ppositionarray"];
	// Assign local variables to center and marker size function parameters
	_pcenterzone = _this select 0;
	_pmarkersize = _this select 1;
	// Initialize empty array
	_ppositionarray = [];
	
	//player sidechat "Center Zone " + (str _pcenterzone);	// Debug
	
	// Use the idea of a "normalized" 3x3 matrix
	for "_x" from -1 to 1 step 1 do {
		for "_y" from -1 to 1 step 1 do {
			_newX = (_pcenterzone select 0) + (_x * _pmarkersize);
			_newY = (_pcenterzone select 1) + (_y * _pmarkersize);
			[_ppositionarray,[_newX,_newY]] call Zen_ArrayAppend;	
			//player sidechat "X and Y " + (str _newX) + ", " + (str _newY);	// Debug
		};
	};
	
	// Return array of positions to calling function
	_ppositionarray
};

f_getnearbyPositions16 = {
	private ["_pcenterzone","_pmarkersize","_newX","_newY","_ppositionarray"];
	// Assign local variables to center and marker size function parameters
	_pcenterzone = _this select 0;
	_pmarkersize = _this select 1;
	// Initialize empty array
	_ppositionarray = [];
	
	// Use the idea of a "normalized" 4x4 matrix
	for "_x" from -1.5 to 1.5 step 1 do {
		for "_y" from -1.5 to 1.5 step 1 do {
			_newX = (_pcenterzone select 0) + (_x * _pmarkersize);
			_newY = (_pcenterzone select 1) + (_y * _pmarkersize);
			[_ppositionarray,[_newX,_newY]] call Zen_ArrayAppend;			
		};
	};
	
	// Return array of positions to calling function
	_ppositionarray
};

f_getnearbyPositionsbyParm = {
	private ["_pXDim","_pYDim","_pcenterzone","_pmarkersize","_xOrigin","_yOrigin","_newX","_newY","_ppositionarray"];
	// Assign local variables to center and marker size function parameters
	_pXDim = _this select 0;
	_pYDim = _this select 1;
	_pcenterzone = _this select 2;
	_pmarkersize = _this select 3;
	// Initialize empty array
	_ppositionarray = [];
	
	//player sidechat "Center Zone " + (str _pcenterzone);	// Debug
	
	// Calculate the bottom left corner of the grid
	_xOrigin = (_pcenterzone select 0) - (_pmarkersize*(_pXDim/2));
	_yOrigin = (_pcenterzone select 1) - (_pmarkersize*(_pYDim/2));
	
	//player sidechat "Origin X " + (str _xOrigin);	// Debug
	//player sidechat "Origin Y " + (str _yOrigin);	// Debug
			
	for "_i" from 0 to (_pYDim - 1) step 1 do {
		for "_j" from 0 to (_pXDim - 1) step 1 do {
			_newX = _xOrigin + ((_j + 0.5) * _pmarkersize);
			_newY = _yOrigin + ((_i + 0.5) * _pmarkersize);
			[_ppositionarray,[_newX,_newY]] call Zen_ArrayAppend;			
		};
	};
	
	// Return array of positions to calling function
	_ppositionarray
};

f_createMarkersfromArray = {
	private ["_ppositionarray","_pmarkersize","_newMarker","_markerarray"];
	// Assign local variables to center and marker size function parameters
	_ppositionarray = _this select 0;
	_pmarkersize = _this select 1;
	// Initialize empty array
	_markerarray = [];
	
	// Iterate across array of positions
	// For each position spawn an area marker
	{	
		_newMarker = [[(_x select 0),(_x select 1)],"", "colorBlack",[_pmarkersize/2, _pmarkersize/2],"rectangle", 0, 0] call Zen_SpawnMarker;
		[_markerarray,_newMarker] call Zen_ArrayAppend;
	} forEach _ppositionarray;
	
	// Return array of markers to the calling function
	_markerarray
};

f_filtermarkersbyTerrain = {
	private ["_parmarray","_pmarkerarray","_terrainExtent"];
	// Assign to local variable the function argument
	_parmarray = _this select 0;
	_pmarkerarray = +_parmarray;	// Filter a copy of the array argument
	
	// Iterate across array of positions
	// If the position is mostly water then replace it in the array with the value '0'
	{ 	
		_terrainExtent = [_x] call Zen_IsWaterArea;
		if (_terrainExtent > 0.6) then {
			_pmarkerarray set [_forEachIndex,0];
		};
	} forEach _pmarkerarray;
	
	// Remove all elements of position array that have value of '0'
	[_pmarkerarray,0] call Zen_ArrayRemoveValue;
	
	// Return filtered array of area markets to the calling function
	_pmarkerarray
};

f_filtermarkersbyParm = {
	private ["_parmarray","_pmarkerarray","_exclusionarray","_exclusiontype","_exclusionpercent","_terrainextent"];
	// Assign to local variables the function arguments
	_parmarray = _this select 0;
	_pmarkerarray = +_parmarray;	// Filter a copy of array argument
	_exclusionarray = _this select 1;

	// Iterate across array of terrain type exclusions
	// If the marker exceeds the terrain extent parameter then replace 
	// the marker in the array with the value '0'
	{ 	
		_exclusiontype = (_x select 0);
		_exclusionpercent = (_x select 1)/100;

		if (_exclusiontype == "urban") then {
			{ 	
				_terrainextent = [_x] call Zen_IsUrbanArea;
				if (_terrainextent > _exclusionpercent) then {
					//player sideChat str _terrainExtent;	// Debug
					_pmarkerarray set [_forEachIndex,0];
				};
			} forEach _pmarkerarray;
		};
		if (_exclusiontype == "water") then {
			{ 	
				_terrainextent = [_x] call Zen_IsWaterArea;
				if (_terrainextent > _exclusionpercent) then {
					_pmarkerarray set [_forEachIndex,0];
				};
			} forEach _pmarkerarray;
		};
		if (_exclusiontype == "forest") then {
			{ 	
				_terrainextent = [_x] call Zen_IsForestArea;
				if (_terrainextent > _exclusionpercent) then {
					_pmarkerarray set [_forEachIndex,0];
				};
			} forEach _pmarkerarray;
		};
		// Remove all elements of position array that have value of '0'
		[_pmarkerarray,0] call Zen_ArrayRemoveValue;
	} forEach _exclusionarray;
	
	//private ["_alphaValue"];	// Debug
	//_alphaValue = 0;	// Debug
	//{	_x setMarkerAlpha 1;	// Debug
	//	if ((_alphaValue mod 2) == 0) then {_x setMarkerColor "ColorOrange"};	// Debug
	//	_alphaValue = _alphaValue+1;	// Debug
	//} forEach _pmarkerarray;	// Debug
	//diag_log ("f_filtermarkersbyParm Return Marker Array " + (str _pmarkerarray));	// Debug
	
	// Return filtered array of area markets to the calling function
	_pmarkerarray
};

f_spawnsquadforMarkerArray = {
	private ["_pmarkerarray","_startarea","_pos","_group"];
	
	// Assign local variables to array of area markers
	_pmarkerarray = _this select 0;
	
	// Select group starting area randomly
	_startArea = [_pmarkerarray] call Zen_ArrayGetRandom;
	_pos = [_startArea] call Zen_FindGroundPosition;
	_group = [_pos, east, "infantry", [2,3]] call Zen_SpawnInfantry;
	0 = [[_group], _pmarkerarray] spawn f_orderRandomPatrol;
	
	// Return spawned group
	_group
};

f_orderRandomPatrol = {
	private ["_pmarkerarray","_pgroup","_patrolarea","_patrolThread"];
	
	// Assign local variables to group and array of area markers
	_pgroup = _this select 0;
	_pmarkerarray = _this select 1;
	
	0 = [[_pgroup],"group"] call Zen_TrackInfantry;	// Debug
		
	while {true} do {
		// Choose area at random
		_patrolarea = [_pmarkerarray] call Zen_ArrayGetRandom;
		// Order sqaud to patrol in that area
		_patrolThread = [[_pgroup], _patrolarea] spawn Zen_OrderInfantryPatrol;
		
		//player sideChat "New Waypoint for " + (str _pgroup);	// Debug
		
		// Sleep from 100 to 140 seconds
		sleep ([100,140] call Zen_FindInRange);
		// If squad is dead exit while loop
		if (scriptDone _patrolThread) exitWith {};
		// Terminate thread handle nad go back to first command of while loop
		terminate _patrolThread;
	};
};

f_createExtractionPosition = {
	private ["_pcenterpoint","_positionarray","_markerArray","_AREAMARKER_WIDTH","_XDIM","_YDIM","_xOrigin","_yOrigin","_newX","_newY","_landingMarker"];
	_pcenterpoint = _this select 0;
		
	// Create a two dimensional array of markers on the perimeter of the town
	_AREAMARKER_WIDTH = 150; _XDIM=6; _YDIM=6;
	// Create an array of positions relative to the center argument
	_positionarray = [];
	// Calculate the bottom left corner of the grid
	_xOrigin = (_pcenterpoint select 0) - (_AREAMARKER_WIDTH*(_XDIM/2));
	_yOrigin = (_pcenterpoint select 1) - (_AREAMARKER_WIDTH*(_YDIM/2));
			
	for "_i" from 0 to (_YDIM - 1) step 1 do {
		for "_j" from 0 to (_XDIM - 1) step 1 do {
			_newX = _xOrigin + ((_j + 0.5) * _AREAMARKER_WIDTH);
			_newY = _yOrigin + ((_i + 0.5) * _AREAMARKER_WIDTH);
			if (_i==0 or _j==0 or _i==_YDIM-1 or _j==_XDIM-1) then {
				[_positionarray,[_newX,_newY]] call Zen_ArrayAppend;
			}
		};
	};
	
	// Convert all the positions into area markers
	_markerArray = [_positionArray,_AREAMARKER_WIDTH] call f_createMarkersfromArray;
	// Filter out all positions that are urban, near water or forested
	_markerArray = [_markerArray,[["urban",20],["forest",20],["water",20]]] call f_filtermarkersbyParm;

	// Select helicopter landing area randomly
	_landingMarker = [_markerArray] call Zen_ArrayGetRandom;
	// Find LZ on level land away from houses, trees, rocks and shrubs
	extractionPosition = [_landingMarker,0,0,1,[1,80],0,[1,0,10],0,0,[1,10],[1,[0,0,-1],10]] call Zen_FindGroundPosition;
	
	//diag_log ("Extraction Position " + (str extractionPosition));	// Debug
	
	//_alphaValue = 0;					// Debug
	//{
	//	_x setMarkerAlpha 1;			// Debug
	//	if ((_alphaValue mod 2) == 0) then {_x setMarkerColor "ColorGreen"};	// Debug
	//	_alphaValue = _alphaValue + 1;	// Debug
	//} forEach _markerArray;			// Debug

};


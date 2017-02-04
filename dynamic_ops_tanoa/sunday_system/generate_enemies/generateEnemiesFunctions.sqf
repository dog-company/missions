dro_spawnEnemyGarrison = {
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
			_group = [_x, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;			
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
};

dro_spawnEnemyBunker = {
	_bunkerTypes = ["Land_BagBunker_Large_F", "Land_BagBunker_Tower_F"];
	_thisPos = [AO_flatPositionsFar, true] call Zen_ArrayGetRandom;		
	_bunkerPos = [_thisPos, 0, 100, 15, 0, 1, 0] call BIS_fnc_findSafePos;
	if (count _bunkerPos > 0) then {
		_startDir = random 360;
		_bunkerType = selectRandom _bunkerTypes;
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
					_group = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;										
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
					_group = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;					
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
				_group = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;					
				if (!isNil "_group") then {
					_unit = ((units _group) select 0);
					_unit setPosATL [(getPos _bunker select 0), (getPos _bunker select 1), (getPos _bunker select 2)+3.5];
					_dir = random 360;
					_unit setFormDir _dir;
					_unit setDir _dir;
				};					
			};
		};

		// Create Marker
		_markerName = format["bunkerMkr%1", floor(random 10000)];
		_markerBunker = createMarker [_markerName, _bunkerPos];			
		_markerBunker setMarkerShape "ICON";
		_markerBunker setMarkerType "hd_warning";
		_markerBunker setMarkerText "Bunker";			
		_markerBunker setMarkerColor markerColorEnemy;
		_markerBunker setMarkerAlpha 0;
		_enemyIntelMarkers pushBack _markerBunker;	
	};
};

dro_spawnEnemyCamp = {

	_pos = _this select 0;
	
	_campPos = [_pos, 0, 50, 3, 0, 0, 0.07] call BIS_fnc_findSafePos;
	if (!isNil "_campPos") then {		
		_campObjects = [
			"Land_CampingTable_F",
			"Land_Camping_Light_F",
			"Land_CampingChair_V2_F",
			"Land_GasTank_01_khaki_F",
			"Land_Pillow_F",
			"Land_Pillow_camouflage_F",
			"Land_Pillow_grey_F",
			"Land_Pillow_old_F",
			"Land_Ground_sheet_khaki_F",
			"Land_TentA_F",
			"Land_TentDome_F",
			"Land_WoodenLog_F",
			"Land_WoodPile_F",
			"Land_WoodPile_large_F",
			"Land_Garbage_square3_F",									
			"Land_Garbage_square5_F",									
			"Land_Sleeping_bag_F",
			"Land_Sleeping_bag_brown_F",
			"Land_Ground_sheet_OPFOR_F"		
		];
		
		_numCampObjects = [5,8] call BIS_fnc_randomInt;
		for "_i" from 1 to _numCampObjects do {
			_spawnPos = [_pos, (1.5 + random 3), (random 360)] call Zen_ExtendPosition;
			_selectedObject = selectRandom _campObjects;
			_object = createVehicle [_selectedObject, _spawnPos, [], 2, "NONE"];
			_dir = [_pos, _spawnPos] call BIS_fnc_dirTo;
			_object setDir _dir;
		};
		
		_spawnedSquad = nil;
		_spawnedSquad = [_pos, enemySide, eInfClassesForWeights, eInfClassWeights, [3,5]] call dro_spawnGroupWeighted;			
		if (!isNil "_spawnedSquad") then {
			[_spawnedSquad, _pos] call bis_fnc_taskDefend;	
			enemyAlertableGroups pushBack _spawnedSquad;
			_spawnedSquad
		};
	};
};

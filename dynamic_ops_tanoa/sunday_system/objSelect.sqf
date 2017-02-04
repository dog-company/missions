scopeName "objSelection";
fnc_selectObjective = compile preprocessFile "sunday_system\objSelect.sqf";
//fnc_evalObjLoc = compile preprocessFile "sunday_system\evalObjectiveLocation.sqf";
fnc_selectObjects = compile preprocessFile "sunday_system\objectsLibrary.sqf";

diag_log "DRO: Attempting to create new task";

_aiSkill = "";
if (aiSkill == 0) then {_aiSkill = "Militia"};

_pos = _this select 0;
_prevObj = _this select 1;
_side = enemySide;
_thisTask = nil;
_objectivePos = [0,0,0];

_markerColorPlayers = "";
_markerColorEnemy = "";

switch (_side) do {
	case west: {
		_markerColorEnemy = "colorBLUFOR";
	};
	case east: {
		_markerColorEnemy = "colorOPFOR";
	};
	case resistance: {
		_markerColorEnemy = "colorIndependent";
	};	
};
switch (side player) do {
	case west: {
		_markerColorPlayers = "colorBLUFOR";
	};
	case east: {
		_markerColorPlayers = "colorOPFOR";
	};
	case resistance: {
		_markerColorPlayers = "colorIndependent";
	};	
};

_thisObj = nil;

_styles = [];
_destroyStyles = [];
_hvtStyles = [];
_powStyles = [];
_heliTransports = [];


if (count AO_roadPosArray > 0) then {
	if (count eCarClasses > 0) then {
		_styles pushBack "VEHICLE";
	};
};

if (count AO_buildingPositions > 0) then {
	_styles pushBack "BUILDING";
	_styles pushBack "INTEL";
	_hvtStyles pushBack "INSIDE";
	_powStyles pushBack "INSIDE";
};

if (count AO_forestPositions > 0) then {
	_powStyles pushBack "OUTSIDE";
	_styles pushBackUnique "CLEARLZ";
};

if (count AO_flatPositions > 0) then {
	if (count eArtyClasses > 0) then {
		_styles pushBack "ARTY";
	};
	if (count eMortarClasses > 0) then {				
		_destroyStyles pushBack "MORTAR";
	};
	/*
	if (count eHeliClasses > 0) then {
		_styles pushBack "HELI";	
	};
	*/
	_styles pushBackUnique "CLEARLZ";	
	_styles pushBack "CLEARBASE";	
	_hvtStyles pushBack "OUTSIDE";
	_destroyStyles pushBack "POWER";
	_destroyStyles pushBack "BOX";
};

if ((count eHeliClasses > 0 && (count AO_flatPositions > 2)) OR ((count eHeliClasses > 0) && count AO_helipads > 0)) then {
	_styles pushBack "HELI";
};

_pVehicleWreckClasses = (pCarClasses + pTankClasses + pHeliClasses);
if (count _pVehicleWreckClasses > 0 && count AO_flatPositions > 2) then {
	_destroyStyles pushBack "WRECK";
};

if (count eOfficerClasses > 0 && count _hvtStyles > 0) then {
	_styles pushBack "HVT";
};

if (count _destroyStyles > 0) then {
	_styles pushBack "DESTROY";
};

if (count _powStyles > 0) then {
	_styles pushBack "POW";
};

if (count _prevObj > 0) then {
	switch (_prevObj select 0) do {
		case "POW": {
			_styles = _styles - ["CLEARLZ", "CLEARBASE", "ARTY", "HELI", "VEHICLE", "BUILDING", "HVT"];
			_destroyStyles = _destroyStyles - ["MORTAR", "BOX"];
		};
		case "CLEARLZ": {
			_styles = _styles - ["POW"];
			_styles = _styles - ["CLEARLZ"];
		};
		case "CLEARBASE": {
			_styles = _styles - ["POW"];
			_styles = _styles - ["CLEARBASE"];
		};
		case "ARTY": {
			_styles = _styles - ["POW"];
		};
		case "HELI": {
			_styles = _styles - ["POW"];
		};
		case "VEHICLE": {
			_styles = _styles - ["POW"];
		};
		case "BUILDING": {
			_styles = _styles - ["POW"];
		};
		case "HVT": {
			_styles = _styles - ["POW"];
		};
		case "DESTROY": {
			switch (_prevObj select 1) do {
				case "MORTAR": {
					_styles = _styles - ["POW"];
				};
				case "BOX": {
					_styles = _styles - ["POW"];
				};
			};
		};
	};
};

_select = [_styles] call Zen_ArrayGetRandom;
//_select = "BUILDING";
//_destroyStyles = ["POWER"];
switch (_select) do {
	case "HVT": {	
		// Eliminate HVT
				
		// Get HVT unit
		_hvtType = [];
		if (count eOfficerClasses > 0) then {
			_hvtType = [eOfficerClasses] call Zen_ArrayGetRandom;
		} else {
			_hvtType = [eInfClasses] call Zen_ArrayGetRandom;
		};		
							
		_hvtChar = nil;
		
		_sceneTypes = ["MEETINGS", "FOBS"];
		_hvtPos = [];
		
		// Select hiding style
		_hvtStyle = selectRandom _hvtStyles;
		switch (_hvtStyle) do {
			case "INSIDE": {				
					_building = [AO_buildingPositions, true] call Zen_ArrayGetRandom;
					_buildingPlaces = [_building] call BIS_fnc_buildingPositions;
					_thisBuildingPlace = [0,((count _buildingPlaces)-1)] call BIS_fnc_randomInt;
					
					// Create HVT unit
					_spawnedGroup = [getPos _building, _hvtType] call Zen_SpawnGroup;	
					_hvtChar = (units _spawnedGroup) select 0;
					_hvtChar setPosATL (_building buildingPos _thisBuildingPlace);					
					_hvtPos	= getPos _building;
			};
			case "OUTSIDE": {								
				//_hvtPos = [AO_flatPositions, true] call Zen_ArrayGetRandom;
				_hvtPos = AO_flatPositions select 0;
				AO_flatPositions = AO_flatPositions - [_hvtPos];
				
				_tempPos = [(_hvtPos select 0), (_hvtPos select 1), 0];
				_hvtPos = _tempPos;
				
				_sceneType = selectRandom _sceneTypes;
				switch (_sceneType) do {
					case "FOBS": {
						_objectLib = ["FOBS"] call fnc_selectObjects;
						_objects = selectRandom _objectLib;
						_spawnedObjects = [_hvtPos, (random 360), _objects] call BIS_fnc_ObjectsMapper;
						
						{
							if (typeOf _x == "Sign_Arrow_Blue_F") then {								
								_guardGroup = [getPos _x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
								_guardUnit = ((units _guardGroup) select 0);
								if (!isNil "_guardUnit") then {	
									_guardUnit setFormDir (getDir _x);
									_guardUnit setDir (getDir _x);
								};
								deleteVehicle _x;
							};
						} forEach _spawnedObjects;
						
						// Create HVT unit						
						_hvtSpawnPos = _hvtPos findEmptyPosition [0, 15, _hvtType];
						_spawnedGroup = [_hvtSpawnPos, _hvtType] call Zen_SpawnGroup;	
						_hvtChar = (units _spawnedGroup) select 0;						
						
					};
					case "MEETINGS": {
						// Create HVT unit
						_hvtSpawnPos = _hvtPos findEmptyPosition [0, 15, _hvtType];
						_spawnedGroup = [_hvtSpawnPos, _hvtType] call Zen_SpawnGroup;	
						_hvtChar = (units _spawnedGroup) select 0;
						_hvtChar setPos _hvtPos;	
					
						_civArray = ["C_man_p_beggar_F", "C_man_1", "C_man_polo_1_F", "C_man_polo_2_F", "C_man_polo_3_F", "C_man_polo_4_F", "C_man_polo_5_F", "C_man_polo_6_F", "C_man_shorts_1_F", "C_man_1_1_F", "C_man_1_2_F", "C_man_1_3_F", "C_man_w_worker_F"];
						_objectLib = ["MEETINGS"] call fnc_selectObjects;
						_objects = selectRandom _objectLib;
						_spawnedObjects = [_hvtPos, (random 360), _objects] call BIS_fnc_ObjectsMapper;
						
						{
							if (typeOf _x == "Sign_Arrow_Blue_F") then {
								_pos = getPos _x;
								_dir = getDir _x;
								deleteVehicle _x;								
								_guardGroup = [_pos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
								_guardUnit = ((units _guardGroup) select 0);
								if (!isNil "_guardUnit") then {
									_guardUnit setFormDir (_dir);
									_guardUnit setDir (_dir);
								};
							};
							if (typeOf _x == "Sign_Arrow_F") then {
								_pos = getPos _x;
								_dir = getDir _x;
								deleteVehicle _x;
								_hvtChar setPos _pos;
								_hvtChar setFormDir _dir;
								_hvtChar setDir _dir;									
							};
							if (typeOf _x == "Sign_Arrow_Yellow_F") then {
								_civType = selectRandom _civArray;
								_pos = getPos _x;
								_dir = getDir _x;
								deleteVehicle _x;
								_spawnedGroup = [_pos, _civType] call Zen_SpawnGroup;	
								_spawnedCiv = (units _spawnedGroup) select 0;
								_spawnedCiv setFormDir _dir;
								_spawnedCiv setDir _dir;									
							};
						} forEach _spawnedObjects;						
					};
				};								
			};
		};
		
		
		_hvtChar disableAI "MOVE";
				
		// Marker
		_markerPos = [_hvtPos, 0, 120, 0, 1, 100, 0] call BIS_fnc_findSafePos;
		_markerName = format["hvtMkr%1", floor(random 10000)];		
		_hvtMarker = createMarker [_markerName, _markerPos];
		_hvtMarker setMarkerShape "ELLIPSE";
		_hvtMarker setMarkerBrush "Solid";
		_hvtMarker setMarkerColor _markerColorEnemy;
		_hvtMarker setMarkerSize [150, 150];
		_hvtMarker setMarkerAlpha 0.5;
		
		// Create Task
		_hvtName = ((configFile >> "CfgVehicles" >> _hvtType >> "displayName") call BIS_fnc_GetCfgData);		
		_taskName = format ["task%1", floor(random 100000)];
		_thisTask = _taskName;
		_taskDesc = format ["Eliminate the %1 %2. Target is believed to be in the <marker name='%3'>marked area</marker>. Use caution and do not allow the target to escape.", enemyFactionName, _hvtName, _markerName];
		_taskTitle = "Eliminate HVT";		
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _markerPos, "CREATED", 1, false, "kill", false] call BIS_fnc_taskCreate;					
		_hvtChar setVariable ["thisTask", _taskName];
		
		// Add killed event handler
		_hvtChar addEventHandler ["Killed", {[((_this select 0) getVariable ("thisTask")), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;}];		
		
		// Spawn patrols
		_minAI = 3;
		_maxAI = 5;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 4;
		};		
		_spawnedSquad = [_hvtPos, _side, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;								
		_allGuards = [];		
		if (!isNil "_spawnedSquad") then {	
			0 = [_spawnedSquad, _hvtPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
			_allGuards = (units _spawnedSquad);			
		};		
		
		// Create fail state		
		_trgFlee = createTrigger ["EmptyDetector", _hvtPos, true];
		_trgFlee setTriggerArea [200, 200, 0, false];
		_trgFlee setTriggerActivation ["ANY", "PRESENT", false];
		_trgFlee setTriggerStatements [
			"
				({alive _x} count (thisTrigger getVariable 'allGuards')) < ((count (thisTrigger getVariable 'allGuards')) * 0.5)				
			",
			"				
				(thisTrigger getVariable 'hvt') enableAI 'MOVE';
				(thisTrigger getVariable 'hvt') allowFleeing 1;					
			", 
			""];
		_trgFlee setVariable ["allGuards", _allGuards];
		_trgFlee setVariable ["hvt", _hvtChar];
				
		_trgFail = createTrigger ["EmptyDetector", _hvtPos, true];
		_trgFail setTriggerArea [350, 350, 0, false];
		_trgFail setTriggerActivation ["ANY", "PRESENT", false];
		_trgFail setTriggerStatements [
			"
				(alive (thisTrigger getVariable 'hvt')) && 
				!((thisTrigger getVariable 'hvt') in thisList) && 
				((thisTrigger getVariable 'hvt') distance player > 1000)
			",
			"				
				[(thisTrigger getVariable 'thisTask'), 'FAILED', true] spawn BIS_fnc_taskSetState;
				hideObject (thisTrigger getVariable 'hvt');				
			", 
			""];
		_trgFail setVariable ["hvt", _hvtChar];
		_trgFail setVariable ["thisTask", _taskName];
		
		_objectivePos = _hvtPos;
		
	};
	case "DESTROY": {
		_destroySelect = [_destroyStyles] call Zen_ArrayGetRandom;
		//_destroySelect = "POWER";
		switch (_destroySelect) do {
			case "MORTAR": {
				// Destroy target				
				//_thisPos =  [AO_flatPositions, true] call Zen_ArrayGetRandom;
				_thisPos = AO_flatPositions select 0;
				AO_flatPositions = AO_flatPositions - [_thisPos];
				
				_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
				_thisPos = _tempPos;
				
				// Marker
				_markerName = format["mortMkr%1", floor(random 10000)];
				_markerMortar = createMarker [_markerName, _thisPos];
				_markerMortar setMarkerShape "ICON";
				_markerMortar setMarkerType  "o_mortar";
				_markerMortar setMarkerColor _markerColorEnemy;
				_markerMortar setMarkerAlpha 0;
								
				// Create objective
				_mortarType = [eMortarClasses, false] call Zen_ArrayGetRandom;
				// Create Task
				_mortarName = ((configFile >> "CfgVehicles" >> _mortarType >> "displayName") call BIS_fnc_GetCfgData);
				
				_taskName = format ["task%1", floor(random 100000)];
				_taskTitle = "Destroy Mortar Emplacement";
				_taskDesc = format ["Destroy the %1 %2s. Mortar emplacement can be found at the <marker name='%3'>marked area</marker>.", enemyFactionName, _mortarName, _markerName];
				_thisTask = _taskName;
				
				[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;	
								
				// Create mortar units
				_mortPos = [_thisPos, 3, (random 360)] call Zen_ExtendPosition;				
				_mortar = _mortarType createVehicle _mortPos;				
				createVehicleCrew _mortar;				
				_mort2Dir = [_mortPos, _thisPos] call BIS_fnc_dirTo;
				_mort2Pos = [_thisPos, 3, _mort2Dir] call Zen_ExtendPosition;
				_mortar2 = _mortarType createVehicle _mort2Pos;				
				createVehicleCrew _mortar2;
				
				// Create trigger				
				_trgComplete = createTrigger ["EmptyDetector", _thisPos, true];
				_trgComplete setTriggerArea [0, 0, 0, false];
				_trgComplete setTriggerActivation ["ANY", "PRESENT", false];
				_trgComplete setTriggerStatements [
					"
						!alive (thisTrigger getVariable 'mortar1') && !alive (thisTrigger getVariable 'mortar2') 			
					",
					"				
						[(thisTrigger getVariable 'thisTask'), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;										
					", 
					""];
				_trgComplete setVariable ["mortar1", _mortar];
				_trgComplete setVariable ["mortar2", _mortar2];
				_trgComplete setVariable ["thisTask", _thisTask];
										
				
				// Create guards and fortifications
				// Populate corner points		
				_cornerFortClasses = ["Land_BagBunker_Small_F"];	
				_startDir = random 360;	
				_dir = (_startDir - 45);
				_rotation = (_startDir - 180);
				for "_i" from 1 to 4 do {
					_popChance = (random 100);
					if (_popChance > 40) then {
						_cornerPos = [_thisPos, 10, _dir] call Zen_ExtendPosition;
						if (_popChance > 70) then {
							// Corner bunker							
							_cornerClass = [_cornerFortClasses, false] call Zen_ArrayGetRandom;
							_corner = [_cornerPos, _cornerClass, 0, _rotation, true] call Zen_SpawnVehicle;
											
							// Create guard														
							_group = [_cornerPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
							_unit = ((units _group) select 0);							
							if (!isNil "_unit") then {
								_unitDir = (_rotation-180);
								_unit setFormDir _unitDir;
								_unit setDir _unitDir;
							};
							
						};
						// Corner fortifications
						_cornerFortExtraClasses = ["Land_Razorwire_F", "Land_BagFence_Long_F"];
						_cornerFortPos1 = [_cornerPos, 5, (_dir-45)] call Zen_ExtendPosition;
						_cornerFortPos2 = [_cornerPos, 5, (_dir+45)] call Zen_ExtendPosition;
						
						_cornerFortClass = [_cornerFortExtraClasses, false] call Zen_ArrayGetRandom;
						_cornerFortObject1 = [_cornerFortPos1, _cornerFortClass, 0, (_rotation - 90), true] call Zen_SpawnVehicle;
						_cornerFortObject2 = [_cornerFortPos2, _cornerFortClass, 0, (_rotation), true] call Zen_SpawnVehicle;
						
						_dir = _dir + 90;
						_rotation = _rotation + 90;
					};
				};
				_randItems = [1,3] call BIS_fnc_randomInt;
				_itemsArray = [
					"Land_Cargo10_grey_F",
					"Land_Cargo10_military_green_F",					
					"CargoNet_01_box_F",					
					"Land_Pallet_MilBoxes_F"						
				];
				for "_i" from 1 to _randItems do {
					_itemPos = [_thisPos, 7, 11, 1, 0, 1, 0] call BIS_fnc_findSafePos;
					_thisItem = [_itemsArray, false] call Zen_ArrayGetRandom;
					[_itemPos, _thisItem, 0, (random 360), true] call Zen_SpawnVehicle;
				};
				_minAI = 3;
				_maxAI = 5;
				if (aiSkill == 1) then {	
					_minAI = 2;
					_maxAI = 4;
				};
				_spawnedSquad = [_thisPos, _side, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;				
				if (!isNil "_spawnedSquad") then {					
					0 = [_spawnedSquad, _thisPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
				};
				_objectivePos = _thisPos;
				
			};
			case "WRECK": {
				// Destroy target
				//_thisPos = [_pos, 0, 200, 10, 0, 10, 0] call BIS_fnc_findSafePos;
				_thisPos = [];
				_wreckType = "";
				_wreckType = selectRandom _pVehicleWreckClasses;
				while {count _wreckType == 0} do {
					_wreckType = selectRandom _pVehicleWreckClasses;
				};
				if (_wreckType isKindOf "Helicopter") then {
					_thisPos = AO_flatPositions select 0;
					AO_flatPositions = AO_flatPositions - [_thisPos];
				} else {
					_posChance = (random 100);
					if (_posChance > 50) then {
						_thisPos = AO_flatPositions select 0;
						AO_flatPositions = AO_flatPositions - [_thisPos];
					} else {
						if (count AO_roadPosArray > 0) then {
							_thisPos = AO_roadPosArray select 0;
							AO_roadPosArray = AO_roadPosArray - [_thisPos];
						} else {
							_thisPos = AO_flatPositions select 0;
							AO_flatPositions = AO_flatPositions - [_thisPos];
						};						
					};
				};
				
				_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
				_thisPos = _tempPos;
				
				// Create objective
				// Marker
				_markerName = format["wreckMkr%1", floor(random 10000)];
				_markerWreck = createMarker [_markerName, _thisPos];
				_markerWreck setMarkerShape "ICON";
				_markerWreck setMarkerType  "n_motor_inf";
				_markerWreck setMarkerColor _markerColorPlayers;
				_markerWreck setMarkerAlpha 0;								
				
				// Create Task				
				_wreckName = ((configFile >> "CfgVehicles" >> _wreckType >> "displayName") call BIS_fnc_GetCfgData);
				
				_taskName = format ["task%1", floor(random 100000)];
				_taskTitle = "Destroy Wreck";
				_taskDesc = format ["Deny the enemy use of our wrecked %1 located at the <marker name='%2'>marked area</marker>. Destroy the wreck by any means available.", _wreckName, _markerName];
				_thisTask = _taskName;
				[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;	
												
				_wreck = _wreckType createVehicle _thisPos;				
				_wreck setVariable ["task", _thisTask];
				// Add destruction event handler
				_wreck addEventHandler ["Killed", {
					(_this select 1)  addRating 7000;
					[((_this select 0) getVariable ('task')), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;						
				} ];				
								
				_wreck setVehicleAmmo 0;
				_wreck setDamage 0.7;
				_wreck setFuel 0;
				_wreck lock true;
				_wreck setDir (random 360);
				
				_emitter = "#particlesource" createVehicleLocal _thisPos;
				_emitter setParticleClass "BigDestructionSmoke";
				_emitter setParticleFire [0.3,1.0,0.1];
				
				// Create guards
				_minAI = 3;
				_maxAI = 5;
				if (aiSkill == 1) then {	
					_minAI = 2;
					_maxAI = 4;
				};
				_spawnedSquad = [_thisPos, _side, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;									
				if (!isNil "_spawnedSquad") then {	
					0 = [_spawnedSquad, _thisPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
				};
				_objectivePos = _thisPos;
				
			};
			case "BOX": {
				// Destroy target
				//_thisPos =  [AO_flatPositions, true] call Zen_ArrayGetRandom;
				_thisPos = AO_flatPositions select 0;
				AO_flatPositions = AO_flatPositions - [_thisPos];
				
				_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
				_thisPos = _tempPos;
				
				// Create objective
				_boxType = "";
				if (count eAmmoClasses > 0) then {
					_boxType = selectRandom eAmmoClasses;
				} else {
					_boxType = "I_supplyCrate_F";
				};
				
				// Create marker
				_markerName = format["boxMkr%1", floor(random 10000)];
				_markerBox = createMarker [_markerName, _thisPos];
				_markerBox setMarkerShape "ICON";
				_markerBox setMarkerType  "mil_destroy";
				//_markerBox setMarkerSize [3, 3];
				_markerBox setMarkerColor _markerColorEnemy;
				_markerBox setMarkerAlpha 0;
				
				// Create Task
				_boxName = ((configFile >> "CfgVehicles" >> _boxType >> "displayName") call BIS_fnc_GetCfgData);
				
				_taskName = format ["task%1", floor(random 100000)];
				_taskTitle = "Destroy Cache";
				_taskDesc = format ["Destroy the %1 ammunition cache.", enemyFactionName];
				_thisTask = _taskName;
				[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;	
							
				_box1 = _boxType createVehicle _thisPos;
				_box1 setDir (random 360);
				_box2 = _boxType createVehicle _thisPos;
				_box2 setDir (random 360);
				_box3 = _boxType createVehicle _thisPos;
				_box3 setDir (random 360);
				
				// Add destruction event handler
				// Create trigger				
				_trgComplete = createTrigger ["EmptyDetector", _thisPos, true];
				_trgComplete setTriggerArea [0, 0, 0, false];
				_trgComplete setTriggerActivation ["ANY", "PRESENT", false];
				_trgComplete setTriggerStatements [
					"
						!alive (thisTrigger getVariable 'box1') &&
						!alive (thisTrigger getVariable 'box2') &&			
						!alive (thisTrigger getVariable 'box3') 			
					",
					"				
						[(thisTrigger getVariable 'thisTask'), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;										
					", 
					""];
				_trgComplete setVariable ["box1", _box1];
				_trgComplete setVariable ["box2", _box2];
				_trgComplete setVariable ["box3", _box3];
				_trgComplete setVariable ["thisTask", _thisTask];
										
				// Create guards and fortifications
				// Populate corner points
				_startDir = random 360;	
				_cornerFortClasses = ["Land_BagBunker_Small_F"];	
				
				_dir = (_startDir - 45);
				_rotation = (_startDir - 180);
				for "_i" from 1 to 4 do {
					_popChance = (random 100);
					if (_popChance > 40) then {
						_cornerPos = [_thisPos, 10, _dir] call Zen_ExtendPosition;
						if (_popChance > 70) then {
							// Corner bunker							
							_cornerClass = [_cornerFortClasses, false] call Zen_ArrayGetRandom;
							_corner = [_cornerPos, _cornerClass, 0, _rotation, true] call Zen_SpawnVehicle;
											
							// Create guard							
							_group = [_cornerPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
							_unit = ((units _group) select 0);
							if (!isNil "_unit") then {
								_unitDir = (_rotation-180);
								_unit setFormDir _unitDir;
								_unit setDir _unitDir;
							};
						};
						// Corner fortifications
						_cornerFortExtraClasses = ["Land_Razorwire_F", "Land_BagFence_Long_F"];
						_cornerFortPos1 = [_cornerPos, 5, (_dir-45)] call Zen_ExtendPosition;
						_cornerFortPos2 = [_cornerPos, 5, (_dir+45)] call Zen_ExtendPosition;
						
						_cornerFortClass = [_cornerFortExtraClasses, false] call Zen_ArrayGetRandom;
						_cornerFortObject1 = [_cornerFortPos1, _cornerFortClass, 0, (_rotation - 90), true] call Zen_SpawnVehicle;
						_cornerFortObject2 = [_cornerFortPos2, _cornerFortClass, 0, (_rotation), true] call Zen_SpawnVehicle;
						
						_dir = _dir + 90;
						_rotation = _rotation + 90;
					};
				};
				_minAI = 3;
				_maxAI = 5;
				if (aiSkill == 1) then {	
					_minAI = 2;
					_maxAI = 4;
				};
				_spawnedSquad = [_thisPos, _side, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;				
				if (!isNil "_spawnedSquad") then {		
					0 = [_spawnedSquad, _thisPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
				};
				_objectivePos = _thisPos;
				
			};
			case "POWER": {
				// Destroy target			
				_thisPos = AO_flatPositions select 0;
				AO_flatPositions = AO_flatPositions - [_thisPos];
				
				_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
				_thisPos = _tempPos;
				
				// Available classes
				_powerObjects = ["Land_spp_Panel_F", "Land_PowLines_Transformer_F", "Land_SolarPanel_1_F", "Land_TTowerSmall_1_F"];
				_powerFences = ["Land_Net_Fence_8m_F", "Land_Net_FenceD_8m_F"];
				_powerTypes = ["Land_dp_transformer_F", "Land_PowerGenerator_F"];
								
				// Create objective generator
				_powerType = [_powerTypes, false] call Zen_ArrayGetRandom;	
				_positionArray = [3,3,_thisPos,8] call f_getnearbyPositionsbyParm;
				_powerPos = _positionArray select 4;
				_positionArray = _positionArray - [_powerPos];
				diag_log _positionArray;
				// Create marker
				_markerName = format["powerMkr%1", floor(random 10000)];
				_markerPower = createMarker [_markerName, _thisPos];
				_markerPower setMarkerShape "ICON";
				_markerPower setMarkerType  "loc_Power";
				_markerPower setMarkerSize [1, 1];
				_markerPower setMarkerColor _markerColorEnemy;
				_markerPower setMarkerAlpha 0;
				
				// Create Task
				_powerName = ((configFile >> "CfgVehicles" >> _powerType >> "displayName") call BIS_fnc_GetCfgData);
				_powerUnit = _powerType createVehicle _thisPos;
				_taskName = format ["task%1", floor(random 100000)];
				_taskTitle = "Destroy Power Relay";
				_taskDesc = format ["Destroy the %2 to disrupt power to the %1 controlled area.", enemyFactionName, _powerName];
				
				_thisTask = _taskName;
				[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;					
				_powerUnit setVariable ["thisTask", _thisTask];
								
				// Add destruction event handler
				_powerUnit addEventHandler ["Explosion", {
					if ((_this select 1) > 0.2) then {
						(_this select 0) setdamage 1;
						{
							deleteVehicle _x;
						} forEach ((_this select 0) getVariable 'objects');
						_taskState = [((_this select 0) getVariable 'thisTask')] call BIS_fnc_taskState;
						diag_log _taskState;
						if (_taskState != "SUCCEEDED") then {
							[((_this select 0) getVariable 'thisTask'), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
						};
						(_this select 0) removeAllEventHandlers "Explosion";
						(_this select 0) removeAllEventHandlers "Killed";
					};
				}];
				
				_powerUnit addEventHandler ["Killed", {			
					{
						deleteVehicle _x;
					} forEach ((_this select 0) getVariable 'objects');
					_taskState = [((_this select 0) getVariable 'thisTask')] call BIS_fnc_taskState;
					diag_log _taskState;
					if (_taskState != "SUCCEEDED") then {
						[((_this select 0) getVariable 'thisTask'), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
					};
					(_this select 0) removeAllEventHandlers "Explosion";
					(_this select 0) removeAllEventHandlers "Killed";
				}];				
										
				// Create extra fluff items
				{
					_chance = random 100;
					if (_chance > 30) then {
						_objectClass = [_powerObjects, false] call Zen_ArrayGetRandom;
						_object = [_x, _objectClass, 0, 0, true] call Zen_SpawnVehicle;
					};
				} forEach _positionArray;
				
				// Create fences
				_startDir = 0;
				_rotation = (_startDir);
				_dir = (_startDir);
				_gateSide = [1,4] call BIS_fnc_randomInt;
				for "_i" from 1 to 4 do {
				
					_fencePos1 = [_thisPos, 12, _dir] call Zen_ExtendPosition;					
					_fencePos2 = [_fencePos1, 8, (_dir-90)] call Zen_ExtendPosition;					
					_fencePos3 = [_fencePos1, 8, (_dir+90)] call Zen_ExtendPosition;	
					
					_fenceClass1 = "";
					if (_i == _gateSide) then {
						_fenceClass1 = "Land_Net_Fence_Gate_F";
					} else {
						_fenceClass1 = [_powerFences, false] call Zen_ArrayGetRandom;
					};					
					_fenceClass2 = [_powerFences, false] call Zen_ArrayGetRandom;
					_fenceClass3 = [_powerFences, false] call Zen_ArrayGetRandom;
					
					_fenceObject1 = [_fencePos1, _fenceClass1, 0, _rotation, true] call Zen_SpawnVehicle;					
					_fenceObject2 = [_fencePos2, _fenceClass2, 0, _rotation, true] call Zen_SpawnVehicle;					
					_fenceObject3 = [_fencePos3, _fenceClass3, 0, _rotation, true] call Zen_SpawnVehicle;	
					
					_dir = _dir + 90;
					_rotation = _rotation + 90;
				};		
				_minAI = 3;
				_maxAI = 5;
				if (aiSkill == 1) then {	
					_minAI = 2;
					_maxAI = 4;
				};
				_spawnedSquad = [_thisPos, _side, eInfClassesForWeights, eInfClassWeights, [_minAI,_maxAI]] call dro_spawnGroupWeighted;				
				if (!isNil "_spawnedSquad") then {	
					0 = [_spawnedSquad, _thisPos, [14, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
				};
				_powerUnit addEventHandler ["Killed", { 
					{
						_x setHit ["light_1_hitpoint", 0.97];
						_x setHit ["light_2_hitpoint", 0.97];
						_x setHit ["light_3_hitpoint", 0.97];
						_x setHit ["light_4_hitpoint", 0.97];
					} forEach nearestObjects [player, [
						"Lamps_base_F",
						"PowerLines_base_F",
						"PowerLines_Small_base_F"
					], 500];
				} ];
				
				_objectivePos = _thisPos;
				
			};
		};
	};
	
	case "POW": {
		// POW
		_powPos = [];
		_powStyle = selectRandom _powStyles;					
		
		_powChar = nil;
		_spawnedSquad = nil;
		_spawnedSquad2 = nil;
		
		_powClass = "";		
		_powClass = selectRandom pInfClasses;
		
		
		switch (_powStyle) do {			
			case "OUTSIDE": {
				// Move to random location				
				//_powPos = [AO_forestPositions, true] call Zen_ArrayGetRandom;
				_powPos = AO_forestPositions select 0;
				AO_forestPositions = AO_forestPositions - [_powPos];
				
				_tempPos = [(_powPos select 0), (_powPos select 1), 0];
				_powPos = _tempPos;
				
				_powSpawnPos = [];
				_powSpawnPos = [_powPos, 0, 150, 1.5, 0, 50, 0] call BIS_fnc_findSafePos;
				if (count _powSpawnPos > 0) then {
					_powPos = _powSpawnPos;
				};				
				
				_campObjects = [
					"Land_CampingTable_F",
					"Land_Camping_Light_F",
					"Land_CampingChair_V2_F",
					"Land_GasTank_01_khaki_F",
					"Land_Pillow_old_F",
					"Land_Ground_sheet_khaki_F",
					"Land_TentA_F",
					"Land_TentDome_F",
					"Land_WoodenLog_F",
					"Land_WoodPile_F",
					"Land_WoodPile_large_F",
					"Land_Garbage_square3_F",
					"Land_GarbageBags_F",					
					"Land_JunkPile_F"
				];
				_numCampObjects = [3,8] call BIS_fnc_randomInt;
				for "_i" from 1 to _numCampObjects do {
					_spawnPos = [_powPos, (1.5 + random 3), (random 360)] call Zen_ExtendPosition;
					_selectedObject = [_campObjects, false] call Zen_ArrayGetRandom;
					_object = createVehicle [_selectedObject, _spawnPos, [], 2, "NONE"];
					_object setDir (random 360);
				};
								
				_group = createGroup side player;
				_powChar = _group createUnit [_powClass, _powPos, [], 0, "NONE"];
				//_spawnedGroup = [_powSpawnPos, _powClass] call Zen_SpawnGroup;	
				//_powChar = (units _spawnedGroup) select 0;				
				
				/*
				_garMarker = createMarker [format["garMkr%1", random 10000], getPos _powChar];
				_garMarker setMarkerShape "ICON";
				_garMarker setMarkerColor "ColorOrange";
				_garMarker setMarkerType "mil_objective";
				*/				
			};
			case "INSIDE": {	
				// If nearby building possible then move to that building and spawn guards
				_building = [AO_buildingPositions, true] call Zen_ArrayGetRandom;
				_buildingPlaces = [_building] call BIS_fnc_buildingPositions;
				_thisBuildingPlace = [0,((count _buildingPlaces)-1)] call BIS_fnc_randomInt;				
				_powPos = getPos _building;
				
				_group = createGroup side player;
				_powChar = _group createUnit [_powClass, _powPos, [], 0, "NONE"];
				//_spawnedGroup = [_powPos, _powClass] call Zen_SpawnGroup;	
				//_powChar = (units _spawnedGroup) select 0;			
				_powChar setPosATL (_building buildingPos _thisBuildingPlace);				
				
				/*
				_garMarker = createMarker [format["garMkr%1", random 10000], getPos _powChar];
				_garMarker setMarkerShape "ICON";
				_garMarker setMarkerColor "ColorOrange";
				_garMarker setMarkerType "mil_objective";
				*/
			};		
		};
		
		_powChar setCaptive true;
		_powChar disableAI "MOVE";	 
		_powChar removeWeaponGlobal (primaryWeapon _powChar);
		_powChar removeWeaponGlobal (secondaryWeapon _powChar);
		_powChar removeWeaponGlobal (handgunWeapon _powChar);	
		removeVest _powChar;
		removeHeadgear _powChar;
		removeGoggles _powChar;
		removeBackpack _powChar;
		removeAllItems _powChar;
		//_powChar setUnitPos "MIDDLE";	
		[[_powChar], "sun_aiNudge"] call BIS_fnc_MP;	
		
	
		// Spawn patrolling guards
		_minAI = 2;
		_maxAI = 3;
		if (aiSkill == 1) then {	
			_minAI = 1;
			_maxAI = 2;
		};
		_spawnedSquad = [_powPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;						
		if (!isNil "_spawnedSquad") then {	
			0 = [_spawnedSquad, _powPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
		};
		_spawnedSquad2 = [_powPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;		
		if (!isNil "_spawnedSquad2") then {			
			[_spawnedSquad2, getPos _powChar] call bis_fnc_taskDefend;
		};
		_allGuards = (((units(_spawnedSquad)))+(units(_spawnedSquad2)));
		
		// Marker
		_markerPos = [_powPos, 0, 150, 0, 1, 100, 0] call BIS_fnc_findSafePos;
		
		_markerName = format["powMkr%1", floor(random 10000)];
		_markerPOW = createMarker [_markerName, _markerPos];
		_markerPOW setMarkerShape "ELLIPSE";
		_markerPOW setMarkerBrush "Solid";
		_markerPOW setMarkerColor _markerColorPlayers;
		_markerPOW setMarkerSize [170, 170];
		_markerPOW setMarkerAlpha 0.5;
		
		// Create Task		
		_powName = ((configFile >> "CfgVehicles" >> _powClass >> "displayName") call BIS_fnc_GetCfgData);
		
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Rescue Captive";
		_taskDesc = format ["Locate and rescue the captured %1. We believe the target is being held by the %3 somewhere within the <marker name='%2'>marked area</marker>. Exercise caution; we have every reason to believe the target will be executed if the enemy feels threatened.", _powName, _markerPOW, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _markerPos, "CREATED", 1, false, "meet", false] call BIS_fnc_taskCreate;	
				
		 // Add triggers
		_trgFail = createTrigger ["EmptyDetector", _powPos, true];
		_trgFail setTriggerArea [0, 0, 0, false];
		_trgFail setTriggerActivation ["ANY", "PRESENT", false];
		_trgFail setTriggerStatements [
			"
				!alive (thisTrigger getVariable 'powChar')
			",
			"				
				[(thisTrigger getVariable 'thisTask'), 'FAILED', true] spawn BIS_fnc_taskSetState;										
			", 
			""];
		_trgFail setVariable ["powChar", _powChar];		
		_trgFail setVariable ["thisTask", _thisTask];
		
		_trgExecute = createTrigger ["EmptyDetector", _powPos, true];
		_trgExecute setTriggerArea [200, 200, 0, false];
		_trgExecute setTriggerActivation ["ANY", "PRESENT", false];
		_trgExecute setTriggerStatements [
			"
				({alive _x} count (thisTrigger getVariable 'allGuards')) < ((count (thisTrigger getVariable 'allGuards')) * 0.2)
			",
			"				
				(thisTrigger getVariable 'pow') setCaptive false;				
			", 
			""];
		_trgExecute setVariable ["allGuards", _allGuards];
		_trgExecute setVariable ["pow", _powChar];
		
		_trgJoin = createTrigger ["EmptyDetector", (getPos _powChar), true];
		_trgJoin setTriggerArea [2, 2, 0, false];
		_trgJoin setTriggerActivation ["ANY", "PRESENT", false];
		_trgJoin setTriggerStatements [
			"
				(alive (thisTrigger getVariable 'pow')) && (({_x in thisList} count (units group player)) > 0)
			",
			"				
				[(thisTrigger getVariable 'pow')] join (group player);
				(thisTrigger getVariable 'pow') enableAI 'MOVE';
                (thisTrigger getVariable 'pow') setCaptive false;
				[(thisTrigger getVariable 'thisTask'), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;				
			", 
			""];
		_trgJoin setTriggerTimeout [1, 1, 2, false];
		_trgJoin setVariable ["pow", _powChar];
		_trgJoin setVariable ["thisTask", _thisTask];		
		
		_objectivePos = _powPos;
		
	};
	case "VEHICLE": {
		// Vehicle target
		_vehicleList = eCarClasses;
		_vehicleType = [_vehicleList, false] call Zen_ArrayGetRandom;		
		//_thisPos = [AO_roadPosArray, true] call Zen_ArrayGetRandom;
		_thisPos = AO_roadPosArray select 0;
		AO_roadPosArray = AO_roadPosArray - [_thisPos];
		
		// Marker
		_markerName = format["vehMkr%1", floor(random 10000)];
		_markerVehicle = createMarker [_markerName, _thisPos];
		_markerVehicle setMarkerShape "ICON";
		_markerVehicle setMarkerType  "o_motor_inf";
		_markerVehicle setMarkerColor _markerColorEnemy;
		_markerVehicle setMarkerAlpha 0;
		
		// Create Task		
		_vehicleName = ((configFile >> "CfgVehicles" >> _vehicleType >> "displayName") call BIS_fnc_GetCfgData);
		
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Destroy Vehicle";
		_taskDesc = format ["Destroy the %3 %1 at the <marker name='%2'>marked location</marker>.", _vehicleName, _markerName, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "truck", false] call BIS_fnc_taskCreate;	
				
		_thisVeh = _vehicleType createVehicle _thisPos;	
		_roads = _thisVeh nearRoads 50;
		_dir = 0;
		if (count _roads > 0) then {
			_firstRoad = _roads select 0;
			if (count (roadsConnectedTo _firstRoad) > 0) then {			
				_connectedRoad = ((roadsConnectedTo _firstRoad) select 0);
				_dir = [_firstRoad, _connectedRoad] call BIS_fnc_dirTo;
				_thisVeh setDir _dir;
			} else {
				_thisVeh setDir (random 360);
			};
		};
		// Find any doors to animate
		{ 
			if ( ((configFile >> "CfgVehicles" >> _vehicleType >> "AnimationSources" >> (configName _x) >> "source") call BIS_fnc_GetCfgData) == "door") then {
				_thisVeh animateDoor [(configName _x), 1, true];
			};
		} forEach ("true" configClasses (configFile >> "CfgVehicles" >> _vehicleType >> "AnimationSources"));
		
		// Create fluff objects
		_loadingChance = random 100;
		if (_loadingChance > 50) then {
			_itemsArray = [		
				"CargoNet_01_barrels_F",
				"CargoNet_01_box_F",			
				"Land_PaperBox_closed_F",
				"Land_PaperBox_open_empty_F",
				"Land_PaperBox_open_full_F",
				"Land_Pallet_MilBoxes_F",
				"Land_Pallets_F",
				"Land_Pallet_F"					
			];
			_item1Pos = [getPos _thisVeh, 5, (_dir - 155)] call Zen_ExtendPosition;
			_item2Pos = [_item1Pos, 1.5, (_dir - 180)] call Zen_ExtendPosition;
			_item1 = selectRandom _itemsArray;
			_item2 = selectRandom _itemsArray;
			[_item1Pos, _item1, 0, _dir] call Zen_SpawnVehicle;
			[_item2Pos, _item2, 0, _dir] call Zen_SpawnVehicle;
		};
		
		_guardPos = [getPos _thisVeh, 5, (_dir - 180)] call Zen_ExtendPosition;		
		_group = [_guardPos, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
		_unit = ((units _group) select 0);
				
		_thisVeh setVariable ["thisTask", _thisTask];
		
		// Add destruction event handler
		_thisVeh addEventHandler ["Killed", {
			[((_this select 0) getVariable ("thisTask")), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;			
		} ];
				
		_spawnPos = [_thisPos, 6, (random 360)] call Zen_ExtendPosition;
		_minAI = 3;
		_maxAI = 5;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 4;
		};
		_spawnedSquad = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;			
		if (!isNil "_spawnedSquad") then {
			0 = [_spawnedSquad, _thisPos, [10, 30], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
		};
		_objectivePos = _thisPos;
		
	};
	case "ARTY": {
		// Destroy Artillery emplacement
		//_thisPos = [AO_flatPositions, true] call Zen_ArrayGetRandom;
		_thisPos = AO_flatPositions select 0;
		AO_flatPositions = AO_flatPositions - [_thisPos];
		
		_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
		_thisPos = _tempPos;
		
		_vehicleList = eArtyClasses;
		_vehicleType = [_vehicleList, false] call Zen_ArrayGetRandom;
				
		// Marker
		_markerName = format["artMkr%1", floor(random 10000)];
		_markerArty = createMarker [_markerName, _thisPos];
		_markerArty setMarkerShape "ICON";
		_markerArty setMarkerType  "o_art";
		_markerArty setMarkerColor _markerColorEnemy;
		_markerArty setMarkerAlpha 0;		
		
		// Create Task		
		_artyName = ((configFile >> "CfgVehicles" >> _vehicleType >> "displayName") call BIS_fnc_GetCfgData);
		
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Destroy Artillery";
		_taskDesc = format ["Destroy the %3 %1 artillery emplacement at the <marker name='%2'>marked location</marker>.", _artyName, _markerName, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;	
				
		_thisVeh = _vehicleType createVehicle _thisPos;			
		_thisVeh setVariable ["thisTask", _thisTask];
		
		// Add destruction event handler
		_thisVeh addEventHandler ["Killed", {
			[((_this select 0) getVariable ("thisTask")), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
		} ];
		
		// Create fortifications
		_dir = direction _thisVeh;
		_rotation = (_dir - 45);
		for "_i" from 1 to 4 do {
			_cornerPos = [getPos _thisVeh, 16, _dir] call Zen_ExtendPosition;
			_corner = [_cornerPos, "Land_HBarrierWall_corner_F", 0, _rotation, true] call Zen_SpawnVehicle;
			_dir = _dir + 90;
			_rotation = _rotation + 90;
		};
		
		_randItems = [4,10] call BIS_fnc_randomInt;
		_itemsArray = [
			"Land_CargoBox_V1_F",
			"Land_Cargo10_grey_F",
			"Land_Cargo10_military_green_F",
			"CargoNet_01_barrels_F",
			"CargoNet_01_box_F",
			"Land_MetalBarrel_F",
			"Land_PaperBox_closed_F",
			"Land_PaperBox_open_empty_F",
			"Land_PaperBox_open_full_F",
			"Land_Pallet_MilBoxes_F",
			"Land_Pallets_F",
			"Land_Pallet_F"			
		];
		for "_i" from 1 to _randItems do {
			_itemPos = [_thisPos, 8, 20, 1, 0, 1, 0] call BIS_fnc_findSafePos;
			_thisItem = [_itemsArray, false] call Zen_ArrayGetRandom;
			[_itemPos, _thisItem, 0, (random 360)] call Zen_SpawnVehicle;
		};
		
		// Create a bunker object and spawn enemies to guard it
		_netPos = [_thisPos, 10, 40, 5, 0, 10, 0] call BIS_fnc_findSafePos;
			
		_net = "CamoNet_INDP_big_F" createVehicle _netPos;
		_net setDir (random 360);
		_minAI = 3;
		_maxAI = 5;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 4;
		};
		_spawnedSquad = [_netPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;		
		if (!isNil "_spawnedSquad") then {
			[_spawnedSquad, _netPos] call bis_fnc_taskDefend;
		};
		_objectivePos = _thisPos;
		
	};
	case "BUILDING": {
		// Destroy building
		
		// Find a random building in the area
		_building = [AO_buildingPositions, true] call Zen_ArrayGetRandom;
		_buildingClass = typeOf _building;		
		_buildingPos = getPos _building;
			
		// Populate building
		_buildingPositions = [_building] call BIS_fnc_buildingPositions;
		_buildingPositionsShuffled = _buildingPositions call BIS_fnc_arrayShuffle;
		diag_log _buildingPositionsShuffled;
		_targetArray = ["Land_Pallet_MilBoxes_F", "Land_DataTerminal_01_F", "Land_PaperBox_open_full_F", "MapBoard_altis_F", "Land_MetalBarrel_F"];
		_spawnedObjects = [];
		_infCount = 0;
		{
			if ((count _spawnedObjects) < 6) then {
				_thisTarget = selectRandom _targetArray;
				_object = [_x, _thisTarget, 0, 0, true] call Zen_SpawnVehicle;
				if (!isNil "_object") then {
					_spawnedObjects pushBack _object;
				};
			} else {	
				if (_infCount < 6) then {
					_group = [_x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
					_unit = ((units _group) select 0);									
					if (!isNil "_unit") then {
						_unit setUnitPos "UP";
						_infCount = _infCount + 1;
					};					
				};
			};		
		} forEach _buildingPositionsShuffled;
		
		// Spawn enemies to guard the building
		_minAI = 2;
		_maxAI = 5;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 3;
		};
		_spawnedSquad2 = [getPos _building, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;				
		if (!isNil "_spawnedSquad2") then {
			[_spawnedSquad2, getPos _building, 100] call bis_fnc_taskPatrol;
		};
		// Marker
		_markerName = format ["structureMkr%1", random 10000];
		_markerBuilding = createMarker [_markerName, _buildingPos];
		_markerBuilding setMarkerShape "ICON";
		_markerBuilding setMarkerType "mil_destroy";
		_markerBuilding setMarkerSize [1, 1];
		_markerBuilding setMarkerColor _markerColorEnemy;
		_markerBuilding setMarkerAlpha 0;
		
		
		// Create task
		_taskName = format ["task%1", floor(random 10000)];
		_taskTitle = "Destroy Structure";
		_buildingName = ((configFile >> "CfgVehicles" >> _buildingClass >> "displayName") call BIS_fnc_GetCfgData);
		_taskDesc = format ["Destroy the %2 containing %1 strategic elements at the marked <marker name='%3'>location</marker>.",enemyFactionName, _buildingName, _markerName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _buildingPos, "CREATED", 1, false, "destroy", false] call BIS_fnc_taskCreate;	
				
		_building setVariable ["thisTask", _thisTask];
		_building setVariable ["objects", _spawnedObjects];

		// Add destruction event handler
		_building addEventHandler ["Explosion", {
			if ((_this select 1) > 0.2) then {
				(_this select 0) setdamage 1;
				{
					deleteVehicle _x;
				} forEach ((_this select 0) getVariable 'objects');
				_taskState = [((_this select 0) getVariable 'thisTask')] call BIS_fnc_taskState;
				diag_log _taskState;
				if (_taskState != "SUCCEEDED") then {
					[((_this select 0) getVariable 'thisTask'), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
				};
				(_this select 0) removeAllEventHandlers "Explosion";
			};
		}];
		
		_building addEventHandler ["Killed", {			
			{
				deleteVehicle _x;
			} forEach ((_this select 0) getVariable 'objects');
			_taskState = [((_this select 0) getVariable 'thisTask')] call BIS_fnc_taskState;
			diag_log _taskState;
			if (_taskState != "SUCCEEDED") then {
				[((_this select 0) getVariable 'thisTask'), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
			};			
			(_this select 0) removeAllEventHandlers "Killed";
		}];
		
		_objectivePos = _buildingPos;
				
	};
	case "HELI": {
		// Destroy helicopter
		
		_vehicleList = eHeliClasses;
		_vehicleType = [_vehicleList, false] call Zen_ArrayGetRandom;
		
		
		_helipadUsed = 0;
		_thisPos = [];		
		if (count AO_helipads > 0) then {			
			_thisPos = getPos (AO_helipads select 0);
			AO_helipads = AO_helipads - [(AO_helipads select 0)];
			_helipadUsed = 1;
		} else {
			_thisPos = AO_flatPositions select 0;
			AO_flatPositions = AO_flatPositions - [_thisPos];
			
			_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
			_thisPos = _tempPos;			
		};		
		
			
		// Marker
		_markerName = format["heliMkr%1", floor(random 10000)];
		_markerHeli = createMarker [_markerName, _thisPos];
		_markerHeli setMarkerShape "ICON";
		_markerHeli setMarkerType  "o_air";
		_markerHeli setMarkerColor _markerColorEnemy;
		_markerHeli setMarkerAlpha 0;		
		
		// Create Task		
		_heliName = ((configFile >> "CfgVehicles" >> _vehicleType >> "displayName") call BIS_fnc_GetCfgData);
		
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Destroy Helicopter";
		_taskDesc = format ["Destroy the %3 %1 helicopter at the <marker name='%2'>marked location</marker>. Exercise caution, if the crew realise they are under threat they may decide to fly the helicopter out of the AO.", _heliName, _markerName, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "gunship", false] call BIS_fnc_taskCreate;	
				
		_thisVeh = _vehicleType createVehicle _thisPos;	
		createVehicleCrew _thisVeh;			
		_thisVeh setVariable ["thisTask", _thisTask];			
		
		// Add destruction event handler
		_thisVeh addEventHandler ["Killed", {
			[((_this select 0) getVariable ("thisTask")), "SUCCEEDED", true] spawn BIS_fnc_taskSetState;
		} ];
		
		// Create helipad and emplacements
		if (_helipadUsed == 0) then {
			_startDir = random 360;
			[_thisPos, "Land_HelipadSquare_F", 0, (_startDir+45), true] call Zen_SpawnVehicle;
			_dir = _startDir;
			_rotation = (_startDir - 45);
			for "_i" from 1 to 4 do {
				_cornerPos = [_thisPos, 16, _dir] call Zen_ExtendPosition;
				_corner = [_cornerPos, "Land_HBarrierWall_corner_F", 0, _rotation, true] call Zen_SpawnVehicle;
				_lightPos = [_thisPos, 10, _dir] call Zen_ExtendPosition;
				_light = [_lightPos, "PortableHelipadLight_01_red_F", 0, _rotation, true] call Zen_SpawnVehicle;
				_dir = _dir + 90;
				_rotation = _rotation + 90;
			};
			
			_towerPos = [_thisPos, 20, random 360] call Zen_ExtendPosition;
			[_towerPos, "Land_HBarrierTower_F", 0, (_startDir+45)] call Zen_SpawnVehicle;
		} else {
			_thisPad = nearestObject [_thisPos, "HeliH"];
			_dir = (getDir _thisPad);
			for "_i" from 1 to 4 do {				
				_lightPos = [_thisPos, 10, _dir] call Zen_ExtendPosition;
				_light = [_lightPos, "PortableHelipadLight_01_red_F", 0, _dir, true] call Zen_SpawnVehicle;
				_dir = _dir + 90;				
			};
		};
		
		_randItems = floor (random 4);
		_itemsArray = ["Land_AirIntakePlug_05_F", "Land_DieselGroundPowerUnit_01_F", "Land_HelicopterWheels_01_assembled_F", "Land_HelicopterWheels_01_disassembled_F", "Land_RotorCoversBag_01_F", "Windsock_01_F"];
		for "_i" from 1 to _randItems do {
			_itemPos = [_thisPos, 8, 20, 1, 0, 1, 0] call BIS_fnc_findSafePos;
			_thisItem = [_itemsArray, false] call Zen_ArrayGetRandom;
			[_itemPos, _thisItem, 0, (random 360)] call Zen_SpawnVehicle;
		};
		
		// Guards
		_minAI = 2;
		_maxAI = 4;
		if (aiSkill == 1) then {	
			_minAI = 1;
			_maxAI = 3;
		};
		_spawnedSquad = [_thisPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;						
		if (!isNil "_spawnedSquad") then {
			[_spawnedSquad, _thisPos] call bis_fnc_taskDefend;
		};
		_minAI = 2;
		_maxAI = 4;
		if (aiSkill == 1) then {	
			_minAI = 1;
			_maxAI = 3;
		};
		_spawnedSquad2 = [_thisPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;					
		if (!isNil "_spawnedSquad2") then {
			[_spawnedSquad2, _thisPos, 150] call bis_fnc_taskPatrol;				
		};
		// Create failstate trigger
		_trgPatrol = createTrigger ["EmptyDetector", _thisPos, true];
		_trgPatrol setTriggerArea [0, 0, 0, false];
		_trgPatrol setTriggerActivation ["ANY", "PRESENT", false];
		_trgPatrol setTriggerStatements [
			"
				{behaviour _x == 'COMBAT'} count [(thisTrigger getVariable 'heli')] > 0
			",
			"	
				[(thisTrigger getVariable 'heli'), getPos thisTrigger] spawn Zen_OrderAircraftPatrol;
			", 
			""];
		_trgPatrol setVariable ["heli", _thisVeh];
		
		_trgFlee = createTrigger ["EmptyDetector", _thisPos, true];
		_trgFlee setTriggerArea [0, 0, 0, false];
		_trgFlee setTriggerActivation ["ANY", "PRESENT", false];
		_trgFlee setTriggerStatements [
			"
				{behaviour _x == 'COMBAT'} count [(thisTrigger getVariable 'heli')] > 0
			",
			"	
				_fleePos = [getPos (thisTrigger getVariable 'heli'), 3500, (random 360)] call Zen_ExtendPosition;
				[(thisTrigger getVariable 'heli'), _fleePos] spawn Zen_OrderVehicleMove;
			", 
			""];
		_trgFlee setTriggerTimeout [180, 250, 300, true];			
		_trgFlee setVariable ["heli", _thisVeh];
		
		_trgFail = createTrigger ["EmptyDetector", _thisPos, true];
		_trgFail setTriggerArea [2500, 2500, 0, false];
		_trgFail setTriggerActivation ["ANY", "PRESENT", false];
		_trgFail setTriggerStatements [
			"
				(alive (thisTrigger getVariable 'heli')) && 
				!((thisTrigger getVariable 'heli') in thisList) && 
				((thisTrigger getVariable 'heli') distance player > 1500)
			",
			"	
				[(thisTrigger getVariable 'thisTask'), 'FAILED', true] spawn BIS_fnc_taskSetState;				
				hideObject (thisTrigger getVariable 'heli');				
			", 
			""];
		_trgFail setVariable ["heli", _thisVeh];
		_trgFail setVariable ["thisTask", _thisTask];		
						
		_objectivePos = _thisPos;
	};
	case "CLEARLZ": {
		// Find suitable posision
		//_thisPos = [AO_flatPositions, true] call Zen_ArrayGetRandom;
		_posArr = [];
		_thisPos = [];
		if (count AO_flatPositions > 0) then {
			_posArr pushBack "AO_flatPositions";
		};
		if (count AO_forestPositions > 0) then {
			_posArr pushBack "AO_forestPositions";
		};
		_posSelect = selectRandom _posArr;
		switch (_posSelect) do {
			case "AO_flatPositions": {
				_thisPos = AO_flatPositions select 0;
				AO_flatPositions = AO_flatPositions - [_thisPos];
			};
			case "AO_forestPositions": {
				_thisPos = AO_forestPositions select 0;
				AO_forestPositions = AO_forestPositions - [_thisPos];
			};
		};
		
		_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
		_thisPos = _tempPos;	
		
		// Create area marker
		_markerName = format["areaMkr%1", floor(random 10000)];
		_markerArea = createMarker [_markerName, _thisPos];
		_markerArea setMarkerShape "ELLIPSE";
		_markerArea setMarkerBrush "Solid";
		_markerArea setMarkerColor _markerColorEnemy;
		_markerArea setMarkerSize [150, 150];
		_markerArea setMarkerAlpha 0.5;
				
		// Create guards
		//_spawnPos = [_thisPos, 0, 100, 1, 0, 30, 0] call BIS_fnc_findSafePos;
		_minAI = 2;
		_maxAI = 4;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 3;
		};
		_spawnedSquad = [_thisPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;				
		if (!isNil "_spawnedSquad") then {
			diag_log "spawned";
			0 = [_spawnedSquad, _thisPos, [0, 120], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;		
		};
		
		_minAI = 2;
		_maxAI = 4;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 3;
		};
		_spawnedSquad2 = [_thisPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;			
		if (!isNil "_spawnedSquad2") then {
			diag_log "spawned";
			0 = [_spawnedSquad2, _thisPos, [0, 120], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;
		};
		// Create Task
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Clear Area";
		_taskDesc = format ["Clear <marker name='%1'>marked area</marker> held by %2 troops.", _markerName, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "attack", false] call BIS_fnc_taskCreate;	
			
		// Create triggers
		_trgAreaClear = createTrigger ["EmptyDetector", _thisPos, true];
		_trgAreaClear setTriggerArea [150, 150, 0, false];
		_trgAreaClear setTriggerActivation ["ANY", "PRESENT", false];
		_trgAreaClear setTriggerStatements [
			"
					
				(({(side _x == (thisTrigger getVariable 'side')) && ((lifeState _x == 'HEALTHY') OR (lifeState _x == 'INJURED'))} count thisList) <= 0)
			",
			"				
				(getPos thisTrigger), (thisTrigger getVariable 'markerName') setMarkerAlpha 0;
				[(thisTrigger getVariable 'thisTask'), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;
			", 
			""];			
		_trgAreaClear setTriggerTimeout [5, 8, 10, true];
		_trgAreaClear setVariable ["side", _side];	
		_trgAreaClear setVariable ["markerName", _markerName];	
		_trgAreaClear setVariable ["thisTask", _thisTask];	
		
		_objectivePos = _thisPos;
		
	};
	case "CLEARBASE": {
		
		//_thisPos = [AO_flatPositions, true] call Zen_ArrayGetRandom;
		_thisPos = AO_flatPositions select 0;
		AO_flatPositions = AO_flatPositions - [_thisPos];
		
		_tempPos = [(_thisPos select 0), (_thisPos select 1), 0];
		_thisPos = _tempPos;
		
		// Create main base
		_startDir = random 360;		
		_HQ = [_thisPos, "Land_Cargo_HQ_V3_F", 0, _startDir, true] call Zen_SpawnVehicle;		
		// Create guards
		_buildingPositionsHQ = [_HQ] call BIS_fnc_buildingPositions;
		{ 
			_unitChance = (random 100);
			if (_unitChance > 50) then {
				_group = createGroup _side;
				_group = [_x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
				_unit = ((units _group) select 0);														
				_unit setFormDir (random 360);
				_unit setDir (random 360);
			};
		} forEach _buildingPositionsHQ;
		
		// Populate corner points		
		_cornerFortClasses = ["Land_Cargo_Patrol_V3_F", "Land_HBarrierTower_F"];	
		
		_dir = (_startDir - 45);
		_rotation = (_startDir - 180);
		for "_i" from 1 to 4 do {
			_popChance = (random 100);
			if (_popChance > 40) then {
				// Corner bunker
				_cornerPos = [_thisPos, 25, _dir] call Zen_ExtendPosition;
				_cornerClass = [_cornerFortClasses, false] call Zen_ArrayGetRandom;
				_corner = [_cornerPos, _cornerClass, 0, _rotation, true] call Zen_SpawnVehicle;
								
				// Create guards
				_buildingPositions = [_corner] call BIS_fnc_buildingPositions;
				{ 
					_unitChance = (random 100);
					if (_unitChance > 50) then {
						_group = [_x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
						_unit = ((units _group) select 0);						
						if (!isNil "_unit") then {						
							_unit setFormDir (_rotation-180);
							_unit setDir (_rotation-180);
						};
					};
				} forEach _buildingPositions;
				
				// Corner fortifications
				_cornerFortExtraClasses = ["Land_Razorwire_F", "Land_HBarrier_Big_F"];
				_cornerFortPos1 = [_cornerPos, 5.5, (_dir-45)] call Zen_ExtendPosition;
				_cornerFortPos2 = [_cornerPos, 5.5, (_dir+45)] call Zen_ExtendPosition;
				
				_cornerFortClass = [_cornerFortExtraClasses, false] call Zen_ArrayGetRandom;
				_cornerFortObject1 = [_cornerFortPos1, _cornerFortClass, 0, (_rotation - 90), true] call Zen_SpawnVehicle;
				_cornerFortObject2 = [_cornerFortPos2, _cornerFortClass, 0, (_rotation), true] call Zen_SpawnVehicle;
				
				_dir = _dir + 90;
				_rotation = _rotation + 90;
			};
		};
		
		// Populate side points
		_sideFortClasses = ["Land_Razorwire_F", "Land_HBarrier_Big_F", "Land_HBarrier_5_F"];
		_rotation = (_startDir);
		_dir = (_startDir);
		for "_i" from 1 to 4 do {
			_sidePos = [_thisPos, 20, _dir] call Zen_ExtendPosition;
			_sidePos2 = [_sidePos, 4.5, (_dir+90)] call Zen_ExtendPosition;
			_sidePos1 = [_sidePos, 4.5, (_dir-90)] call Zen_ExtendPosition;
			_sideClass = [_sideFortClasses, false] call Zen_ArrayGetRandom;
			_sideObject1 = [_sidePos1, _sideClass, 0, _rotation, true] call Zen_SpawnVehicle;
			_sideObject2 = [_sidePos2, _sideClass, 0, _rotation, true] call Zen_SpawnVehicle;
			_dir = _dir + 90;
			_rotation = _rotation + 90;
		};		

		// Marker
		_markerName = format["baseMkr%1", floor(random 10000)];
		_markerBase = createMarker [_markerName, _thisPos];
		_markerBase setMarkerShape "ICON";
		_markerBase setMarkerType "loc_Fortress";		
		_markerBase setMarkerSize [3.5, 3.5];			
		_markerBase setMarkerColor _markerColorEnemy;
		_markerBase setMarkerAlpha 0;		
		
		// Create Task						
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Clear Base";
		_taskDesc = format ["Clear the fortified %2 base at the <marker name='%1'>marked location</marker>.", _markerName, enemyFactionName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _thisPos, "CREATED", 1, false, "attack", false] call BIS_fnc_taskCreate;		
		
		// Create guards
		_spawnPos = [_thisPos, 0, 70, 1, 0, 30, 0] call BIS_fnc_findSafePos;
		_minAI = 2;
		_maxAI = 4;
		if (aiSkill == 1) then {	
			_minAI = 1;
			_maxAI = 3;
		};
		_spawnedSquad = [_spawnPos, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;				
		if (!isNil "_spawnedSquad") then {	
			0 = [_spawnedSquad, _thisPos, [0, 50], [0, 360], "limited", "safe"] spawn Zen_OrderInfantryPatrol;		
		};		
		// Create triggers
		_trgAreaClear = createTrigger ["EmptyDetector", _thisPos, true];
		_trgAreaClear setTriggerArea [100, 100, 0, false];
		_trgAreaClear setTriggerActivation ["ANY", "PRESENT", false];
		_trgAreaClear setTriggerStatements [
			"
				(({(side _x == (thisTrigger getVariable 'side')) && ((lifeState _x == 'HEALTHY') OR (lifeState _x == 'INJURED'))} count thisList) <= 0)
			",
			"
				[(thisTrigger getVariable 'thisTask'), 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;						
			", 
			""];
		_trgAreaClear setVariable ["thisTask", _thisTask];
		_trgAreaClear setVariable ["side", _side];		
		_objectivePos = _thisPos;
				
	};
	case "INTEL": {
		// intel object to be picked up
		// marks locations of enemy roadblocks, bunkers - handwriting]
				
		_building = [AO_buildingPositions, true] call Zen_ArrayGetRandom;
		_buildingClass = typeOf _building;	
		_buildingPos = getPos _building;
		_buildingPositions = [_building] call BIS_fnc_buildingPositions;
		
		// Populate building				
		_intelClasses = ["Land_MetalCase_01_medium_F", "Land_MetalCase_01_small_F", "Land_Suitcase_F"];
		_intelClass = [_intelClasses, false] call Zen_ArrayGetRandom;
		_thisBuildingPos = [_buildingPositions, true] call Zen_ArrayGetRandom;
		_intelSpawnPos = _thisBuildingPos;//[(_thisBuildingPos select 0), (_thisBuildingPos select 1), ((_thisBuildingPos select 2)+1.75)];
		
		_thisIntel = _intelClass createVehicle _intelSpawnPos;
		_bbr = boundingBoxReal _thisIntel;
		_p1 = _bbr select 0;
		_p2 = _bbr select 1;
		_maxHeight = abs ((_p2 select 2) - (_p1 select 2));
		_thisIntel setPos [(_thisBuildingPos select 0), (_thisBuildingPos select 1), ((_thisBuildingPos select 2)+(_maxHeight/2))];
		_thisIntel setVelocity [0, 0, 0];
		
		_infCount = 0;
		{
			_chance = random 100;
			if ((_chance > 50) && (_infCount < 6)) then {
				_group = [_x, _side, eInfClassesForWeights, eInfClassWeights, [1,1]] call dro_spawnGroupWeighted;
				_unit = ((units _group) select 0);
				if (!isNil "_unit") then {	
					_unit setUnitPos "UP";
					_infCount = _infCount + 1;
				};				
			};				
		} forEach _buildingPositions;
		
		// Spawn enemies to guard the building
		_minAI = 2;
		_maxAI = 5;
		if (aiSkill == 1) then {	
			_minAI = 2;
			_maxAI = 3;
		};
		_spawnedSquad2 = [getPos _building, enemySide, eInfClassesForWeights, eInfClassWeights, [_minAI, _maxAI]] call dro_spawnGroupWeighted;			
		if (!isNil "_spawnedSquad2") then {	
			[_spawnedSquad2, getPos _building, 100] call bis_fnc_taskPatrol;
		};
		// Marker
		_markerName = format["intelMkr%1", floor(random 10000)];
		_markerBuilding = createMarker [_markerName, _buildingPos];			
		_markerBuilding setMarkerShape "ICON";
		_markerBuilding setMarkerType "mil_pickup";
		_markerBuilding setMarkerColor _markerColorEnemy;		
		_markerBuilding setMarkerAlpha 0;
		
		// Create task
		_buildingName = ((configFile >> "CfgVehicles" >> _buildingClass >> "displayName") call BIS_fnc_GetCfgData);
		_intelName = ((configFile >> "CfgVehicles" >> _intelClass >> "displayName") call BIS_fnc_GetCfgData);			
					
		_taskName = format ["task%1", floor(random 100000)];
		_taskTitle = "Retrieve Intel";
		_taskDesc = format ["Retrieve the %1 intelligence from a %2 located at the marked <marker name='%4'>%3</marker>. As well as containing important information desired by high command this intel package may contain useful information about troop placement in the AO.",enemyFactionName, _intelName,_buildingName, _markerName];
		_thisTask = _taskName;
		[group groupLeader, _taskName, [_taskDesc, _taskTitle, _markerName], _buildingPos, "CREATED", 1, false, "download", false] call BIS_fnc_taskCreate;
					
		[[_thisIntel, _taskName ], "sun_addIntel" ] call BIS_fnc_MP;		
			
		_objectivePos = _buildingPos;
		
	};
	
};

// Set reinforcements on task completion
diag_log format["DRO: _objectivePos = %1", _objectivePos];
_reinfChance = (random 100);
if (_reinfChance > 30) then {
	_trgReinforce = createTrigger ["EmptyDetector", _objectivePos, true];
	_trgReinforce setTriggerArea [300, 300, 0, false];
	_trgReinforce setTriggerActivation ["ANY", "PRESENT", false];
	_trgReinforce setTriggerStatements [
		"
			[(thisTrigger getVariable 'thisTask')] call BIS_fnc_taskCompleted
		",
		"	
			diag_log 'Reinforcing due to task completion';
			_enemyArray = [];
			[AO_roadPosArray, (thisTrigger getVariable 'pos'), 0, [1,2]] execVM 'sunday_system\reinforce.sqf';
			{ if (side _x == (thisTrigger getVariable 'side')) then {_enemyArray = _enemyArray + [_x]} } forEach thisList;
			{[group _x, (thisTrigger getVariable 'pos')] call BIS_fnc_taskAttack} forEach _enemyArray;
		", 
		""];
	_trgReinforce setVariable ["thisTask", _thisTask];
	_trgReinforce setVariable ["pos", _objectivePos];
	_trgReinforce setVariable ["side", _side];
};


// Add cancel button to task
_taskData = [_thisTask] call BIS_fnc_taskDescription;
_taskDesc = (_taskData select 0) select 0;
_taskTitle = _taskData select 1;
_taskMarker = _taskData select 2;
_taskDescNew = format ["%1<br /><br /><execute expression='[""%2"", ""CANCELED"", true] spawn BIS_fnc_taskSetState;'>Cancel task</execute>", _taskDesc, _thisTask];

[_thisTask, [_taskDescNew, _taskTitle, _taskMarker]] call BIS_fnc_taskSetDescription;

allObjectives pushBack _thisTask;
diag_log format ["DRO: Task created: %1, %2", _taskTitle, _thisTask];
diag_log format ["DRO: allObjectives is now %1", allObjectives];


_return = [_select, _destroyStyles];
_return
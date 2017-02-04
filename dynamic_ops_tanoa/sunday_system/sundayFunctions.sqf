dro_heliInsertion = {
	_heli = _this select 0;
	_insertPos = _this select 1;
	_type = _this select 2;
	
	diag_log format ["DRO: Init heli insertion with heli %1 to %2", _heli, _insertPos];
	
	_heliGroup = (group _heli);
	_startPos = [((getPos _heli) select 0), ((getPos _heli) select 1), ((getPos _heli) select 2)];
	_height = getTerrainHeightASL _insertPos; 
	_insertPosHigh = [(_insertPos select 0), (_insertPos select 1), _height+150];
	
	_flyDir = [_startPos, _insertPosHigh] call BIS_fnc_dirTo;
	_flyByPosExtend = [_insertPosHigh, 3000, _flyDir] call Zen_ExtendPosition;
	_flyByPos = [(_flyByPosExtend select 0), (_flyByPosExtend select 1), 200];
	
	_heli flyInHeight 200;
	_heliGroup = (group _heli);
	
	_driver = driver _heli;
	_heliGroup setBehaviour "careless";
    _driver disableAI "FSM";
    _driver disableAI "Target";
    _driver disableAI "AutoTarget";
	
	// Clear current waypoints
	while {(count (waypoints _heliGroup)) > 0} do {
		deleteWaypoint ((waypoints _heliGroup) select 0);
	};	
	
	_wp0 = _heliGroup addWaypoint [_startPos, 0];	
	_wp0 setWaypointSpeed "FULL";
	_wp0 setWaypointType "MOVE";	
	_wp0 setWaypointBehaviour "COMBAT";
	
	_wp1 = _heliGroup addWaypoint [_flyByPos, 0];	
	_wp1 setWaypointSpeed "FULL";
	_wp1 setWaypointType "MOVE";	
	
	_trgEject = createTrigger ["EmptyDetector", _insertPosHigh];
	_trgEject setTriggerArea [800, 50, _flyDir, false];
	_trgEject setTriggerActivation ["ANY", "PRESENT", false];
	_trgEject setTriggerStatements ["(thisTrigger getVariable 'heli') in thisList", "[(assignedCargo (thisTrigger getVariable 'heli'))] execVM 'sunday_system\callParadrop.sqf';", ""];
	_trgEject setVariable ["heli", _heli];
	
	_trgDelete = createTrigger ["EmptyDetector", _flyByPos];
	_trgDelete setTriggerArea [100, 100, 0, false];
	_trgDelete setTriggerActivation ["ANY", "PRESENT", false];
	_trgDelete setTriggerStatements ["(thisTrigger getVariable 'heli') in thisList", "deleteVehicle (thisTrigger getVariable 'heli');", ""];
	_trgDelete setVariable ["heli", _heli];
	
	
	diag_log format ["DRO: heli waypoints %1, %2", waypointPosition [_heliGroup, 0], waypointPosition [_heliGroup, 1]];
	
};

dro_spawnGroupWeighted = {	
	_pos = [];
	if (!isNil {(_this select 0)}) then {
		_pos = _this select 0;
	};
	_side = _this select 1;			
	_unitArr = _this select 2;		// Array : [classnames]
	_unitArrWeights = _this select 3;		// Array : [weights]
	_unitNumbers = _this select 4;	// Array : [min units, max units]
	

	if (count _pos > 0) then {	
		
		// Get a random number of units to select between the boundaries
		_minUnits = (_unitNumbers select 0);
		if (_minUnits < 1) then {_minUnits = 1};
		_maxUnits = (_unitNumbers select 1);	
		_limitUnits = [_minUnits, _maxUnits] call BIS_fnc_randomInt;
		
		_unitsToSpawn = [];
		for "_i" from 1 to _limitUnits do {
			_thisUnit = nil;
			if (count _unitArrWeights > 0) then {
				_thisUnit = [_unitArr, _unitArrWeights] call BIS_fnc_selectRandomWeighted;
			} else {
				_thisUnit = selectRandom _unitArr;
			};				
			_unitsToSpawn pushBack _thisUnit;
		};
		
		_group = [_pos, _side, _unitsToSpawn] call BIS_fnc_spawnGroup;
		if (!isNil "aiSkill") then {
			if (aiSkill == 0) then {
				[_group] call dro_setSkillAction;
			};
		};	
		_group
	};	
};

dro_setSkillAction = {
	if (typeName (_this select 0) == "OBJECT") then {
		_unit = (_this select 0);
		_unit setSkill ["aimingAccuracy", random [0.06, 0.07, 0.08]];
		_unit setSkill ["aimingShake", random [0.01, 0.015, 0.02]];
		_unit setSkill ["aimingSpeed", random [0.1, 0.1, 0.15]];
		_unit setSkill ["spotDistance", random [0.6, 0.75, 0.8]];
		_unit setSkill ["spotTime", random [0.3, 0.4, 0.5]];
		_unit setSkill ["general", random [0.7, 0.75, 0.8]];	
		_unit setSkill ["courage", random [0.1, 0.2, 0.3]];
		_unit setSkill ["reloadSpeed", random [0.1, 0.1, 0.2]];
	};
	if (typeName (_this select 0) == "GROUP") then {		
		{
			_unit = _x;
			_unit setSkill ["aimingAccuracy", random [0.06, 0.07, 0.08]];
			_unit setSkill ["aimingShake", random [0.01, 0.015, 0.02]];
			_unit setSkill ["aimingSpeed", random [0.1, 0.1, 0.15]];
			_unit setSkill ["spotDistance", random [0.6, 0.75, 0.8]];
			_unit setSkill ["spotTime", random [0.3, 0.4, 0.5]];
			_unit setSkill ["general", random [0.7, 0.75, 0.8]];	
			_unit setSkill ["courage", random [0.1, 0.2, 0.3]];
			_unit setSkill ["reloadSpeed", random [0.1, 0.1, 0.2]];
		} forEach (units (_this select 0));
	};
};


sun_addArsenal = {
	(_this select 0) addAction ["Arsenal", "['Open', true] call BIS_fnc_arsenal", nil, 6];
};	

sun_pasteLoadoutAdd = {
	_target = _this select 0;
	
	_actionIndex = _target addAction [
		"Paste Loadout",
		{
			_unit = _this select 1;
			_target = _this select 0;
			
			// Remove current loadout			
			_target removeWeaponGlobal (primaryWeapon _target);
			_target removeWeaponGlobal (secondaryWeapon _target);
			_target removeWeaponGlobal (handgunWeapon _target);
			removeUniform _target;
			removeVest _target;
			removeHeadgear _target;
			removeGoggles _target;
			removeBackpack _target;
			_target unassignItem "NVGoggles";
			_target removeItem "NVGoggles";	
			
			// Paste player's loadout
			_loadoutName = format ["loadout%1", _unit];
			[_unit, [missionNameSpace, _loadoutName]] call BIS_fnc_saveInventory;
			[_target, [missionNameSpace, _loadoutName]] call BIS_fnc_loadInventory;			
		},
		nil,
		1.5,
		false,
		false
	];
	
	// Record this action index for later removal
	_target setVariable ["loadoutAction", _actionIndex];
	
};

sun_pasteLoadoutRemove = {
	_target = _this select 0;
	_actionIndex = _target getVariable "loadoutAction";		
	_target removeAction _actionIndex;
};

sun_moveInCargo = {
	//_unit = _this select 0;
	_vehicle = _this select 0;
	
	player moveInCargo _vehicle;
	
};

sun_playRadioRandom = {
	_radioArray = [		
		"RadioAmbient2",
		"RadioAmbient6",
		"RadioAmbient8"
	];
	playSound [(selectRandom _radioArray), true];
};

sun_setNameMP = {
	_unit = _this select 0;
	_firstName = _this select 1;
	_lastName = _this select 2;
	_speaker = _this select 3;
	_unit setName [format ["%1 %2", _firstName, _lastName], _firstName, _lastName];
	_unit setNameSound _lastName;
	_unit setSpeaker _speaker;
};

sun_aiNudge = {		
	_target = _this select 0;
	
	_target addAction [
		"Nudge",
		{
			_dir = [(_this select 1), (_this select 0)] call BIS_fnc_dirTo;
			_nudgePos = [(getPos (_this select 0)), 2, _dir] call Zen_ExtendPosition;
			(_this select 0) setPos _nudgePos;
		},
		nil,
		1.5,
		false,
		false
	];

};

sun_aiNudgeAdd = {		
	_target = _this select 0;
	_actionIndex = (_target getVariable "nudgeAction");
	if (isNil '_actionIndex' || ((_target getVariable "nudgeActionPresent") == 0)) then {
		_actionIndex = _target addAction [
			"Nudge",
			{
				_dir = [(_this select 1), (_this select 0)] call BIS_fnc_dirTo;
				_nudgePos = [(getPos (_this select 0)), 2, _dir] call Zen_ExtendPosition;
				(_this select 0) setPos _nudgePos;
			},
			nil,
			1.5,
			false,
			false
		];
		
		_target setVariable ["nudgeAction", _actionIndex];
		_target setVariable ["nudgeActionPresent", 1];
	};
};

sun_aiNudgeRemove = {
	_target = _this select 0;
	_actionIndex = _target getVariable "nudgeAction";		
	_target removeAction _actionIndex;
	_target setVariable ["nudgeActionPresent", 0];
};

sun_checkPosInMap = {
	// For checking that positions to be generated at high distances from the center fall within the map bounds
	
	_center = _this select 0;
	_distance = _this select 1;		// Array : [min distance, max distance]
	
	_distMin = _distance select 0;
	_distMax = _distance select 1;
	
	_worldSize = worldSize;
	
};

sun_spawnGroup = {
	_pos = [];
	if (!isNil {(_this select 0)}) then {
		_pos = _this select 0;
	};
	_side = _this select 1;			
	_unitArr = _this select 2;		// Array : [classnames]
	_unitNumbers = _this select 3;	// Array : [min units, max units]
	_skill = _this select 4;
	
	if (count _unitArr > 0) then {
		if (count _pos > 0) then {	
			// Get a random number of units to select between the boundaries
			_minUnits = (_unitNumbers select 0);
			_maxUnits = (_unitNumbers select 1);	
			_limitUnits = [_minUnits,_maxUnits] call BIS_fnc_randomInt;
			
			_unitsToSpawn = [];
			for "_i" from 1 to _limitUnits do {
				_thisUnit = selectRandom _unitArr;
				_unitsToSpawn pushBack _thisUnit;
			};
			
			_group = [_pos, _side, _unitsToSpawn] call BIS_fnc_spawnGroup;
			if (!isNil "_skill") then {
				if (_skill == "Militia") then {
					[_group] call dro_setSkillAction;
				};
			};
			_group
		};
	};
};

sun_spawnCfgGroup = {
	_pos = [];
	if (!isNil {(_this select 0)}) then {
		_pos = _this select 0;
	};
	_side = _this select 1;			
	_groupsCfgArr = _this select 2;		// Array : [group classnames]
	_unitNumbers = _this select 3;
	_skill = _this select 4;
	_unitArr = _this select 5;			// Array : [unit classnames] optional, for use if no groups found
	
	_minUnits = (_unitNumbers select 0);
	_maxUnits = (_unitNumbers select 1);	
	
	if (count _groupsCfgArr > 0) then {			
		if (count _pos > 0) then {	
			{		
				if ((count ([_x, 0, true] call BIS_fnc_returnChildren)) > _maxUnits) then {
					_groupsCfgArr = _groupsCfgArr - [_x];
				}
			} forEach _groupsCfgArr;
			
			_thisGroup = selectRandom _groupsCfgArr;
			if (!isNil "_thisGroup") then {
				diag_log "DRO: Spawning group using Cfg data";
				_group = [_pos, _side, _thisGroup, [], [], [], [], [_minUnits, 0.65]] call BIS_fnc_spawnGroup;
				if (_skill == "Militia") then {
					[_group] call dro_setSkillAction;
				};
				_group
			} else {
				if (!isNil "_unitArr") then {
					if (count _unitArr > 0) then {
						diag_log "DRO: Spawning group using array data";
						_group = [_pos, _side, _unitArr, _unitNumbers, _skill] call sun_spawnGroup;
						if (_skill == "Militia") then {
							[_group] call dro_setSkillAction;
						};
						_group
					};
				};
			};
		};
	} else {
		if (!isNil "_unitArr") then {
			if (count _unitArr > 0) then {
				diag_log "DRO: Spawning group using array data";
				_group = [_pos, _side, _unitArr, _unitNumbers, _skill] call sun_spawnGroup;
				if (_skill == "Militia") then {
					[_group] call dro_setSkillAction;
				};
				_group
			};
		};
	};

};

sun_spawnGroupSingleUnit = {
	_pos = [];
	if (!isNil {(_this select 0)}) then {
		_pos = _this select 0;
	};
	_side = _this select 1;			
	_groupsCfgArr = _this select 2;		// Array : [group classnames]
	_skill = _this select 3;
	_unitArr = _this select 4;			// Array : [unit classnames] optional, for use if no groups found
		
	if (count _groupsCfgArr > 0) then {
		if (count _pos > 0) then {		
			_thisUnitClass = selectRandom _groupsCfgArr;
			if (count _thisUnitClass > 0) then {
				_group = createGroup _side;
				_unit = _group createUnit [_thisUnitClass, _pos, [], 0, "NONE"];	
				if (_skill == "Militia") then {
					[_unit] call dro_setSkillAction;
				};			
				_unit
			} else {
				if (isNil "_thisUnitClass") then {
					_thisUnitClass = selectRandom _unitArr;
					_group = createGroup _side;
					_unit = _group createUnit [_thisUnitClass, _pos, [], 0, "NONE"];	
					if (_skill == "Militia") then {
						[_unit] call dro_setSkillAction;
					};
					_unit
				};
			};
		};
	} else {
		if (!isNil "_unitArr") then {
			if (count _unitArr > 0) then {
				_thisUnitClass = selectRandom _unitArr;
				_group = createGroup _side;
				_unit = _group createUnit [_thisUnitClass, _pos, [], 0, "NONE"];	
				if (_skill == "Militia") then {
					[_unit] call dro_setSkillAction;
				};
				_unit
			};
		};
	};
};

sun_refreshList = {
	
	_control = (_this select 0);	
	_idc = ctrlIDC _control;
	_index = (_this select 1);

	_unavailableFactions = ["IND_G_F", "OPF_G_F", "CUP_B_CDF", "CUP_B_CZ", "CUP_B_GB", "CUP_B_US", "CUP_B_US_Army", "CUP_I_PMC_ION", "CUP_I_UN", "CUP_O_ChDKZ", "CUP_O_RU"];
	
	_faction = _control lbData _index;		
	_selectedSide = ((configFile >> "CfgFactionClasses" >> _faction >> "side") call BIS_fnc_GetCfgData);
	
	_otherIDC = 0;
	if (_idc == 2100) then {
		_otherIDC = 2101;
	} else {
		_otherIDC = 2100;
	};
	
	lbClear _otherIDC;
	_otherIndex = lbCurSel _otherIDC;
	localize str _otherIndex;
	
	_otherFaction = lbData [_otherIDC, _otherIndex];
	_otherSide = ((configFile >> "CfgFactionClasses" >> _otherFaction >> "side") call BIS_fnc_GetCfgData);
	
	
	{
		_thisSideNum = ((configFile >> "CfgFactionClasses" >> (configName _x) >> "side") call BIS_fnc_GetCfgData);
		if (_thisSideNum < 3 && _thisSideNum > -1 && _thisSideNum != _selectedSide) then {
			
			_thisFactionName = ((configFile >> "CfgFactionClasses" >> (configName _x) >> "displayName") call BIS_fnc_GetCfgData);
			_thisFactionFlag = ((configfile >> "CfgFactionClasses" >> (configName _x) >> "flag") call BIS_fnc_GetCfgData);
			//if (!(["IND_G_F", _thisFactionName, false] call BIS_fnc_inString) && !(["OPF_G_F", _thisFactionName, false] call BIS_fnc_inString)) then {
			if ((configName _x) in _unavailableFactions) then {
				
			} else{
				_color = "";
				switch (_thisSideNum) do {
					case 1: {
						_color = [0, 0.3, 0.6, 1];
					};
					case 0: {
						_color = [0.5, 0, 0, 1];
					};
					case 2: {
						_color = [0, 0.5, 0, 1];
					};	
				};
			
				_thisIndex = lbAdd [_otherIDC, _thisFactionName];
				lbSetData [_otherIDC, _thisIndex, (configName _x)];
				lbSetColor [_otherIDC, _thisIndex, _color];
				lbSetPicture [_otherIDC, _thisIndex, _thisFactionFlag];
				lbSetPictureColor [_otherIDC, _thisIndex, [1, 1, 1, 1]];
				lbSetPictureColorSelected [_otherIDC, _thisIndex, [1, 1, 1, 1]];
			};		
		};
	} forEach ("true" configClasses (configFile / "CfgFactionClasses"));
	
	_otherSize = lbSize _otherIDC; 
	
	for "_i" from 1 to _otherSize do {
		_thisFaction =  lbData [_otherIDC, (_i - 1)];
		if (_thisFaction == _otherFaction) then {
			lbSetCurSel [_idc, (_i - 1)];
		};	
	};
	
	
	//if (_otherSide != _selectedSide) then {
		//lbSetCurSel [_idcToChange, _otherIndex];
	//};
	
};

sun_addIntel = {
	_intelObject = _this select 0;
	_taskName = _this select 1;
	_intelObject setVariable ["task", _taskName];
	
	
	_intelObject addAction [
		"Collect Intel",
		{
			[_this select 3, 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;	
			deleteVehicle (_this select 0);
			{
				_chance = (random 100);
				if (_chance > 50) then {
					_x setMarkerAlpha 1;
				};
			} forEach (missionNamespace getVariable "enemyIntelMarkers");
		},
		_taskName,
		6,
		true,
		true
		//"[(_target getVariable 'task'), ['created', 'canceled']] call Zen_AreTasksComplete"
		
	];
	
};
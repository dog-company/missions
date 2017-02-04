_faction = _this select 0;

_infClasses = [];
_officerClasses = [];
_carClasses = [];
_carNoTurretClasses = [];
_tankClasses = [];
_artyClasses = [];
_mortarClasses = [];
_heliClasses = [];
_planeClasses = [];
_shipClasses = [];
_ammoClasses = [];
_genericNames = "";
_factionLanguage = "";
_uavClasses = [];
_infClassesForWeights = [];
_infClassWeights = [];

_infEditorSubcats = [];
/*
_apexPresent = 0;

if (isClass(configfile >> "CfgPatches" >> "A3_Data_F_Exp")) then {
	_apexPresent = 1;
};
{
	_continue = 1;	
	if (_apexPresent == 0) then {
		if (isClass (configFile >> "CfgVehicles" >> (configName _x) >> "DLC")) then {
			_dlc = ((configFile >> "CfgVehicles" >> (configName _x) >> "DLC") call BIS_fnc_GetCfgData);
			if (!isNil "_dlc") then {
				if (_dlc == "Expansion") then {
					_continue = 0;
				};
			};
		};
	};	
	if (_continue == 1) then {
*/

diag_log format ["DRO: Extracting data for faction %1", _faction];

{
	if ( ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData) == _faction) then {		
		if ( ((configFile >> "CfgVehicles" >> (configName _x) >> "scope") call BIS_fnc_GetCfgData) == 2) then {	
			if (configName _x isKindOf 'Man') then {
				if (count _genericNames == 0) then {
					_genericNames = ((configFile >> "CfgVehicles" >> (configName _x) >> "genericNames") call BIS_fnc_GetCfgData);
					_factionLanguage = (((configFile >> "CfgVehicles" >> (configName _x) >> "identityTypes") call BIS_fnc_GetCfgData) select 0);
				};
				if ( ["officer", (configName _x), false] call BIS_fnc_inString ) then {
					_officerClasses pushBack (configName _x);
				} else {					
					if (
						(["crew", (configName _x), false] call BIS_fnc_inString) ||
						(["driver", (configName _x), false] call BIS_fnc_inString) ||
						(["diver", (configName _x), false] call BIS_fnc_inString) ||
						(["story", (configName _x), false] call BIS_fnc_inString) ||
						(["competitor", (configName _x), false] call BIS_fnc_inString) ||
						(["survivor", (configName _x), false] call BIS_fnc_inString) ||
						(["unarmed", (configName _x), false] call BIS_fnc_inString) ||
						(["protagonist", (configName _x), false] call BIS_fnc_inString) ||
						(["pilot", (configName _x), false] call BIS_fnc_inString) ||
						(["_vr_", (configName _x), false] call BIS_fnc_inString) ||
						(["story", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString) ||
						(count ((configFile >> "CfgVehicles" >> (configName _x) >> "weapons") call BIS_fnc_GetCfgData) <= 2)						
					) then {
						
					} else {
						_infClasses pushBack (configName _x);
						_thisWeight = 0;
						
						// Check config 'role' value
						_thisRole = ((configFile >> "CfgVehicles" >> (configName _x) >> "role") call BIS_fnc_GetCfgData);
						switch (_thisRole) do {
							case "Assistant": {_thisWeight = 0.15};
							case "CombatLifeSaver": {_thisWeight = 0.25};
							case "Grenadier": {_thisWeight = 0.25};
							case "MachineGunner": {_thisWeight = 0.25};
							case "Marksman": {_thisWeight = 0.1};
							case "MissileSpecialist": {_thisWeight = 0.15};
							case "Rifleman": {_thisWeight = 1};
							case "Sapper": {_thisWeight = 0.15};
							case "SpecialOperative": {_thisWeight = 0.15};
							default {_thisWeight = 0.5};
						};
						
						// Overwrite weight if certain words appear in unit name
						_thisDisplayName = ((configFile >> "CfgVehicles" >> (configName _x) >> "displayName") call BIS_fnc_GetCfgData);
						if (
							(["sniper", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["marksman", _thisDisplayName, false] call BIS_fnc_inString) ||						
							(["spotter", _thisDisplayName, false] call BIS_fnc_inString)	||					
							(["sharp", _thisDisplayName, false] call BIS_fnc_inString)
						) then {
							_thisWeight = 0.1;
						};						
						if (
							(["asst.", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["missile", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["AT", _thisDisplayName, true] call BIS_fnc_inString) ||
							(["AA", _thisDisplayName, true] call BIS_fnc_inString) ||
							(["special", _thisDisplayName, false] call BIS_fnc_inString) ||						
							(["leader", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["gunner", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["ammo", _thisDisplayName, false] call BIS_fnc_inString)
						) then {
							_thisWeight = 0.15;
						};
						if (
							(["medic", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["grenadier", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["machine", _thisDisplayName, false] call BIS_fnc_inString) ||
							(["auto", _thisDisplayName, false] call BIS_fnc_inString)								
						) then {
							_thisWeight = 0.25;
						};
						
						_infClassesForWeights pushBack (configName _x);
						_infClassWeights pushBack _thisWeight;
						_infEditorSubcats pushBackUnique ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData);
					};					
				};
			};			
			if (configName _x isKindOf 'Car') then {
				_edSubcat = ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData);
				if (!isNil "_edSubcat") then {
					if ( ["EdSubcat_Drones", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
						
					} else {
						_carClasses pushBack (configName _x);				
						_thisVehClass = (configName _x);							
						{					
							if ((configName _x) == "Turrets") then {						
								_turretCfg = ([(configFile >> "CfgVehicles" >> _thisVehClass >> "Turrets"), 0, true] call BIS_fnc_returnChildren);						
								if (count _turretCfg > 0) then {
									
									_noTurret = 0;
									{
										//diag_log ((configFile >> "CfgVehicles" >> _thisVehClass >> "Turrets" >> (configName _x) >> "gun") call BIS_fnc_GetCfgData);
										if (((configFile >> "CfgVehicles" >> _thisVehClass >> "Turrets" >> (configName _x) >> "gun") call BIS_fnc_GetCfgData) == "mainGun") then {
											_noTurret = 1;
										};
									} forEach _turretCfg;
									if (_noTurret == 0) then {
										_carNoTurretClasses pushBackUnique _thisVehClass;
									};
								} else {
									_carNoTurretClasses pushBackUnique _thisVehClass;
								};
							};
						} forEach ([(configFile >> "CfgVehicles" >> _thisVehClass), 0, true] call BIS_fnc_returnChildren);
					};
				};
								
			};
			_edSubcat = ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData);
			if (!isNil "_edSubcat") then {
				if ( ["EdSubcat_Artillery", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_artyClasses pushBack (configName _x);
				};
				if ( ["EdSubcat_Tanks", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_tankClasses pushBack (configName _x);
				};
				if ( ["EdSubcat_Helicopters", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_heliClasses pushBack (configName _x);
				};	
				if ( ["EdSubcat_Planes", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_planeClasses pushBack (configName _x);
				};			
				if ( ["EdSubcat_Boats", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_shipClasses pushBack (configName _x);
				};
				if ( ["EdSubcat_Drones", ((configFile >> "CfgVehicles" >> (configName _x) >> "editorSubcategory") call BIS_fnc_GetCfgData), false] call BIS_fnc_inString ) then {
					_uavClasses pushBack (configName _x);
				};
			};
			if (configName _x isKindOf 'StaticMortar') then {
				_mortarClasses pushBack (configName _x);
			};
			if (configName _x isKindOf 'ReammoBox_F') then {
				_ammoClasses pushBack (configName _x);
			};
		};
	};
	
} forEach ("true" configClasses (configFile / "CfgVehicles"));

// Check to see if all classes have distinct role data and if not try again using icons
/*
_useIcons = true;
{	
	if (((configFile >> "CfgVehicles" >> _x >> "role") call BIS_fnc_GetCfgData) != "Rifleman") then {
		_useIcons = false;
	};
} forEach _infClassesForWeights;

if (_useIcons) then {
	_infClassWeights = [];
	{	
		_thisIcon = ((configFile >> "CfgVehicles" >> _x >> "icon") call BIS_fnc_GetCfgData);
		switch (_thisIcon) do {			
			case "iconManMedic": {_infClassWeights pushBack 0.25};			
			case "iconManMG": {_infClassWeights pushBack 0.25};			
			case "iconManAT": {_infClassWeights pushBack 0.2};
			case "iconMan": {_infClassWeights pushBack 0.8};			
			case "iconManEngineer": {_infClassWeights pushBack 0.2};			
			default {_infClassWeights pushBack 0.2};
		};
	} forEach _infClassesForWeights;
};
*/


// If there are more than one subcategory of infantry units then select one
if (count _infEditorSubcats > 1) then {
	_chosenClasses = [];
	_chosenWeights = [];
	// Check how many units are in a subcategory
	_unavailableSubcats = [];
	_availableSubcats = [];
	_subcatWeights = [];
	{
		_chosenClasses = [];
		_chosenWeights = [];
		for "_i" from 0 to ((count _infClassesForWeights)-1) do {
			_thisSubcat = (((configFile >> "CfgVehicles" >> (_infClassesForWeights select _i) >> "editorSubcategory")) call BIS_fnc_GetCfgData);
			if (_thisSubcat == _x) then {
				_chosenClasses pushBack (_infClassesForWeights select _i);
				_chosenWeights pushBack (_infClassWeights select _i);
			};
		};
		diag_log format ["Subcat %2 _chosenWeights = %1", _chosenWeights, _x];
		// Look at weights in this subcategory, if there are none above sniper level then disallow the subcategory
		_allowThisSubcat = false;
		{
			if (_x > 0.1) then {
				_allowThisSubcat = true;
			};
		} forEach _chosenWeights;
		
		if (!_allowThisSubcat) then {
			_unavailableSubcats pushBack _x;
		} else {
			_availableSubcats pushBack _x;
			_subcatWeights pushBack ((count _chosenClasses)/100);
		};
	} forEach _infEditorSubcats;
	
	diag_log format ["_availableSubcats = %1", _availableSubcats];
	diag_log format ["_unavailableSubcats = %1", _unavailableSubcats];
	diag_log format ["_subcatWeights = %1", _subcatWeights];
	//_infEditorSubcats = _infEditorSubcats - _unavailableSubcats;
	//diag_log format ["_infEditorSubcats = %1", _infEditorSubcats];
	
	// Choose a subcategory out of those remaining
	//_chosenSubcat = selectRandom _infEditorSubcats;
	_chosenSubcat = [_availableSubcats, _subcatWeights] call BIS_fnc_selectRandomWeighted;
	diag_log format ["_chosenSubcat = %1", _chosenSubcat];
	
	// Add units with that subcategory to the chosen units
	_chosenClasses = [];
	_chosenWeights = [];
	for "_i" from 0 to ((count _infClassesForWeights)-1) do {
		_thisSubcat = (((configFile >> "CfgVehicles" >> (_infClassesForWeights select _i) >> "editorSubcategory")) call BIS_fnc_GetCfgData);
		if (_thisSubcat == _chosenSubcat) then {
			_chosenClasses pushBack (_infClassesForWeights select _i);
			_chosenWeights pushBack (_infClassWeights select _i);
		};		
	};
	_infClassesForWeights = _chosenClasses;
	_infClassWeights = _chosenWeights;
};


diag_log format ["_infClassesForWeights = %1", _infClassesForWeights];
diag_log format ["_infClassWeights = %1", _infClassWeights];


_return = [
	_infClasses,
	_officerClasses,
	_carClasses,
	_carNoTurretClasses,
	_tankClasses,
	_artyClasses,
	_mortarClasses,
	_heliClasses,
	_planeClasses,
	_shipClasses,
	_ammoClasses,
	_genericNames,
	_factionLanguage,
	_uavClasses,
	_infClassesForWeights,
	_infClassWeights
];
diag_log _return;
_return

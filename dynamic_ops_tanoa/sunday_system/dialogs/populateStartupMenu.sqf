
_index = lbAdd [2103, "Random"];
_index = lbAdd [2103, "Dawn"];
_index = lbAdd [2103, "Day"];
_index = lbAdd [2103, "Dusk"];
_index = lbAdd [2103, "Night"];

_index = lbAdd [2105, "Action"];
_index = lbAdd [2105, "Milsim"];

_index = lbAdd [2106, "Random"];
_index = lbAdd [2106, "1"];
_index = lbAdd [2106, "2"];
_index = lbAdd [2106, "3"];

_index = lbAdd [2107, "Random"];
_index = lbAdd [2107, "Small"];
_index = lbAdd [2107, "Medium"];
_index = lbAdd [2107, "Large"];

_index = lbAdd [2108, "Enabled"];
_index = lbAdd [2108, "Disabled"];

lbSetCurSel [2103, timeOfDay];
lbSetCurSel [2105, aiSkill];
lbSetCurSel [2106, numObjectives];
lbSetCurSel [2107, aoOptionSelect];
lbSetCurSel [2108, (missionNameSpace getVariable "reviveOptionSelect")];

if (!isNil "aoName") then {
	ctrlSetText [2202, format ["AO location: %1", aoName]];
};



// Check for factions that have units
_availableFactions = [];
_unavailableFactions = [];
_factionsWithUnits = [];
// Record all factions from infantry units
{
	_factionsWithUnits pushBackUnique ((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData);
} forEach ("(configName _x) isKindOf 'Man'" configClasses (configFile / "CfgVehicles"));
diag_log _factionsWithUnits;
// Filter out factions that have no units with that faction name
{
	if ((configName _x) in _factionsWithUnits) then {
		_availableFactions pushBackUnique (configName _x);
	} else {
		_unavailableFactions pushBackUnique (configName _x);
	};
} forEach ("true" configClasses (configFile / "CfgFactionClasses"));

_unavailableFactions pushBack "Virtual_F";

diag_log format ["DRO: Unavailable factions: %1", _unavailableFactions];

{
	_thisFaction = _x;
	_thisSideNum = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "side") call BIS_fnc_GetCfgData);
		
	if (typeName _thisSideNum == "SCALAR") then {
		if (_thisSideNum <= 3 && _thisSideNum > -1) then {
				
			_thisFactionName = ((configFile >> "CfgFactionClasses" >> _thisFaction >> "displayName") call BIS_fnc_GetCfgData);
			_thisFactionFlag = ((configfile >> "CfgFactionClasses" >> _thisFaction >> "flag") call BIS_fnc_GetCfgData);
			
			if (_thisFaction in _unavailableFactions) then {
				
			} else {
				// Add factions to combo boxes
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
					case 3: {
						_color = [1, 1, 1, 1];
					};						
				};				
				if (_thisSideNum == 3) then {
					_indexC = lbAdd [2102, _thisFactionName];					
					lbSetData [2102, _indexC, _thisFaction];
					lbSetColor [2102, _indexC, _color];
					if (!isNil "_thisFactionFlag") then {
						lbSetPicture [2102, _indexC, _thisFactionFlag];
						lbSetPictureColor [2102, _indexC, [1, 1, 1, 1]];
						lbSetPictureColorSelected [2102, _indexC, [1, 1, 1, 1]];
					};
				} else {
					_indexP = lbAdd [2100, _thisFactionName];					
					lbSetData [2100, _indexP, _thisFaction];
					lbSetColor [2100, _indexP, _color];
					if (!isNil "_thisFactionFlag") then {
						lbSetPicture [2100, _indexP, _thisFactionFlag];
						lbSetPictureColor [2100, _indexP, [1, 1, 1, 1]];
						lbSetPictureColorSelected [2100, _indexP, [1, 1, 1, 1]];
					};
					_indexE = lbAdd [2101, _thisFactionName];					
					lbSetData [2101, _indexE, _thisFaction];
					lbSetColor [2101, _indexE, _color];
					if (!isNil "_thisFactionFlag") then {
						lbSetPicture [2101, _indexE, _thisFactionFlag];
						lbSetPictureColor [2101, _indexE, [1, 1, 1, 1]];
						lbSetPictureColorSelected [2101, _indexE, [1, 1, 1, 1]];
					};
				};					
			};		
		};	
	};
} forEach _availableFactions;

lbSetCurSel [2100, pFactionIndex];
lbSetCurSel [2101, eFactionIndex];
lbSetCurSel [2102, cFactionIndex];

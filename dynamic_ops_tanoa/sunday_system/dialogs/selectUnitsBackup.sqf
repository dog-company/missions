_lbArray = [1201, 1203, 1205, 1207];

{lbClear _x} forEach _lbArray;

_playersIndex = lbCurSel 2100;
_playersFaction = lbData [2100, _playersIndex];
_playersSideNum = ((configFile >> "CfgFactionClasses" >> _playersFaction >> "side") call BIS_fnc_GetCfgData);
_playersSide = "West";

if (_playersFaction == "BLU_G_F") then {_playersFaction = "Guerilla"};
if (_playersFaction == "BLU_GEN_F") then {_playersFaction = "Gendarmerie"};

switch (_playersSideNum) do {
	case 0: {_playersSide = "East"};
	case 1: {_playersSide = "West"};
	case 2: {_playersSide = "Indep"};
};

_unitList = [];

{
	_groupCategory = configName _x;
	{
		_thisGroup = configName _x;	
		{		
			_thisGroupUnits = ("count ((_x >> 'vehicle') call BIS_fnc_getCfgData) > 0" configClasses (configfile >> "CfgGroups" >> _playersSide >> _playersFaction >> _groupCategory >> _thisGroup));
			{
				_thisUnitClass = ((_x >> 'vehicle') call BIS_fnc_getCfgData);
				if (_thisUnitClass isKindOf "Man") then {
					_unitList pushBackUnique [_thisUnitClass, ((configfile >> "CfgVehicles" >> _thisUnitClass >> "displayName") call BIS_fnc_getCfgData)];
				};
			} forEach _thisGroupUnits;
		} forEach (configProperties [configfile >> "CfgGroups" >> _playersSide >> _playersFaction >> _groupCategory >> _thisGroup]);	
	} forEach (configProperties [configfile >> "CfgGroups" >> _playersSide >> _playersFaction >> _groupCategory]);
} forEach ([configfile >> "CfgGroups" >> _playersSide >> _playersFaction] call BIS_fnc_returnChildren);



{
	_thisLB = _x;
	{
		_index = lbAdd [_thisLB, (_x select 1)];
		lbSetData [_thisLB, _index, (_x select 0)];
	} forEach _unitList;	
	lbSetCurSel [_thisLB, (floor(random(count _unitList)))];
} forEach _lbArray;


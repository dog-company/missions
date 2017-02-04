

_playersFaction = _this select 0;
if (_playersFaction == "BLU_G_F") then {_playersFaction = "Guerilla"};
if (_playersFaction == "BLU_GEN_F") then {_playersFaction = "Gendarmerie"};

_playersSideNum = ((configFile >> "CfgFactionClasses" >> _playersFaction >> "side") call BIS_fnc_GetCfgData);
_playersSide = "West";
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

_unitList 
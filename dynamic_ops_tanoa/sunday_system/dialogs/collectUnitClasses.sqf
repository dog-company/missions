
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
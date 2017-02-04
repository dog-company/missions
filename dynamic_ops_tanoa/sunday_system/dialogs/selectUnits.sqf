

if (playersFaction == "BLU_G_F") then {playersFaction = "Guerilla"};
if (playersFaction == "BLU_GEN_F") then {playersFaction = "Gendarmerie"};


unitList = [];

{
	_groupCategory = configName _x;
	//diag_log format["_groupCategory = %1", _groupCategory];
	{
		_thisGroup = configName _x;	
		//diag_log format["_thisGroup = %1", _thisGroup];
		{		
			_thisGroupUnits = ("count ((_x >> 'vehicle') call BIS_fnc_getCfgData) > 0" configClasses (configfile >> "CfgGroups" >> playersSideCfgGroups >> playersFaction >> _groupCategory >> _thisGroup));
			//diag_log format["_thisGroupUnits = %1", _thisGroupUnits];
			{
				_thisUnitClass = ((_x >> 'vehicle') call BIS_fnc_getCfgData);
				if (_thisUnitClass isKindOf "Man") then {
					unitList pushBackUnique [_thisUnitClass, ((configfile >> "CfgVehicles" >> _thisUnitClass >> "displayName") call BIS_fnc_getCfgData)];
				};
			} forEach _thisGroupUnits;
		} forEach (configProperties [configfile >> "CfgGroups" >> playersSideCfgGroups >> playersFaction >> _groupCategory >> _thisGroup]);	
	} forEach (configProperties [configfile >> "CfgGroups" >> playersSideCfgGroups >> playersFaction >> _groupCategory]);
} forEach ([configfile >> "CfgGroups" >> playersSideCfgGroups >> playersFaction] call BIS_fnc_returnChildren);

publicVariable "unitList";
_unit = _this select 0;
_target = _this select 1;

while {(_unit distance arsenalBox < 30)} do {
	{
		if (!isPlayer _x) then {
			if ((_target getVariable 'loadoutActionPresent') == 0) then {
				[_target] call sun_pasteLoadoutAdd;	
				_target setVariable ['loadoutActionPresent', 1];
			};
		};
	} forEach units group player;	
};
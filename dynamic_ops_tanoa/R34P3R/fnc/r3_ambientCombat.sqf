/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

// Animations:
// "STAND" 			- standing still, slightly turning to the sides. Needs a rifle!
// "STAND_IA"		- default a3 animations for standing, rifle lowered
// "SIT_LOW"		- sitting on the ground, with weapon.
// "KNEEL"			- kneeling, with weapon.
// "LEAN"			- standing while leaning (on wall)
// "WATCH"/"WATCH1"/"WATCH2"	- standing and turning around

// TO ENABLE AMBIENT COMBAT, USW: [this,"ANIMATION"] execVM "R34P3R\ai\r3_ac.sqf";

if(isServer) then {

	r3_aiAmbientCombat = 
	{
		_unit = [_this, 0, objNull] call BIS_fnc_param;
		_anim = [_this, 1, ""] call BIS_fnc_param;
		
		if(!isNull _unit && !isNil "_anim") then {
			[_unit, _anim, "ASIS", 
				{ 
					([_this] call r3_aiExitAmbient);
				}
			] call BIS_fnc_ambientAnimCombat;
		};
	};

	r3_aiExitAmbient = 
	{
		_unit = _this select 0;
		_return = false;
		
		if(time > 5) then {
			{
				if(!isNull _x) then {
					if(!isNil {r3_serverFullLoaded}) then {
						if!(captive _x) then {
							if((_unit knowsAbout _x) > 2) then {
								_unit stop false;
								_unit setCombatMode "YELLOW";
								_unit setBehaviour "AWARE";
								_return = true;
							} else {
								if((_unit distance _x) < 50) then {
									_unit stop false;
									_unit setCombatMode "RED";
									_unit setBehaviour "COMBAT";
									_return = true;
								};
							};
						};
					};
				};
			} forEach r3_playableUnits;
		};
		_return
	};
};
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

	_unit = [_this, 0, objNull] call BIS_fnc_param;
	_anim = [_this, 1, ""] call BIS_fnc_param;
	
	if(!isNull _unit && !isNil "_anim") then {
	
		_dir = getDir _unit;
		
		waitUntil{sleep 1; !isNil {r3_serverFullLoaded}};
		
		[_unit,toUpper(_anim)] spawn r3_aiAmbientCombat;
		_unit setDir _dir;
	};
};
// by Alias
// nul = [] execvm "scriptsmisc\umblator.sqf";

if (!isServer) exitWith {};

umbla= "Land_HelipadEmpty_F" createVehicle [0,0,0];

while {true} do {
// >> you can tweak sleep value if you want to hear ambient sounds more or less often
	sleep 120+random ambient_sounds_al;
	_natura = ["lup_01","lup_02","lup_03"] call BIS_fnc_selectRandom;
	
	pos_umbla = [hunt_alias,100+random 200, random 360] call BIS_fnc_relPos;
	umbla setpos [pos_umbla select 0,pos_umbla select 1,50 + random 50];
 
	[[umbla, _natura], "say3d", true] call BIS_fnc_MP;
};
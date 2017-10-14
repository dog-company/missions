/*
TPW PUDDLE - puddles on flat ground during and after rain
Version: 1.02
Author: tpw
Date: 20170529
Requires: CBA A3, tpw_core.sqf
Compatibility: SP

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_puddle.sqf
2 - Call it with 0 = [8,50,10,0.1,600,0.2,0] execvm "tpw_puddle.sqf"; // where 8 = maximum puddles around player; 50 = max distance from player to spawn puddles; 10 =  min distance from player to spawn puddles; 0.1; // how flat must spawn position be to spawn puddle 0 = absolutely flat, 1 = 45 degree gradient;  600 = Sec after rain stops to continue spawning puddles; 0.2 = rain threshold beyond which puddles will be spawned -1 = puddles regardless; 0 = use static water shader, 1 = use rippling water shader for puddles - may give visual anomolies

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
WaitUntil {!isNull FindDisplay 46};
if (count _this < 7) exitwith {hint "TPW puddle incorrect/no config, exiting."};

//VARIABLES
tpw_puddle_version = "1.01"; // Version string
tpw_puddle_max = _this select  0; // maximum puddles around player 
tpw_puddle_radius =  _this select  1; // max distance from player to spawn puddles
tpw_puddle_minradius =  _this select  2; // min distance from player to spawn puddles
tpw_puddle_gradient =  _this select  3; // how flat must spawn position be to spawn puddle 0 = absolutely flat, 1 = 45 degree gradient 
tpw_puddle_time =  _this select  4; // Sec after rain stops to continue spawning puddles
tpw_puddle_rainthresh =  _this select  5; // rain threshold beyond which puddles will be spawned, -1 = puddles regardless
tpw_puddle_ripple =  _this select  6; // 1 = use rippling water shader for puddles - will give visual anomolies. 2 = use BIS puddles 

// Pre-spawn puddles out of range
tpw_puddle_fnc_spawn =
	{
	private ["_puddle","_type"];
	// Prespawn ponds
	tpw_puddle_array = [];	
	tpw_puddle_usednums = [];
	tpw_puddle_availnums = [];
	
	// Small puddles
	_type = ["PUDDLE_S","PUDDLERIPPLE_S","LAND_PUDDLE_01_F"] select tpw_puddle_ripple;
	for "_i" from 1 to tpw_puddle_max do
		{
		_puddle = _type createvehicle [0,0,10000]; 
		_puddle setdir random 360;
		tpw_puddle_array pushback _puddle;
		};

	// Larger puddles
	_type = ["PUDDLE_M","PUDDLERIPPLE_M","LAND_PUDDLE_01_F"] select tpw_puddle_ripple;
	for "_i" from 1 to tpw_puddle_max do
		{
		_puddle = _type createvehicle [0,0,10000]; 
		_puddle setdir random 360;
		tpw_puddle_array pushback _puddle;
		};
		
	// Available puddle numbers	
	for "_i" from 0 to ((tpw_puddle_max * 2) - 1) do
		{
		tpw_puddle_availnums pushback _i;
		};
	};
 
// "Spawn" new puddles by moving them to spawnpos and removing them from available
tpw_puddle_fnc_select = 
	{
	private ["_pos","_dir","_dist","_posx","_posy","_spawnpos","_rnd","_pud","_puddle"];
	// Pick random position
	_pos = getposasl player;
	_dir = random 360;
	_dist = tpw_puddle_minradius + random (tpw_puddle_radius - tpw_puddle_minradius);
	_posx = (_pos select 0) + (_dist * sin _dir);
	_posy = (_pos select 1) +  (_dist * cos _dir);
	_spawnpos = [_posx,_posy,0];
	
	// Position not in water
	if (surfaceiswater _spawnpos) exitwith {};
	
	// Pick appropiate sized puddles based on radius of flat area
	if ([_spawnpos] call tpw_puddle_fnc_flat) then 
		{
		_rnd = floor random count tpw_puddle_availnums;
		_pud = tpw_puddle_availnums deleteat _rnd; // pick and remove random puddle number from available
		tpw_puddle_array select _pud setpos _spawnpos; // move to spawnpos
		if (tpw_puddle_ripple == 1) then
			{
			_puddle = tpw_puddle_array select _pud;
			_spawnpos = getposasl _puddle;
			_puddle setposasl [_spawnpos select 0, _spawnpos select 1,(_spawnpos select 2) + 0.05]; 
			};
		tpw_puddle_usednums pushback _pud; // add puddle number to used
		};
	};
	
// Main loop
tpw_puddle_mainloop =
	{
	private ["_max","_num","_diff","_spawntime"];
	_spawntime = 0; // Don't spawn puddles after this time;
	while {true} do
		{
		// If raining advance puddle stop time
		if (rain > tpw_puddle_rainthresh) then
			{
			_spawntime = diag_ticktime + tpw_puddle_time;
			};

		// "Delete" distant puddles - move them out of range and make them available
		if (count tpw_puddle_usednums > 0) then 
			{ 
				for "_i" from 0 to (count tpw_puddle_usednums - 1) do
					{
					_num = tpw_puddle_usednums select _i;
					if ( tpw_puddle_array select _num distance player > tpw_puddle_radius) then
						{
						tpw_puddle_usednums set[_i, -1];
						tpw_puddle_array select _num setposasl [0,0,10000]; // move out of range
						tpw_puddle_availnums pushback _num;
						};
					};
				tpw_puddle_usednums = tpw_puddle_usednums - [-1];	
			};
			
		// Spawn new puddles if necessary
		_diff = tpw_puddle_max - count tpw_puddle_usednums;
		if (_spawntime > diag_ticktime && {_diff > 0}) then
			{
			for "_i" from 1 to _diff do 
				{
				[] call tpw_puddle_fnc_select; 
				sleep 0.1;				
				};
			};
		sleep random 5;
		};
	};

// Simple flatness detection around designated spot	
tpw_puddle_obj = "Land_HelipadEmpty_F" createvehicle [0,0,0];	
tpw_puddle_fnc_flat = 
	{
	private ["_pos","_z1","_z2","_z3","_z4","_flat"];
	_pos = _this select 0;
	// Get z coord from each corner of 2m square
	tpw_puddle_obj setpos [(_pos select 0) - 1,(_pos select 1) - 1];
	_z1 = (getposasl tpw_puddle_obj) select 2;
	tpw_puddle_obj setpos [(_pos select 0) - 1,(_pos select 1) + 1];
	_z2 = (getposasl tpw_puddle_obj) select 2;
	tpw_puddle_obj setpos [(_pos select 0) + 1,(_pos select 1) - 1];
	_z3 = (getposasl tpw_puddle_obj) select 2;
	tpw_puddle_obj setpos [(_pos select 0) + 1,(_pos select 1) + 1];
	_z4 = (getposasl tpw_puddle_obj) select 2;
	
	// How level are the opposite corners?
	if ((abs(_z1 - _z4) < tpw_puddle_gradient) && (abs(_z2 - _z3) < tpw_puddle_gradient)) then
		{
		_flat = true;
		} else
		{
		_flat = false;
		};
	_flat	
	};

	[] call tpw_puddle_fnc_spawn;
[] spawn tpw_puddle_mainloop;	

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};	
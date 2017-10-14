/* 
TPW CROWD - Ambient crowds, spawns large numbers of civs but disables their simulation unless the player can actually see them
Author: tpw 
Date: 20170711
Version: 1.07
Requires: CBA A3, tpw_core.sqf
Compatibility: SP only

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_civs.sqf
2 - Call it with 0 = [50,2,200,100,50,1.5] execvm "tpw_crowd.sqf"; where 50 = maximum crowd size, 2 = civilians per house, 200 = maximum spawn radius, 100 = crowd members closer than this (m) will animate, 50 = crowd members closer than this will disperse (m), 1.5 = seconds between spawning/visibility scans

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 7) exitwith {hint "TPW CROWD incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_crowd_max = _this select 0; // maximum number of civs
tpw_crowd_density = _this select 1; // crowd civs per house
tpw_crowd_radius = _this select 2; // radius to scan around player
tpw_crowd_animradius = _this select 3; // units closer than this will animate
tpw_crowd_moveradius = _this select 4; // units closer than this will disperse
tpw_crowd_scantime = _this select 5; // time (sec) between scanning, spawning and visibility checks. Higher saves CPU but distant units viewed through optics will take longer to start animating
tpw_crowd_mapstrings = _this select 6;

// VARS
tpw_crowd_version = "1.07";
tpw_crowd_array = []; // array of all crowd civs
tpw_crowd_houses = []; // array of houses to spawn near
tpw_crowd_lastpos = [0,0,0]; // position of player at last house scan
tpw_crowd_active = true;
tpw_crowd_ceil = tpw_crowd_max;
_centerc = createCenter civilian;
civilian setFriend [west, 1];
west setfriend [civilian,1];
tpw_crowd_sqname = creategroup civilian;
tpw_crowd_sqname setbehaviour "CARELESS";	
tpw_crowd_sqname setspeedmode "LIMITED";

// GET APPROPRIATE CIVS IF TPW CIVS IS NOT ACTIVE
sleep 5;
if (isnil "tpw_civ_active") then
	{
	[tpw_crowd_mapstrings] call tpw_core_fnc_civs;
	};

// SCAN FOR HOUSES TO SPAWN CROWDS NEAR
tpw_crowd_fnc_houses = 
	{
	if (player distance tpw_crowd_lastpos > tpw_crowd_moveradius) then
		{
		tpw_crowd_lastpos = position player;
		tpw_crowd_houses = [tpw_crowd_radius] call tpw_core_fnc_houses;
		};
	};

// SPAWN CROWD
tpw_crowd_fnc_spawn =
	{	
	private ["_house","_roads","_civ","_civtype","_spawnpos","_spawndir","_move","_animct","_sel"];
	
	// Don't scan for houses or spawn if moving quickly
	if  (speed vehicle player >  40) exitwith {};	
	
	// Don't spawn if insufficient houses	
	[] call tpw_crowd_fnc_houses;
	if (count tpw_crowd_houses < 3) exitwith {};	

	// Adjust maximum crowd numbers
	if ((count tpw_crowd_houses) * tpw_crowd_density < tpw_crowd_max) then
		{
		tpw_crowd_ceil = (count tpw_crowd_houses) * tpw_crowd_density;
		} else
		{
		tpw_crowd_ceil = tpw_crowd_max;
		};
		
	// Smaller max crowds at night
	tpw_crowd_ceil = 1 + tpw_crowd_ceil * ([0,0,0,0,0,0.1,0.2,0.4,0.8,1,1,1,1,1,1,1,1,1,1,1,0.8,0.6,0.4,0.2,0,0] select floor daytime);
		
	// Smaller max crowds when raining
	if (rain > 0.2) then
		{
		tpw_crowd_ceil = 1 + floor (tpw_crowd_ceil / 10);
		};
	
	// Spawn on roadside if possible	
	_house = tpw_crowd_houses select (floor random count tpw_crowd_houses); // random house
	_roads = _house nearroads 25;
	if (count _roads > 1) then
		{	
		_road = _roads select floor random count _roads;
		_spawnpos = _road modeltoworld [-10,-25 + random 50,0]; // side of road hopefully
		} else
		{
		_spawnpos = [position _house,5,15,1,0,100, 0] call BIS_fnc_findSafePos;
		};
	_spawndir = _spawnpos;	

	 // Don't spawn if too close	
	if (_spawnpos distance player < tpw_crowd_animradius) exitwith {};
	
	_animct = [0,1,2,3,4,5];
	for "_i" from 1 to (2 + floor random 1) do
	
		{
		// Spawn crowd civ 
		_sqname = creategroup civilian;
		_sqname setbehaviour "CARELESS";	
		_sqname setspeedmode "LIMITED";
		_civtype = tpw_core_civs select (floor (random (count tpw_core_civs)));
		_civ = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"]; 
		_spawnpos = getposatl _civ;
		_spawnpos set [2,0];
		_civ setposatl (_spawnpos); // make sure they're at ground level

		// Random uniform if using BIS civs
		if (["c_man",str _civtype] call BIS_fnc_inString) then
			{
			_civ forceAddUniform (tpw_crowd_clothes select (floor random count tpw_crowd_clothes));
			removeheadgear _civ;
			if (random 1 > 0.5) then 
				{
				_civ execVM "\A3\characters_f\civil\scripts\randomize_civ1.sqf";// force headgear
				};
			};
			
		// Face towards spawn pos	
		_civ setdir ([_civ, _spawndir] call BIS_fnc_dirTo);
		
		// Nerf AI
		_civ disableai "MOVE";
		_civ disableai "ANIM";
		_civ disableAI "TARGET";
		_civ disableAI "FSM";
		_civ disableAI "AUTOTARGET";
		_civ disableAI "AIMINGERROR";
		_civ disableAI "SUPPRESSION"; 
		_civ disableAI "CHECKVISIBLE"; 
		_civ disableAI "COVER"; 
		_civ disableAI "AUTOCOMBAT";
		_civ setunitpos "UP";
		_civ setspeedmode "LIMITED";
		_civ disableConversation true;
		_civ setSpeaker "NoVoice";

		// Different animation for each crowd member
		_sel = _animct deleteat floor random count _animct;
		_move = ["Acts_CivilTalking_1"
		,"Acts_CivilTalking_2",
		"Acts_CivilListening_1",
		"Acts_CivilListening_2",
		"Acts_CivilIdle_1",
		"Acts_CivilIdle_2"] select _sel;
		_civ setvariable ["tpw_crowd_anim",_move];
		_civ switchmove "";
		_civ playMove _move;
		_civ setvariable ["tpw_crowd_move",0]; // not moving
		_civ setAnimSpeedCoef 0.6 + random 0.4;		
		_civ enablesimulation false; // no simulation
		tpw_crowd_array set [count tpw_crowd_array, _civ]; // add to crowd array
		};
	};

// MAIN LOOP - ADD AND REMOVE CROWD AS REQUIRED
sleep 5;
while {true} do 
	{
	private ["_opt","_civ","_vis","_dest","_dests","_rain","_gunfire","_dist","_mov"];
	if (tpw_crowd_active) then
		{
		// Gunfire?
		if (!(isnil "tpw_soap_nextcry") && {diag_ticktime < tpw_soap_nextcry + 60}) then
			{
			_gunfire = true;
			} else
			{
			_gunfire = false;
			};
		
		// Rain?
		if (rain > 0.2) then
			{
			_rain = true;
			} else
			{
			_rain = false;
			};
		
		// Is player looking through optics
		if (cameraview == "GUNNER") then
			{
			_opt = true;
			} else
			{
			_opt = false;
			};
		
		// Remove distant or damaged civs
		for "_i" from 0 to count tpw_crowd_array - 1 do
			{		
			_civ = tpw_crowd_array select _i;	
			if (_civ distance player > tpw_crowd_radius || damage _civ > 0) then
				{
				tpw_crowd_array set [_i,-1];
				deletevehicle _civ;
				};
			};
		tpw_crowd_array = tpw_crowd_array - [-1];		
		
		// Spawn new crowd if needed
		if (count tpw_crowd_array < tpw_crowd_ceil && {!(_rain)} && {!(_gunfire)}) then
			{
			tpw_crowd_clothes = [] call tpw_core_fnc_clothes;
			[] call tpw_crowd_fnc_spawn;
			};	
			
		// Animate / disperse / despawn as appropriate	
		for "_i" from 0 to count tpw_crowd_array - 1 do
			{
			
			_civ = tpw_crowd_array select _i;	
			_dist = _civ distance player;
			_mov = _civ getvariable ["tpw_crowd_move",0];			
			
			// Simulation off by default
			_civ enablesimulation false;
			
			// Visibility check
			_vis = 0;
			if (_opt || _dist < tpw_crowd_animradius) then
				{
				if (count (worldToScreen position _civ) > 0) then
					{
					_vis = [objNull, "VIEW"] checkVisibility [eyePos player, eyepos _civ];
					};
				};			
				
			// Simulation enable conditions
			if (
			(_opt && {_vis > 0.5}) || // looking through optics and visible
			(_dist  < tpw_crowd_animradius && {_vis > 0}) || // close enough and visible
			(_dist < tpw_crowd_animradius / 2) // very close, regardless of visibility
			) then
				{
				_civ enablesimulation true;	
				
				// Keep anims looping, no crouching
				if (speed _civ == 0) then 
					{
					if (animationState _civ != (_civ getvariable "tpw_crowd_anim")) then
						{
						_civ switchmove "";
						_civ playmove (_civ getvariable "tpw_crowd_anim");
						};
					} else
					{	
					if (stance _civ != "STAND") then
						{
						_civ switchmove "";
						};
					};
				};	

			// Disperse / remove stationary crowds if gunfire or rain
			if ((_gunfire || _rain) && {_mov == 0}) then
				{
				if	(_vis > 0) then
					{
					_civ setspeedmode "FULL";
					_civ setvariable ["tpw_crowd_move",1];
					_civ enablesimulation true;
					_civ setAnimSpeedCoef 0.8 + random 0.2;
					_civ enableai "MOVE";
					_civ enableai "ANIM";
					_civ switchmove "";
					_civ setunitpos "UP";
					_dests = nearestTerrainObjects [position _civ,["building","house"],50,false];
					_dest = position (_dests select (floor random count _dests));
					_civ domove _dest;
					_civ setvariable ["tpw_crowd_dest",_dest];
					} else
					{
					_civ setvariable ["tpw_crowd_move",10];
					};
				}; 

			// Disperse close crowds
			if (_dist  < tpw_crowd_moveradius && {random 1 > 0.5} && {_vis > 0} && {_mov == 0}) then
				{
				_civ setvariable ["tpw_crowd_move",1];
				_civ enablesimulation true;
				_civ setAnimSpeedCoef 0.8 + random 0.2;
				_civ enableai "MOVE";
				_civ enableai "ANIM";
				_civ switchmove "";
				_civ setunitpos "UP";
				_dests = nearestTerrainObjects [position _civ,["building","house"],50,false];
				_dest = position (_dests select (floor random count _dests));
				_civ domove _dest;
				_civ setvariable ["tpw_crowd_dest",_dest];
				};
	
			// Delete out of sight moving crowd after a few sec
			if (_mov > 0 && {_vis ==0}) then
				{
				_civ setvariable ["tpw_crowd_move",_mov + 1];
				};
			
			// Delete civ
			if (_mov > 4 && {_vis == 0}) then
				{
				tpw_crowd_array set [_i,-1];
				deletegroup (group _civ);
				deletevehicle _civ;
				sleep 0.1;
				};	
			};	
		tpw_crowd_array = tpw_crowd_array - [-1];	
		};	
	sleep tpw_crowd_scantime;
	};
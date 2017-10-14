/* 
TPW BOATS - Ambient civilian boats
Author: tpw 
Additional code suggestions: LordPrimate
Date: 20170713
Version: 1.34
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_boats.sqf
2 - Call it with 0 = [5,1000,15,2] execvm "tpw_boats.sqf"; where 5 = start delay, 1000 = radius, 15 = number of waypoints, 2 = max boats

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 4) exitwith {hint "TPW BOATS incorrect/no config, exiting."};
if (_this select 3 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN VARIABLES
tpw_boat_version = "1.34"; // Version string
tpw_boat_sleep = _this select 0;
tpw_boat_radius = _this select 1;
tpw_boat_waypoints = _this select 2;
tpw_boat_maxnum = _this select 3;

// DEFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_boat_sleep = 5;
	tpw_boat_radius = 1000;
	tpw_boat_waypoints = 15;
	tpw_boat_num =2;
	};

tpw_boat_active = true; // Global enable/disable
tpw_boat_debug = false; // Debugging
tpw_boat_boatarray = []; // Player's array of boats
tpw_boat_mindist = 200; // Don't remove boats closer than this
tpw_boat_slowdist = 100; // Boats slow down when this close 
tpw_boat_spawnradius = tpw_boat_radius / 2; // Boats will spawn this far from player
tpw_boat_num = tpw_boat_maxnum;
tpw_boat_time = time + random 120;

_boatlist = [
"C_Boat_Civil_01_F",
"C_Boat_Civil_01_police_F",
"C_Boat_Civil_01_rescue_F",
"C_rubberboat"
];

_tanoaboatlist = [
"c_boat_transport_02_f",
"c_scooter_transport_01_f"
];

if (isclass (configfile/"CfgWeapons"/"u_c_man_casual_1_f")) then 
	{
	_boatlist = _boatlist + _tanoaboatlist;
	};
	
// DELAY
sleep tpw_boat_sleep;

// CREATE AI CENTRE
_centerC = createCenter civilian;

//FIND WATER NEAR PLAYER
tpw_boat_fnc_findwater = 
	{
	private ["_pos","_spawnpos"];
	_pos = position player;
	waituntil
		{
		sleep 0.2;
		_spawnpos = [_pos, 250, tpw_boat_spawnradius, 5, 2, 0, 0] call BIS_fnc_findSafePos;
		!(isnil "_spawnpos");
		};
	[_spawnpos] call tpw_boat_fnc_spawnboat;
	};
	
// SPAWN BOAT/DRIVER IN THE WATER
tpw_boat_fnc_spawnboat =
	{
	private ["_spawnpos","_boat","_spawnboat"];
	_spawnpos = _this select 0;
	
	//Random boat
	_sqname = creategroup civilian;
	_boat = _boatlist select (floor (random (count _boatlist)));
	_spawnboat = _boat createVehicle _spawnpos;
	
	// Random civ
	_civ = tpw_core_civs select (floor (random (count tpw_core_civs)));
	_civ createunit [_spawnpos,_sqname,"this moveindriver _spawnboat;this setskill 0;this disableAI 'TARGET';this disableAI 'AUTOTARGET';this setbehaviour 'CARELESS'; this setSpeaker format ['Male0%1GRE',ceil (random 4)]"]; 
	
	//Add killed/hit eventhandlers to driver
	(leader _sqname) addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	(leader _sqname) addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
	
	//Passenger - thanks LordPrimate
	if (random 10 < 5) then
		{
		_civtype = tpw_core_civs select (floor (random (count tpw_core_civs)));
		_passenger = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"];
		_passenger setSpeaker format ["Male0%1GRE",ceil (random 4)];
		_passenger setSkill 0;
		_passenger disableAI "TARGET";
		_passenger disableAI "AUTOTARGET";
		_passenger moveInCargo _spawnboat;
		_passenger addEventHandler ["Hit",{_this call tpw_civ_fnc_casualty}];
		_passenger addEventHandler ["Killed",{_this call tpw_civ_fnc_casualty}];
		};
	
	// Assign waypoints
	[_sqname,_spawnpos] call tpw_boat_fnc_waypoints;
	
	//Mark it as owned by this player
	_spawnboat setvariable ["tpw_boat_owner",[player],true];

	//Mark boat's driver
	_spawnboat setvariable ["tpw_boat_driver",(leader _sqname),true];
	
	// Add it to player's boat array
	tpw_boat_boatarray set [count tpw_boat_boatarray,_spawnboat];
	
	// Timer for stuck boat
	_spawnboat setvariable ["tpw_boat_stucktime", diag_ticktime + 60]
	};	
	
// SEE IF ANY BOATS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, USE THESE INSTEAD OF SPAWNING A NEW BOAT (MP)
tpw_boat_fnc_nearboat =
	{
	private ["_owner","_nearboats","_shareflag","_i","_boat"];
	_spawnflag = 1;
	if (isMultiplayer) then 
		{
		// Array of near boats
		_nearboats = (position player) nearEntities [["Ship"], tpw_boat_radius];

		// Live boats within range
		for "_i" from 0 to (count _nearboats - 1) do	
			{
			_boat = _nearboats select _i;	
			if (_boat distance vehicle player < tpw_boat_radius && alive _boat) then   
				{
				_owner = _boat getvariable ["tpw_boat_owner",[]];

				//Units with owners, but not this player
				if ((count _owner > 0) && !(player in _owner)) exitwith
					{
					_spawnflag = 0;
					_owner set [count _owner,player]; // add player as another owner of this car
					_boat setvariable ["tpw_boat_owner",_owner,true]; // update ownership
					tpw_boat_boatarray set [count tpw_boat_boatarray,_boat]; // add this boat to the array of boats for this player
					};
				} 
			};
		};
	//Otherwise, spawn a new boat
	if (_spawnflag == 1) then 
		{
		[] call tpw_boat_fnc_findwater;    
		};
	};  	

// WATER WAYPOINTS
tpw_boat_fnc_waypoints =
	{
	private ["_spawnpos","_grp","_posx","_posy","_wp","_wppos"];
	_grp = _this select 0;
	_spawnpos = _this select 1;
	for "_i" from 1 to tpw_boat_waypoints do
		{
		_wppos = [_spawnpos, tpw_boat_spawnradius / 2, tpw_boat_spawnradius, 5, 2, 0, 0] call BIS_fnc_findSafePos;
		_wp = _grp addWaypoint [_wppos, 50];
		
		if (_i == tpw_boat_waypoints) then 
			{
			_wp setwaypointtype "CYCLE";
			};
		};
	};

// MAIN LOOP - ADD AND REMOVE BOATS AS NECESSARY, CHECK IF OTHER PLAYERS HAVE DIED (MP)
while {true} do 
	{
	if (tpw_boat_active) then
		{
		private ["_driver","_boatarray","_deadplayer","_group","_boat","_i","_index","_water"];
		tpw_boat_removearray = [];

		// Debugging	
		if (tpw_boat_debug) then {hintsilent format ["boats: %1",count tpw_boat_boatarray]};
		
		// Add boats if daytime
		if (count tpw_boat_boatarray == 0) then 
			{
			tpw_boat_num = ceil (random tpw_boat_maxnum);
			};
		
		if (count tpw_boat_boatarray < tpw_boat_num  && {daytime > 5 && daytime < 20} && {time > tpw_boat_time}) then 
			{
			// Only bother if there is water near the player
			_water = [position player , 500, tpw_boat_spawnradius, 5, 2, 0, 0] call BIS_fnc_findSafePos;
			if (surfaceiswater _water) then
				{
				tpw_boat_time = time + random 120;
				0 = [] call tpw_boat_fnc_nearboat;
				};
			};
			
		for "_i" from 0 to (count tpw_boat_boatarray - 1) do	
			{
			_boat = tpw_boat_boatarray select _i;
			
			// Slow down near player
			if (_boat distance player < tpw_boat_slowdist) then 
				{
				_boat setSpeedMode "LIMITED";
				} else
				{
				_boat setSpeedMode "NORMAL";
				};
				
			// If boat is moving
			if (abs(speed _boat) > 5) then
				{
				_boat setvariable ["tpw_boat_stucktime", diag_ticktime + 60]; 
				};

			//Conditions for removing boat
			if (_boat distance vehicle player > tpw_boat_radius || // too far from player
			damage _boat > 0.9 || // boat too damaged 
			damage (driver _boat) > 0.5 || // boat driver too damaged
			(driver _boat) distance _boat > 2 || // boat driver away from boat
			diag_ticktime > _boat getvariable "tpw_boat_stucktime" // boat has been still for 60 sec
			) then
				{
				_boat setvariable ["tpw_boat_owner", (_boat getvariable "tpw_boat_owner") - [player],true];            
				tpw_boat_removearray set [count tpw_boat_removearray,_boat];    
				};

			// Delete the boat, driver and waypoints if it's not owned by anyone    
			if (count (_boat getvariable ["tpw_boat_owner",[]]) == 0) then    
				{
				_driver = _boat getvariable "tpw_boat_driver";
				_group = group _driver;	
				for "_i" from count (waypoints _group) to 1 step -1 do
					{
					deleteWaypoint ((waypoints _group) select _i);
					};
					{
					moveout _x;
					deletevehicle _x;
					sleep 0.1;
					} count units _group;		
				deletevehicle _boat;
				deletegroup _group;
				};
			_boat setvariable ["tpw_boat_lastspeed",(speed _boat)];	
			};

		// Update player's boat array    
		tpw_boat_boatarray = tpw_boat_boatarray - tpw_boat_removearray;
		player setvariable ["tpw_boatarray",tpw_boat_boatarray,true];

		// If MP, check if any other players have been killed and disown their boats
		if (isMultiplayer) then 
			{
				{
				if ((isplayer _x) && !(alive _x)) then
					{
					_deadplayer = _x;
					_boatarray = _x getvariable ["tpw_boatarray"];
						{
						_x setvariable ["tpw_boat_owner",(_x getvariable "tpw_boat_owner") - [_deadplayer],true];
						} count _boatarray;
					};
				} count allunits;    
			};
		};	
	sleep random 10;    
	};  
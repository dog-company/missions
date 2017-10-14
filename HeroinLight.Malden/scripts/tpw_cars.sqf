/* 
TPW CARS - Ambient civilian traffic
Author: tpw 
Date: 20170811
Version: 1.56
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_cars.sqf
2 - Call it with 0 = [5,1000,15,2,1,["str1","str2",etc]] execvm "tpw_cars.sqf"; where 5 = start delay, 1000 = radius, 15 = number of waypoints, 2 = max cars, 1 = no cars spawned during combat (0 = cars spawned during combat), ["str1","str2",etc] = substrings of mod car classnames

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 6) exitwith {hint "TPW CARS incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

private ["_clothes","_houses","_carlist","_sqname","_centerC"];

// READ IN VARIABLES
tpw_car_version = "1.56"; // Version string
tpw_car_sleep = _this select 0;
tpw_car_radius = _this select 1;
tpw_car_waypoints = _this select 2;
tpw_car_maxnum = _this select 3;
tpw_car_nocombatspawn = _this select 4;
tpw_car_include = _this select 5;

// DEFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_car_sleep = 5;
	tpw_car_radius = 1000;
	tpw_car_waypoints = 15;
	tpw_car_maxnum =2;
	};
	
// VARIABLES
_civcarlist = [
"C_Hatchback_01_F",
"C_Hatchback_01_F",
"C_Hatchback_01_F",
"C_Offroad_01_F",
"C_Offroad_01_F",
"C_Offroad_01_F",
"C_SUV_01_F",
"C_SUV_01_F",
"C_SUV_01_F",
"C_Quadbike_01_F"
]; 

// ADD TANOAN CARS IF AVAILABLE
if (isclass (configfile/"CfgWeapons"/"u_c_man_casual_1_f")) then 
	{
	_civcarlist = _civcarlist + ["C_Offroad_02_unarmed_F","C_Offroad_02_unarmed_F","C_Offroad_02_unarmed_F"];
	};

_comcarlist = [
"C_Van_01_box_F",
"C_Van_01_transport_F",
"C_Van_01_fuel_F"
]; 

// ADD IDAP CARS IF AVAILABLE
if (isclass (configfile/"CfgWeapons"/"U_C_IDAP_Man_cargo_F")) then 
	{	
	private ["_cfg"];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {["IDAP",str _cfgname] call BIS_fnc_inString}) then 
				{
				_civcarlist pushback _cfgname;
				};
			};
		};
	};

_comcarlist = [
"C_Van_01_box_F",
"C_Van_01_transport_F",
"C_Van_01_fuel_F"
]; 


// ADD CARS FROM INCLUDE LIST
	{
	private ["_cfg"];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_x,str _cfgname] call BIS_fnc_inString}) then 
				{
				_civcarlist pushback _cfgname;
				};
			};
		};
	} count tpw_car_include;


// SPAWN EACH TO CACHE THEM
//{_temp = _x createvehicle [0,0,0]; sleep 0.1; deletevehicle _temp} foreach _civcarlist;	
//{_temp = _x createvehicle [0,0,0]; sleep 0.1; deletevehicle _temp} foreach _comcarlist;	

tpw_car_cararray = []; // array holding spawned cars
tpw_car_farroads = []; // roads > 250m from unit
tpw_car_roadlist = []; // roads near unit
tpw_car_debug = false; // Car counter
tpw_car_radius_orig = tpw_car_radius; // Original radius to reset to after exclusion
tpw_car_exclude = false; // Is player near car exclusion zone?
tpw_car_mindist = 100; // Car won't be removed if closer than this to player
tpw_car_slowdist = 150; // Car will slow down if this close to the player
tpw_car_spawndist = 250; // Cars will be spawned further than this distance from player
tpw_car_active = true; // Global activate/deactivate
tpw_car_spawntime = 0; // Will be set up to 5 minutes past the last suppression event
tpw_car_num = tpw_car_maxnum;
tpw_car_time = time; // Time until next car can spawn
tpw_car_lastpos = [0,0,0];


// DELAY	
sleep tpw_car_sleep;	

// CREATE AI CENTRE
_centerC = createCenter civilian;

// DELETE CAR OCCUPANTS AND WAYPOINTS
tpw_car_fnc_delete =
	{
	private ["_grp","_index"];
	_grp = _this select 0;

	// Delete occupants
		{
		deletevehicle _x;
		sleep 0.1;
		} count units _grp;	

	// Delete occupant group		
	deletegroup _grp;
	};

// SPAWN CIV/CAR INTO EMPTY GROUP
tpw_car_fnc_carspawn =
	{
	private ["_civtype","_driver","_car","_roadseg","_spawnpos","_spawndir","_i","_ct","_sqname","_carlist","_road","_wp","_wppos"];

	// Only bother if enough time has passed since battle
	if (diag_ticktime < tpw_car_spawntime) exitwith {};	
	
	// Pick a random road segment to spawn car
	[] call tpw_car_fnc_roadpos;
	if (count tpw_car_roadlist < 100) exitwith {};
	_roadseg = tpw_car_roadlist select (floor (random (count tpw_car_roadlist)));
	if (_roadseg distance player < tpw_car_spawndist ) exitwith {};
	
	_carlist = _civcarlist;
	if (daytime > 5 || daytime < 20) then
		{
		_carlist = _civcarlist + _civcarlist + _comcarlist; // vans only during daytime
		};
	
	_spawnpos = getposasl _roadseg;
	_spawndir = getdir _roadseg;
	_car = _carlist select (floor (random (count _carlist)));
	 _sqname = creategroup civilian;
	_spawncar = _car createVehicle _spawnpos;
	_spawncar setdir _spawndir; 
	_spawncar setfuel random 0.5;
	_spawncar limitspeed 100;

	//Driver
	_civtype = tpw_core_civs select (floor (random (count tpw_core_civs)));
	_driver = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"]; 
	_driver setSpeaker "NoVoice";
	_driver setskill 0;
	_driver disableAI 'TARGET';
	_driver disableAI 'AUTOTARGET';
	_driver disableAI 'FSM';
	_driver moveindriver _spawncar;
	_driver setbehaviour "CARELESS";	
	_driver addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
	_driver addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
	
	//Passenger
	if (random 10 < 5) then 
		{
		_civtype = tpw_core_civs select (floor (random (count tpw_core_civs)));
		_passenger = _sqname createUnit [_civtype,_spawnpos, [], 0, "FORM"]; 
		_passenger setSpeaker "NoVoice";
		_passenger moveincargo _spawncar;
		_passenger setbehaviour "CARELESS";	
		_passenger setskill 0;
		_passenger disableAI 'TARGET';
		_passenger disableAI 'AUTOTARGET';
		_passenger addeventhandler ["Hit",{_this call tpw_civ_fnc_casualty}];
		_passenger addeventhandler ["Killed",{_this call tpw_civ_fnc_casualty}];
		};
	
	//Set variables 
	_spawncar setvariable ["tpw_car_owner", [player],true];
	_spawncar setvariable ["tpw_car_occupants",_sqname,true];

	//Add ability to commandeer car
	_spawncar addaction 
		[
		"Commandeer Vehicle",
			{
			private ["_car","_grp"];
			_car = _this select 0;
			_grp = _car getvariable "tpw_car_occupants";
			
			// Occupants out of car	
				{
				unassignvehicle _x;
				_x leavevehicle _car;
				} count crew _car;
			
			// Delete occupants if far enough away
			[_grp] spawn 
				{
				private ["_grp","_unit"];
				_grp = _this select 0;
				_unit = (units _grp) select 0;
				waituntil
					{
					sleep 2;
					(_unit distance player > 100);
					};
				[_grp] call tpw_car_fnc_delete;	
				};
			
			// Remove menu item
			_car removeaction 0;
		
			// Remove car from player's car array (it can no longer be despawned)
			tpw_car_cararray = tpw_car_cararray - [_this select 0];
			}
		,nil,0,vehicle player == player	
		];

	//Add car to the array of spawned cars
	tpw_car_cararray set [count tpw_car_cararray,_spawncar];

	//Assign waypoints
	for "_i" from 1 to tpw_car_waypoints do
		{
		sleep 0.2;
		_road = tpw_car_roadlist select (floor (random (count tpw_car_roadlist)));
		_wppos = getposasl _road; 
		_wp = _sqname addWaypoint [_wppos, 0];
		_wp setWaypointCompletionRadius 50;
		if (_i == tpw_car_waypoints) then 
			{
			_wp setwaypointtype "CYCLE";
			} else
			{
			_wp setWaypointType "MOVE";
			};
		};
		
	// Timer for stuck vehicle	
	_spawncar setvariable ["tpw_car_stucktime", diag_ticktime + 60]; 
	};
    
// SEE IF ANY CARS OWNED BY OTHER PLAYERS ARE WITHIN RANGE, WHICH CAN BE USED INSTEAD OF SPAWNING A NEW CIV
tpw_car_fnc_nearcar =
	{
	private ["_owner","_nearcars","_shareflag","_car","_i","_exc"];
	_shareflag = 0;
	if (isMultiplayer) then 
		{
		// Array of near cars
		_nearcars = (position player) nearEntities [["Car"], tpw_car_radius];

		// Live units within range
		for "_i" from 0 to (count _nearcars - 1) do		
			{    
			_car = _nearcars select _i;
			if (_car distance vehicle player < tpw_car_radius && alive _car) then   
				{
				_owner = _car getvariable ["tpw_car_owner",[]];

				//Units with owners, but not this player
				if ((count _owner > 0) && !(player in _owner)) exitwith
					{
					_shareflag = 1;
					_owner set [count _owner,player]; // add player as another owner of this car
					_car setvariable ["tpw_car_owner",_owner,true]; // update ownership
					tpw_car_cararray set [count tpw_car_cararray,_car]; // add this car to the array of cars for this player
					};
				} 
			};
		};
	//Otherwise, spawn a new car
	if (_shareflag == 0) then 
		{
		[] call tpw_car_fnc_carspawn;    
		};
	};        
	
// POOL OF ROAD POSTIONS NEAR PLAYER
tpw_car_fnc_roadpos = 
	{ 
	if (tpw_car_lastpos distance player > tpw_car_radius / 2) then
		{
		tpw_car_lastpos = getposasl player;
		tpw_car_roadlist = ((position player) nearRoads tpw_car_radius) select {isonroad _x && {_x distance player > 250}};
		};
	};

sleep 3;

// DISABLE VEHICLE COLLISIONS WITH NEARBY AI
tpw_car_fnc_nocollide =
	{
	private ["_allcars","_movecars","_stopcars","_car"];
	while {true} do
		{
			if (tpw_car_nocollision) then
			{
			_allcars = (player nearentities ["car",100])  - [vehicle player];
			_movecars = (_allcars select {(abs speed _x) > 0.05});
			
				// Show units within 10m of all cars
				{
				_car = _x;
					{
					_x hideobject false;
					} foreach (_car nearentities ["man",10]);
				} foreach _allcars;
			
				// Hide units within 5m of moving cars
				{
				_car = _x;
					{
					_x hideobject true;
					} foreach (_car nearentities ["man",4]);
				} foreach _movecars;
			
			};
		sleep 0.1;
		};
	};	

// MAIN LOOP - ADD AND REMOVE CARS AS NECESSARY, CHECK IF OTHER PLAYERS HAVE DIED (MP)
tpw_car_nocollision = true;
[] spawn tpw_car_fnc_nocollide;
while {true} do 
	{
	if (tpw_car_active) then
		{
		private ["_cararray","_deadplayer","_grp","_center","_group","_logic","_driver","_near","_car","_i","_unit","_ncity","_dst","_cpos","_nearest","_dir"];
		tpw_car_removearray = [];
		
		// No new traffic if there's combat (as determined by TPW_SOAP)
		if (!(isnil "tpw_soap_nextcry") && {diag_ticktime < tpw_soap_nextcry + 60} && {tpw_car_nocombatspawn == 1}) then 
			{
			tpw_car_spawntime = diag_ticktime + (random 300);
			for "_i" from 0 to (count tpw_car_cararray - 1) do
				{
				_car = tpw_car_cararray select _i;
				if (_car distance player < tpw_car_radius) then
					{
					dostop (driver _car); // stop the car, eventually it'll be deleted as appropriate
					};
				};
			};

		// Debugging	
		if (tpw_car_debug) then {hintsilent format ["Cars: %1",count tpw_car_cararray]};

		// Randomise max cars
		if (count tpw_car_cararray ==0) then
			{
			tpw_car_num = ceil (random tpw_car_maxnum);
			
			// Fewer cars at night
			if (daytime < 5 || daytime > 20) then
				{
				tpw_car_num = tpw_car_num / 2
				};	
			};
					
		// Add cars as necessary			
		if (count tpw_car_cararray < tpw_car_num) then
			{
			//Delay car spawning based on proximity to towns (thanks Rydygier)
			if (time > tpw_car_time) then 
				{
				if (count nearestLocations [position player, ["NameCity","NameCityCapital","NameVillage"], tpw_car_radius] == 0) then
					{
					tpw_car_time = time + random 180;
					}
					else
					{
					tpw_car_time = time + 10;
					};
				0 = [] call tpw_car_fnc_nearcar;
				};
			};
		if (count tpw_car_cararray > 0) then
			{
			for "_i" from 0 to (count tpw_car_cararray - 1) do
				{
				_car = tpw_car_cararray select _i;
				_driver = driver _car;
				_dst = _car distance vehicle player;
				
				// Remove commandeer menu from damaged cars or those with dead drivers
				if (damage _car > 0.2 || !(alive _driver)) then
					{
					_car removeaction 0;	
					};
					
				// If car is moving
				if (abs(speed _car) > 5) then
					{
					_car setvariable ["tpw_car_stucktime", diag_ticktime + 60]; 
					};
				//Conditions for removing car
				if (driver _car != player) then
					{
					if ((_dst > tpw_car_radius) || // too far from player
					(count (_car nearroads 50) == 0) ||  // too far from road
					diag_ticktime > _car getvariable "tpw_car_stucktime" // car has been still for 60 sec
					) then 
						{
						// If player can't see the car
							if (_dst  > tpw_car_mindist && {[objNull, "VIEW"] checkVisibility [eyePos player, eyePos driver _car] < 0.9}) then
								{
								//  Remove player as owner, remove from player's car array
								_car setvariable ["tpw_car_owner", (_car getvariable "tpw_car_owner") - [player],true];            
								tpw_car_cararray set [_i,-1];    
								};
						};
						
					// Slow cars close to player	
					if (_dst < 100)then
						{
						_car limitspeed 60;
						};
						
					// Stop cars too close to player - will be removed eventually	
					if (_dst < 50 && {isonroad player}) then
						{
						dostop (driver _car);
						};
					};

				// Delete the car, occupants and waypoints if it's not owned by anyone    
				if (count (_car getvariable ["tpw_car_owner",[]]) == 0) then    
					{
					_grp = _car getvariable "tpw_car_occupants";
					[_grp] call tpw_car_fnc_delete;
					deletevehicle _car;
					sleep 0.1;
					};
				};	

			// Update player's car array    
			tpw_car_cararray = tpw_car_cararray - [-1];
			player setvariable ["tpw_cararray",tpw_car_cararray,true];

			// If MP, check if any other players have been killed and disown their cars
			if (isMultiplayer) then 
				{
					{
					if ((isplayer _x) && !(alive _x)) then
						{
						_deadplayer = _x;
						_cararray = _x getvariable ["tpw_cararray"];
							{
							_x setvariable ["tpw_car_owner",(_x getvariable "tpw_car_owner") - [_deadplayer],true];
							} count _cararray;
						};
					} count allunits;    
				};
			};	
		};
	sleep random 10;    
	};  

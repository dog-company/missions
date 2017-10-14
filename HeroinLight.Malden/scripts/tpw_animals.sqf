/* 
TPW ANIMALS - Spawn ambient animals around player.
Author: tpw 
Date: 20170506
Version: 1.37
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_animals.sqf
2 - Call it with 0 = [10,15,200,75,60] execvm "tpw_animals.sqf"; where 10 = start delay, 15 = maximum animals near player, 200 = animals will be removed beyond this distance (m), 75 = minimum distance from player to spawn an animal (m), 60 = maximum time between dog/cat noises (sec)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 5) exitwith {hint "TPW ANIMALS incorrect/no config, exiting."};
if (_this select 1 == 0) exitwith {};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_animal_version = "1.37"; // Version string
tpw_animal_sleep = _this select 0; // delay until animals start spawning
tpw_animal_max = _this select 1; // maximum animals near player
tpw_animal_maxradius = _this select 2; // distance beyond which animals will be removed
tpw_animal_minradius = _this select 3; // minimum distance from player to spawn animals
tpw_animal_noisetime = _this select 4; // maximum time in between animal noises

// DEFAULT VALUES FOR MP
if (isMultiplayer) then 
	{
	tpw_animal_sleep = 9.99; 
	tpw_animal_max =15; 
	tpw_animal_maxradius = 200;
	tpw_animal_minradius = 75;
	};

// VARIABLES
tpw_animal_debug = false; // debugging
tpw_animal_array = []; // array of animals near player
tpw_animal_exclude = false; // player near exlusion object
tpw_animal_active = true; // global activate/deactivate

tpw_animals = // array of animals and their min / max flock sizes
[["Hen_random_F",2,4], // chicken
["Sheep_random_F",3,6], // sheep
["Sheep_random_F",3,6],
["Goat_random_F",3,6], // goat
["Goat_random_F",3,6],
["Alsatian_random_F",1,1], // alsation
["Fin_random_F",1,1]]; // mutt

// DELAY
sleep tpw_animal_sleep;

// CONDITIONS FOR SPAWNING A NEW ANIMAL
tpw_animal_fnc_nearanimal =
	{
	private ["_owner","_spawnflag","_deadplayer","_animalarray","_animal","_i"];

	if ((count nearestTerrainObjects [player, ["tree","smalltree"], tpw_animal_minradius, false]) > 50) exitwith {}; // don't bother with animals if too many trees nearby
	
	if ((count nearestTerrainObjects [player, ["house"], tpw_animal_minradius, false]) > 5) exitwith {}; // don't bother with animals if too many buildings nearby	
	
	if (count nearestLocations [position player, ["NameCity","NameCityCapital","NameVillage","NameLocal"], tpw_animal_maxradius] > 0) exitwith {}; // don't bother if town nearby
	
	_spawnflag = true; // only spawn animal if this is true

	// Check if any players have been killed and disown their animals - MP
	if (isMultiplayer) then 
		{
			{
			if ((isplayer _x) && !(alive _x)) then
				{
				_deadplayer = _x;
				_animalarray = _x getvariable ["tpw_animalarray"];
				for "_i" from 0 to (count _animalarray - 1) do 
					{
					
					_animal setvariable ["tpw_animal_owner",(_animal getvariable "tpw_animal_owner") - [_deadplayer],true];
					};
				};
			} count allunits;    

		// Any nearby animals owned by other players - MP
		_nearanimals = (position player) nearentities [["Fowl_Base_F", "Dog_Base_F", "Goat_Base_F", "Sheep_Random_F"],tpw_animal_maxradius]; 
		for "_i" from 0 to (count _nearanimals - 1) do 
			{
			_animal = _nearanimals select _i;
			_owner = _animal getvariable ["tpw_animal_owner",[]];
	
			//Animals with owners who are not this player
			if ((count _owner > 0) && !(player in _owner)) exitwith
				{
				_spawnflag = false;
				_owner set [count _owner,player]; // add player as another owner of this animal
				_animal setvariable ["tpw_animal_owner",_owner,true]; // update ownership
				tpw_animal_array set [count tpw_animal_array,_animal]; // add this animal to the array of animals for this player
				};
			};
		};  
    
	// Otherwise, spawn a new animal
	if (_spawnflag) then 
		{
		[] spawn tpw_animal_fnc_spawn;    
		};     
	};

// SPAWN ANIMALS INTO APPROPRIATE SPOTS
tpw_animal_fnc_spawn =
	{
	private ["_group","_pos","_dir","_posx","_posy","_spawnpos","_type","_animal","_typearray","_type","_flock","_minflock","_maxflock","_diff","_i"];

	_typearray = tpw_animals select (floor (random (count tpw_animals))); // select animal/flocksize
	_type = _typearray select 0; // type of animal
	_minflock = _typearray select 1; // minimum flock size
	_maxflock = _typearray select 2; // maximum flock size
	_diff = round (random (_maxflock - _minflock)); // how many animals more than minimum flock size
	_flock = _minflock + _diff; // flock size
	_pos = getposasl player; 	
	_spawnpos = [_pos, tpw_animal_minradius, tpw_animal_maxradius, 5, 0, 100, 0] call BIS_fnc_findSafePos;
	
	if(!(isnil "_spawnpos")) then 
		{
		// Spawn flock
		for "_i" from 1 to _flock do 
			{
			sleep random 3;
			_animal = createAgent [_type,_spawnpos, [], 0, "NONE"];
			_animal setdir random 360;
			_animal setbehaviour "CARELESS";
			_animal setSpeedMode "LIMITED";
			_animal setvariable ["tpw_animal_startpos",_spawnpos];
			_animal setvariable ["tpw_animal_owner",[player],true]; // mark it as owned by this player
			tpw_animal_array set [count tpw_animal_array,_animal]; // add to player's animal array
			player setvariable ["tpw_animalarray",tpw_animal_array,true]; // broadcast it
			};
		};	
	};

//DISPERSE	
tpw_animal_disperse = 
	{
	private ["_obj","_animal","_adir","_pdir","_dir","_pos","_posx","_posy"];
	_obj = _this select 0;
	_animal = _this select 1;
	
	if (_animal getvariable ["tpw_animal_disperse",0] == 0) then	
		{
		sleep random 2;
		_animal setvariable	["tpw_animal_disperse",1];
		_adir = [_obj,_animal] call bis_fnc_dirto;
		_pdir = direction _obj;
		_dir = 0;
		if (_adir < _pdir) then
			{
			_dir = _pdir - 45 - random 20;
			}
		else
			{
			_dir = _pdir + 45 + random 20;
			};
		_animal setdir _dir;	
		for "_i" from 1 to (50 + random 100) do
			{
			_pos = position _animal;
			_posx = (_pos select 0) + (0.05 * sin _dir);
			_posy = (_pos select 1) +  (0.05 * cos _dir);
			_animal setposatl [_posx,_posy,0];
			sleep random 0.1;
			};
		_animal setvariable	["tpw_animal_disperse",0];	
		};	
	};	
	
// BARKING DOGS	
tpw_animal_fnc_dogbark =
	{
	private ["_ball","_pos","_dist","_posx","_posy","_barkpos","_bark","_nearhouses","_vol"];		
	
	//Invisible object to attach bark to 
	_ball = "Land_HelipadEmpty_F" createvehiclelocal [0,0,0];
		
	while {true} do
		{
		if (tpw_animal_active && {player == vehicle player}) then
			{
			// random position around player
			_pos = getposasl player;
			_dir = random 360;
			_dist = 10 + (random 10);
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_barkpos = [_posx,_posy,0]; 
			_ball setposatl _barkpos;
					
			// Scan for habitable houses 
			_nearhouses = [100] call tpw_core_fnc_houses;
			
			// Reduce bark volume away from habitation
			if (count _nearhouses == 0) then 
				{
				_vol = 0.25;
				}
			else
				{
				_vol = 1;
				};
			
			// play bark
			_bark = format ["TPW_SOUNDS\sounds\dog%1.ogg",ceil (random 20)];
			playsound3d [_bark,_ball,false,getposasl _ball,_vol,1,50];
			};
		sleep random tpw_animal_noisetime;
		};
	};	
	
// YOWLING CATS AT NIGHT 	
tpw_animal_fnc_catmeow =
	{
	private ["_nearhouses","_ball","_pos","_dist","_posx","_posy","_meowpos","_meow"];		
	//Invisible object to attach meow to 
	_ball = "Land_HelipadEmpty_F" createvehiclelocal [0,0,0];
		
	while {true} do
		{
		// Scan for habitable houses 
		
		_nearhouses = [100] call tpw_core_fnc_houses;
		if (tpw_animal_active && {count _nearhouses > 0} && {(daytime < 5 || daytime > 20)} && {player == vehicle player}) then
			{
			// random position around player
			_pos = getposasl player;
			_dir = random 360;
			_dist = 15 + (random 10);
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_meowpos = [_posx,_posy,0]; 
			_ball setposatl _meowpos;
			
			// play meow
			_meow = format ["TPW_SOUNDS\sounds\cat%1.ogg",ceil (random 5)];
			playsound3d [_meow,_ball,false,getposasl _ball,1,0.5 + (random 0.6),50];
			};
		sleep random tpw_animal_noisetime;
		};
	};	

// BLEATING GOATS 	
tpw_animal_fnc_goatbleat =
	{
	private ["_bleatpos","_bleat","_neargoats","_goat"];		
	while {true} do
		{
		_neargoats = (position player) nearEntities ["goat_base_f", 50];
		if (tpw_animal_active && {count _neargoats > 0} && {(daytime < 5 || daytime < 20)} && {player == vehicle player}) then
			{
			// Random goat
			_goat = _neargoats select (floor (random (count _neargoats)));
			_bleatpos = getposasl _goat; 
			
			// Play bleat
			_bleat = format ["TPW_SOUNDS\sounds\goat%1.ogg",ceil (random 5)];
			playsound3d [_bleat,_goat,false,getposasl _goat,2,0.9 + (random 0.2),100];
			};
		sleep random 10;
		};
	};	

// CLUCKING CHICKENS 	
tpw_animal_fnc_chickencluck =
	{
	private ["_cluckpos","_cluck","_nearchickens","_chicken"];		
	while {true} do
		{
		_nearchickens = (position player) nearEntities ["Fowl_Base_F", 50];
		if (tpw_animal_active && {count _nearchickens > 0} && {(daytime < 5 || daytime < 20)} && {player == vehicle player}) then
			{
			// Random chicken
			_chicken = _nearchickens select (floor (random (count _nearchickens)));
			_cluckpos = getposasl _chicken; 
			
			// Play cluck
			_cluck = format ["TPW_SOUNDS\sounds\cluck%1.ogg",ceil (random 6)];
			playsound3d [_cluck,_chicken,false,getposasl _chicken,1,0.9 + (random 0.2),100];
			};
		sleep random 10;
		};
	};		
	

// MAIN LOOP
tpw_animal_fnc_mainloop = 
	{
	while {true} do
		{
		if (tpw_animal_active && vehicle player == player) then
			{
			private ["_animal","_i"];

			if (tpw_animal_debug) then
				{
				hintsilent format ["Animals: %1",count tpw_animal_array];
				};
		
			// Spawn animals if there are less than the specified maximum
			if (count tpw_animal_array < tpw_animal_max && {rain < 0.3}) then
				{
				[] call tpw_animal_fnc_nearanimal;
				};

			// Remove ownership of distant or dead animals
			tpw_animal_removearray = []; // array of animals to remove
			for "_i" from 0 to (count tpw_animal_array - 1) do 
				{
				_animal = tpw_animal_array select _i;
				if (_animal distance player > tpw_animal_maxradius || !(alive _animal)) then 
					{
					_animal setvariable ["tpw_animal_owner",(_animal getvariable "tpw_animal_owner") - [player],true];
					tpw_animal_removearray set [count tpw_animal_removearray,_animal];
					};
				
				// Delete live animals with no owners
				if ((count (_animal getvariable ["tpw_animal_owner",[]]) == 0) && (alive _animal))then	
					{
					deletevehicle _animal;
					sleep 0.1;
					};
					
				// Animals move away from vehicles
				_near = (position _animal) nearEntities [["LandVehicle"], 20];
				if (count _near > 0) then
					{
					[(_near select 0),_animal] spawn tpw_animal_disperse;
					};
				
				// Slow and relaxed	
				_animal setAnimSpeedCoef 0.8 + random 0.2;					
				_animal setbehaviour "CARELESS";
				_animal setSpeedMode "LIMITED";	
				_animal forceSpeed 0.0001; 
				_animal forcewalk true;
				_animal moveto (_animal getvariable "tpw_animal_startpos");
				}; 

			// Update player's animal array	
			tpw_animal_array = tpw_animal_array - tpw_animal_removearray;
			player setvariable ["tpw_animalarray",tpw_animal_array,true];
			};
		sleep random 10;
		};
	};	
	
// RUN IT
[] spawn tpw_animal_fnc_goatbleat;
[] spawn tpw_animal_fnc_chickencluck;
[] spawn tpw_animal_fnc_dogbark;
[] spawn tpw_animal_fnc_catmeow;
[] spawn tpw_animal_fnc_mainloop;

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
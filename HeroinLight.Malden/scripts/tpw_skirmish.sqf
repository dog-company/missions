/* 
TPW SKIRMISH - Ambient infantry combat.
Authors: tpw, CB65, dakaodo 
Date: 20170706
Version: 1.40
Compatibility: SP
Requires: Community Base Addons for A3, tpw_core.sqf

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_skirmish.sqf
2 - Call it with
0 = [5,2,6,3,4,1,500,2000,1,1,1,[0,1,etc],[0,1,etc],[0,1,etc],30,"str1","str2","str3","str4","str5","str6",["cas_string",etc],["chs_string",etc],["uav_string",etc],["enemy_cas_string",etc],["enemy_chs_string",etc],["enemy_uav_string",etc],["resist_cas_string",etc],["resist_chs_string",etc],["resist_uav_string",etc]] execvm "tpw_skirmish.sqf";

where
5 = maximum friendly squads around player,
2 = maximum friendly vehicles around player,
6 = maximum enemy squads around player,
3 = maximum enemy vehicles around the player,
4 = maximum resistance squads around player,
1 = maximum resistance vehicles around player,
500 = minimum distance to spawn squads from player,
2000 = maximum distance to spawn squads, squads will be removed past this distance,
1 = NATO friendlies can call support (0 = no support),
1 = CSAT enemy can call support (0 = no support),
1 = AAF can call support (0 = no support),
[0,1,etc] = friendly (BLUFOR) types
	(
		0 = user specified
		1 = NATO
		2 = NATO PACIFIC
		3 = CTRG PACIFIC
		4 = CSAT
		5 = CSAT PACIFIC
		6 = AAF
		7 = FIA
		8 = SYNDIKAT
		empty = NATO default
	),
[0,1,etc] = enemy (OPFOR) types
	(
		0 = user specified
		1 = NATO
		2 = NATO PACIFIC
		3 = CTRG PACIFIC
		4 = CSAT
		5 = CSAT PACIFIC
		6 = AAF
		7 = FIA
		8 = SYNDIKAT
		empty = CSAT default
	),
[0,1,etc] = resistance (INDFOR) types
	(
		0 = user specified
		1 = NATO
		2 = NATO PACIFIC
		3 = CTRG PACIFIC
		4 = CSAT
		5 = CSAT PACIFIC
		6 = AAF
		7 = FIA
		8 = SYNDIKAT
		empty = AAF default
	),
30 = time (sec) between spawning each enemy/friendly squad/vehicle,
str1 = string to select friendly unit classnames,
str2 = string to select friendly vehicle classnames,
str3 = string to select enemy unit classnames,
str4 = string to select enemy vehicle classnames,
str5 = string to select resistance unit classnames,
str6 = string to select resistance vehicle classnames,
cas_string = array, classnames of CAS aircraft,
chs_string = array, classnames of support heli,
uav_string = array, classnames of UAV,
enemy_cas_string = array, classnames of CAS aircraft,
enemy_chs_string = array, classnames of support heli,
enemy_uav_string = array, classnames of UAV,
resist_cas_string = array, classnames of CAS aircraft,
resist_chs_string = array, classnames of support heli,
resist_uav_string = array, classnames of UAV

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/
if (isDedicated) exitWith {};
if (count _this < 30) exitwith {hint "TPW SKIRMISH incorrect/no config, exiting."};
sleep 5;

// CONFIG
tpw_skirmish_version = "1.40";
tpw_skirmish_friendlysquad_max = _this select 0; // Maximum number of friendly squads around player
tpw_skirmish_friendlyvehicles_max = _this select 1; // Maximum number of friendly vehicles around player
tpw_skirmish_enemysquad_max = _this select 2; // Maximum number of enemy squads around player
tpw_skirmish_enemyvehicles_max = _this select 3; // Maximum number of enemy vehicles around player
tpw_skirmish_resistsquad_max = _this select 4; // Maximum number of friendly squads around player
tpw_skirmish_resistvehicles_max = _this select 5; // Maximum number of friendly vehicles around player
tpw_skirmish_minspawnradius = _this select 6; // Minimum distance from player to spawn units/vehicles
tpw_skirmish_maxspawnradius = _this select 7; // Maximum distance from player to spawn units/vehicles. They'll be removed beyond this distance.
tpw_skirmish_support = _this select 8; // NATO units can call support
tpw_skirmish_enemy_support = _this select 9; // CSAT enemy units can call support
tpw_skirmish_resist_support = _this select 10; // AAF units can call support
tpw_skirmish_friendlytype = _this select 11; // 0 = user specified,1 = NATO, 2 = NATO PACIFIC, 3 = CTRG PACIFIC, 4 = CSAT,	5 = CSAT PACIFIC, 6 = AAF, 7 = FIA, 8 = SYNDIKAT, negative values will wear shemaghs. Empty = NATO default 
tpw_skirmish_enemytype = _this select 12; // 0 = user specified,1 = NATO, 2 = NATO PACIFIC, 3 = CTRG PACIFIC, 4 = CSAT,	5 = CSAT PACIFIC, 6 = AAF, 7 = FIA, 8 = SYNDIKAT, negative values will wear shemaghs. Empty = CSAT default 
tpw_skirmish_resisttype = _this select 13; // 0 = user specified,1 = NATO, 2 = NATO PACIFIC, 3 = CTRG PACIFIC, 4 = CSAT,	5 = CSAT PACIFIC, 6 = AAF, 7 = FIA, 8 = SYNDIKAT, negative values will wear shemaghs. Empty = AAF default 
tpw_skirmish_spawntime = _this select 14; // Time (sec) between spawning each enemy/friendly squad/vehicle
tpw_skirmish_friendlyunitstring = _this select 15; // Custom string to select friendly units from config
tpw_skirmish_friendlyvehiclestring = _this select 16; // Custom string to select friendly vehicles from config
tpw_skirmish_enemyunitstring = _this select 17; // Custom string to select enemy units from config
tpw_skirmish_enemyvehiclestring = _this select 18; // Custom string to select enemy vehicles from config
tpw_skirmish_resistunitstring = _this select 19; // Custom string to select resistance units from config
tpw_skirmish_resistvehiclestring = _this select 20; // Custom string to select resistance vehicles from config
tpw_skirmish_casstring = _this select 21; // Classname array of custom CAS aircraft
tpw_skirmish_chsstring = _this select 22; // Classname array of custom support heli
tpw_skirmish_uavstring = _this select 23; // Classname array of custom UAV
tpw_skirmish_enemy_casstring = _this select 24; // Classname array of custom enemy CAS aircraft
tpw_skirmish_enemy_chsstring = _this select 25; // Classname array of custom enemy support heli
tpw_skirmish_enemy_uavstring = _this select 26; // Classname array of custom enemy UAV
tpw_skirmish_resist_casstring = _this select 27; // Classname array of custom resistance CAS aircraft
tpw_skirmish_resist_chsstring = _this select 28; // Classname array of custom resistance support heli
tpw_skirmish_resist_uavstring = _this select 29; // Classname array of custom resistance UAV

// VARS
tpw_skirmish_report = ["Taking casualties at","All units be advised, we are taking heavy fire at","Man down. Repeat, man down grid","Man down. Man down at","All units, taking casualties grid","Under heavy fire, grid"];
tpw_skirmish_shemaglist = ["H_Shemag_khk","H_Shemag_olive","H_Shemag_tan","H_Shemag_olive_hs","H_Shemagopen_khk","H_Shemagopen_tan"];
tpw_skirmish_active = true;
tpw_skirmish_houses = [];
tpw_skirmish_roads = [];
tpw_skirmish_friendlywpflag = true;
tpw_skirmish_enemywpflag = true;
tpw_skirmish_resistwpflag = true;

// ARRAYS OF UNITS AND VEHICLES FOR EACH OF THE PARTICIPATING FACTIONS
tpw_skirmish_friendlyunitarray = [];
tpw_skirmish_friendlyvehiclearray = [];
tpw_skirmish_enemyunitarray = [];
tpw_skirmish_enemyvehiclearray = [];
tpw_skirmish_resistunitarray = [];
tpw_skirmish_resistvehiclearray = [];
tpw_skirmish_deletearray = []; // array of vehicles to be deleted

 
// HAZE AND GLOWING EMBERS AT FRESH BOMBSITES	
tpw_skirmish_fnc_bombhaze =  
	{
	private ["_spawnpos","_pos","_end","_colour","_alpha","_lifetime","_rotvel","_size","_weight","_diameter","_height","_source","_haze","_light","_intensity","_firesource","_heat"];
	_pos = _this select 0;
	_spawnpos = [_pos select 0, _pos select 1, 0.3]; // always spawn haze at ground level
	_end = diag_ticktime + 180 + random 180;
	_colour = [0.8, 0.75, 0.7]; // dust colour
	_alpha = 0.1; // lower = more transparent haze
	_lifetime = 30; // particle lifetime (sec)
	_rotvel = [0,0,0]; // rotation speed is wind dependent
	_size = 20; // particle size
	_weight = 1.5; // particle weight
	// Volume to spawn particles in
	_diameter = 10; // x and y  
	_height = 1; // z
	_intensity = random 20; // intensity of crater fire light
	
	while {diag_ticktime < _end} do 
		{
		_firesource = "logic" createVehicleLocal _spawnpos;
		_firesource setpos _spawnpos;
		
		_light = "#lightpoint" createVehiclelocal _spawnpos;   
		_light setLightColor [250,75,0]; //slightly yellow
		_light setLightAmbient [1,0.3,0]; 
		_light setlightattenuation [2,4,4,0,1,2];
		_light setLightIntensity _intensity;
		_light attachto [_firesource,[0,0,0]];
		
		_heat = "#particlesource" createVehicleLocal _spawnpos;
		_heat setParticleClass "Refract";  
		_heat attachto [_firesource,[0,0,0]];	
		
		_source = "logic" createVehicleLocal _spawnpos;
		_source setpos _spawnpos;
		_haze = "#particlesource" createvehiclelocal _spawnpos;
		_haze attachto [_source,[0,0,0]];
		_haze setparticleparams [["a3\data_f\particleeffects\universal\universal.p3d", 16, 12, 8, 0], "", "billboard", 1, _lifetime, [0, 0, 0],_rotvel,1,_weight, 1, 0.01, [_size],[_colour + [0], _colour + [_alpha], _colour + [0]], [1000], 1, 1, "", "", _source];
		_haze setparticlerandom [1, [_diameter, _diameter, _height], [0, 0,-10], 0, 0, [0, 0, 0, 0.1], 0, 0];
		_haze setparticlecircle [0, [0, 0, 0]];
		_haze setdropinterval 0.5; // smaller = more haze
		
		sleep 27.67;
		
		_alpha = _alpha * 0.8; // increase haze transparency over time
		_intensity = _intensity *  0.8;// decrease light brightness over time
		
		deletevehicle _heat;
		deletevehicle _haze;
		deletevehicle _source;	
		deletevehicle _light;
		deletevehicle _firesource;	
		};
	};				

// RANDOM POSITION	
tpw_skirmish_fnc_randpos =
	{
	private ["_thispos","_radius","_dir","_posx","_posy","_randpos"];
	_thispos = _this select 0;
	_radius = _this select 1;
	_dir = random 360;
	_posx = ((_thispos select 0) + (_radius * sin(_dir)));
	_posy = ((_thispos select 1) + (_radius * cos(_dir)));
	_randpos = [_posx,_posy,0]; 
	_randpos
	};	
	
// CAMERA SHAKE FROM DISTANT EXPLOSIONS	
tpw_skirmish_fnc_expshake = 
	{
	private ["_bomb","_dist","_delay","_intensity","_height","_bombpos"];
	_bomb = _this select 0;	
	_bombpos = position _bomb;
	_dist = _bomb distance player;

	// Wait until bomb hits the ground
	waituntil
		{
		_height = (position _bomb) select 2; 
		_height < 10;
		};
	[_bombpos] spawn tpw_skirmish_fnc_bombhaze; 

	_delay = _dist / 343; // speed of sound delay
	_intensity = (500 / _dist) ^ 2; // greater intensity of closer explosion
	sleep _delay;
	addcamshake [_intensity, 1, 10];
	};	

//ASL - ADVANCED SQUAD LEADER - AI SQUAD LEADER CAN CALL IN CAS OR ARTILLERY
tpw_skirmish_fnc_asl =
	{
	private ["_maxdist","_min","_scantime","_sql","_group","_cancallsupport","_side","_enemyside","_mindist","_groupdist","_allunits","_enemyvehicles","_enemyinfantry","_friendlyunits","_target","_targetset","_assets","_asset","_grid","_hq"];

	_sql = _this select 0; // Squad leader
	_cas = _this select 1; // Can call close air support
	_art = _this select 2; // Can call artillery support
	_group = group _sql; // Group of the squad leader
	_cancallsupport = true; // Squad leader can scan for targets 
	_scantime = 30; // How often will squad leader scan for new targets (sec)
	_hq=[West,"HQ"]; 

	// Asset sharing variables - ensure that AI squads can only call one instance of a given asset
	if (isNil "tpw_asl_cas_west") then 
		{
		tpw_asl_cas_west = true;
		};
	if (isNil "tpw_asl_chs_west") then 
		{
		tpw_asl_chs_west = true;
		};	
	if (isNil "tpw_asl_uav_west") then 
		{
		tpw_asl_uav_west = true;
		};			
	if (isNil "tpw_asl_art_west") then 
		{
		tpw_asl_art_west = true;
		};
	if (isNil "tpw_asl_smoke_west") then 
		{
		tpw_asl_smoke_west = true;
		};
	if (isNil "tpw_asl_flare_west") then 
		{
		tpw_asl_flare_west = true;
		};	

	// Remove squad leader binoculars (stops them from remaining indefinietely rooted to the spot looking through them)
	if ("Binocular" in weapons _sql) then
		{
		_sql removeWeapon "Binocular";
		};
		
	// CAS - plane
	_fnc_casplane =
		{
		private ["_planetype","_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_cas_west = false;
		
		if !(tpw_skirmish_casstring isEqualTo []) then
			{
			_planetype = selectRandom tpw_skirmish_casstring;
			}  else
			{
			_planetype = "B_Plane_CAS_01_F";
			};
	
		_target = _this select 0;
		_grid = mapGridPosition _target;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: close air support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwcasmarker", position _target] ;
			"tpwcasmarker" setmarkertype "hd_objective";
			"tpwcasmarker" setMarkerAlpha 0.5;
			"tpwcasmarker" setmarkercolor "colorblack";
			"tpwcasmarker" setmarkertext "!!CAS";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 5000,100];
		_endpos = [(_pos select 0),(_pos select 1) - 5000,1000];
		_grp = createGroup west; 
		_plane = [_startpos,0,_planetype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		// Strafe target
		waitUntil {sleep 0.2;(_plane distance _pos < 1500)};
		_plane fireAtTarget [_target];
		waitUntil {sleep 0.2;(_plane distance _pos < 1000)};
		_plane fireAtTarget [_target];
		waitUntil {sleep 0.2;(_plane distance _pos < 600)};
		_plane fireAtTarget [_target];
	
		// Climb and drop bomb		
		waitUntil {sleep 0.2;(_plane distance _pos < 500)};
		_plane flyinheight 500;		
		sleep 5;
		for "_j" from 1 to 4 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_GBU12_LGB" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
	   _grp setSpeedMode "FULL";
		waitUntil {sleep 2;(_plane distance _target > 4000)};
		
		deleteVehicle _plane;
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach crew _plane;
		deleteGroup _grp; 
		
		_cancallsupport = true;	
		tpw_asl_cas_west = true;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: close air support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwcasmarker";
			};
		};
		
	// CAS - heli
	_fnc_casheli =
		{
		private ["_helitype","_target","_pos","_startpos","_startpos2","_endpos","_heli","_heli2","_grp","_wp0","_wp1","_time"];
		_cancallsupport = false;
		tpw_asl_chs_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_chsstring isEqualTo []) then
			{
			_helitype = selectRandom tpw_skirmish_chsstring;
			}  else
			{
			_helitype = "B_Heli_Attack_01_F";
			};
			
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: gunship support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwchsmarker", position _target] ;
			"tpwchsmarker" setmarkertype "hd_objective";
			"tpwchsmarker" setMarkerAlpha 0.5;
			"tpwchsmarker" setmarkercolor "colorblack";
			"tpwchsmarker" setmarkertext "!!CHS";
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) - 5000,50];
		_endpos = [(_pos select 0),(_pos select 1) + 5000,500];
		_time = time + 600;
		_grp = createGroup west; 
		_heli = [_startpos,140,_helitype,_grp] call BIS_fnc_spawnVehicle; // Spawn helicopter and crew
		_heli = _heli select 0;
		_heli flyinheight 50;
		_grp setBehaviour "COMBAT";
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,50];
		_wp0 setwaypointtype "move"; 

		for "_i" from 1 to 3 do
			{
			_randpos = [_pos, (250 + random 250)] call tpw_skirmish_fnc_randpos;
			_wp = _grp addWaypoint [_randpos, 100];
			_wp setwaypointtype "move"; 
			};
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		
		//When to remove heli?
		waitUntil 
			{sleep 5;
			(
			((_heli distance _endpos < 1000) || !(alive _heli)) || 
			time > _time
			)
			};				

		deletevehicle _heli;
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach units _grp;	
		deleteGroup _grp; 

		_cancallsupport = true;	
		tpw_asl_chs_west = true;
		_grid = mapGridPosition _target;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: gunship support at %1 has concluded.",_grid];
			deletemarker "tpwchsmarker";
			};
		};

	// CAS - UAV
	_fnc_casuav =
		{
		private ["_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell","_uavtype"];
		_cancallsupport = false;
		tpw_asl_uav_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_uavstring isEqualTo []) then
			{
			_uavtype = selectRandom tpw_skirmish_uavstring;
			}  else
			{
			_uavtype = "B_UAV_02_CAS_F";
			};

		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: UAV support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwuavmarker", position _target] ;
			"tpwuavmarker" setmarkertype "hd_objective";
			"tpwuavmarker" setMarkerAlpha 0.5;
			"tpwuavmarker" setmarkercolor "colorblack";
			"tpwuavmarker" setmarkertext "!!UAV";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 2500,50];
		_endpos = [(_pos select 0),(_pos select 1) - 2500,200];
		_grp = createGroup west; 
		_plane = [_startpos,0,_uavtype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED"; 
		_grp setSpeedMode "FULL";		
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		waitUntil {sleep 1;(_plane distance _pos < 500)};
		_plane flyinheight 200;		
		sleep 7;
		for "_j" from 1 to 2 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_Mk82" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
		waitUntil {sleep 2;(_plane distance _target > 2000)};
		deleteVehicle _plane;
		deleteGroup _grp; 
		_cancallsupport = true;	
		tpw_asl_uav_west = true;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: UAV support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwuavmarker";
			};
		};			

	// Artillery
	_fnc_arty =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false; 
		tpw_asl_art_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == WEST) then
			{		
			_hq SideChat format ["All units be advised: artillery H.E. inbound on co-ordinates %1.",_grid];
			createmarker ["tpwhemarker", position _target] ;
			"tpwhemarker" setmarkertype "hd_objective";
			"tpwhemarker" setMarkerAlpha 0.5;
			"tpwhemarker" setmarkercolor "colorblack";
			"tpwhemarker" setmarkertext "!!HE";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 6 do // number of barrages
			{
			for "_j" from 1 to 4 do // number of shells per barrage
				{
				// Shells will land randomly around target
				if (!isnull _target && _target distance _pos > 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 50;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["Sh_82mm_AMOS",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100];
				[_shell] spawn tpw_skirmish_fnc_expshake;				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_art_west = true;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: artillery support at %1 has concluded.",_grid];
			deletemarker "tpwhemarker";
			};
		};
		
	// Smoke
	_fnc_smoke =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_smoke_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: artillery smoke inbound on co-ordinates %1.",_grid];
			createmarker ["tpwsmkmarker", position _target] ;
			"tpwsmkmarker" setmarkertype "hd_objective";
			"tpwsmkmarker" setMarkerAlpha 0.5;
			"tpwsmkmarker" setmarkercolor "colorblack";
			"tpwsmkmarker" setmarkertext "!!SMK";
			};
		sleep 30 + random 60;
		
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 4 do
				{
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 100;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["SmokeShell",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100]; 				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_smoke_west = true;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: artillery smoke support at %1 has concluded.",_grid];
			deletemarker "tpwsmkmarker";
			};
		};		
		
	// Flare
	_fnc_flare =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_flare_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: artillery flares inbound on co-ordinates %1.",_grid];
			createmarker ["tpwflrmarker", position _target] ;
			"tpwflrmarker" setmarkertype "hd_objective";
			"tpwflrmarker" setMarkerAlpha 0.5;
			"tpwflrmarker" setmarkercolor "colorblack";
			"tpwflrmarker" setmarkertext "!!FLR";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 4 do
				{
				_dir = random 360;
				_dist = random 100;
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,250];
				_shell = createVehicle ["F_40mm_White",_droppos,[],0,"FLY"]; // Create shell
				// Attach more powerful light to flare shell
				_light = "#lightpoint" createVehiclelocal _droppos;   
				_light setLightColor [200,200,250]; // blueish white
				_light setLightAmbient [.8,.8,1]; 
				_light setlightattenuation [50,4,4,0,1,1000];
				[_light,_shell] spawn
					{
					_light = _this select 0;
					_shell = _this select 1;
					sleep random 2;
					waituntil 
						{
						sleep random 2;
						_light setlightintensity  200 + random 400;
						(position _shell) select 2 < 150;
						};
					deletevehicle _light;
					};
				_shell setVelocity [random 10,random 10 ,random 10]; 
				sleep random 5;	
				};
			sleep random 30;	
			};	
		_cancallsupport = true;
		tpw_asl_flare_west = true;	
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: artillery flare support at %1 has concluded.",_grid];
			deletemarker "tpwflrmarker";
			};
		};	
		
	// Determine which assets are available, pick a random one	
	_fnc_assets =
		{
		_assets = [];
		if (_cas && tpw_asl_cas_west) then 
			{
			_assets pushback _fnc_casplane;
			};
		if (_cas && tpw_asl_chs_west) then 
			{
			_assets pushback _fnc_casheli;
			};	
		if (_cas && tpw_asl_uav_west) then 
			{
			_assets pushback _fnc_casuav;
			};			
		if (_art && tpw_asl_art_west) then
			{
			_assets pushback _fnc_arty;
			};
		if (_art && tpw_asl_smoke_west) then
			{
			_assets pushback _fnc_smoke;
			};		
		if (_art && tpw_asl_flare_west && ((daytime < 4.5) || (daytime > 19))) then
			{
			_assets pushback _fnc_flare;
			};	
		if (count _assets > 0) then 
			{	
			_asset = _assets select (floor (random (count _assets)));	
			_sql doWatch _target;
			[_target] call _asset;	
			};
		};
		
	// Select potential targets near squad leader
	_fnc_target =
		{	
		private _leaders = [];
			{
			_leaders pushback leader _x;
			} foreach (tpw_skirmish_friendlysquads + tpw_skirmish_resistsquads + tpw_skirmish_enemysquads + tpw_skirmish_friendlyvehicles + tpw_skirmish_resistvehicles + tpw_skirmish_enemyvehicles);

		private _eleaders = ((_leaders select {_x distance _sql> 200 && _x distance _sql < 1500}) select {(side _x) getFriend (side _sql) < 0.5}) select {[objNull, "VIEW"] checkVisibility [eyePos _x, eyepos _sql] > 0}; // all visible enemy leaders > 200m away

		private _fleaders = _leaders select {(side _x) getFriend (side _sql) > 0.5}; // all friendly leaders
		
		private _safetargets = []; // enemy leaders with no nearby friendly within 200m
			{
			_leader = _x;
			if (count (_fleaders select {_x distance _leader < 200}) == 0) then
				{
				_safetargets pushback _leader;
				};
			} foreach _eleaders;
			
		if (count _safetargets > 0) then
			{
			_target = _safetargets select floor random count _safetargets;
			_targetset = true;
			} else
			{
			_targetset = false;
			};		
		};	
		
	// Squad leader periodically scans for targets 
	while {count (units _group) > 0} do
		{
		_sql = leader _group; 
		if (_cancallsupport) then
			{
			[] call _fnc_target;
			
			// If target has been chosen
			if (_targetset) then 
				{
				[] call _fnc_assets;//Call in support
				};
			};
		sleep random _scantime;
		};	
	};

//ENEMY ASL - ADVANCED SQUAD LEADER - OPFOR AI SQUAD LEADER CAN CALL IN CAS OR ARTILLERY 
tpw_skirmish_enemy_fnc_asl =
	{
	private ["_maxdist","_min","_scantime","_sql","_group","_cancallsupport","_side","_enemyside","_mindist","_groupdist","_allunits","_enemyvehicles","_enemyinfantry","_friendlyunits","_target","_targetset","_assets","_asset","_grid","_hq"];

	_sql = _this select 0; // Squad leader
	_cas = _this select 1; // Can call close air support
	_art = _this select 2; // Can call artillery support
	_group = group _sql; // Group of the squad leader
	_cancallsupport = true; // Squad leader can scan for targets 
	_scantime = 30; // How often will squad leader scan for new targets (sec)
	_hq=[East,"HQ"]; 

	// Asset sharing variables - ensure that AI squads can only call one instance of a given asset
	if (isNil "tpw_asl_cas_east") then 
		{
		tpw_asl_cas_east = true;
		};
	if (isNil "tpw_asl_chs_east") then 
		{
		tpw_asl_chs_east = true;
		};	
	if (isNil "tpw_asl_uav_east") then 
		{
		tpw_asl_uav_east = true;
		};			
	if (isNil "tpw_asl_art_east") then 
		{
		tpw_asl_art_east = true;
		};
	if (isNil "tpw_asl_smoke_east") then 
		{
		tpw_asl_smoke_east = true;
		};
	if (isNil "tpw_asl_flare_east") then 
		{
		tpw_asl_flare_east = true;
		};	

	// Remove squad leader binoculars (stops them from remaining indefinietely rooted to the spot looking through them)
	if ("Binocular" in weapons _sql) then
		{
		_sql removeWeapon "Binocular";
		};
		
	// CAS - plane
	_fnc_casplane =
		{
		private ["_planetype","_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_cas_east = false;
		
		if !(tpw_skirmish_enemy_casstring isEqualTo []) then
			{
			_planetype = selectRandom tpw_skirmish_enemy_casstring;
			}  else
			{
			_planetype = "O_Plane_CAS_02_F";
			};
	
		_target = _this select 0;
		_grid = mapGridPosition _target;
		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: close air support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwcasmarker", position _target] ;
			"tpwcasmarker" setmarkertype "hd_objective";
			"tpwcasmarker" setMarkerAlpha 0.5;
			"tpwcasmarker" setmarkercolor "colorblack";
			"tpwcasmarker" setmarkertext "!!CAS";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 5000,100];
		_endpos = [(_pos select 0),(_pos select 1) - 5000,1000];
		_grp = createGroup east; 
		_plane = [_startpos,0,_planetype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		waitUntil {sleep 1;(_plane distance _pos < 500)};
		_plane flyinheight 500;		
		sleep 5;
		for "_j" from 1 to 4 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_GBU12_LGB" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
	   _grp setSpeedMode "FULL";
		waitUntil {sleep 2;(_plane distance _target > 4000)};
		
		deleteVehicle _plane;
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach crew _plane;
		deleteGroup _grp; 
		
		_cancallsupport = true;	
		tpw_asl_cas_east = true;
		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: close air support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwcasmarker";
			};
		};
		
	// CAS - heli
	_fnc_casheli =
		{
		private ["_helitype","_target","_pos","_startpos","_startpos2","_endpos","_heli","_heli2","_grp","_wp0","_wp1","_time"];
		_cancallsupport = false;
		tpw_asl_chs_east = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_enemy_chsstring isEqualTo []) then
			{
			_helitype = selectRandom tpw_skirmish_enemy_chsstring;
			}  else
			{
			_helitype = "O_Heli_Attack_02_F";
			};
			
		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: helicopter support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwchsmarker", position _target] ;
			"tpwchsmarker" setmarkertype "hd_objective";
			"tpwchsmarker" setMarkerAlpha 0.5;
			"tpwchsmarker" setmarkercolor "colorblack";
			"tpwchsmarker" setmarkertext "!!CHS";
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) - 5000,50];
		_endpos = [(_pos select 0),(_pos select 1) + 5000,500];
		_time = time + 600;
		_grp = createGroup east; 
		_heli = [_startpos,140,_helitype,_grp] call BIS_fnc_spawnVehicle; // Spawn helicopter and crew
		_heli = _heli select 0;
		_heli flyinheight 50;
		_grp setBehaviour "COMBAT";
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,50];
		_wp0 setwaypointtype "move"; 

		for "_i" from 1 to 3 do
			{
			_randpos = [_pos, (250 + random 250)] call tpw_skirmish_fnc_randpos;
			_wp = _grp addWaypoint [_randpos, 100];
			_wp setwaypointtype "move"; 
			};
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		
		//When to remove helis?
		waitUntil 
			{sleep 5;
			(
			((_heli distance _endpos < 1000) || !(alive _heli))  || 
			time > _time
			)
			};				

		deletevehicle _heli;
		deletevehicle _heli2;	
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach units _grp;	
		deleteGroup _grp; 

		_cancallsupport = true;	
		tpw_asl_chs_east = true;
		_grid = mapGridPosition _target;
		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: helicopter support at %1 has concluded.",_grid];
			deletemarker "tpwchsmarker";
			};
		};

	// CAS - UAV
	_fnc_casuav =
		{
		private ["_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell","_uavtype"];
		_cancallsupport = false;
		tpw_asl_uav_east = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_enemy_uavstring isEqualTo []) then
			{
			_uavtype = selectRandom tpw_skirmish_enemy_uavstring;
			}  else
			{
			_uavtype = "O_UAV_02_CAS_F";
			};

		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: UAV support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwuavmarker", position _target] ;
			"tpwuavmarker" setmarkertype "hd_objective";
			"tpwuavmarker" setMarkerAlpha 0.5;
			"tpwuavmarker" setmarkercolor "colorblack";
			"tpwuavmarker" setmarkertext "!!UAV";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 2500,50];
		_endpos = [(_pos select 0),(_pos select 1) - 2500,200];
		_grp = createGroup east; 
		_plane = [_startpos,0,_uavtype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED"; 
		_grp setSpeedMode "FULL";		
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		waitUntil {sleep 1;(_plane distance _pos < 500)};
		_plane flyinheight 200;		
		sleep 7;
		for "_j" from 1 to 2 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_Mk82" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
		waitUntil {sleep 2;(_plane distance _target > 2000)};
		deleteVehicle _plane;
		deleteGroup _grp; 
		_cancallsupport = true;	
		tpw_asl_uav_east = true;
		if (side player == EAST) then
			{
			_hq SideChat format ["All units be advised: UAV support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwuavmarker";
			};
		};			

	// Artillery
	_fnc_arty =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false; 
		tpw_asl_art_east = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == EAST) then
			{		
			_hq SideChat format ["All units be advised: artillery H.E. inbound on co-ordinates %1.",_grid];
			createmarker ["tpwhemarker", position _target] ;
			"tpwhemarker" setmarkertype "hd_objective";
			"tpwhemarker" setMarkerAlpha 0.5;
			"tpwhemarker" setmarkercolor "colorblack";
			"tpwhemarker" setmarkertext "!!HE";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 6 do // number of barrages
			{
			for "_j" from 1 to 4 do // number of shells per barrage
				{
				// Shells will land randomly around target
				if (!isnull _target && _target distance _pos > 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 50;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["Sh_82mm_AMOS",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100];
				[_shell] spawn tpw_skirmish_fnc_expshake;				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_art_east = true;
		if (side player == east) then
			{
			_hq SideChat format ["All units be advised: artillery support at %1 has concluded.",_grid];
			deletemarker "tpwhemarker";
			};
		};
		
	// Smoke
	_fnc_smoke =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_smoke_east = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == east) then
			{
			_hq SideChat format ["All units be advised: artillery smoke inbound on co-ordinates %1.",_grid];
			createmarker ["tpwsmkmarker", position _target] ;
			"tpwsmkmarker" setmarkertype "hd_objective";
			"tpwsmkmarker" setMarkerAlpha 0.5;
			"tpwsmkmarker" setmarkercolor "colorblack";
			"tpwsmkmarker" setmarkertext "!!SMK";
			};
		sleep 30 + random 60;
		
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 2 do
				{
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 100;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["SmokeShellOrange",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100]; 				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_smoke_east = true;
		if (side player == east) then
			{
			_hq SideChat format ["All units be advised: artillery smoke support at %1 has concluded.",_grid];
			deletemarker "tpwsmkmarker";
			};
		};		
		
	// Flare
	_fnc_flare =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_flare_east = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == east) then
			{
			_hq SideChat format ["All units be advised: artillery flares inbound on co-ordinates %1.",_grid];
			createmarker ["tpwflrmarker", position _target] ;
			"tpwflrmarker" setmarkertype "hd_objective";
			"tpwflrmarker" setMarkerAlpha 0.5;
			"tpwflrmarker" setmarkercolor "colorblack";
			"tpwflrmarker" setmarkertext "!!FLR";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 4 do
				{
				_dir = random 360;
				_dist = random 100;
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,250];
				_shell = createVehicle ["F_40mm_White",_droppos,[],0,"FLY"]; // Create shell
				// Attach more powerful light to flare shell
				_light = "#lightpoint" createVehiclelocal _droppos;   
				_light setLightColor [200,200,250]; // blueish white
				_light setLightAmbient [.8,.8,1]; 
				_light setlightattenuation [50,4,4,0,1,1000];
				[_light,_shell] spawn
					{
					_light = _this select 0;
					_shell = _this select 1;
					sleep random 2;
					waituntil 
						{
						sleep random 2;
						_light setlightintensity  200 + random 400;
						(position _shell) select 2 < 150;
						};
					deletevehicle _light;
					};
				_shell setVelocity [random 10,random 10 ,random 10]; 
				sleep random 5;	
				};
			sleep random 30;	
			};	
		_cancallsupport = true;
		tpw_asl_flare_east = true;	
		if (side player == east) then
			{
			_hq SideChat format ["All units be advised: artillery flare support at %1 has concluded.",_grid];
			deletemarker "tpwflrmarker";
			};
		};	
		
	// Determine which assets are available, pick a random one	
	_fnc_assets =
		{
		_assets = [];
		if (_cas && tpw_asl_cas_east) then 
			{
			_assets pushback _fnc_casplane;
			};
		if (_cas && tpw_asl_chs_east) then 
			{
			_assets pushback _fnc_casheli;
			};	
		if (_cas && tpw_asl_uav_east) then 
			{
			_assets pushback _fnc_casuav;
			};			
		if (_art && tpw_asl_art_east) then
			{
			_assets pushback _fnc_arty;
			};
		if (_art && tpw_asl_smoke_east) then
			{
			_assets pushback _fnc_smoke;
			};		
		if (_art && tpw_asl_flare_east && ((daytime < 4.5) || (daytime > 19))) then
			{
			_assets pushback _fnc_flare;
			};	
		if (count _assets > 0) then 
			{	
			_asset = _assets select (floor (random (count _assets)));	
			_sql doWatch _target;
			[_target] call _asset;	
			};
		};
		
	// Select potential targets near squad leader
	_fnc_target =
		{	
		private _leaders = [];
			{
			_leaders pushback leader _x;
			} foreach (tpw_skirmish_friendlysquads + tpw_skirmish_resistsquads + tpw_skirmish_enemysquads + tpw_skirmish_friendlyvehicles + tpw_skirmish_resistvehicles + tpw_skirmish_enemyvehicles);

		private _eleaders = ((_leaders select {_x distance _sql> 200 && _x distance _sql < 1500}) select {(side _x) getFriend (side _sql) < 0.5}) select {[objNull, "VIEW"] checkVisibility [eyePos _x, eyepos _sql] > 0}; // all visible enemy leaders > 200m away

		private _fleaders = _leaders select {(side _x) getFriend (side _sql) > 0.5}; // all friendly leaders
		
		private _safetargets = []; // enemy leaders with no nearby friendly within 200m
			{
			_leader = _x;
			if (count (_fleaders select {_x distance _leader < 200}) == 0) then
				{
				_safetargets pushback _leader;
				};
			} foreach _eleaders;
			
		if (count _safetargets > 0) then
			{
			_target = _safetargets select floor random count _safetargets;
			_targetset = true;
			} else
			{
			_targetset = false;
			};		
		};				
		
	// Squad leader periodically scans for targets
	while {count (units _group) > 0} do
		{
		_sql = leader _group; 
		if (_cancallsupport) then
			{
			[] call _fnc_target;
			
			// If target has been chosen
			if (_targetset) then 
				{
				[] call _fnc_assets;//Call in support
				};
			};
		sleep random _scantime;
		};	
	};

//RESISTANCE ASL - ADVANCED SQUAD LEADER - INDFOR AI SQUAD LEADER CAN CALL IN CAS OR ARTILLERY 
tpw_skirmish_resist_fnc_asl =
	{
	private ["_maxdist","_min","_scantime","_sql","_group","_cancallsupport","_side","_enemyside","_mindist","_groupdist","_allunits","_enemyvehicles","_enemyinfantry","_friendlyunits","_target","_targetset","_assets","_asset","_grid","_hq"];

	_sql = _this select 0; // Squad leader
	_cas = _this select 1; // Can call close air support
	_art = _this select 2; // Can call artillery support
	_group = group _sql; // Group of the side leader
	_cancallsupport = true; // Squad leader can scan for targets 
	_scantime = 30; // How often will squad leader scan for new targets (sec)
	_hq=[resistance,"HQ"]; 

	// Asset sharing variables - ensure that AI squads can only call one instance of a given asset
	if (isNil "tpw_asl_cas_resist") then 
		{
		tpw_asl_cas_resist = true;
		};
	if (isNil "tpw_asl_chs_resist") then 
		{
		tpw_asl_chs_resist = true;
		};	
	if (isNil "tpw_asl_uav_resist") then 
		{
		tpw_asl_uav_resist = true;
		};			
	if (isNil "tpw_asl_art_resist") then 
		{
		tpw_asl_art_resist = true;
		};
	if (isNil "tpw_asl_smoke_resist") then 
		{
		tpw_asl_smoke_resist = true;
		};
	if (isNil "tpw_asl_flare_resist") then 
		{
		tpw_asl_flare_resist = true;
		};	

	// Remove squad leader binoculars (stops them from remaining indefinietely rooted to the spot looking through them)
	if ("Binocular" in weapons _sql) then
		{
		_sql removeWeapon "Binocular";
		};
		
	// CAS - plane
	_fnc_casplane =
		{
		private ["_planetype","_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_cas_resist = false;
		
		if !(tpw_skirmish_resist_casstring isEqualTo []) then
			{
			_planetype = selectRandom tpw_skirmish_resist_casstring;
			}  else
			{
			_planetype = "I_Plane_Fighter_03_CAS_F";
			};
	
		_target = _this select 0;
		_grid = mapGridPosition _target;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: close air support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwcasmarker", position _target] ;
			"tpwcasmarker" setmarkertype "hd_objective";
			"tpwcasmarker" setMarkerAlpha 0.5;
			"tpwcasmarker" setmarkercolor "colorblack";
			"tpwcasmarker" setmarkertext "!!CAS";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 5000,100];
		_endpos = [(_pos select 0),(_pos select 1) - 5000,1000];
		_grp = createGroup resistance; 
		_plane = [_startpos,0,_planetype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		waitUntil {sleep 1;(_plane distance _pos < 500)};
		_plane flyinheight 500;		
		sleep 5;
		for "_j" from 1 to 4 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_GBU12_LGB" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
	   _grp setSpeedMode "FULL";
		waitUntil {sleep 2;(_plane distance _target > 4000)};
		
		deleteVehicle _plane;
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach crew _plane;
		deleteGroup _grp; 
		
		_cancallsupport = true;	
		tpw_asl_cas_resist = true;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: close air support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwcasmarker";
			};
		};
		
	// CAS - heli
	_fnc_casheli =
		{
		private ["_helitype","_target","_pos","_startpos","_startpos2","_endpos","_heli","_heli2","_grp","_wp0","_wp1","_time"];
		_cancallsupport = false;
		tpw_asl_chs_resist = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_resist_chsstring isEqualTo []) then
			{
			_helitype = selectRandom tpw_skirmish_resist_chsstring;
			}  else
			{
			_helitype = "I_Heli_light_03_F";
			};
			
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: helicopter support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwchsmarker", position _target] ;
			"tpwchsmarker" setmarkertype "hd_objective";
			"tpwchsmarker" setMarkerAlpha 0.5;
			"tpwchsmarker" setmarkercolor "colorblack";
			"tpwchsmarker" setmarkertext "!!CHS";
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) - 5000,50];
		_endpos = [(_pos select 0),(_pos select 1) + 5000,500];
		_time = time + 600;
		_grp = createGroup resistance; 
		_heli = [_startpos,140,_helitype,_grp] call BIS_fnc_spawnVehicle; // Spawn helicopter1 and crew
		_heli = _heli select 0;
		_heli flyinheight 50;
		_grp setBehaviour "COMBAT";
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,50];
		_wp0 setwaypointtype "move"; 

		for "_i" from 1 to 3 do
			{
			_randpos = [_pos, (250 + random 250)] call tpw_skirmish_fnc_randpos;
			_wp = _grp addWaypoint [_randpos, 100];
			_wp setwaypointtype "move"; 
			};
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		
		//When to remove helis?
		waitUntil 
			{sleep 5;
			(
			((_heli distance _endpos < 1000) || !(alive _heli)) || 
			time > _time
			)
			};				

		deletevehicle _heli;
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach units _grp;	
		deleteGroup _grp; 

		_cancallsupport = true;	
		tpw_asl_chs_resist = true;
		_grid = mapGridPosition _target;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: helicopter support at %1 has concluded.",_grid];
			deletemarker "tpwchsmarker";
			};
		};

	// CAS - UAV
	_fnc_casuav =
		{
		private ["_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell","_uavtype"];
		_cancallsupport = false;
		tpw_asl_uav_resist = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;

		if !(tpw_skirmish_resist_uavstring isEqualTo []) then
			{
			_uavtype = selectRandom tpw_skirmish_resist_uavstring;
			}  else
			{
			_uavtype = "I_UAV_02_CAS_F";
			};

		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: UAV support has been dispatched to co-ordinates %1.",_grid];
			createmarker ["tpwuavmarker", position _target] ;
			"tpwuavmarker" setmarkertype "hd_objective";
			"tpwuavmarker" setMarkerAlpha 0.5;
			"tpwuavmarker" setmarkercolor "colorblack";
			"tpwuavmarker" setmarkertext "!!UAV";	
			};
		_pos = position _target;
		_startpos = [(_pos select 0),(_pos select 1) + 2500,50];
		_endpos = [(_pos select 0),(_pos select 1) - 2500,200];
		_grp = createGroup resistance; 
		_plane = [_startpos,0,_uavtype,_grp] call BIS_fnc_spawnVehicle;
		_plane = _plane select 0;
		_pilot = driver _plane;
		_pilot setcaptive true;
		_pilot setskill 0;
		_pilot disableAI "TARGET";
		_pilot disableAI "AUTOTARGET";
		_grp setBehaviour "COMBAT"; 
		_grp setCombatMode "RED"; 
		_grp setSpeedMode "FULL";		
		_wp0 = _grp addwaypoint[_pos,100];
		_wp0 setwaypointtype "move"; 
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		waitUntil {sleep 1;(_plane distance _pos < 500)};
		_plane flyinheight 200;		
		sleep 7;
		for "_j" from 1 to 2 do // number of shells per barrage
			{
			// Shells will land randomly around target
			if (!isnull _target && _target distance _pos < 200) then
				{
				_pos = position _target;
				};
			_dir = random 360;
			_dist = random 10;
			_posx = (_pos select 0) + (_dist * sin _dir);
			_posy = (_pos select 1) +  (_dist * cos _dir);
			_droppos = [_posx,_posy,0];
			_shell = "Bo_Mk82" createVehicle _droppos;
			[_shell] spawn tpw_skirmish_fnc_expshake;
			sleep random 1;	
			};	
		waitUntil {sleep 2;(_plane distance _target > 2000)};
		deleteVehicle _plane;
		deleteGroup _grp; 
		_cancallsupport = true;	
		tpw_asl_uav_resist = true;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: UAV support at %1 has concluded and aircraft is R.T.B.",_grid];
			deletemarker "tpwuavmarker";
			};
		};			

	// Artillery
	_fnc_arty =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false; 
		tpw_asl_art_resist = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == resistance) then
			{		
			_hq SideChat format ["All units be advised: artillery H.E. inbound on co-ordinates %1.",_grid];
			createmarker ["tpwhemarker", position _target] ;
			"tpwhemarker" setmarkertype "hd_objective";
			"tpwhemarker" setMarkerAlpha 0.5;
			"tpwhemarker" setmarkercolor "colorblack";
			"tpwhemarker" setmarkertext "!!HE";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 6 do // number of barrages
			{
			for "_j" from 1 to 4 do // number of shells per barrage
				{
				// Shells will land randomly around target
				if (!isnull _target && _target distance _pos > 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 50;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["Sh_82mm_AMOS",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100];
				[_shell] spawn tpw_skirmish_fnc_expshake;				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_art_resist = true;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: artillery support at %1 has concluded.",_grid];
			deletemarker "tpwhemarker";
			};
		};
		
	// Smoke
	_fnc_smoke =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_smoke_resist = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: artillery smoke inbound on co-ordinates %1.",_grid];
			createmarker ["tpwsmkmarker", position _target] ;
			"tpwsmkmarker" setmarkertype "hd_objective";
			"tpwsmkmarker" setMarkerAlpha 0.5;
			"tpwsmkmarker" setmarkercolor "colorblack";
			"tpwsmkmarker" setmarkertext "!!SMK";
			};
		sleep 30 + random 60;
		
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 2 do
				{
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_dir = random 360;
				_dist = random 100;
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,500];
				_shell = createVehicle ["SmokeShellOrange",_droppos,[],0,"FLY"]; // Create shell
				_shell say "shell1";
				_shell setVelocity [0,0,-100]; 				
				sleep random 1;	
				};
			sleep random 10;	
			};	
		_cancallsupport = true;
		tpw_asl_smoke_resist = true;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: artillery smoke support at %1 has concluded.",_grid];
			deletemarker "tpwsmkmarker";
			};
		};		
		
	// Flare
	_fnc_flare =
		{
		private ["_target","_pos","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_flare_resist = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		_pos = position _target;
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: artillery flares inbound on co-ordinates %1.",_grid];
			createmarker ["tpwflrmarker", position _target] ;
			"tpwflrmarker" setmarkertype "hd_objective";
			"tpwflrmarker" setMarkerAlpha 0.5;
			"tpwflrmarker" setmarkercolor "colorblack";
			"tpwflrmarker" setmarkertext "!!FLR";
			};
		sleep 30 + random 60;
		for "_i" from 1 to 4 do
			{
			for "_j" from 1 to 4 do
				{
				_dir = random 360;
				_dist = random 100;
				if (!isnull _target && _target distance _pos < 200) then
					{
					_pos = position _target;
					};
				_posx = (_pos select 0) + (_dist * sin _dir);
				_posy = (_pos select 1) +  (_dist * cos _dir);
				_droppos = [_posx,_posy,250];
				_shell = createVehicle ["F_40mm_White",_droppos,[],0,"FLY"]; // Create shell
				// Attach more powerful light to flare shell
				_light = "#lightpoint" createVehiclelocal _droppos;   
				_light setLightColor [200,200,250]; // blueish white
				_light setLightAmbient [.8,.8,1]; 
				_light setlightattenuation [50,4,4,0,1,1000];
				[_light,_shell] spawn
					{
					_light = _this select 0;
					_shell = _this select 1;
					sleep random 2;
					waituntil 
						{
						sleep random 2;
						_light setlightintensity  200 + random 400;
						(position _shell) select 2 < 150;
						};
					deletevehicle _light;
					};
				_shell setVelocity [random 10,random 10 ,random 10]; 
				sleep random 5;	
				};
			sleep random 30;	
			};	
		_cancallsupport = true;
		tpw_asl_flare_resist = true;	
		if (side player == resistance) then
			{
			_hq SideChat format ["All units be advised: artillery flare support at %1 has concluded.",_grid];
			deletemarker "tpwflrmarker";
			};
		};	
		
	// Determine which assets are available, pick a random one	
	_fnc_assets =
		{
		_assets = [];
		if (_cas && tpw_asl_cas_resist) then 
			{
			_assets pushback _fnc_casplane;
			};
		if (_cas && tpw_asl_chs_resist) then 
			{
			_assets pushback _fnc_casheli;
			};	
		if (_cas && tpw_asl_uav_resist) then 
			{
			_assets pushback _fnc_casuav;
			};			
		if (_art && tpw_asl_art_resist) then
			{
			_assets pushback _fnc_arty;
			};
		if (_art && tpw_asl_smoke_resist) then
			{
			_assets pushback _fnc_smoke;
			};		
		if (_art && tpw_asl_flare_resist && ((daytime < 4.5) || (daytime > 19))) then
			{
			_assets pushback _fnc_flare;
			};	
		if (count _assets > 0) then 
			{	
			_asset = _assets select (floor (random (count _assets)));	
			_sql doWatch _target;
			[_target] call _asset;	
			};
		};
		
	// Select potential targets near squad leader
	_fnc_target =
		{	
		private _leaders = [];
			{
			_leaders pushback leader _x;
			} foreach (tpw_skirmish_friendlysquads + tpw_skirmish_resistsquads + tpw_skirmish_enemysquads + tpw_skirmish_friendlyvehicles + tpw_skirmish_resistvehicles + tpw_skirmish_enemyvehicles);

		private _eleaders = ((_leaders select {_x distance _sql> 200 && _x distance _sql < 1500}) select {(side _x) getFriend (side _sql) < 0.5}) select {[objNull, "VIEW"] checkVisibility [eyePos _x, eyepos _sql] > 0}; // all visible enemy leaders > 200m away

		private _fleaders = _leaders select {(side _x) getFriend (side _sql) > 0.5}; // all friendly leaders
		
		private _safetargets = []; // enemy leaders with no nearby friendly within 200m
			{
			_leader = _x;
			if (count (_fleaders select {_x distance _leader < 200}) == 0) then
				{
				_safetargets pushback _leader;
				};
			} foreach _eleaders;
			
		if (count _safetargets > 0) then
			{
			_target = _safetargets select floor random count _safetargets;
			_targetset = true;
			} else
			{
			_targetset = false;
			};		
		};	
		
	// Squad leader periodically scans for targets (only if in combat/stealth mode)
	while {count (units _group) > 0} do
		{
		_sql = leader _group; 
		if (_cancallsupport) then
			{
			[] call _fnc_target;
			
			// If target has been chosen
			if (_targetset) then 
				{
				[] call _fnc_assets;//Call in support
				};
			};
		sleep random _scantime;
		};	
	};

// GET UNITS FROM CONFIG - Thanks to Larrow for the code idea
tpw_skirmish_fnc_types =
	{
	private ["_str","_cfg","_side"];
	_str = _this select 0;
	_side = _this select 1;
	_unitlist = [];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ((_cfgName isKindOf "camanbase") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString} && {!(["civ",str _cfgname] call BIS_fnc_inString)}) then 
				{
				_unitlist pushback _cfgname;
				};
			};
		};
	
	// Default to NATO/CSAT/AAF if no units found	
	if (count _unitlist == 0) then
		{
		switch _side do
			{
			case EAST:
				{
				["o_soldier"] call tpw_skirmish_fnc_types;
				};
			case WEST:		
				{
				["b_soldier"] call tpw_skirmish_fnc_types;
				};
			case RESISTANCE:	
				{
				["i_soldier"] call tpw_skirmish_fnc_types;
				};
			};
		};
	_unitlist	
	};

// GET VEHICLES FROM CONFIG
tpw_skirmish_fnc_cartypes =
	{
	private ["_str","_cfg","_side"];
	_str = _this select 0;
	_side = _this select 1;
	_carlist = [];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString} && {!(["civ",str _cfgname] call BIS_fnc_inString)}) then 
				{
				_carlist  pushback _cfgname;
				};
			};
		};
	
	// Default to NATO/CSAT/AAF if no vehicles found	
	if (count _carlist == 0) then
		{
		switch _side do
			{
			case EAST:
				{
				["o_mrap"] call tpw_skirmish_fnc_cartypes;
				};
			case WEST:		
				{
				["b_mrap"] call tpw_skirmish_fnc_cartypes;
				};
			case RESISTANCE:	
				{
				["i_mrap"] call tpw_skirmish_fnc_cartypes;
				};
			};
		};	
	_carlist
	};	

// Random position
tpw_skirmish_fnc_randomspawnpos = 
	{
	// Pick random position
	private _pos = getposasl player;
	private _spawnpos = getposasl player;
	waituntil
		{
		private _dir = random 360;
		private _dist = tpw_skirmish_minspawnradius + random (tpw_skirmish_maxspawnradius - tpw_skirmish_minspawnradius);
		private _posx = (_pos select 0) + (_dist * sin _dir);
		private _posy = (_pos select 1) +  (_dist * cos _dir);
		_spawnpos = [_posx,_posy,0];
		!(surfaceiswater _spawnpos)
		};
	_spawnpos	
	};	
	
// HOUSES FOR INFANTRY SPAWNING
tpw_skirmish_fnc_houses =
	{
	private ["_houses"];
	if (player distance tpw_skirmish_lasthousepos > (tpw_skirmish_minspawnradius / 2))then 
		{
		tpw_skirmish_lasthousepos = position player;
		_houses = [tpw_skirmish_minspawnradius] call tpw_core_fnc_houses;
		tpw_skirmish_houses = _houses select {_x distance player > (tpw_skirmish_minspawnradius / 2)};		
		};
	};

// ROADS FOR VEHICLE SPAWNING
tpw_skirmish_fnc_roads =
	{
	if (player distance tpw_skirmish_lastroadpos > (tpw_skirmish_maxspawnradius / 2)) then 
		{
		tpw_skirmish_lastroadpos = position player;
		tpw_skirmish_roads = (player nearroads tpw_skirmish_maxspawnradius) select {isonroad _x && {_x distance player > tpw_skirmish_minspawnradius}};
		};
	};

//SPAWN INFANTRY
tpw_skirmish_squadspawn = 
	{
	private ["_side","_units","_num","_spawnpos","_max","_unit","_house","_spawnpos","_sqname","_leader","_shemag","_formations","_form"];
	_side = _this select 0;
	_units = _this select 1;
	_num = _this select 2;
	
	// Spawn position in nearby houses or otherwise a random location 
	[] call tpw_skirmish_fnc_houses;
	if (count tpw_skirmish_houses > 10 && {random 1 > 0.5}) then
		{
		_house = tpw_skirmish_houses select (floor (random (count tpw_skirmish_houses)));
		_spawnpos = (position _house) vectoradd [5,5,0];
		} else
		{
		_spawnpos = [] call tpw_skirmish_fnc_randomspawnpos; 
		};
	
	// Pick random members for squad	
	_sqname = creategroup _side;
	_max = 2 + floor random 5;
	for "_i" from 0 to _max do 
		{
		_unit = _units select (floor (random (count _units)));
		_unit = _unit createUnit [_spawnpos,_sqname,"this enablesimulation false;this setvariable ['tpw_skirmish',1];this setskill 0.05 + random 0.15;this setAnimSpeedCoef 0.8 + random 0.2; this removeweapon 'binocular';this removeweapon 'rangefinder'"];	
		sleep random 1;
		};

	// Shemaghs	
	if (_num < 0) then
		{
			{
			_shemag = tpw_skirmish_shemaglist select (floor (random (count tpw_skirmish_shemaglist)));
			_x linkItem "NVGoggles";
			_x unlinkItem "NVGoggles";
			_x addheadgear _shemag;	
			} foreach units _sqname;
		};
	
	// Side specific behaviours
	_leader = leader _sqname;
	_leader move ([] call tpw_skirmish_fnc_randomspawnpos);
	switch _side do
		{
		case WEST:
			{
			if (tpw_skirmish_support == 1 && {_num in [0,1,2,3,-1,-2,-3]}) then 
				{
				0 = [_leader, true, true] spawn tpw_skirmish_fnc_asl;
				};
			// Add WEST killed eventhandlers
				{
				_x addeventhandler ["killed",
					{
					(_this select 0) setvariable ["tpw_skirmish_removedead",diag_ticktime + 300];
					private ["_squad","_leader","_call"];
					if (tpw_skirmish_friendlywpflag) then
						{
						_squad = group (_this select 0);
						if (count units _squad > 0) then
							{
							_call = tpw_skirmish_report select (floor (random (count tpw_skirmish_report)));
							_leader = leader _squad;
							_leader sidechat format ["%1 %2",_call,mapgridposition _leader];
							};
						};
					}]; // other sqauds will move towards this killed unit
				sleep 0.2;
				_x enablesimulation true;
				} foreach units _sqname;

			// Add to friendly squad array	
			tpw_skirmish_friendlysquads pushback _sqname;			
			};
			
		case EAST:	
			{
			if (tpw_skirmish_enemy_support == 1 && {_num in [0,4,5,-4,-5]}) then
				{
				0 = [_leader, true, true] spawn tpw_skirmish_enemy_fnc_asl;
				};
				// Add EAST killed eventhandler
				{
				_x addeventhandler ["killed",
					{
					(_this select 0) setvariable ["tpw_skirmish_removedead",diag_ticktime + 300];
					private ["_squad","_leader","_call"];
					if (tpw_skirmish_enemywpflag) then
						{
						_squad = group (_this select 0);
						if (count units _squad > 0) then
							{
							_call = tpw_skirmish_report select (floor (random (count tpw_skirmish_report)));
							_leader = leader _squad;
							_leader sidechat format ["%1 %2",_call,mapgridposition _leader];
							};
						};
					}];
				_x enablesimulation true;
				} foreach units _sqname;
				
			//Add to enemy squad array	
			tpw_skirmish_enemysquads pushback _sqname;
			};
			
		case RESISTANCE:
			{
			if (tpw_skirmish_resist_support == 1 && {_num in [0,6,-6]}) then
				{
				0 = [_leader, true, true] spawn tpw_skirmish_resist_fnc_asl;
				};
				// Add RESISTANCE killed eventhandler
				{
				_x addeventhandler ["killed",
					{
					(_this select 0) setvariable ["tpw_skirmish_removedead",diag_ticktime + 300];
					private ["_squad","_leader","_call"];
					if (tpw_skirmish_resistwpflag) then
						{
						_squad = group (_this select 0);
						if (count units _squad > 0) then
							{
							_call = tpw_skirmish_report select (floor (random (count tpw_skirmish_report)));
							_leader = leader _squad;
							_leader sidechat format ["%1 %2",_call,mapgridposition _leader];
							};
						};
					}];
				_x enablesimulation true;
				} foreach units _sqname;

				//Add to resistance squad array	
				tpw_skirmish_resistsquads pushback _sqname;
			};
		};
	};
	
//SPAWN VEHICLES
tpw_skirmish_vehspawn = 
	{
	private ["_side","_units","_cars","_spawnpos","_unit","_roadlist","_farroads","_road","_spawncar","_car","_leader","_wppos","_wp","_shemag","_uniform","_crewcount"];
	_side = _this select 0;
	_units = _this select 1;	
	_cars = _this select 2;	
	_num = _this select 3;
	
	// Spawn position - on road if available
	[] call tpw_skirmish_fnc_roads;
	if (count tpw_skirmish_roads > 50) then
		{
		waituntil
			{
			sleep 0.2;
			_spawnpos = position (tpw_skirmish_roads select floor (random (count tpw_skirmish_roads)));
			_spawnpos distance player > tpw_skirmish_minspawnradius;
			};
		} else
		{
		_spawnpos = [] call tpw_skirmish_fnc_randomspawnpos;
		};
	
	// Spawn car	
	_sqname = creategroup _side;
	_car = _cars select (floor (random (count _cars)));
	_spawncar = _car createVehicle _spawnpos;
	[_spawncar] joinsilent _sqname;	
	_crewcount = [_car,true] call BIS_fnc_crewCount;

	// Pick random crew for vehicle	
	for "_i" from 1 to (2 + floor (random (_crewcount - 1))) do 
		{
		_unit = _units select (floor (random (count _units)));
		_unit createUnit [_spawnpos,_sqname];
		sleep random 1;
		};
		{
		_x setvariable ["tpw_skirmish",2];	
		// Shemaghs	
		if (_num < 0) then
			{
			_shemag = tpw_skirmish_shemaglist select (floor (random (count tpw_skirmish_shemaglist)));
			_x linkItem "NVGoggles";
			_x unlinkItem "NVGoggles";
			_x addheadgear _shemag;
			};
		_x moveinany _spawncar;
		_x setAnimSpeedCoef 0.8 + random 0.2;
		_x addeventhandler ["killed",{(_this select 0) setvariable ["tpw_skirmish_removedead",diag_ticktime + 300];}];// delete dead units after 5 min	
		_x setskill 0.05 + random 0.15;
		} foreach units _sqname;	
	
	// Add patrol waypoints to car. New ones will be calculated every minute or so, to prevent cars loitering around waypoint	
	[_spawncar] call tpw_skirmish_fnc_waypoint;

	(driver _spawncar) disableAI 'FSM';	

	// Add to the vehicle array	
		switch _side do
		{
		case EAST: 
			{
			tpw_skirmish_enemyvehicles pushback _spawncar;
			};
		case WEST: 
			{
			tpw_skirmish_friendlyvehicles pushback _spawncar;
			};
		case RESISTANCE: 
			{
			tpw_skirmish_resistvehicles pushback _spawncar;
			};
		};	

	// Timer for stuck vehicle - vehicle will be removed if still for more than 60 sec	
	_spawncar setvariable ["tpw_skirmish_stucktime", diag_ticktime + 60]; 
	};
	
// ADD SINGLE WAYPOINT
tpw_skirmish_fnc_waypoint =
	{
	private ["_car","_group","_wp","_wppos"];
	_car = _this select 0;
	_group  = group _car;
	[] call tpw_skirmish_fnc_roads;
	tpw_skirmish_roads = tpw_skirmish_roads select {_x distance player > tpw_skirmish_minspawnradius};
	if (count tpw_skirmish_roads > 50) then
		{
		_wppos = getposasl (tpw_skirmish_roads select floor (random (count tpw_skirmish_roads)));
		} else
		{
		_wppos = [] call tpw_skirmish_fnc_randomspawnpos;
		};
		
	// Delete existing waypoints
	while {(count (waypoints _group)) > 0} do 
		{ 
		deleteWaypoint ((waypoints _group) select 0); 
		};
	
	// Add waypoint
	[_group, _wppos, 5, 1, "SAD", "AWARE", "YELLOW", "NORMAL", "STAG COLUMN", "", [0,0,0]] call CBA_fnc_taskPatrol;
	
	// Timer til next waypoint created
	_car setvariable ["tpw_skirmish_wptime",(diag_ticktime + random 60)];	
	};	

// NO UNARMED, PILOT, VR, DIVERS, SURVIVORS, ZEUS CURATOR, OR ZOMBIES
tpw_skirmish_fnc_noncom =
	{
	private ["_list","_i","_unit"];
	_list = _this select 0;
	for "_i" from 0 to (count _list - 1) do	
		{	
		_unit = _list select _i;
		if ((["unarmed",str _unit] call BIS_fnc_inString) ||(["pilot",str _unit] call BIS_fnc_inString)||(["diver",str _unit] call BIS_fnc_inString)||(["vr",str _unit] call BIS_fnc_inString)||(["RyanZombie",str _unit] call BIS_fnc_inString)||(["survivor",str _unit] call BIS_fnc_inString)||(["curator",str _unit] call BIS_fnc_inString)) then
			{
			_list set [_i, -1];
			};
		};
	_list = _list - [-1];	
	_list;
	};
	
// REMOVE SQUADS AS APPROPRIATE
tpw_skirmish_fnc_squadremove =
	{
	private ["_squads","_squad","_ct","_i"];
	_squads = _this select 0;
	_squads = _squads - [-1];
	for "_ct" from 0 to (count _squads - 1) do	
		{	
		_squad = _squads select _ct;
		if ((leader _squad) distance player > tpw_skirmish_maxspawnradius) then
			{
				{
				deletevehicle _x;
				sleep 0.1;
				} foreach units _squad;
			deletegroup _squad;	
			_squads set [_ct,-1];
			};
					
			// Delete stuck units
			{
			private _unit = _x;
			if (position _unit distance (_unit getvariable "lastpos") > 0.5) then
				{
				_unit setvariable ["tpw_skirmish_stucktime",diag_ticktime + 89];
				};
			if (diag_ticktime > _unit getvariable "tpw_skirmish_stucktime") then
				{
				if (animationstate _unit != "acts_InjuredLyingRifle02_180") then
					{
					// Unfreeze and kill any inappropriately frozen units
					{_unit enableai _x} count ["anim","move","fsm","target","autotarget"];
					_unit setunconscious false;
					_unit setdamage 1;
					};
				// Delete if distant	
				if (_unit distance player > tpw_skirmish_minspawnradius) then
					{
					deletevehicle _unit;
					};	
				};
			_unit setvariable ["lastpos",position _unit];		
			} foreach units _squad select {alive _x};		
			
		private _alive = (units _squad) select {alive _x}; 
		if (count _alive == 0) then
			{
			deletegroup _squad;
			_squads set [_ct,-1];
			};	
		};
	_squads = _squads - [-1];
	_squads
	};

// CONSOLIDATE SQUADS AS APPROPRIATE
tpw_skirmish_fnc_consolidate =
	{
	private ["_singletons","_squads","_squad","_unit"];
	_squads = _this select 0;
	if (count _squads < 2 && {count units (_squads select 0) < 2}) exitwith 
		{
			{
			deletevehicle _x;
			sleep 0.1;
			} foreach units (_squads select 0);
		};
	_singletons = _squads select {count (units _x) == 1};
	_squads = _squads - _singletons;
	if (count _squads > 0) then
		{
			{
			_squad = _squads select 0;
			_unit = (units _x) select 0;
			[_unit] joinsilent _squad;
			_unit sidechat format ["Joining up with %1",_squad];
			} foreach _singletons;
		};
	_squads
	};

// MOVE AND REMOVE VEHICLES AS APPROPRIATE
tpw_skirmish_fnc_vehicleremove =
	{
	private ["_vehicles","_car","_ct","_group","_i","_wp","_stopflag"];
	_vehicles = _this select 0;
	for "_ct" from 0 to (count _vehicles - 1) do	
		{	
		_car = _vehicles select _ct;
		_group = group driver _car;
		
		if (isnull _car) exitwith {_vehicles set [_ct,-1]};
		
		// Give car a new waypoint if enough time has passed
		if (diag_ticktime > _car getvariable "tpw_skirmish_wptime") then
			{
			[_car] spawn tpw_skirmish_fnc_waypoint;
			};

		// Stop car if any of its crew are distant, so they can get back in
		_stopflag = 0;
			{
			if (_x distance _car > 5) then
				{
				_x domove position _car;
				_stopflag = 1;
				};
			} foreach units _group;
		
		if (_stopflag == 1) then
			{
			dostop driver _car;
			} else
			{
			driver _car setspeedmode "NORMAL";	
			driver _car domove waypointPosition [_group,1];
			};
		
		// Stuck or incapacitated car? 
		if (abs(speed _car) > 5) then
			{
			_car setvariable ["tpw_skirmish_stucktime", diag_ticktime + 120]; 
			};	
			
		if (diag_ticktime > _car getvariable "tpw_skirmish_stucktime" || // car has been still for > 2 min
		_car distance player > tpw_skirmish_maxspawnradius || // car too distant
		!(alive driver _car) || // no-one around to drive it
		!(alive _car) // car is fucked
		) then 
			{
			// Mark car for deletion
			tpw_skirmish_deletearray pushback _car;
			deletegroup group _car;
			_vehicles set [_ct,-1];
			};			
		};
	_vehicles = _vehicles - [-1];
	_vehicles
	};
	
// DISABLE VEHICLE COLLISIONS WITH NEARBY AI
tpw_skirmish_nocollision = true;
tpw_skirmish_fnc_nocollide =
	{
	private ["_smovecars","_allcars","_car"];
	if (isnil "tpw_car_active" || (!(isnil "tpw_car_active") && !(tpw_car_active))) then
		{
		while {true} do
			{
			if (tpw_skirmish_nocollision) then
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
						} foreach (_car nearentities ["man",5]);
					} foreach _movecars;
				
				};
			sleep 0.1;
			};
		};	
	};

// SELECT BLUFOR 
	{
	private ["_unitstring","_carstring"];
	switch abs(_x) do
		{
		case 0:
			{
			_unitstring = "b_soldier";
			_carstring = "b_mrap";
			
			// User defined
			if !(tpw_skirmish_friendlyunitstring == "") then 
				{
				_unitstring = tpw_skirmish_friendlyunitstring; 
				};
			if !(tpw_skirmish_friendlyvehiclestring == "") then
				{
				_carstring = tpw_skirmish_friendlyvehiclestring; 
				};
			};
		case 1:
			{
			//NATO
			_unitstring = "b_soldier";
			_carstring = "b_mrap";
			};
		case 2:
			{
			//NATO PACIFIC
			_unitstring = "b_t_soldier";
			_carstring = "b_t_lsv";
			};
		case 3:
			{
			//CTRG PACIFIC
			_unitstring = "b_ctrg";
			_carstring = "b_t_lsv";
			};
		case 4:
			{
			//CSAT
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			};
		case 5:
			{
			//CSAT PACIFIC
			_unitstring = "o_t_soldier";
			_carstring = "o_t_lsv";
			};
		case 6:
			{
			//AAF
			_unitstring = "i_soldier";
			_carstring = "i_mrap";
			};
		case 7:
			{
			//FIA
			_unitstring = "b_g_soldier";
			_carstring = "b_g_offroad";
			};
		case 8:
			{
			// SYNDIKAT
			_unitstring = "i_c_soldier";
			_carstring = "i_c_";
			};	
		default
			{
			//NATO
			_unitstring = "b_soldier";
			_carstring = "b_mrap";
			};	
		};	
	_friendlyunitlist = [_unitstring,WEST] call tpw_skirmish_fnc_types;
	_friendlyunitlist = [_friendlyunitlist] call tpw_skirmish_fnc_noncom;
	_friendlycarlist = [_carstring,WEST] call tpw_skirmish_fnc_cartypes;
	tpw_skirmish_friendlyunitarray pushback _friendlyunitlist;
	tpw_skirmish_friendlyvehiclearray pushback _friendlycarlist;
	} foreach tpw_skirmish_friendlytype;

// SELECT OPFOR
	{
	private ["_unitstring","_carstring"];
	switch abs(_x) do
		{
		case 0:
			{
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			
			// User defined
			if !(tpw_skirmish_enemyunitstring == "") then 
				{
				_unitstring = tpw_skirmish_enemyunitstring; 
				};
			if !(tpw_skirmish_enemyvehiclestring == "") then
				{
				_carstring = tpw_skirmish_enemyvehiclestring; 
				};
			};
		case 1:
			{
			//NATO
			_unitstring = "b_soldier";
			_carstring = "b_mrap";
			};
		case 2:
			{
			//NATO PACIFIC
			_unitstring = "b_t_soldier";
			_carstring = "b_t_lsv";
			};
		case 3:
			{
			//CTRG PACIFIC
			_unitstring = "b_ctrg";
			_carstring = "b_t_lsv";
			};
		case 4:
			{
			//CSAT
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			};
		case 5:
			{
			//CSAT PACIFIC
			_unitstring = "o_t_soldier";
			_carstring = "o_t_lsv";
			};
		case 6:
			{
			//AAF
			_unitstring = "i_soldier";
			_carstring = "i_mrap";
			};
		case 7:
			{
			//FIA
			_unitstring = "o_g_soldier";
			_carstring = "o_g_offroad";
			};
		case 8:
			{
			// SYNDIKAT
			_unitstring = "i_c_soldier";
			_carstring = "i_c_";
			};
		default
			{
			//CSAT
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			};
		};
	_enemyunitlist = [_unitstring,EAST] call tpw_skirmish_fnc_types;
	_enemyunitlist = [_enemyunitlist] call tpw_skirmish_fnc_noncom;
	_enemycarlist = [_carstring,EAST] call tpw_skirmish_fnc_cartypes;
	tpw_skirmish_enemyunitarray pushback _enemyunitlist;
	tpw_skirmish_enemyvehiclearray pushback _enemycarlist;
	} foreach tpw_skirmish_enemytype;

// SELECT RESISTANCE
	{
	private ["_unitstring","_carstring"];
	switch abs(_x) do
		{
		case 0:
			{
			_unitstring = "i_soldier";
			_carstring = "i_mrap";
			
			// User defined
			if !(tpw_skirmish_resistunitstring == "") then 
				{
				_unitstring = tpw_skirmish_resistunitstring; 
				};
			if !(tpw_skirmish_resistvehiclestring == "") then
				{
				_carstring = tpw_skirmish_resistvehiclestring; 
				};
			};
		case 1:
			{
			//NATO
			_unitstring = "b_soldier";
			_carstring = "b_mrap";
			};
		case 2:
			{
			//NATO PACIFIC
			_unitstring = "b_t_soldier";
			_carstring = "b_t_lsv";
			};
		case 3:
			{
			//CTRG PACIFIC
			_unitstring = "b_ctrg";
			_carstring = "b_t_lsv";
			};
		case 4:
			{
			//CSAT
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			};
		case 5:
			{
			//CSAT PACIFIC
			_unitstring = "o_t_soldier";
			_carstring = "o_t_lsv";
			};
		case 6:
			{
			//AAF
			_unitstring = "i_soldier";
			_carstring = "i_mrap";
			};
		case 7:
			{
			//FIA
			_unitstring = "i_g_soldier";
			_carstring = "i_g_offroad";
			};
		case 8:
			{
			// SYNDIKAT
			_unitstring = "i_c_soldier";
			_carstring = "i_c_";
			};
		default
			{
			//AAF
			_unitstring = "i_soldier";
			_carstring = "i_mrap";
			};
		};	
	_resistunitlist = [_unitstring,RESISTANCE] call tpw_skirmish_fnc_types;
	_resistunitlist = [_resistunitlist] call tpw_skirmish_fnc_noncom;
	_resistcarlist = [_carstring,RESISTANCE] call tpw_skirmish_fnc_cartypes;
	tpw_skirmish_resistunitarray pushback _resistunitlist;
	tpw_skirmish_resistvehiclearray pushback _resistcarlist;
	} foreach tpw_skirmish_resisttype;

// MAKE INFANTRY MOVE TOWARDS ENEMIES
tpw_skirmish_fnc_moveto = 
	{
	while {true} do
		{
		sleep tpw_skirmish_spawntime;
		
		// Squad leaders
		private _leaders = [];
			{
			_leaders pushback leader _x;
			} foreach (tpw_skirmish_friendlysquads + tpw_skirmish_resistsquads + tpw_skirmish_enemysquads + [group player]);

		// Nearest enemies to each friendly squad	
			{
			private _leader = _x;
			_leader setbehaviour "SAFE";
			_leader setunitpos "UP";
			private _enemies = (_leaders select {side _x getfriend side _leader < 0.6}) apply {[_x distance _leader, _x]}; 
			_enemies sort true;
			
			if (count _enemies > 0) then
				{
				private _closest = (_enemies select 0) select 1;
				(group _leader) move ([] call tpw_skirmish_fnc_randomspawnpos);
				sleep 2;
				(group _leader) move getposasl _closest;
				} else
				{
				(group _leader) move ([] call tpw_skirmish_fnc_randomspawnpos);
				};
			sleep random 5;	
			} foreach _leaders;
		};		
	};
	
// MAIN FRIENDLY LOOP
tpw_skirmish_allgroups = [];	
tpw_skirmish_fnc_friendlyloop =	
	{
	private ["_rnd","_friendlyunitlist","_friendlycarlist","_num","_friendlysquads","_friendlyvehicles","_car"];
	tpw_skirmish_friendlysquads = [];	
	tpw_skirmish_friendlyvehicles = [];
	while {true} do
		{
		if (tpw_skirmish_active && {speed vehicle player < 50}) then
			{
			// Spawn new squads
			if (count tpw_skirmish_friendlysquads < tpw_skirmish_friendlysquad_max) then
				{
				_rnd = floor random count tpw_skirmish_friendlytype;
				_friendlyunitlist = tpw_skirmish_friendlyunitarray select _rnd;
				_num = tpw_skirmish_friendlytype select _rnd;
				[WEST,_friendlyunitlist,_num] call tpw_skirmish_squadspawn;
				};
			
			// Spawn new vehicles
			if (count tpw_skirmish_friendlyvehicles < tpw_skirmish_friendlyvehicles_max) then
				{
				_rnd = floor random count tpw_skirmish_friendlytype;
				_friendlyunitlist = tpw_skirmish_friendlyunitarray select _rnd;
				_friendlycarlist = tpw_skirmish_friendlyvehiclearray select _rnd;
				_num = tpw_skirmish_friendlytype select _rnd;
				[WEST,_friendlyunitlist,_friendlycarlist,_num] call tpw_skirmish_vehspawn;
				};	
			
			// Delete distant squads
			_friendlysquads = [];
			_friendlysquads = [tpw_skirmish_friendlysquads] call tpw_skirmish_fnc_squadremove;
			tpw_skirmish_friendlysquads = _friendlysquads;

			// Any squads with only one member - consolidate with nearest squad from same side 
			tpw_skirmish_friendlysquads = [tpw_skirmish_friendlysquads] call tpw_skirmish_fnc_consolidate;
			tpw_skirmish_friendlysquads = _friendlysquads;

			// Flag distant or incapacitated vehicles
			_friendlyvehicles = [];
			_friendlyvehicles = [tpw_skirmish_friendlyvehicles] call tpw_skirmish_fnc_vehicleremove;
			tpw_skirmish_friendlyvehicles = _friendlyvehicles;
			};
		sleep random tpw_skirmish_spawntime;
		};
	};
	
// MAIN ENEMY LOOP	
tpw_skirmish_fnc_enemyloop =	
	{
	private ["_rnd","_enemyunitlist","_enemycarlist","_num","_enemysquads","_enemyvehicles"];
	tpw_skirmish_enemysquads = [];	
	tpw_skirmish_enemyvehicles = [];
	while {true} do
		{
		if (tpw_skirmish_active && {speed vehicle player < 50}) then
			{
		
			// Spawn new squads
			if (count tpw_skirmish_enemysquads < tpw_skirmish_enemysquad_max) then
				{
				_rnd = floor random count tpw_skirmish_enemytype;
				_enemyunitlist = tpw_skirmish_enemyunitarray select _rnd;
				_num = tpw_skirmish_enemytype select _rnd;
				[EAST,_enemyunitlist,_num] call tpw_skirmish_squadspawn;
				};
				
			// Spawn new vehicles
			if (count tpw_skirmish_enemyvehicles < tpw_skirmish_enemyvehicles_max) then
				{
				_rnd = floor random count tpw_skirmish_enemytype;
				_enemyunitlist = tpw_skirmish_enemyunitarray select _rnd;
				_enemycarlist = tpw_skirmish_enemyvehiclearray select _rnd;
				_num = tpw_skirmish_enemytype select _rnd;
				[EAST,_enemyunitlist,_enemycarlist,_num] call tpw_skirmish_vehspawn;
				};	
			
			// Delete distant squads
			_enemysquads = [];
			_enemysquads = [tpw_skirmish_enemysquads] call tpw_skirmish_fnc_squadremove;
			tpw_skirmish_enemysquads = _enemysquads;

			// Any squads with only one member - consolidate with nearest squad from same side 
			tpw_skirmish_enemysquads = [tpw_skirmish_enemysquads] call tpw_skirmish_fnc_consolidate;
			tpw_skirmish_enemysquads = _enemysquads;

			//Delete distant or incapacitated vehicles
			_enemyvehicles = [];
			_enemyvehicles = [tpw_skirmish_enemyvehicles] call tpw_skirmish_fnc_vehicleremove;
			tpw_skirmish_enemyvehicles = _enemyvehicles;
			};
		sleep random tpw_skirmish_spawntime;
		};
	};	
	
// MAIN RESISTANCE LOOP	
tpw_skirmish_fnc_resistloop =	
	{
	private ["_rnd","_resistunitlist","_resistcarlist","_num","_resistsquads","_resistvehicles"];
	tpw_skirmish_resistsquads = [];	
	tpw_skirmish_resistvehicles = [];
	while {true} do
		{
		if (tpw_skirmish_active && {speed vehicle player < 50}) then
			{
			// Spawn new squads
			if (count tpw_skirmish_resistsquads < tpw_skirmish_resistsquad_max) then
				{
				_rnd = floor random count tpw_skirmish_resisttype;
				_resistunitlist = tpw_skirmish_resistunitarray select _rnd;
				_num = tpw_skirmish_resisttype select _rnd;
				[RESISTANCE,_resistunitlist,_num] call tpw_skirmish_squadspawn;
				};
				
			// Spawn new vehicles
			if (count tpw_skirmish_resistvehicles < tpw_skirmish_resistvehicles_max) then
				{
				_rnd = floor random count tpw_skirmish_resisttype;
				_resistunitlist = tpw_skirmish_resistunitarray select _rnd;
				_resistcarlist = tpw_skirmish_resistvehiclearray select _rnd;
				_num = tpw_skirmish_resisttype select _rnd;
				[RESISTANCE,_resistunitlist,_resistcarlist,_num] call tpw_skirmish_vehspawn;
				};	
			
			// Delete distant squads
			_resistsquads = [];
			_resistsquads = [tpw_skirmish_resistsquads] call tpw_skirmish_fnc_squadremove;
			tpw_skirmish_resistsquads = _resistsquads;

			// Any squads with only one member - consolidate with nearest squad from same side 
			tpw_skirmish_resistsquads = [tpw_skirmish_resistsquads] call tpw_skirmish_fnc_consolidate;
			tpw_skirmish_resistsquads = _resistsquads;

			//Delete distant or incapacitated vehicles
			_resistvehicles = [];
			_resistvehicles = [tpw_skirmish_resistvehicles] call tpw_skirmish_fnc_vehicleremove;
			tpw_skirmish_resistvehicles = _resistvehicles;
			};
		sleep random tpw_skirmish_spawntime;
		};
	};	
	
// CLEAN UP 
tpw_skirmish_fnc_cleanup =
	{
	while {true} do
		{
		// Clean up any stragglers (passengers out of vehicles for more than 60 sec)
			{
			if (_x getvariable ["tpw_skirmish",0] == 2 && {_x == vehicle _x} && {_x distance player > tpw_skirmish_minspawnradius}) then
				{
				if (_x getvariable ["tpw_skirmish_deletetime",-1] == -1) then
					{
					_x setvariable ["tpw_skirmish_deletetime",diag_ticktime + 60];
					} else
					{
					if (_x getvariable "tpw_skirmish_deletetime" < diag_ticktime) then
						{
						deletevehicle _x;
						sleep 0.1;
						};
					};
				};
			} foreach allunits;
		
		// Delete dead bodies after 5 min
			{
			if (_x getvariable "tpw_skirmish_removedead" < diag_ticktime && {_x distance player > tpw_skirmish_minspawnradius}) then
				{
				deletevehicle _x;
				sleep 0.1;
				};
			} count alldead;
		
		// Delete flagged vehicles
		for "_i" from 0 to count tpw_skirmish_deletearray - 1 do
			{
			_car = tpw_skirmish_deletearray select _i;
			if (_car distance player > tpw_skirmish_minspawnradius) then
				{
					{
					deletevehicle _x;
					sleep 0.1;
					} foreach units group _car;
				deletevehicle _car;
				tpw_skirmish_deletearray set [_i,-1];
				};
			};
		tpw_skirmish_deletearray = 	tpw_skirmish_deletearray - [-1];
		sleep 30;
		};
	};
	
// CREATE AI CENTRES SO SPAWNED GROUPS KNOW WHO'S AN ENEMY
private ["_centerW", "_centerE", "_centerR", "_centerC"];
_centerW = createCenter west;
_centerE = createCenter east;
_centerR = createCenter resistance;
_centerC = createCenter civilian;

// INITIAL POSITIONS FOR ROAD AND HOUSE SCANNING 
tpw_skirmish_lasthousepos = [-2000,-2000,0];
tpw_skirmish_lastroadpos = [-2000,-2000,0];

sleep tpw_skirmish_spawntime;
[] spawn tpw_skirmish_fnc_friendlyloop;
sleep 0.1;
[] spawn tpw_skirmish_fnc_enemyloop;
sleep 0.1;
[] spawn tpw_skirmish_fnc_resistloop;
sleep 1;
tpw_car_nocollision = true;
[] spawn tpw_skirmish_fnc_nocollide;
sleep 1;
[] spawn tpw_skirmish_fnc_cleanup;
sleep 1;
[] spawn tpw_skirmish_fnc_moveto;
while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
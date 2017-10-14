/* 
TPW SKIRMISH - Ambient infantry combat.
Authors: tpw, CB65 
Date: 20150124
Version: 1.19
Compatibility: SP
Requires: Community Base Addons for A3, tpw_core.sqf, CAF Aggressors (optional),CSAT Modification Project (optional)

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_skirmish.sqf
2 - Call it with 0 = [5,2,5,2,500,2000,1,1,1,30,"str1","str2","str3","str4"] execvm "tpw_skirmish.sqf"; where 5 = maximum enemy squads around player, 2 = maximum enemy vehicles around the player, 5 = maximum friendly squads around player, 2 = maximum friendly vehicles around player, 500 = minimum distance to spawn enemies from player, 2000 = maximum distance to spawn enemies, enemies will be removed past this distance, 1 = NATO friendlies can call support (0 = no support), 1 = friendly type ( 0 = user specified, 1 = NATO, 2 = FIA, 3 = AAF), 1 = enemy type ( 0 = user specified, 1 = CAF_AG, 2 = CSAT, 3 = AAF, 4 = CMP arid, 5 = CMP semiarid, 6 = CMP urban),7 = ISIS - mixed CAF_AG with shemags, 8 = ISIS 2035 - CSAT with CAF_AG clothes and shemags), 30 = time (sec) between spawning each enemy/friendly squad/vehicle, str1 = string to select friendly unit classnames, str2 = string to select friendly vehicle classnames, str3 = string to select enemy unit classnames, str4 = string to select enemy vehicle classnames,

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 14) exitwith {hint "TPW PARK incorrect/no config, exiting."};
sleep 5;

tpw_skirmish_version = "1.19";
tpw_skirmish_enemysquad_max = _this select 0; // Maximum number of enemy squads around player
tpw_skirmish_enemyvehicles_max = _this select 1; // Maximum number of enemy vehicles around player
tpw_skirmish_friendlysquad_max = _this select 2; // Maximum number of friendly squads around player
tpw_skirmish_friendlyvehicles_max = _this select 3; // Maximum number of friendly vehicles around player
tpw_skirmish_minspawnradius = _this select 4; // Minimum distance from player to spawn units/vehicles
tpw_skirmish_maxspawnradius = _this select 5; // Maximum distance from player to spawn units/vehicles. They'll be removed beyond this distance.
tpw_skirmish_support = _this select 6; // NATO units can call support
tpw_skirmish_friendlytype = _this select 7; // 0 = user defined, 1 = NATO, 2 = FIA, 3 = AAF, 
tpw_skirmish_enemytype = _this select 8; // 0 = user defined, 1 = CAF_AG, 2 = CSAT, 3 = AAF, 4 = CSAT modification project (CMP) arid, 5 = CMP semiarid, 6 = CMP urban, 7 = ISIS (mixed CAG Aggressors with shemags), 
tpw_skirmish_spawntime = _this select 9;  // Time (sec) between spawning each enemy/friendly squad/vehicle
tpw_skirmish_friendlyunitstring = _this select 10; // Custom string to select friendly units from config
tpw_skirmish_friendlyvehiclestring = _this select 11; // Custom string to select friendly vehicles from config
tpw_skirmish_enemyunitstring = _this select 12; // Custom string to select enemy units from config
tpw_skirmish_enemyvehiclestring = _this select 13; // Custom string to select enemy vehicles from config
tpw_skirmish_active = true;
tpw_skirmish_friendlywpflag = true;
tpw_skirmish_enemywpflag = true;
tpw_skirmish_report = ["Taking casualties at","All units be advised, we are taking heavy fire at","Man down. Repeat, man down grid","Man down. Man down at","All units, taking casualties grid","Under heavy fire, grid"];
tpw_skirmish_shemaglist = [];
tpw_skirmish_templist = [];


// CAMERA SHAKE FROM DISTANT EXPLOSIONS	
tpw_skirmish_fnc_expshake = 
	{
	private ["_bomb","_dist","_delay","_intensity","_height","_bombpos"];
	_bomb = _this select 0;	
	_dist = _bomb distance player;

	// Wait until bomb hits the ground
	waituntil
		{
		_height = (getpos _bomb) select 2; 
		_height < 10;
		};
	_bombpos = getpos _bomb;
	playSound3D ["A3\Sounds_F\weapons\explosion\expl_big_1.wss",player,false,_bombpos,50,0.75,500];
	_delay = _dist / 343; // speed of sound delay
	_intensity = (500 / _dist) ^ 2; // greater intensity of closer explosion
	sleep _delay;
	addcamshake [_intensity, 1, 10];
	};	


//ASL - ADVANCED SQUAD LEADER - BLUFOR AI SQUAD LEADER CAN CALL IN CAS OR ARTILLERY ON HIGH VALUE TARGETS
tpw_skirmish_fnc_asl =
	{
	private ["_maxdist","_min","_scantime","_sql","_group","_cancallsupport","_side","_enemyside","_mindist","_groupdist","_allunits","_enemyvehicles","_enemyinfantry","_friendlyunits","_target","_targetset","_assets","_asset","_grid","_hq"];

	_sql = _this select 0; // Squad leader
	_cas = _this select 1; // Can call close air support
	_art = _this select 2; // Can call artillery support
	_group = group _sql; // Group of the side leader
	_side = side _sql; // Side of squad leader
	_enemysides = _sql call BIS_fnc_EnemySides; // Enemy sides
	_maxdist = 1000; // Maximum distance to scan for targets
	_mindist = 200; // Cannot call in support on targets closer than this to any friendlies
	_groupdist = 30; // Enemies closer than this are considered as a single target. More enemies within this distance = higher value target 
	_cancallsupport = true; // Squad leader can scan for targets 
	_scantime = 30; // How often will squad leader scan for new targets (sec)
	_min = 1; // An enemy infantry unit must have greater than this many colleagues within _groupdist to be considered as a target 
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

	// Give squad leader binoculars
	if !("Binocular" in weapons _sql) then
		{
		_sql addWeapon "Binocular";
		};
		
	// CAS - plane
	_fnc_casplane =
		{
		private ["_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_cas_west = false;
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
		_plane = [_startpos,0,"B_Plane_CAS_01_F",_grp] call BIS_fnc_spawnVehicle;
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
		private ["_target","_pos","_startpos","_startpos2","_endpos","_heli","_heli2","_grp","_wp0","_wp1","_time"];
		_cancallsupport = false;
		tpw_asl_chs_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
		if (side player == WEST) then
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
		_startpos2 = [(_pos select 0),(_pos select 1) - 5050,50];
		_endpos = [(_pos select 0),(_pos select 1) + 5000,500];
		_time = time + 600;
		_grp = createGroup west; 
		_heli = [_startpos,140,"B_Heli_Attack_01_F",_grp] call BIS_fnc_spawnVehicle; // Spawn helicopter1 and crew
		_heli = _heli select 0;
		_heli2 = [_startpos2,140,"B_Heli_Attack_01_F",_grp] call BIS_fnc_spawnVehicle; // Spawn helicopter2 and crew
		_heli2 = _heli2 select 0;
		_heli flyinheight 50;
		_heli2 flyinheight 50;
		_grp setBehaviour "COMBAT";
		_grp setCombatMode "RED";  
		_wp0 = _grp addwaypoint[_pos,50];
		_wp0 setwaypointtype "move"; 
		for "_i" from 1 to 3 do
			{
			[_pos, (250 + random 250)] call tpw_skirmish_fnc_randpos;
			_wp = _grp addWaypoint [randpos, 100];
			_wp setwaypointtype "move"; 
			};
		_wp1 = _grp addwaypoint[_endpos,0];
		_wp1 setwaypointtype "Move"; 
		//When to remove helis?
		waitUntil 
			{sleep 5;
			(
			(((_heli distance _endpos < 1000) || !(alive _heli)) && 
			((_heli2 distance _endpos < 1000) || !(alive _heli2))) || 
			time > _time
			)
			};
		deletevehicle _heli;
		deletevehicle _heli2;
		deleteGroup _grp;
		_cancallsupport = true;	
		tpw_asl_chs_west = true;
		_grid = mapGridPosition _target;
		if (side player == WEST) then
			{
			_hq SideChat format ["All units be advised: helicopter support at %1 has concluded.",_grid];
			deletemarker "tpwchsmarker";
			};
		};

	// CAS - UAV
	_fnc_casuav =
		{
		private ["_target","_pos","_startpos","_endpos","_plane","_pilot","_grp","_wp0","_wp1","_dir","_dist","_posx","_posy","_droppos","_shell"];
		_cancallsupport = false;
		tpw_asl_uav_west = false;
		_target = _this select 0;
		_grid = mapGridPosition _target;
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
		_plane = [_startpos,0,"B_UAV_02_CAS_F",_grp] call BIS_fnc_spawnVehicle;
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
				_shell = createVehicle ["Smoke_120mm_AMOS_White",_droppos,[],0,"FLY"]; // Create shell
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
				_droppos = [_posx,_posy,100];
				_shell = createVehicle ["F_40mm_White",_droppos,[],0,"FLY"]; // Create shell
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
			_assets set [count _assets,_fnc_casplane];
			};
		if (_cas && tpw_asl_chs_west) then 
			{
			_assets set [count _assets,_fnc_casheli];
			};	
		if (_cas && tpw_asl_uav_west) then 
			{
			_assets set [count _assets,_fnc_casuav];
			};			
		if (_art && tpw_asl_art_west) then
			{
			_assets set [count _assets,_fnc_arty];
			};
		if (_art && tpw_asl_smoke_west) then
			{
			_assets set [count _assets,_fnc_smoke];
			};		
		if (_art && tpw_asl_flare_west && ((daytime < 4.5) || (daytime > 19))) then
			{
			_assets set [count _assets,_fnc_flare];
			};	
		if (count _assets > 0) then 
			{	
			_asset = _assets select (floor (random (count _assets)));	
			_sql doWatch _target;
			[_target] call _asset;	
			};
		};
		
	// Select highest value target near squad leader
	_fnc_target =
		{
		private ["_unit","_enemyvehicle","_enemysoldier","_friendlyunit","_otherenemy","_ct","_max"];

		// Scan for all vehicles and foot mobiles near squad leader
		_allunits = (getpos _sql) nearEntities [["LandVehicle","camanbase"],_maxdist];
		
		// Sort into friendly and enemy units
		_enemyvehicles = [];
		_enemyinfantry = [];
		_friendlyunits = [];
		for "_i" from 0 to (count _allunits - 1) do 
			{
			_unit = _allunits select _i;
			// Lazy evaluation
			if ( 
			alive _unit && // Unit must be alive
			{_unit distance _sql > _mindist} && // Not too close to squad leader
			{!(lineintersects [getposasl _unit,getposasl _sql]) || (_sql knowsabout _unit > 0)} // Squad leader must either see unit or know about it
			) then
				{
				// Enemies			
				if (side _unit in _enemysides) then 
					{
					if (_unit iskindof "Landvehicle") then
						{
						_enemyvehicles set [count _enemyvehicles,_unit]; // Enemy vehicles
						} else
						{
						_enemyinfantry set [count _enemyinfantry,_unit]; // Enemy infantry
						};
					} else
					{
					_friendlyunits set [count _friendlyunits,_unit]; // Friendly units 
					};
				};
			};

		// Are there any friendlies near enemy vehicles?	
		for "_i" from 0 to (count _enemyvehicles - 1) do 
			{
			_enemyvehicle = _enemyvehicles select _i;
			for "_j" from 0 to (count _friendlyunits - 1) do 
				{
				_friendlyunit = _friendlyunits select _j;
				if (_friendlyunit distance _enemyvehicle < _mindist) exitwith
					{
					_enemyvehicles set [_i,-1]; // Flag this enemy for removal from potential target list
					};
				};			
			};
		_enemyvehicles = _enemyvehicles - [-1];	// Remove flagged enemy vehicles too close to friendlies
		
		// Are there any friendlies near enemy infantry?	
		for "_i" from 0 to (count _enemyinfantry - 1) do 
			{
			_enemysoldier = _enemyinfantry select _i;
			for "_j" from 0 to (count _friendlyunits - 1) do 
				{
				_friendlyunit = _friendlyunits select _j;
				if (_friendlyunit distance _enemysoldier < _mindist) exitwith
					{
					_enemyinfantry set [_i,-1]; // Flag this enemy for removal from potential target list
					};
				};			
			};
		_enemyinfantry = _enemyinfantry - [-1];	// Remove flagged enemy infantry too close to friendlies
		
		// Now to select targets from these screened units
		_target = objnull;
		_targetset = false;
		
		// Are there potential vehicle targets (higher priority than infantry)
		if (count _enemyvehicles > 0) then
			{
			_target = _enemyvehicles select (floor (random (count _enemyvehicles)));
			_targetset = true;
			} else
			{
			// Determine which enemy infantry unit has the most other nearby enemies
			_max = _min; 
			for "_i" from 0 to (count _enemyinfantry - 1) do 
				{
				_enemysoldier = _enemyinfantry select _i;
				_ct = 0; // Nearby enemy counter
				for "_j" from 0 to (count _enemyinfantry - 1) do 
					{
					_otherenemy = _enemyinfantry select _j;
					if (_enemysoldier distance _otherenemy < _groupdist) then
						{
						_ct = _ct + 1;
						};
					};	
				if (_ct > _max) then
					{
					_max = _ct;
					_target = _enemysoldier;
					_targetset = true;
					};
				};
			};	
		};
		
	// Squad leader periodically scans for targets (only if in combat/stealth mode)
	while {count (units _group) > 0} do
		{
		_sql = leader _group; 
		if (
		_cancallsupport && 
		{behaviour _sql == "COMBAT" || behaviour _sql == "STEALTH"}
		) then
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

// GET UNITS FROM CONFIG  - Thanks to Larrow for the code idea
tpw_skirmish_fnc_types =
	{
	private ["_str","_cfg","_side"];
	_str = _this select 0;
	_side = _this select 1;
	tpw_skirmish_unitlist = [];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ((_cfgName isKindOf "camanbase") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString} && {!(["civ",str _cfgname] call BIS_fnc_inString)}) then 
				{
				tpw_skirmish_unitlist set [count tpw_skirmish_unitlist,_cfgname];
				};
			};
		};
	
	// Default to NATO/CSAT if no units found	
	if (count tpw_skirmish_unitlist == 0) then
		{
		if ( _side == "east") then
			{
			["o_soldier"] call tpw_skirmish_fnc_types;
			} else
			{
			["b_soldier"] call tpw_skirmish_fnc_types;
			};
		};	
	};

// GET VEHICLES FROM CONFIG
tpw_skirmish_fnc_cartypes =
	{
	private ["_str","_cfg","_side"];
	_str = _this select 0;
	_side = _this select 1;
	tpw_skirmish_carlist = [];
	_cfg = (configFile >> "CfgVehicles");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {[_str,str _cfgname] call BIS_fnc_inString} && {!(["civ",str _cfgname] call BIS_fnc_inString)}) then 
				{
				tpw_skirmish_carlist set [count tpw_skirmish_carlist,_cfgname];
				};
			};
		};
		
	// Default to NATO/CSAT if no vehicles found	
	if (count tpw_skirmish_carlist == 0) then
		{
		if ( _side == "east") then
			{
			["o_mrap"] call tpw_skirmish_fnc_cartypes;
			} else
			{
			["b_mrap"] call tpw_skirmish_fnc_cartypes;
			};
		};		
	};	

// GET UNIFORMS FROM CONFIG
tpw_skirmish_fnc_uniforms =
	{
	private ["_str","_cfg"];
	_str = _this select 0;
	tpw_skirmish_uniformlist = [];
	_cfg = (configFile >> "CfgWeapons");
	for "_i" from 0 to ((count _cfg) -1) do 
		{
		if (isClass ((_cfg select _i) ) ) then 
			{
			_cfgName = configName (_cfg select _i);
			if (getNumber ((_cfg select _i) >> "scope") == 2 && {[_str,str _cfgname] call BIS_fnc_inString}) then 
				{
				tpw_skirmish_uniformlist set [count tpw_skirmish_uniformlist,_cfgname];
				};
			};
		};
	};	
	
// RANDOM POSITION	
tpw_skirmish_fnc_randpos =
	{
	private ["_thispos","_radius","_dir","_posx","_posy"];
	_thispos = _this select 0;
	_radius = _this select 1;
	_dir = random 360;
	_posx = ((_thispos select 0) + (_radius * sin(_dir)));
	_posy = ((_thispos select 1) + (_radius * cos(_dir)));
	randpos = [_posx,_posy,0]; 
	};
	
//SPAWN INFANTRY
tpw_skirmish_squadspawn = 
	{
	private ["_side","_units","_spawnpos","_max","_unit","_house","_houses","_spawnpos","_sqname","_leader""_shemag","_uniform"];
	_side = _this select 0;
	_units = _this select 1;	
	
	// Random position to spawn	- either in a nearby house (250-500m away) or otherwise at a random position > 500m away
	[tpw_skirmish_minspawnradius] call tpw_core_fnc_houses;
	_houses = tpw_core_houses;
	for "_ct" from 0 to (count _houses - 1) do
		{
		_house = _houses select _ct;
		if (position _house distance player < (tpw_skirmish_minspawnradius / 2)) then
			{
			_houses set [_ct, -1];
			};
		};
	_houses = _houses - [ -1];	
	if (count _houses > 10 && {random 100 > 50}) then
		{
		_house = _houses select (floor (random (count _houses)));
		_spawnpos = position _house;
		} else
		{
		waituntil
			{
			sleep 0.2;
			[position player,(tpw_skirmish_minspawnradius + (random tpw_skirmish_maxspawnradius))] call tpw_skirmish_fnc_randpos;
			!(surfaceiswater randpos);
			};
		_spawnpos = randpos;
		};
	
	// Pick random members for squad	
	_sqname = creategroup _side;
	_max = 2 + floor random 4;
	for "_i" from 0 to _max do 
		{
		_unit = _units select (floor (random (count _units)));
		_unit createUnit [_spawnpos,_sqname];
		sleep 0.2;
		};

	// Patrol behaviour
	_leader = leader _sqname;
	[_leader, _leader, 250, 7, "MOVE", "SAFE", "YELLOW", "LIMITED","WEDGE", "_this spawn CBA_fnc_searchNearby", [3,6,9]] call CBA_fnc_taskPatrol; 
	
	// Side specific behaviours
	if (_side == WEST) then
		{ 
		if (tpw_skirmish_support == 1 && {tpw_skirmish_friendlytype == 0 || tpw_skirmish_friendlytype == 1}) then 
			{
			0 = [_leader, true, true] spawn tpw_skirmish_fnc_asl;
			};
		// Add killed eventhandler
			{
			_x addeventhandler ["killed",
				{
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
					[position (_this select 0)] spawn tpw_skirmish_fnc_friendlywp;
					};
				}];
			sleep 0.2;	
			} foreach units _sqname;

		// Add to friendly squad array	
		tpw_skirmish_friendlysquads set [count tpw_skirmish_friendlysquads,_sqname];			
		} else
		{
			{
			// Add killed eventhandler
			_x addeventhandler ["killed",
				{
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
					[position (_this select 0)] spawn tpw_skirmish_fnc_enemywp;
					};
				}];
			
			// ISIS uniforms & shemags	 
			if (count tpw_skirmish_shemaglist > 0 && {tpw_skirmish_enemytype == 7 || tpw_skirmish_enemytype == 8}) then
				{
				_shemag = tpw_skirmish_shemaglist select (floor (random (count tpw_skirmish_shemaglist)));
				_uniform = tpw_skirmish_uniformlist select (floor (random (count tpw_skirmish_uniformlist)));
				_x unassignItem "NVGoggles_OPFOR";    
				_x removeItem "NVGoggles_OPFOR";
				_x forceadduniform _uniform;
				_x addheadgear _shemag;
				};
			sleep 0.2;	
			} foreach units _sqname;
			
		//Add to enemy squad array	
		tpw_skirmish_enemysquads set [count tpw_skirmish_enemysquads,_sqname];
		};
	};

// MOVE WAYPOINTS	
tpw_skirmish_fnc_friendlywp = 	
	{
	private ["_ct","_group","_killpos"];
	tpw_skirmish_friendlywpflag = false; // only one instance of this function can run at once
	_killpos = _this select 0;
	for "_ct" from 0 to (count tpw_skirmish_friendlysquads - 1) do	
		{
		sleep random 2;
		_group = tpw_skirmish_friendlysquads select _ct;
		if (!isnil "_group") then
			{
			// Remove current waypoints
			for "_i" from count (waypoints _group) to 1 step -1 do
				{
				deleteWaypoint ((waypoints _group) select _i);
				};
			// Get squads to move towards and patrol around killed unit	
			[(leader _group),_killpos, 250, 7, "MOVE","AWARE", "YELLOW", "LIMITED","DIAMOND", "_this spawn CBA_fnc_searchNearby", [3,6,9]] call CBA_fnc_taskPatrol; 
			};
		};
	tpw_skirmish_friendlywpflag = true;	
	};	

tpw_skirmish_fnc_enemywp = 	
	{
	private ["_ct","_group","_killpos"];
	tpw_skirmish_enemywpflag = false; // only one instance of this function can run at once
	_killpos = _this select 0;
	for "_ct" from 0 to (count tpw_skirmish_enemysquads - 1) do	
		{
		sleep random 2;
		_group = tpw_skirmish_enemysquads select _ct;
		if (!isnil "_group") then
			{
			// Remove current waypoints
			for "_i" from count (waypoints _group) to 1 step -1 do
				{
				deleteWaypoint ((waypoints _group) select _i);
				};
			// Get squads to move towards and patrol around killed unit	
			[(leader _group),_killpos, 250, 7, "MOVE","AWARE", "YELLOW", "LIMITED","DIAMOND", "_this spawn CBA_fnc_searchNearby", [3,6,9]] call CBA_fnc_taskPatrol; 
			};	
		};
	tpw_skirmish_enemywpflag = true;	
	};	
	
//SPAWN VEHICLES
tpw_skirmish_vehspawn = 
	{
	private ["_side","_units","_cars","_spawnpos","_unit","_roadlist","_farroads","_road","_spawncar","_car","_p1","_p2","_leader","_wppos","_wp","_shemag","_uniform"];
	_side = _this select 0;
	_units = _this select 1;	
	_cars = _this select 2;	

	// Pick random car	
	_car = _cars select (floor (random (count _cars)));
			
	// Roads to spawn and drive on	
	_roadlist = (position player) nearRoads tpw_skirmish_maxspawnradius;
	_farroads = [];

	for "_i" from 0 to (count _roadlist - 1) do	
		{
		_road = _roadlist select _i;
		if (vehicle player distance position _road > tpw_skirmish_minspawnradius) then 
			{
			_farroads set [count _farroads,_road];
			};
		};	
		
	// Spawn position if enough roads
	if (count _farroads > 10) then
		{
		_spawnpos = getpos ( _farroads select (floor (random (count _farroads))));	
		} else
		{
		// Random position if no roads
		waituntil
			{
			sleep 0.2;
			// Random position	
			_radius = tpw_skirmish_minspawnradius + random tpw_skirmish_maxspawnradius;
			_dir = random 360;
			_posx = (((getpos player) select 0) + (_radius * sin(_dir)));
			_posy = (((getpos player) select 1) + (_radius * cos(_dir)));
			_spawnpos = [_posx,_posy,0]; 
			!(surfaceiswater _spawnpos);
			};
		};

	// Pick random members for vehicle	
	_sqname = creategroup _side;
	_max = 2 + floor random 4;
	for "_i" from 1 to 3 do 
		{
		_unit = _units select (floor (random (count _units)));
		_unit createUnit [_spawnpos,_sqname];
		sleep 0.2;
		};
		
	// Spawn car
	_spawncar = _car createVehicle _spawnpos; 
	
		{
		_x moveinany _spawncar;
		// ISIS shemags	
		if (side _x == EAST && {count tpw_skirmish_shemaglist > 0} && {tpw_skirmish_enemytype == 7 || tpw_skirmish_enemytype == 8}) then
			{
			_shemag = tpw_skirmish_shemaglist select (floor (random (count tpw_skirmish_shemaglist)));
			_uniform = tpw_skirmish_uniformlist select (floor (random (count tpw_skirmish_uniformlist)));
			_x unassignItem "NVGoggles_OPFOR";    
			_x removeItem "NVGoggles_OPFOR";
			_x forceadduniform _uniform;
			_x addheadgear _shemag;
			};
		sleep 0.2	
		} foreach units _sqname;
		
	// Waypoints if enough roads	
	if (count _farroads > 10) then
		{
		for "_i" from 1 to 5 do
			{
			_road = _roadlist select (floor (random (count _roadlist)));
			_wppos = getpos _road; 
			_wp = _sqname addWaypoint [_wppos, 0];
			if (_i == 5) then 
				{
				_wp setwaypointtype "CYCLE";
				};
			};
		} else
		{
		//Random waypoints if no roads
		for "_i" from 1 to 5 do
			{
			waituntil
				{
				sleep 0.2;
				// Random position	
				_radius = tpw_skirmish_minspawnradius + random tpw_skirmish_maxspawnradius;
				_dir = random 360;
				_posx = (((getpos player) select 0) + (_radius * sin(_dir)));
				_posy = (((getpos player) select 1) + (_radius * cos(_dir)));
				_wppos = [_posx,_posy,0]; 
				!(surfaceiswater _wppos);
				};
			_wp = _sqname addWaypoint [_wppos, 0];
			if (_i == 5) then 
				{
				_wp setwaypointtype "CYCLE";
				};
			};
		};
		
	// Add to the vehicle array	
	if (_side == EAST) then
		{
		tpw_skirmish_enemyvehicles set [count tpw_skirmish_enemyvehicles,_spawncar];
		}
		else
		{
		tpw_skirmish_friendlyvehicles set [count tpw_skirmish_friendlyvehicles,_spawncar];
		};			
	};	

// SELECT UNITS
private ["_unitstring","_carstring"];

// BLUFOR
switch tpw_skirmish_friendlytype do
	{
	case 0:
		{
		// User defined
		_unitstring = tpw_skirmish_friendlyunitstring; 
		_carstring = tpw_skirmish_friendlyvehiclestring; 
		};	
	case 1:
		{
		//NATO
		_unitstring = "b_soldier";
		_carstring = "b_mrap";
		};
	case 2:
		{
		//FIA
		_unitstring = "b_g_soldier";
		_carstring = "b_g_offroad";
		};
	case 3:
		{
		//AAF
		_unitstring = "i_soldier";
		_carstring = "i_mrap";
		};	
	case 4:
		{
		// User defined
		_unitstring = tpw_skirmish_friendlyunitstring; 
		_carstring = tpw_skirmish_friendlyvehiclestring; 
		};			
	};	
[_unitstring,"west"] call tpw_skirmish_fnc_types;
_friendlyunitlist = tpw_skirmish_unitlist;
[_carstring,"west"] call tpw_skirmish_fnc_cartypes;
_friendlycarlist = tpw_skirmish_carlist;

// OPFOR
switch tpw_skirmish_enemytype do
	{
	case 0:
		{
		// User defined
		_unitstring = tpw_skirmish_enemyunitstring; 
		_carstring = tpw_skirmish_enemyvehiclestring; 
		};	
	case 1:
		{
		//CAF AG
		if (isclass (configfile/"CfgWeapons"/"H_caf_ag_turban")) then 
			{
			// European default
			_unitstring = "caf_ag_eeur"; 
			_carstring = "caf_ag_eeur"; 
			
			//Arid
			if (worldname in 
			[
			"MCN_Aliabad",
			"BMFayshkhabur",
			"clafghan",
			"fallujah",
			"fata",
			"hellskitchen",
			"hellskitchens",
			"MCN_HazarKot",
			"praa_av",
			"reshmaan",
			"Shapur_BAF",
			"Takistan",
			"torabora",
			"TUP_Qom",
			"Zargabad",
			"pja307",
			"pja306",
			"Mountains_ACR",
			"tunba"
			]
			) then 
				{
				// Mid east
				_unitstring = "caf_ag_me"; 
				_carstring = "caf_ag_me";
				};
			
			// Tropical
			if (worldname in 
			[
			"mak_Jungle",
			"pja305",
			"tropica",
			"tigeria",
			"tigeria_se"
			]
			) then 
				{
				// African
				_unitstring = "caf_ag_afr";
				_carstring = "caf_ag_afr";
				};
			} else
			{
			//CSAT if CAF AG not found
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			}; 
		};
	case 2:
		{
		//CSAT
		_unitstring = "o_soldier";
		_carstring = "o_mrap";
		};
	case 3:
		{
		//AAF
		_unitstring = "i_soldier";
		_carstring = "i_mrap";
		};
	case 4:
		{
		//TEC CMP - Arid
		if (isclass (configfile/"CfgWeapons"/"TEC_H_Beret_MEDFOR")) then 
			{
			_unitstring = "tec_o_soldier";
			_carstring = "tec_vh_mrap";
			} else
			{
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			}
		};
	case 5:
		{
		//TEC CMP - Semi arid
		if (isclass (configfile/"CfgWeapons"/"TEC_H_Beret_MEDFOR")) then 
			{
			_unitstring = "tec_o_soldier_semiarid";
			_carstring = "tec_vh_mrap";
			} else
			{
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			}
		};	
	case 6:
		{
		//TEC CMP - Urban
		if (isclass (configfile/"CfgWeapons"/"TEC_H_Beret_MEDFOR")) then 
			{
			_unitstring = "tec_o_soldier_urban";
			_carstring = "tec_vh_mrap";
			} else
			{
			_unitstring = "o_soldier";
			_carstring = "o_mrap";
			}
		};
	case 7:
		{
		// ISIS			
		tpw_skirmish_shemaglist = ["H_Shemag_khk","H_Shemag_olive","H_Shemag_tan","H_Shemag_olive_hs","H_Shemagopen_khk","H_Shemagopen_tan"]; // shemags
		if (isclass (configfile/"CfgWeapons"/"H_caf_ag_turban")) then 
			{
			["u_caf_ag"] call tpw_skirmish_fnc_uniforms;// CAF AG uniforms
			_unitstring = "caf_ag_me"; // CAF Aggressor units
			_carstring = "caf_ag_me"; // CAF Aggressor units and vehicles
			}else
			{
			["u_bg_guerilla"] call tpw_skirmish_fnc_uniforms;// FIA uniforms
			_unitstring = "o_soldier";// CSAT units
			_carstring = "b_g_offroad";// FIA vehicles
			};
		};	
	case 8:
		{
		// ISIS 2035
		tpw_skirmish_shemaglist = ["H_Shemag_khk","H_Shemag_olive","H_Shemag_tan","H_Shemag_olive_hs","H_Shemagopen_khk","H_Shemagopen_tan"]; // shemags
		if (isclass (configfile/"CfgWeapons"/"H_caf_ag_turban")) then 
			{
			["u_caf_ag"] call tpw_skirmish_fnc_uniforms;// CAF AG uniforms
			_unitstring = "o_soldier";// CSAT units
			_carstring = "caf_ag_me"; // CAF Aggressor units and vehicles
			}else
			{
			["u_bg_guerilla"] call tpw_skirmish_fnc_uniforms;// FIA uniforms
			_unitstring = "o_soldier";// CSAT units
			_carstring = "b_g_offroad";// FIA vehicles
			};
		};		
	};	
[_unitstring,"east"] call tpw_skirmish_fnc_types;
_enemyunitlist = tpw_skirmish_unitlist;
[_carstring,"east"] call tpw_skirmish_fnc_cartypes;
_enemycarlist = tpw_skirmish_carlist;

//ADDITIONAL ENEMY PROCESSING
if (tpw_skirmish_enemytype == 3) then
	{
	for "_i" from 0 to (count _enemyunitlist - 1) do	
		{	
		_unit = _enemyunitlist select _i;
		if ((["Semiarid",str _unit] call BIS_fnc_inString) || (["Urban",str _unit] call BIS_fnc_inString)) then
			{
			_enemyunitlist set [_i, -1];
			};
		};
	_enemyunitlist = _enemyunitlist - [-1];	
	};
	
// No unarmed, pilot, VR or diver enemies	
for "_i" from 0 to (count _enemyunitlist - 1) do	
	{	
	_unit = _enemyunitlist select _i;
	if ((["unarmed",str _unit] call BIS_fnc_inString) ||(["pilot",str _unit] call BIS_fnc_inString)||(["diver",str _unit] call BIS_fnc_inString)||(["vr",str _unit] call BIS_fnc_inString)) then
		{
		_enemyunitlist set [_i, -1];
		};
	};
_enemyunitlist = _enemyunitlist - [-1];	

// No unarmed, pilot, VR or diver friendlies	
for "_i" from 0 to (count _friendlyunitlist - 1) do	
	{	
	_unit = _friendlyunitlist select _i;
	if ((["unarmed",str _unit] call BIS_fnc_inString) ||(["pilot",str _unit] call BIS_fnc_inString)||(["diver",str _unit] call BIS_fnc_inString)||(["vr",str _unit] call BIS_fnc_inString)) then
		{
		_friendlyunitlist set [_i, -1];
		};
	};
_friendlyunitlist = _friendlyunitlist - [-1];	

// Briefly spawn all units so that textures are cached
	{
	_temp = _x createvehicle [0,0,5000]; 
	sleep 0.1;
	deletevehicle _temp;
	} foreach _enemyunitlist;
	
	{
	_temp = _x createvehicle [0,0,5000]; 
	sleep 0.1;
	deletevehicle _temp;
	} foreach _friendlyunitlist;

// CREATE AI CENTRES SO SPAWNED GROUPS KNOW WHO'S AN ENEMY
private ["_centerW", "_centerE", "_centerR", "_centerC"];
_centerW = createCenter west;
_centerE = createCenter east;
_centerC = createCenter civilian;
west setFriend [east, 0];
east setFriend [west, 0];

// SCAN AROUND PLAYER, SPAWN AND DELETE UNITS AS APPROPRIATE
tpw_skirmish_enemysquads = [];	
tpw_skirmish_enemyvehicles = [];
tpw_skirmish_friendlysquads = [];	
tpw_skirmish_friendlyvehicles = [];
while {true} do
	{
	private ["_squad","_car","_group","_leader","_nearsort","_nearestsquad","_ct"];
	if (tpw_skirmish_active) then 
		{
		// Spawn new enemy squads
		if (count tpw_skirmish_enemysquads < tpw_skirmish_enemysquad_max) then
			{
			[EAST,_enemyunitlist] call tpw_skirmish_squadspawn;
			sleep 2;	
			};
		
			
		// Spawn new enemy vehicles
		if (count tpw_skirmish_enemyvehicles < tpw_skirmish_enemyvehicles_max && {random 100 > 75}) then
			{
			[EAST,_enemyunitlist,_enemycarlist] call tpw_skirmish_vehspawn;
			sleep 2;
			};
	

		// Spawn new friendly squads
		if (count tpw_skirmish_friendlysquads < tpw_skirmish_friendlysquad_max) then
			{
			[WEST,_friendlyunitlist] call tpw_skirmish_squadspawn;
			sleep 2;
			};

			
		// Spawn new friendly vehicles
		if (count tpw_skirmish_friendlyvehicles < tpw_skirmish_friendlyvehicles_max && {random 100 > 75}) then
			{
			[WEST,_friendlyunitlist,_friendlycarlist] call tpw_skirmish_vehspawn;
			sleep 2;
			};			
			
		//Delete distant enemy squads
		for "_ct" from 0 to (count tpw_skirmish_enemysquads - 1) do	
			{	
			_squad = tpw_skirmish_enemysquads select _ct;
			if ((leader _squad) distance player > tpw_skirmish_maxspawnradius) then
				{
					{
					deletevehicle _x;
					} foreach units _squad;
				deleteGroup _squad;
				tpw_skirmish_enemysquads set [_ct,-1];
				};
			};
		tpw_skirmish_enemysquads = tpw_skirmish_enemysquads - [-1];
		
		//Delete distant friendly squads
		for "_ct" from 0 to (count tpw_skirmish_friendlysquads - 1) do	
			{	
			_squad = tpw_skirmish_friendlysquads select _ct;
			if ((leader _squad) distance player > tpw_skirmish_maxspawnradius) then
				{
					{
					deletevehicle _x;
					} foreach units _squad;
				deleteGroup _squad;
				tpw_skirmish_friendlysquads set [_ct,-1];
				};
			};
		tpw_skirmish_friendlysquads = tpw_skirmish_friendlysquads - [-1];
				
		// Any enemy squads with only one member - consolidate with nearest enemy squad 
		if (count tpw_skirmish_enemysquads  > 1) then
			{
			for "_ct" from 0 to (count tpw_skirmish_enemysquads - 1) do	
				{	
				_squad = tpw_skirmish_enemysquads select _ct;
				if (count (units _squad) == 1) exitwith
					{
					_leader = leader _squad;
					_nearsort = [tpw_skirmish_enemysquads,[],{_leader distance ((units _x) select 0)},"ASCEND"] call BIS_fnc_sortBy;
					_nearestsquad = _nearsort select 1;
					[_leader] joinsilent _nearestsquad;
					deleteGroup _squad;
					tpw_skirmish_enemysquads set [_ct,-1];
					};
				};
			};
		tpw_skirmish_enemysquads = tpw_skirmish_enemysquads - [-1];	
		
		// Any friendly squads with only one member - consolidate with nearest friendly squad 
		if (count tpw_skirmish_friendlysquads  > 1) then
			{
			for "_ct" from 0 to (count tpw_skirmish_friendlysquads - 1) do	
				{	
				_squad = tpw_skirmish_friendlysquads select _ct;
				if (count (units _squad) == 1) exitwith
					{				
					_leader = leader _squad;
					_nearsort = [tpw_skirmish_friendlysquads,[],{_leader distance ((units _x) select 0)},"ASCEND"] call BIS_fnc_sortBy;
					_nearestsquad = _nearsort select 1;
					[_leader] joinsilent _nearestsquad;
					deleteGroup _squad;
					tpw_skirmish_friendlysquads set [_ct,-1];
					};
				};
			};
		tpw_skirmish_friendlysquads = tpw_skirmish_friendlysquads - [-1];		
		
		//Delete distant enemy vehicles
		for "_ct" from 0 to (count tpw_skirmish_enemyvehicles - 1) do	
			{	
			_car = tpw_skirmish_enemyvehicles select _ct;
			_group = group driver _car;
			
			if (_car distance player > tpw_skirmish_maxspawnradius) then
				{
				// Remove waypoints	
				for "_i" from count (waypoints _group) to 1 step -1 do
					{
					deleteWaypoint ((waypoints _group) select _i);
					};	
				// Remove crew		
					{
					deletevehicle _x;
					} foreach units _group;
				deletevehicle _car;
				deleteGroup _group;
				tpw_skirmish_enemyvehicles set [_ct,-1];
				};
			};
		tpw_skirmish_enemyvehicles = tpw_skirmish_enemyvehicles - [-1];
		
		//Delete distant friendly vehicles
		for "_ct" from 0 to (count tpw_skirmish_friendlyvehicles - 1) do	
			{	
			_car = tpw_skirmish_friendlyvehicles select _ct;
			_group = group driver _car;
			
			if (_car distance player > tpw_skirmish_maxspawnradius) then
				{
				// Remove waypoints	
				for "_i" from count (waypoints _group) to 1 step -1 do
					{
					deleteWaypoint ((waypoints _group) select _i);
					};	
				// Remove crew		
					{
					deletevehicle _x;
					} foreach units _group;
				deletevehicle _car;
				deleteGroup _group;
				tpw_skirmish_friendlyvehicles set [_ct,-1];
				};
			};
		tpw_skirmish_friendlyvehicles = tpw_skirmish_friendlyvehicles - [-1];
		};
	sleep tpw_skirmish_spawntime;
	};	
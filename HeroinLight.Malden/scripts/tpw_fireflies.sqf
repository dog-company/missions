/*
TPW FIREFLIES - Animated glowing fireflies on warm evenings, houseflies build up around dead bodies
Version: 1.05
Author: tpw
Thanks: Valken for the idea, lordprimate for input and suggestions
Date: 20170706
Requires: CBA A3
Optional: TPW FOG, TPW SOAP
Compatibility: SP, MP client (maybe)

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as e.g. tpw_fireflies.sqf
2 - Call it with 0 = [4,18,5,25,5,50,5,0.1,[250,220,100],0.8,0.05,1,0.075] execvm "tpw_fireflies.sqf";  where the numbers represent (in order):

// Environment
4 = tpw_firefly_window // How many hours after sunset will fireflies appear
18 = tpw_firefly_temp // Minimum temperature (deg C) for fireflies to be active, if running TPW FOG
5 = tpw_firefly_trees // Number of trees needed within tpw_firefly_radius of player in order to spawn fireflies. 0 = fireflies everywhere 
 
// Spawning 
25 = tpw_firefly_radius // Firefies will be spawned within this distance (m) of player
5 = tpw_firefly_time // Max seconds between spawning each firefly/swarm
50 = tpw_firefly_maxflies // Maximum number of fireflies around player
5 = tpw_firefly_swarmsize // Maximum number of fireflies per swarm (must be less than tpw_firefly_maxflies)
0.1 = tpw_firefly_largeswarm // Chance of a large swarm (5 X tpw_firefly_swarmsize) spawning near player. 0 = never, 1 = always
 
// Firefly attributes
[250,220,100] = tpw_firefly_colour // Firefly glow colour
0.8 = tpw_firefly_brightness // Brightness of each firefly (0 - 1)
0.05 = tpw_firefly_size // Apparent size of each firefly (0.01 - 0.2)
1 = tpw_firefly_blink // Flashing enabled. 0 = no flashing, 1 = brief flash with ~1 sec between flashes
0.075 = tpw_firefly_speed // Max time (sec) between firefly animation "frames". Larger = slower moving fireflies

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if ((count _this) < 13) exitWith {hint "TPW FIREFLIES incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
 
// VARIABLES
tpw_firefly_version = "1.05"; // Version string
tpw_firefly_active = true; // Fireflies active. 
 
// Environment
tpw_firefly_window = _this select 0; // How many hours after sunset will fireflies appear
tpw_firefly_temp = _this select 1; // Minimum temperature (deg C) for fireflies to be active, if running TPW FOG
tpw_firefly_trees = _this select 2 ; // Number of trees needed within tpw_firefly_radius of player in order to spawn fireflies. 0 = fireflies everywhere 
 
// Spawning 
tpw_firefly_radius = _this select 3; // Firefies will be spawned within this distance (m) of player
tpw_firefly_time = _this select 4; // Max seconds between spawning each firefly/swarm
tpw_firefly_maxflies = _this select 5; // Maximum number of fireflies around player
tpw_firefly_swarmsize = _this select 6; // Maximum number of fireflies per swarm (must be less than tpw_firefly_maxflies)
tpw_firefly_largeswarm = _this select 7; // Chance of a large swarm (5 X tpw_firefly_swarmsize) spawning near player. 0 = never, 1 = always
 
// Firefly attributes
tpw_firefly_colour = _this select 8; // Firefly glow colour
tpw_firefly_brightness = _this select 9; // Brightness of each firefly (0 - 1)
tpw_firefly_size = _this select 10; //  Apparent size of each firefly (0.01 - 0.2)
tpw_firefly_blink = _this select 11; // Flashing enabled. 0 = no flashing, 1 = brief flash with ~1 sec between flashes
tpw_firefly_speed = _this select 12; // Max time (sec) between firefly animation "frames". Larger = slower moving fireflies

tpw_firefly_houseflyrange = 8; // Flies will spawn/despawn at this range
 
// CO-ORDINATES FOR ANIMATING FIREFLIES 
// Each co-ordinate represents displacement from original startpoint, not absolute position in world space, so can be applied to any object 
tpw_firefly_flightarray = [[0.0439453,0.00634766,-0.0027256],[0.131836,0.0117188,-0.00764084],[0.216797,0.0117188,-0.0117626],[0.302734,-0.00244141,-0.0132179],[0.429688,-0.0385742,-0.0128517],[0.507813,-0.0749512,-0.0100594],[0.577148,-0.116211,-0.00601387],[0.666016,-0.195313,0.00541878],[0.708984,-0.256836,0.0153732],[0.761719,-0.358643,0.0343571],[0.786133,-0.427979,0.0485001],[0.796875,-0.500977,0.0638981],[0.797852,-0.616943,0.0920849],[0.787109,-0.689453,0.109226],[0.770508,-0.760742,0.123106],[0.734375,-0.871338,0.147993],[0.699219,-0.937744,0.162752],[0.661133,-1.00342,0.178305],[0.59082,-1.09888,0.20372],[0.533203,-1.15698,0.219051],[0.470703,-1.21118,0.236105],[0.370117,-1.28052,0.259731],[0.299805,-1.31787,0.273663],[0.222656,-1.35034,0.28941],[0.101563,-1.3833,0.309582],[0.0185547,-1.39478,0.323536],[-0.0644531,-1.40063,0.338097],[-0.141602,-1.39136,0.346508],[-0.253906,-1.36621,0.35914],[-0.326172,-1.33765,0.365284],[-0.388672,-1.30396,0.368486],[-0.477539,-1.23828,0.37532],[-0.524414,-1.18433,0.375397],[-0.567383,-1.12769,0.375376],[-0.621094,-1.0293,0.374701],[-0.641602,-0.964844,0.371052],[-0.655273,-0.897949,0.368309],[-0.663086,-0.797363,0.360992],[-0.65918,-0.730957,0.354088],[-0.648438,-0.664551,0.348282],[-0.618164,-0.565674,0.328905],[-0.59082,-0.50708,0.316721],[-0.561523,-0.449219,0.305183],[-0.50293,-0.375977,0.284504],[-0.456055,-0.329102,0.27211],[-0.401367,-0.260254,0.253872],[-0.376953,-0.215576,0.24193],[-0.359375,-0.172607,0.23156],[-0.348633,-0.108887,0.213509],[-0.353516,-0.065918,0.202593],[-0.364258,-0.0224609,0.193159],[-0.396484,0.0388184,0.181801],[-0.425781,0.0834961,0.17786],[-0.458984,0.126465,0.174463],[-0.524414,0.190674,0.1714],[-0.574219,0.233398,0.172075],[-0.626953,0.267822,0.173143],[-0.711914,0.312256,0.177267],[-0.775391,0.338379,0.182373],[-0.839844,0.352539,0.18766],[-0.943359,0.366455,0.199978],[-1.01465,0.366455,0.209566],[-1.08594,0.359375,0.219231],[-1.19336,0.33667,0.237915],[-1.26074,0.309326,0.249615],[-1.3291,0.277344,0.262356],[-1.42969,0.214355,0.284672],[-1.48926,0.162842,0.297728],[-1.54199,0.105469,0.312429],[-1.6084,0.0107422,0.331869],[-1.64258,-0.0559082,0.342173],[-1.66895,-0.128418,0.354151],[-1.69141,-0.239502,0.36729],[-1.69531,-0.313477,0.375938],[-1.69531,-0.385986,0.384855],[-1.67383,-0.485352,0.389666],[-1.64941,-0.551025,0.393681],[-1.61816,-0.613281,0.395206],[-1.58008,-0.668701,0.393782],[-1.51074,-0.743408,0.388815],[-1.45703,-0.783447,0.381929],[-1.40137,-0.819336,0.375084],[-1.30664,-0.865234,0.3643],[-1.24219,-0.883789,0.354816],[-1.17773,-0.896729,0.346823],[-1.07715,-0.904785,0.332701],[-1.00781,-0.900879,0.321283],[-0.939453,-0.889893,0.311756],[-0.844727,-0.857666,0.29425],[-0.787109,-0.829102,0.28429],[-0.730469,-0.797119,0.275248],[-0.658203,-0.732666,0.257126],[-0.614258,-0.683838,0.248888],[-0.553711,-0.594238,0.229216],[-0.533203,-0.553955,0.220648],[-0.501953,-0.480957,0.213087],[-0.483398,-0.429443,0.207119],[-0.46582,-0.391357,0.198231],[-0.435547,-0.360596,0.175703],[-0.412109,-0.348877,0.1598],[-0.385742,-0.350098,0.14596]];

// ANIMATE  HOUSEFLIES
tpw_firefly_fnc_houseflyanimate = 
	{
	private _model = _this select 0; 
	private _startpos = visibleposition _model;

	// Randomise radius (ie scaling the size of flight envelope) and speed (time between position updates) for each pass through the co-ordinate array 
	private _mult = 0.5 - (random 1); // random radius (-0.5 to 0.5)
	private _sleep = tpw_firefly_speed / 5 + random tpw_firefly_speed / 5; // random speed
	
	// Step through co-ordinates and update position of lightpoint and model
	for "_i" from 0 to 100 do
		{
		_pos = tpw_firefly_flightarray select _i;
		private _newpos = _startpos vectoradd (_pos vectormultiply _mult); // add scaled co-ordinate to start position
		_model setposatl _newpos;
		sleep _sleep;
		};
	};
 
// ANIMATE FIREFLIES
tpw_firefly_fnc_animate = 
	{
	private _light = _this select 0;
	private _model = _this select 1; 
	private _startpos = visibleposition _light;

	// Randomise radius (ie scaling the size of flight envelope) and speed (time between position updates) for each pass through the co-ordinate array 
	private _mult = 1 - (random 2); // random radius (-1 to 1)
	private _sleep = tpw_firefly_speed / 2 + random tpw_firefly_speed / 2; // random speed
	
	// Step through co-ordinates and update position of lightpoint and model
	for "_i" from 0 to 100 do
		{
		_pos = tpw_firefly_flightarray select _i;
		private _newpos = _startpos vectoradd (_pos vectormultiply _mult); // add scaled co-ordinate to start position
		_light setposatl _newpos;
		_model setposatl _newpos;
		sleep _sleep;
		};
	};
 
// SPAWN INDIVIDUAL HOUSE FLY 
tpw_firefly_fnc_spawnhousefly =
	{
	if (tpw_firefly_totalhouseflies > tpw_firefly_maxflies) exitwith {};
	private _body = _this select 0;
	private _pos = (getpos _body) vectoradd [0,0,random 1]; 
	private _model = "Housefly" createvehiclelocal _pos;
	_model setdir random 360;
	private _spawnedflies = _body getvariable ["spawnedflies",0];
	_body setvariable ["spawnedflies",_spawnedflies + 1];
	tpw_firefly_totalhouseflies = tpw_firefly_totalhouseflies + 1;
	// Spawn distance and condition check to remove fly , add buzzing
	[_body, _model] spawn 
		{
		private _body = _this select 0;
		private _model = _this select 1;
		while {alive _model} do
			{
			if ((_model distance player > tpw_firefly_houseflyrange) || (tpw_firefly_canspawnhousefly == 0)) then
				{
				deletevehicle _model;
				_body setvariable ["spawnedflies",0];
				tpw_firefly_totalhouseflies = tpw_firefly_totalhouseflies - 1;
				};
			
			if (random 1 > 0.9) then
				{	
				private _buzz = format ["TPW_SOUNDS\sounds\fly%1.ogg",ceil (random 8)];
				playsound3d [_buzz,_model,false,getposasl _model,0.4,0.9 + (random 0.2),20];
				};	
				
			sleep random 1;		
			};		
		};	
	
	// Animate live fly, entire spawned fnc will terminate once fly is removed 	
	while {alive _model} do
		{
		[_model] call tpw_firefly_fnc_houseflyanimate;
		};	
	};	
 
 // FLY BUZZING AROUND PLAYER
tpw_firefly_fnc_playerflies =
	{
	if (daytime > tpw_firefly_dusktime || daytime < tpw_firefly_dawntime) exitwith {};
	if (random 1 > 0.9) then
		{
		private _buzz = format ["TPW_SOUNDS\sounds\fly%1.ogg",ceil (random 8)];
		playsound3d [_buzz,player,false,eyepos player vectoradd [-0.5 + random 1,-0.5 + random 1, -0.5 + random 1],random 0.15,0.9 + random 0.2,20];
		};
	};
	
 // MOSQUITO BUZZING AROUND PLAYER
tpw_firefly_fnc_playermozzies =
	{
	if (daytime < tpw_firefly_dusktime && {daytime > tpw_firefly_dawntime}) exitwith {};
	if (random 1 > 0.9) then
		{
		private _buzz = format ["TPW_SOUNDS\sounds\mozzie%1.ogg",ceil (random 4)];
		playsound3d [_buzz,player,false,eyepos player vectoradd [-0.5 + random 1,-0.5 + random 1, -0.5 + random 1],random 0.05,0.9 + random 0.2,20];
		};
	};
	
// SPAWN INDIVIDUAL FIREFLY AND BEHAVIOUR
tpw_firefly_fnc_spawnfly =
	{
	private _pos = (_this select 0) vectoradd [0,0,random 1]; // random height from ground
	 
	// Create lightpoint and fly model
	private _light = "#lightpoint" createVehiclelocal _pos;  
	private _model = "Mosquito" createvehiclelocal _pos; 
	_model setdir random 360;
	_light setLightColor tpw_firefly_colour;  
	_light setLightIntensity tpw_firefly_brightness; 
	_light setLightAttenuation [0,1,4,0,0.1,1];  
	_light setLightUseFlare true;
	_light setLightFlareSize tpw_firefly_size;
	_light setLightFlareMaxDistance tpw_firefly_radius; 
	 
	// Spawn behaviour for each lightpoint/model 
	[_light,_pos,_model] spawn 
		{
		private _light = _this select 0;
		private _pos = _this select 1;
		private _model = _this select 2;
		private _flash = 0.2 + (random 0.1);
		private _dark = 1 + (random 0.5);
		 
		// Animation loop - will terminate when bug is deleted
		[_light,_model] spawn
			{
			private _light = _this select 0;
			private _model = _this select 1;
			while {alive _light} do
				{
				[_light,_model] call tpw_firefly_fnc_animate;
				};
			};
		 
		// Lightpoint loop - will terminate when bug is deleted
		while {alive _light} do
			{
			// Activate light 
			if (tpw_firefly_canspawn == 1) then
				{
				if (tpw_firefly_blink == 1) then
					{
					// Blink
					_light setlightcolor tpw_firefly_colour;
					_light setlightintensity tpw_firefly_brightness - (random tpw_firefly_brightness / 2); 
					sleep _flash;
					_light setlightintensity 0;
					} else
					{
					// Steady
					_light setlightcolor tpw_firefly_colour;
					_light setlightintensity tpw_firefly_brightness - (random tpw_firefly_brightness / 2); 
					};
				} else
				{
				_light setlightintensity 0;
				}; 
			 
			// Delete if distant
			if (_light distance player > tpw_firefly_radius) then
				{
				deletevehicle _light; 
				deletevehicle _model;
				tpw_firefly_flycount = tpw_firefly_flycount - 1;
				};
			 
			sleep _dark; 
			};
		};
	tpw_firefly_flycount = tpw_firefly_flycount + 1;
	};
 
// CONDITIONS FOR SPAWNING FIREFLIES AND HOUSEFLIES
tpw_firefly_fnc_envscan =
	{		
	private _fireflytemp = 1;
	private _houseflytemp = 1;
	tpw_firefly_maxhouseflies = 5;
	while {true} do
		{
		// Warm enough? (TPW FOG)
		if !(isnil "tpw_fog_temp") then 
			{
			tpw_firefly_maxhouseflies = (floor(tpw_fog_temp/10) *3);
			if (tpw_fog_temp < tpw_firefly_temp) then
				{
				_fireflytemp = 0;
				} else
				{
				_fireflytemp = 1;
				};
				
			if (tpw_fog_temp < 10) then
				{
				_houseflytemp = 0;
				} else
				{
				_houseflytemp = 1;
				};	
				
			} else
			{
			_fireflytemp = 1;
			_houseflytemp = 1;
			};

		// Nearby gunfire? (TPW SOAP)
		if !(isnil "tpw_soap_nextcry") then 
			{
			if (diag_ticktime < tpw_soap_nextcry + 45) then
				{
				tpw_firefly_gunfire = 1;
				} else
				{
				tpw_firefly_gunfire = 0;
				};
			} else
			{
			tpw_firefly_gunfire = 0;
			};
		
		// Conditions
		if (tpw_firefly_active && 
		{player == vehicle player} && // player on foot
		{_fireflytemp == 1} && // warm enough
		{tpw_firefly_gunfire == 0} && // no nearby gunfire
		{daytime > tpw_firefly_dusktime && daytime < tpw_firefly_dusktime + tpw_firefly_window} && // time window after dusk
		{rain < 0.2} && // not raining
		{windstr < 0.4} && // not windy
		{nearestbuilding player  distance player > tpw_firefly_radius} && // no nearby buildings
		{count nearestTerrainObjects [player, ["tree","smalltree","bush"], tpw_firefly_radius, false] > tpw_firefly_trees} // sufficient trees
		) then
			{
			tpw_firefly_canspawn = 1;
			} else
			{
			tpw_firefly_canspawn = 0;
			};
			
		// Conditions for flies around corpses
		if (tpw_firefly_active && 
		{player == vehicle player} && // player on foot
		{_houseflytemp == 1} && // warm enough
		{tpw_firefly_gunfire == 0} && // no nearby gunfire
		{rain < 0.2} && // not raining
		{windstr < 0.4} // not windy
		) then
			{
			tpw_firefly_canspawnhousefly = 1;
			
			} else
			{
			tpw_firefly_canspawnhousefly = 0;
			};	
		sleep 10; 
		};
	}; 
 
// SPAWN FIREFLIES AROUND PLAYER 
tpw_firefly_fnc_spawnflies =
	{
	while {true} do
		{
		if (tpw_firefly_canspawn == 1 && {tpw_firefly_flycount < tpw_firefly_maxflies}) then
			{
			private _spawnpos = [player, tpw_firefly_radius] call cba_fnc_randpos;
			private _swarmsize = tpw_firefly_swarmsize;
			 
			// Don't spawn on road or water
			if (!(isonroad _spawnpos) && !(surfaceiswater _spawnpos)) then
				{
				// Occasional large swarm 
				if (random 1 < tpw_firefly_largeswarm) then
					{
					_swarmsize = tpw_firefly_swarmsize * 5;
					};
				 
				// Spawn swarm 
				for "_i" from 0 to random _swarmsize do
					{
					[_spawnpos] call tpw_firefly_fnc_spawnfly;
					sleep random 1;
					}
				}; 
			}; 
		sleep random tpw_firefly_time;
		}; 
	}; 
	
// SPAWN HOUSE FLIES AROUND DEAD BODIES, RUBBISH, AND PLAYER
tpw_firefly_fnc_deadflies =
	{
	while {true} do
		{
		if (tpw_firefly_canspawnhousefly == 1) then
			{
			// Dead bodies
				{
				private _body = _x;
				private _flies = _body getvariable ["flies",0];
				
				// Set up first dead fly to spawn in ~60 sec
				if (_body getvariable ["nextfly",-1] == -1) then 
					{
					_body setvariable ["nextfly",time + random 180];
					}; 
				private _nextfly = _body getvariable "nextfly";

				// Increment fly counter
				if  ((_flies < tpw_firefly_maxhouseflies) && {time > _nextfly}) then
					{
					_flies = _flies + 1;
					_body setvariable ["flies",_flies];
					_body setvariable ["nextfly",time + random 180]; // 60 seconds til next fly 
					};
					
				// Spawn flies 	
				if (_body distance player < tpw_firefly_houseflyrange) then
					{
					private _spawnedflies = _body getvariable ["spawnedflies",0];
					private _fliestospawn = _flies - _spawnedflies;
					if (_fliestospawn > 0) then
						{
						for "_i" from 1 to _fliestospawn do
							{
							[_body] spawn tpw_firefly_fnc_spawnhousefly;
							sleep 0.5;
							};
						};	
					};	
				} foreach alldead;
			
			// Flies around rubbish	
				{
				if ((["garb", str _x] call BIS_fnc_inString) && {_x distance player < 20}) then
					{
					[_x] spawn tpw_firefly_fnc_spawnhousefly;
					};
				} foreach nearestterrainObjects [player,["hide"],tpw_firefly_houseflyrange,false]; 
			
			// Flies around player's ears			
			[] spawn tpw_firefly_fnc_playerflies;	
						
			// Mosquitos around player's ears			
			[] spawn tpw_firefly_fnc_playermozzies;	
			}; 			
		sleep random tpw_firefly_time;
		}; 
	}; 
 
// RUN IT 
tpw_firefly_dusktime = (([] call BIS_fnc_sunriseSunsetTime) select 1) + 0.5;
tpw_firefly_dawntime = (([] call BIS_fnc_sunriseSunsetTime) select 0) - 0.5;
tpw_firefly_gunfire = 0;
tpw_firefly_flycount = 0;
tpw_firefly_canspawn = 0;
tpw_firefly_canspawnhousefly = 0;
tpw_firefly_totalhouseflies = 0;
0 = [] spawn tpw_firefly_fnc_envscan;
0 = [] spawn tpw_firefly_fnc_spawnflies;
0 = [] spawn tpw_firefly_fnc_deadflies;

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
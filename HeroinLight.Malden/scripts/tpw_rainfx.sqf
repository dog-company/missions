/*
TPW RAINFX - rain droplet fx on the surface, player goggles and vehicle windscreens.
Version: 1.15
Author: tpw
Date: 20170414
Requires: CBA A3, tpw_core.sqf
Compatibility: SP

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_rainfx.sqf
2 - Call it with 0 = [] execvm "tpw_rainfx.sqf"; 

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
WaitUntil {!isNull FindDisplay 46};

//VARIABLES
tpw_rain_version = "1.15";


// SHOULD RAIN FX FUNCTIONS RUN?	
tpw_rain_fnc_check =
	{
	while {true} do
		{
		// Raining	
		if (rain > 0.1) then
			{
			// Drops on surface
			if (player == vehicle player) then 
				{
				[(time + 1)] spawn tpw_rain_fnc_surfacedrops; 
				};

			// Run googel/car fx if not underwater or in external views
			if (!(underwater player) && {cameraview == "internal"}) then 
				{
				// Under cover?
				private _pos = eyepos player vectoradd [0,0,0];
				private _highpos = _pos vectoradd [0,0,50];
				
				// Drops on goggles
				if (!(lineintersects [_pos,_highpos]) && {vehicle player == player} && {goggles player !=""}) then
					{
					0 = [rain] spawn tpw_rain_fnc_goggledrops; 
					};
				
				// Drops on car windshields	
				if (vehicle player != player) then 
					{
					0 = [rain] spawn tpw_rain_fnc_cardrops; 
					};
				};
			};	
		sleep 1.1;	
		};
	};
	
// RAIN DROPS ON PLAYER GOGGLES
tpw_rain_fnc_goggledrops =
	{
	private _rain = _this select 0;
	private _int = 0.02 / _rain; // more drops if heavier rain
	private _gograinemitter = "#particlesource" createVehicleLocal [0,0,0];		
	private _logic = "logic" createVehicleLocal [0,0,0];
	_gograinemitter attachto [_logic,[0,0,0]];
	_logic attachto [player,[0,0,0],"HEAD"];	
	_gograinemitter setParticleCircle [0.0, [0, 0, 0]];
	_gograinemitter setParticleRandom [0, [0.5,0.5,0.5], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
	_gograinemitter setParticleParams 
	[["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1],
	"",
	"Billboard", 1,0.05, [0,0,0], [0,0,0], 1, 1,0,0,[0.1],[[1,1,1,1]],[0], 0, 0, "", "", _logic];
	_gograinemitter setDropInterval _int;    
	sleep 1;
	deletevehicle _gograinemitter;
	deletevehicle _logic;
	};

// RAIN DROPS ON VEHICLE WINDSCREENS
tpw_rain_fnc_cardrops =
	{
	private _end = time + 1;
	while {time < _end && {diag_fps > 25}} do
		{	
		private _speed = 1 + (speed player / 10) ;
		private _pos = getposasl player;		
		private _min = (getdir vehicle player) - 30;
		private _density = (rain * 50);
		private _size = 0.075 * _speed;
		for "_i" from 0 to _density do
			{
			private _dir = _min + random 60;
			private _dist = _speed + random 1;
			private _offset =  [(_dist * sin _dir),(_dist * cos _dir),random 2];
			private _droppos = asltoatl (_pos vectoradd _offset);
			drop [["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1],"","Billboard",1,0.05,_droppos,[0,0,0],1,1,0,0,[_size],[[1,1,1,0.6]],[0],0,0,"","",""]; 
			sleep 0.01;
			};
		sleep 0.1;
		};	
	};

// RAIN DROPS ON EXPOSED SURFACES
tpw_rain_fnc_surfacedrops =
	{
	private _end = time + 1;
	while {time < _end && {diag_fps > 25}} do
		{	
		private _pos = getposasl player;		
		private _min = ([0,0,0] getdir getCameraViewDirection player) - 20;
		private _density = floor (rain * 50);
		private _part = ceil random 5;
		for "_i" from 0 to _density do
			{
			private _dir = _min + random 40;
			private _dist = random 5;
			private _offset =  [(_dist * sin _dir),(_dist * cos _dir),-50];
			private _lowpos = _pos vectoradd _offset;
			private _highpos = _lowpos vectoradd [0,0,100];
			private _int = lineintersectssurfaces [_highpos,_lowpos,objnull,objnull,true,1,"FIRE","GEOM"];	
			private _droppos = asltoatl ((_int select 0) select 0);
			private _lifetime = random 0.3;
			drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,14,_part,0],"","Billboard",0.1,_lifetime,_droppos,[0,0,0],1,1.35,1,0,[0,0.2],[[1,1,1,0.8]],[1000],0,0,"","",""]; 
			drop [["\A3\data_f\ParticleEffects\Universal\Universal",16,12,_part,0],"","Billboard",0.1,_lifetime/2,_droppos,[0,0,0],1,1.3,1,0,[0,0.15],[[1,1,1,0.2]],[1000],0,0,"","",""];
			sleep 0.01;
			};
		sleep 0.1;
		};	
	};
	
// RUN IT
[] spawn tpw_rain_fnc_check;

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
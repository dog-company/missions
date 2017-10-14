/*
TPW FOG - Region specific climate: ground fog, foggy breath, snow in cold weather; heat haze in hot.
Version: 1.56
Authors: tpw, falcon_565,meatball, neoarmageddon
Date: 20170917
Requires: CBA A3, tpw_core.sqf
Compatibility: SP
	
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_fog.sqf
2 - Call it with 0 = [250,10,1,1,1,1,1,1] execvm "tpw_fog.sqf"; where 250 = radius around player to give units foggy breath (m). 10 = delay until functions start (sec), 1 = foggy breath, 1 = ground fog, 1 = rain fog, 1 = heat haze , 1 = snow, 1 = mist fx

The dust storm function can be invoked with [duration] spawn tpw_fog_fnc_duststorm; where duration is in minutes.

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (_this select 0 == 0) exitWith {};
if ((count _this) < 7) exitWith {hint "TPW FOG incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
WaitUntil {!isnil "tpw_core_sunangle"};

// VARIABLES
tpw_fog_version = "1.56"; // version string
tpw_fog_radius = _this select 0; // units must be closer than this to show foggy breath. 
tpw_fog_delay = _this select 1; // delay
tpw_fog_breath = _this select 2; // foggy breath enabled
tpw_fog_groundfog = _this select 3; // ground fog enabled
tpw_fog_rainfog = _this select 4; // rain fog enabled
tpw_fog_heathaze = _this select 5; // heat haze enabled
tpw_fog_cansnow = _this select 6; // snow enabled
tpw_fog_mist = _this select 7; // ground mist fx level

tpw_fog_active = true; // global enable/disable
tpw_fog_debug = false; // debugging 

// Temp values (weatherspark.com) = [high day max temp, low day max temp, high day min temp, low day min temp,high day max dewpoint, low day max dewpoint, high day min dewpoint, low day min dewpoint, coldest month, chance of snow in coldest month];
private _arctic = [20,-10,5,-25,9,-10,2,-18,1,20,"Arctic"]; // eg Malmo
private _centralasia = [34,6,19,-5,11,-6,-1,-12,1,20,"Central Asia"]; // eg Kabul
private _europe = [24,2,13,-4,16,0,11,-5,12,34,"Europe"]; // eg Frankfurt
private _mediterranean = [31,10,22,4,20,6,13,0,2,3,"Mediterranean"]; // eg Limnos
private _mideast = [45,15,30,5,12,4,6,-1,1,1,"Mideast"]; // eg Baghdad
private _nordic = [21,0,12,-3,14,-3,9,-9,2,40,"Nordic"]; // eg Oslo
private _tropical = [33,28,25,22,26,23,23,15,8,0,"Tropical"]; // eg Lagos

// Select map appropriate weather
tpw_fog_weather = _mediterranean; // Default to Altis weather

// Arctic
if (tolower worldname in [
"caribou",
"namalsk"
]) then
	{
	tpw_fog_weather = _arctic;
	};		
	
// Central Asia
if (tolower worldname in [
"mcn_aliabad",
"bmfayshkhabur",
"clafghan",
"fata",
"hellskitchen",
"hellskitchens",
"mcn_hazarkot",
"praa_av",
"reshmaan",
"shapur_baf",
"takistan",
"torabora",
"tup_qom",
"zargabad",
"pja306",
"tunba",
"mountains_acr",
"kunduz",
"pja310",
"pja308",
"lythium"
]) then
	{
	tpw_fog_weather = _centralasia;
	};	

// Europe
if (tolower worldname in [
"bush_island_51",
"carraigdubh",
"chernarus",
"chernarusredux",
"chernarus_summer",
"fdf_isle1_a",
"mbg_celle2",
"woodland_acr",
"bootcamp_acr",
"thirsk",
"thirskw",
"utes",
"gsep_mosch",
"gsep_zernovo",
"bornholm",
"anim_helvantis_v2",
"wgl_palms",
"colleville",
"staszow",
"baranow",
"panovo",
"ivachev",
"xcam_taunus"
]) then
	{
	tpw_fog_weather = _europe;
	};	

// Mid east / desert
if (tolower worldname in [
"tropica",
"pja307",
"wgl_palms",
"fallujah",
"dya",
"kidal",
"isladuala3",
"dingor",
"pja319"

]) then
	{
	tpw_fog_weather = _mideast;
	};	
	
// Nordic
if (tolower worldname in [
"japahto",
"thirsk",
"thirskw",
"lostw",
"lost",
"abramia"
]) then
	{
	tpw_fog_weather = _nordic;
	};	
	
// Tropical
if (tolower worldname in [
"mak_jungle",
"pja305",
"tigeria",
"tigeria_se",
"plr_mana",
"sara",
"saralite",
"sara_dbe1",
"porto",
"intro",
"pja312",
"tanoa",
"bsoc_brasil",
"lingor3",
"prei_khmaoch_luong"
]) then
	{
	tpw_fog_weather = _tropical;
	};	

// Temperature values from relevant array
tpw_fog_hidaymaxtemp = tpw_fog_weather select 0; // Highest daily maximum temperature 
tpw_fog_lowdaymaxtemp = tpw_fog_weather select 1; // Lowest daily maximum temperature
tpw_fog_hidaymintemp = tpw_fog_weather select 2; // Highest daily minimum temperature 
tpw_fog_lowdaymintemp = tpw_fog_weather select 3; // Lowest daily minimum temperature 
tpw_fog_maxtemprange = tpw_fog_hidaymaxtemp - tpw_fog_lowdaymaxtemp;
tpw_fog_mintemprange = tpw_fog_hidaymintemp - tpw_fog_lowdaymintemp;

// Dew point values from relevant array
tpw_fog_hidaymaxdp = tpw_fog_weather select 4; // Highest daily maximum dew point 
tpw_fog_lowdaymaxdp = tpw_fog_weather select 5; // Lowest daily maximum dew point 
tpw_fog_hidaymindp = tpw_fog_weather select 6; // Highest daily minimum dew point 
tpw_fog_lowdaymindp = tpw_fog_weather select 7; // Lowest daily minimum dew point 
tpw_fog_maxdprange = tpw_fog_hidaymaxdp - tpw_fog_lowdaymaxdp;
tpw_fog_mindprange = tpw_fog_hidaymindp - tpw_fog_lowdaymindp; 

// Coldest month
tpw_fog_coldmonth = tpw_fog_weather select 8;

// Chance of snow
tpw_fog_snowchance = tpw_fog_weather select 9;

// DELAY
sleep tpw_fog_delay;


// FOG ATTENUATION FOR MAPS WITH STRONG FOG IN CONFIG
tpw_fog_atten = 1;
if (tolower worldname == "prei_khmaoch_luong") then
	{
	tpw_fog_atten = 0.1;
	}; 
if (tolower worldname == "tanoa") then
	{
	tpw_fog_atten = 0.5;
	}; 	


	
// CALCULATE DAILY TEMPERATURE AND DEW POINT MAXIMA AND MINIMA FOR THIS TIME OF YEAR, USING SINE CURVE
private _daynum = (datetonumber date - (tpw_fog_coldmonth * 0.083) + 0.0833); // Convert day of year to number, with month offset
if (_daynum < 0) then 
	{
	_daynum = 1 + _daynum;
	};
private _dayangle = _daynum * 180; // Feb 01  = 0, Jan 30 = 180 
private _daysin = abs (sin _dayangle); // Feb 01 = 0, Aug 01 = 1, Jan 30 = 0 
private _daycos = abs (cos _dayangle); // Feb 01 = 1, Aug 01 = 0, Jan 30 = 1 

tpw_fog_maxtemp = tpw_fog_lowdaymaxtemp + (tpw_fog_maxtemprange * _daysin); // Highest temp for this day, at 1800
tpw_fog_mintemp = tpw_fog_lowdaymintemp + (tpw_fog_mintemprange * _daysin); // Lowest tempt for this day, at 0600
tpw_fog_maxdp = tpw_fog_lowdaymaxdp + (tpw_fog_maxdprange * _daysin); // Highest dew point for this day, at 1800
tpw_fog_mindp = tpw_fog_lowdaymindp + (tpw_fog_mindprange * _daysin); // Lowest dew point for this day, at 0600

// Randomise slightly
tpw_fog_maxtemp = tpw_fog_maxtemp - 2.5 + (random 5); 
tpw_fog_mintemp = tpw_fog_mintemp - 2.5 + (random 5); 
tpw_fog_maxdp = tpw_fog_maxdp -2.5 + (random 5); 
tpw_fog_mindp = tpw_fog_mindp -2.5 + (random 5); 
tpw_fog_temprange = tpw_fog_maxtemp - tpw_fog_mintemp;
tpw_fog_dprange = tpw_fog_maxdp - tpw_fog_mindp;

// Snow today?
tpw_fog_snowflag = false;
tpw_fog_snow = tpw_fog_snowchance * _daycos; // Chance of snow on this day (greater chance in colder months)
tpw_fog_int = 0.01 * ceil random 5;
if (tpw_fog_cansnow == 1 && {(random 100) < tpw_fog_snow}) then 
	{
	tpw_fog_snowflag = true;
	};

// DETERMINE TEMPERATURE AND DEWPOINT
tpw_fog_fnc_dewpoint =
	{
	while {true} do
		{
		if (tpw_fog_active) then 
			{
			// Temperature and dewpoint, based on sine/cosine curves
			private _timeangle = (daytime - 6) * 7.5; // 6am = 0 deg, 6pm = 180 deg
			private _timesin = abs (sin _timeangle); // 6am = 0, 6pm = 1
			private _timecos = abs (cos _timeangle); // 6am = 1, 6pm = 0
			private _temp = tpw_fog_mintemp + (_timesin * tpw_fog_temprange); // temperature
			tpw_fog_temp = _temp - (_temp * 0.2 * overcast); // lower temperature if overcast (or higher temperature if temperature < 0)
			private _dewpoint = tpw_fog_mindp + (_timecos * tpw_fog_dprange); // dewpoint
			tpw_fog_dewpoint = _dewpoint + (humidity * 3); // A3 humidity, 1 = raining 
			
			// Breath fog?
			tpw_fog_rel50 = tpw_fog_dewpoint + 10; // Dewpoint  + 10degC = temperature of 50% relative humidity. Air at >50% relative humidity must be less than 13degC for foggy breath. www.sciencebits.com/ExhaleCondCalc
			};
		sleep 120;	
		};	
	};
	
// APPLY VARIOUS FX	
tpw_fog_fnc_fx =
	{
	while {true} do
		{
		if (tpw_fog_active) then 
			{
			tpw_fog_flag = false;
			tpw_heat_flag = false;
			
			// Foggy breath?
			if (tpw_fog_breath == 1 && {tpw_fog_temp < tpw_fog_rel50} && {tpw_fog_temp < 10}) then 
				{
				tpw_fog_flag = true;
				};
			
			// Clear fog values
			private _rainfogval = 0;
			private _groundfogval = 0;
			
			// Ground fog (thicker closer to sea level) as temperature falls?
			if (tpw_fog_groundfog == 1 && {tpw_fog_temp < tpw_fog_dewpoint + 2.5} && {tpw_fog_temp < 10}) then
				{
				if (tpw_fog_temp < 0) then
					{
					_groundfogval = 0.5 * tpw_fog_atten;
					} else
					{
					_groundfogval = (10 - tpw_fog_temp) / 20; // Maximum fog thickness = 0.5 at 0degC or less
					};
				};
				
			// Rain fog (independent of height)? Overrides ground fog	
			if (tpw_fog_rainfog == 1) then
				{
				 _rainfogval =  (rain / 2)  * tpw_fog_atten;
				};
			
			// Actually set the fog
			if (tpw_fog_groundfog == 1 && {_groundfogval > _rainfogval}) then
				{
				30 setFog [_groundfogval, 0.01, 0];
				};
			if (tpw_fog_rainfog == 1  && {_groundfogval < _rainfogval}) then
				{
				30 setFog _rainfogval;
				};

			// Heat haze?
			if (
			tpw_fog_heathaze == 1 &&
			{tpw_fog_temp > 25} &&
			{tpw_core_sunangle > 30} &&
			{overcast < 0.8} &&
			{rain < 0.1}
			) then 
				{
				tpw_heat_flag = true;
				};		
			sleep 9.67;							
			};
		};
	};


// BREATH FUNCTION
tpw_fog_fnc_breathe = 
	{
		{
		private _unit = _x;
		
		// Only bother if unit is alive, close to player and foggy conditions are met
		if ((alive _unit) && {tpw_fog_flag} && {_unit distance player < tpw_fog_radius} && {_unit == vehicle _unit}) then 
			{
			private _nexttime = _unit getVariable ["NextBreathTime", -1];
			if(_nexttime == -1) then 
				{
				_unit setVariable ["NextBreathTime", diag_tickTime + (random 3)];
				_unit addEventHandler ["SoundPlayed",{if (tpw_fog_flag && {_this select 1 < 3} && {getfatigue (_this select 0) > 0.25}) then {[_this select 0] spawn tpw_fog_fnc_exhale};}];
				};
			if (diag_tickTime >= _nextTime) then 
				{
				[_unit] spawn tpw_fog_fnc_exhale;
				_unit setVariable ["NextBreathTime", diag_tickTime + (3 / (1.1 - getfatigue _unit)) + random 1 ];
				};				
			};
		} count allunits; 
	};

// EXHALE FOGGY BREATH	
tpw_fog_fnc_exhale =
	{
	private _unit = _this select 0;
	private _source = "logic" createVehicleLocal (getpos _unit);
	if (_unit == player) then 
		{
		_source attachto [_unit,[0,0.1,0.04], "neck"];
		} 
	else 
		{
		_source attachto [_unit,[0,0.05,-0.08], "pilot"];
		};
	private _breathemitter = "#particlesource" createVehicleLocal getpos _source;
	_breathemitter setParticleParams [
	["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 12, 13,0],
	"", 
	"Billboard", 
	0.5, 
	0.5, 
	[0,0,0],
	[0,0.0,-0.3], 
	1,1.275,1,0.2, 
	[0,0.2,0], 
	[[1,1,1,0.02], [1,1,1,0.01], [1,1,1,0]], 
	[1000], 
	1, 
	0.04, 
	"", 
	"", 
	_source
	];
	_breathemitter setParticleRandom [0.5, [0, 0, 0], [0.25, 0.25, 0.25], 0, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
	_breathemitter setDropInterval 0.01; 
	sleep random 0.5;
	deletevehicle _source;
	deletevehicle _breathemitter;
	};	
	
// HEAT HAZE	
tpw_fog_fnc_heathaze =	
	{		
	private _hazearray = [];
	for "_i" from 0 to 9 do
		{
		private _logic = "logic" createvehiclelocal [0,0,0];
		private _haze = "#particlesource" createVehicleLocal [0,0,0];
		_haze setParticleClass "Refract";  
		_haze attachto [_logic,[0,0,0]];
		_hazearray pushback _logic;
		};	
	while {true} do
		{
		if (
		tpw_heat_flag && 
		{player == vehicle player} && 
		{stance player == "PRONE"}
		) then 
			{
			private _dist = 5 + random 5;
			private _dir = ([0,0,0] getdir getCameraViewDirection player) - 45;
			for "_i" from 0 to 9 do
				{
				_dir = _dir + 9;
				private _pos = getposasl player;
				private _posx = (_pos select 0) + (_dist * sin _dir);
				private _posy = (_pos select 1) +  (_dist * cos _dir);
				private _hz = _hazearray select _i;
				_hz setposatl [_posx,_posy,0];
				};	
			}
		else
			{
			for "_i" from 0 to 9 do
				{
				(_hazearray select _i) setposasl [0,0,0]; 
				};
			};
		sleep 2;
		};	
	};	

//SNOW FX	
// Snow fx on goggles
tpw_fog_fnc_goggledrops =
	{
	// More drops if heavier snow and/or moving faster
	private _dens = tpw_fog_snowdensity;
	if (_dens > 25) then {_dens = 25};
	private _spd = abs (ceil speed player);
	private _int = 4 / _dens / (1 + _spd); 
	
	// Emitter
	private _gogemitter = "#particlesource" createVehicleLocal [0,0,0];
	private _logic = "logic" createVehicleLocal [0,0,0];		
	_gogemitter attachto [_logic,[0,0,0]];
	_logic attachto [player,[0,0,0],"HEAD"];	
	_gogemitter setParticleCircle [0.0, [0, 0, 0]];
	_gogemitter setParticleRandom [0, [0.5,0.5,0.5], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
	_gogemitter setParticleParams 
	[["\A3\data_f\ParticleEffects\Universal\Refract",1,0,1],
	"",
	"Billboard", 1,0.05, [0,0,0], [0,0,0], 1, 1, 0, 0,[0.1],[[1,1,1,1]],[0], 0, 0, "", "", _logic];
	_gogemitter setDropInterval _int;    
	sleep 0.5;
	deletevehicle _gogemitter;
	deletevehicle _logic;
	};
	
// Array of precalculated random position offsets
tpw_fog_fnc_snowpos = 
	{
	tpw_fog_snowpos = []; 
	for "_i" from 1 to 1000 do
		{
		private _dir = random 360;
		private _dist = random 20;
		tpw_fog_snowpos pushback [(_dist * sin _dir),(_dist * cos _dir),0];
		};
	};
	
// Array of exposed positions around player	
tpw_fog_fnc_expos =  
	{
	private _temppos = [];
	private _pos = eyepos player;
	for "_i" from 0 to count tpw_fog_snowpos - 1 do
		{
		private _offset = tpw_fog_snowpos select _i;
		private _lowpos = _pos vectoradd _offset;
		private _highpos = _lowpos vectoradd [0,0,30];

		// Emitter cover checks 
		if (!lineintersects [_lowpos,_highpos]) then
			{
			_temppos pushback (_lowpos vectoradd [0,0,(1 + random 3)]);
			};
		};
	tpw_fog_expos = _temppos;		
	};
// Additional snowflakes in 60 degree arc in front of moving player	
tpw_fog_fnc_singlepos = 
	{
	private _playdir = _this select 0;
	private _min = _playdir - 30;	
	private _dir = _min + random 60;
	private _dist = 5 + random 10;
	private _offset =  [(_dist * sin _dir),(_dist * cos _dir),0];
	private _pos = eyepos player;
	private _lowpos = _pos vectoradd _offset;
	private _highpos = _lowpos vectoradd [0,0,30];
	// Emitter cover checks 
	if (!lineintersects [_lowpos,_highpos]) then
		{
		[_lowpos vectoradd [0,0,(random 3)]] spawn tpw_fog_fnc_snowemitter;
		};
	};	

// Fixed emitter for fast vehicles
tpw_fog_fnc_fastsnow =
	{
	private _spd = abs (ceil speed player);
	private _dst = _spd / 5; // snow box further away if faster
	private _snowEmitter = "#particlesource" createVehicleLocal [0,0,0];
	private _logic	=  "logic" createVehicleLocal [0,0,0];
	_snowEmitter attachto [_logic, [0,0,0]];
	_logic attachto [vehicle player, [0,_dst,1]];
	_snowEmitter setParticleCircle [0.0, [0, 0, 0]];
	_snowEmitter setParticleRandom [0, [2,2,2], [0, 0, 0], 0, 0.01, [0, 0, 0, 0.1], 0, 0];
	_snowEmitter setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 1,0], "","Billboard", 10,10, [0,0,0], [0,0,0], 1, 0.0000001, 0, 20,[0.02],[[1,1,1,1]],[1000], 0.2, 0.2, "", "",_logic];
	_snowEmitter setDropInterval 0.2 / _spd; // more snow if faster  	
	sleep 1;
	deletevehicle _snowemitter;
	deletevehicle _logic;
	};	
	
// Snow particle emitter
tpw_fog_fnc_snowemitter =
	{
	private _pos = asltoatl (_this select 0);	
	drop [["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 1,0], "","Billboard", 10,10, _pos, [0,0,0], 0, 0.01,0, 10,[0.05],[[1,1,1,1]],[0,0], 0.2, 0.2, "", "", ""];
	};

// Spawn snow around footbound player
tpw_fog_fnc_snowscan =
	{
	private _time = (_this select 0) + 0.49;
	private _spd = _this select 1;
	private _posct = count tpw_fog_expos;
	while {time < _time} do
		{
		[tpw_fog_expos select floor random _posct] spawn tpw_fog_fnc_snowemitter; // random snowdrop around player
		if (_spd > 6) then
			{
			[getdir player] spawn tpw_fog_fnc_singlepos; // random snowdrops in direction of movement
			sleep 0.01;
			};
		sleep 0.01;
		};			
	};

// Main snow loop	
tpw_fog_fnc_snow =
	{
	while {true} do
		{
		// Conditions for snow
		if (alive player && {(eyepos player) select 2 > 0} &&{overcast > 0.4} && {tpw_fog_temp < 10}  && {diag_fps > 25}) then 
			{
			// Kill wind and rain
			0 setrain 0;
			0 setwindstr 0;
			
			// Player under cover?
			private _cover = false; 
			private _ep = eyepos player;
			private _epc = _ep vectoradd [0,0,30];
			if (lineintersects[_ep,_epc]) then
				{
				_cover = true;
				};
				
			// Snow droplets on goggles
			if (cameraview != "external" && {!_cover} && {player == vehicle player}) then
				{
				[] spawn tpw_fog_fnc_goggledrops;
				};
				
			// Periodically change snow density
			if (time > tpw_fog_snowtime) then
				{
				tpw_fog_snowtime = time + random 300;
				tpw_fog_snowdensity = ceil random 10;
				};
			
			// Complex snow for slow movers
			private _spd = abs (ceil speed player);
			if (_spd < 20) then 
				{
				// Update spawn positions only if player has moved sufficiently
				if (tpw_fog_lastpos distance player > 5) then
					{
					[] call tpw_fog_fnc_expos;
					tpw_fog_lastpos = getposasl player;
					};
				// Place snow drops in exposed areas
				for "_i" from 0 to tpw_fog_snowdensity do
					{	
					[time,_spd] spawn tpw_fog_fnc_snowscan;	
					};
				} else
				{
				// Simple snow emitter box for fast movers
				[] spawn tpw_fog_fnc_fastsnow;
				};
			};
		sleep 0.5;	
		};	
	};	

// DUST STORM / SMOKE FX
tpw_fog_dustactive = 0;	
tpw_fog_fnc_duststorm =  
	{
	["_vd",",_fog","_tpw_fog_rainfog","_tpw_fog_groundfog","_end","_colour","_alpha","_colourprog","_lifetime","_rotvel","_size","_weight","_diameter","_height","_source","_dust"];
	// Only one dust storm at a time
	if (tpw_fog_dustactive == 1) exitwith {hint "Only one active duststorm at a time"};
	tpw_fog_dustactive = 1;
	
	_hq=[side player,"HQ"]; 
	_hq SideChat format ["All units be advised: dust storm inbound, expect reduced visibility"];
	
	// Disable TPW FOG's ground and rain fog for the duration 
	_tpw_fog_rainfog = tpw_fog_rainfog;
	_tpw_fog_groundfog = tpw_fog_groundfog;
	if (tpw_fog_rainfog == 1 || tpw_fog_groundfog == 1) then 
		{
		tpw_fog_rainfog = 0;
		tpw_fog_groundfog = 0;
		sleep 15;
		};
		
	// Reduce visibility
	_fogthickness = _this select 1;
	_vd = viewdistance;
	_fog = fog;
	10 setfog _fogthickness  * tpw_fog_atten;
	sleep 10;
	setviewdistance 800;
	
	_end = diag_ticktime + ((_this select 0) * 60) ;
	
	_colour = [0.6, 0.4, 0.2]; // dust colour
	//_colour = [1, 1, 1]; // fog colour
	_alpha = _this select 2; // lower = more transparent dust
	_colourprog = [_colour + [0], _colour + [_alpha], _colour + [0]]; // colour progression
	_lifetime = 30; // particle lifetime (sec)
	_rotvel = [0,0,0]; // rotation speed
	_size = 100; // particle size
	_weight = 1.275; // < 1 floats, > 1.5 sinks
	_rub = 0.01; // higher = more affected by wind supposedly
	_vol = 1;
	
	// Volume around player to spawn dust particle coulds
	_diameter = 300; // x and y  
	_height = 50; // z
	
	// Generate dust clouds
	while {diag_ticktime < _end && tpw_fog_dustactive == 1} do 
		{
		_dust = "#particlesource" createvehiclelocal getposasl vehicle player;  
		_dust attachto [vehicle player,[0,0,0]];
		_dust setparticleparams [["a3\data_f\particleeffects\universal\universal.p3d", 16, 12, 8, 0], "", "billboard", 1, _lifetime, [0, 0, 0],_rotvel,1, _weight,_vol,_rub, [_size],_colourprog, [1000], 1, 1, "", "", vehicle player];
		_dust setparticlerandom [1, [_diameter, _diameter, _height], [0, 0, 0], 0, 0, [0, 0, 0, 0.1], 0, 0];
		_dust setparticlecircle [0, [0, 0, 0]];
		_dust setdropinterval 0.05; // smaller = more dust
		sleep 30;
		deletevehicle _dust;
		};
	
	_hq SideChat format ["All units be advised: dust storm clearing"];
	
	// Restore visibility 
	10 setfog _fog;
	sleep 10;
	setviewdistance _vd;
	
	// Restore ground and rain fog to previous settings
	tpw_fog_rainfog = _tpw_fog_rainfog;
	tpw_fog_groundfog = _tpw_fog_groundfog;
	tpw_fog_dustactive = 0;
	};	
	
// GROUND MIST FX
tpw_fog_mistactive = 0;	
tpw_fog_fnc_mist =  
	{
	["_end","_colour","_alpha","_colourprog","_lifetime","_rotvel","_size","_weight","_diameter","_height","_source","_mist","_int", "_pos","_posx","_posy","_dist","_dir","_spawnpos","_mistsource"];
	
	// Only one incidence of jungle mist at a time
	if (tpw_fog_mistactive == 1) exitwith {hint "Only one active mist at a time"};
	tpw_fog_mistactive = 1;
	
	_end = diag_ticktime + ((_this select 0) * 60) ;
	_colour = [0.8, 0.8, 1]; // fog colour
	_alpha = _this select 1; // fog transparency;
	_colourprog = [_colour + [0], _colour + [_alpha], _colour + [0]]; // colour progression
	_weight = 1.275; // < 1 floats, > 1.5 sinks
	_vol = 1; //m3
	_rotvel = [0,0,0]; // rotation speed
	_rub = 0.01; // higher = more affected by wind supposedly
	_mistsource = "logic" createVehicleLocal [0,0,0];
	
	// Generate mist with randomised parameters
	while { diag_ticktime < _end && {tpw_fog_mistactive == 1}} do 
		{
		_lifetime = 20 + random 20; // particle lifetime (sec)
		_size = 15 + random 15; // particle size
		_diameter = _size; // x and y  around logic to spawn particles
		_height = 10; // z around logic to spawn particles
		_int = 0.035 * (1 - rain); // interval between particles, smaller = more mist
		_pos = getposasl player;
		_dir = random 360;
		_dist = 75 + random 150;
		_posx = (_pos select 0) + (_dist * sin _dir);
		_posy = (_pos select 1) +  (_dist * cos _dir);
		_spawnpos = [_posx,_posy];	
		_mistsource setpos _spawnpos;		
		_mist = "#particlesource" createvehiclelocal _spawnpos;  
		_mist attachto [_mistsource,[0,0,0]];
		_mist setparticleparams [["a3\data_f\particleeffects\universal\universal.p3d", 16, 12, 8, 0], "", "billboard", 1, _lifetime, [0, 0, 0],[0,0,0],1, _weight,_vol,_rub, [_size],_colourprog, [1000], 1, 0, "", "", _mistsource];
		_mist setparticlerandom [1, [_diameter, _diameter, _height], [0, 0, 0], 0, 0, [0, 0, 0, 0.1], 0, 0];
		_mist setparticlecircle [0, [0, 0, 0]];
		_mist setdropinterval _int; 
		sleep random 1;
		deletevehicle _mist;
		};
	deletevehicle _mistsource;	
	tpw_fog_mistactive = 0;
	};	

tpw_fog_fnc_mistscan = 
	{	
	private ["_dp","_diff","_alpha"];
	while {true} do
		{
		// Mist enabled, player not in fast vehicle
		if (tpw_fog_mist > 0 && {speed player < 50}) then
			{
			// Raise dewpoint if there are lots of trees around, so more likely to get mist in jungle
			_dp = tpw_fog_dewpoint + (count nearestTerrainObjects [player, ["tree","smalltree"], 200, false] / 100);
			
			// Is temperature lower than tree modified dewpoint?
			_diff = tpw_fog_temp + 2.5 - _dp; 
		
			// Mist if temperature is below dewpoint	
			if (_diff < 0 && {tpw_fog_mistactive == 0}) then
				{
				_alpha =  tpw_fog_mist * abs(_diff / 10) * (1 + rain) * (1 + overcast); // thicker mist the more the temperature differs from the dewpoint, if raining, if overcast
				[0.25,_alpha] spawn tpw_fog_fnc_mist;
				};
			};
		sleep 3.33;
		tpw_fog_mistactive == 0;		
		};
	};	

// RUN IT	
sleep tpw_fog_delay;

// Dewpoint
[] spawn tpw_fog_fnc_dewpoint;
sleep 0.1;

// Weather fx
[] spawn tpw_fog_fnc_fx;
sleep 0.1;

// Snow
tpw_fog_snowtime = time + random 300;
tpw_fog_snowdensity = ceil random 10;
tpw_fog_lastpos = getposasl player;
[] call tpw_fog_fnc_snowpos;
if (tpw_fog_snowflag) then
	{
	[] spawn tpw_fog_fnc_snow;
	};
sleep 0.1;

// Heat haze	
[] spawn tpw_fog_fnc_heathaze;
sleep 0.1;

// Breath fog
[tpw_fog_fnc_breathe, 0.2] call cba_fnc_addPerFrameHandler;
sleep 0.1;

// Mist
[] spawn tpw_fog_fnc_mistscan;

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
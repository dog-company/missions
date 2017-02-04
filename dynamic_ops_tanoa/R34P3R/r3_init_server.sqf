/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
if (isServer) then {

	// functions
	call compile preprocessFileLineNumbers "R34P3R\r3_settings.sqf";
	call compile preprocessFileLineNumbers "R34P3R\fnc\r3_functions.sqf";

	if(r3_enableDebugMode) then { diag_log "LOADING SERVER INIT"; };
		
	// get and set Loadout by: aeroson
	//getLoadout = compile preprocessFileLineNumbers 'R34P3R\3rdparty\get_loadout.sqf';
	//setLoadout = compile preprocessFileLineNumbers 'R34P3R\3rdparty\set_loadout.sqf';

	// Check DayTime
	if(isNil "r3_isNight") then {

		if(daytime > r3_nightStart OR (daytime > 0 && daytime < r3_dayStart)) then {
			r3_isNight = true; 
		} else {
			r3_isNight = false;
		};
			
		[] spawn {
			while {true} do {
				sleep 5;
				if(daytime > r3_nightStart OR (daytime > 0 && daytime < r3_dayStart)) then {
					r3_isNight = true; 
				} else {
					r3_isNight = false;
				};
			};
		};
	};

	// Init Vehicle respawn and repair
	if(r3_enableVehicleRespawn) then {
		r3_loadingTxt = "Loading vehicles";
		publicVariable "r3_loadingTxt";
		call compile preprocessFileLineNumbers "R34P3R\veh\r3_fnc_veh_server.sqf";
		call compile preprocessFileLineNumbers "R34P3R\veh\r3_init_veh.sqf";
		[] call r3_load_vehicles;
		sleep 0.5;
	};
	
	// Select Leader if only one Player
	/*
	if( {isPlayer _x} count r3_playableUnits == 1) then {
		{
			if(isPlayer _x) exitWith { (group _x) selectLeader _x; };
		}forEach r3_playableUnits;
	};
	*/

	// Weather Server
	if(r3_enableWeatherScript) then { 
		r3_loadingTxt = "Loading weather functions";
		publicVariable "r3_loadingTxt";
		call compile preprocessFileLineNumbers "R34P3R\weather\r3_weather_server.sqf";
		[] spawn r3_weatherCycle_server;
		sleep 0.5;
	};

	// Ambient Combat
	//call compile preprocessFileLineNumbers "R34P3R\fnc\r3_ambientCombat.sqf";
	
	// AI DOGS
	if(r3_enableAiDogs) then {
		r3_loadingTxt = "Loading dog functions";
		publicVariable "r3_loadingTxt";
		call compile preprocessFileLineNumbers "R34P3R\fnc\r3_fnc_dog.sqf";
		sleep 0.5;
	};

	r3_loadingTxt = "Server is ready !";
	publicVariable "r3_loadingTxt";
	sleep 1;

	// Server Ready
	r3_serverFullLoaded = true;
	publicVariable "r3_serverFullLoaded";

	if(r3_enableDebugMode) then { diag_log "LOADING SERVER INIT (DONE)"; };
	
};

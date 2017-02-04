/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

// Player Variables (can be different on each client !)
//
// r3_showNames
// r3_showTaskIcon
// r3_showStaminaBar
// r3_enableColorCorrection
// r3_enableStaminaScript
// r3_enableAutoHeal
// r3_enableFSNVG

//  GLOBAL SETTINGS
r3_autoSelectLeader = false;               // Player is always Leader in SP and in MP if he plays alone.
r3_enableReviveScript = true;             // enable Revive Global
r3_enableAiDogs = false;                  // enable AI Dogs
r3_enableWeatherScript = false;            // enable weather script
r3_enableVehicleRespawn = false;		  // Enable Vehicle Respawn and Repair functions
r3_enableRespawnSelection = false; 		  // Enable Respawn Screen to select position
r3_enableDebugMode = true;               // enable Debug Mode = FALSE (This will flood your LOG FILE !)

r3_moveJIPtoLeader = true;				  // JIP Player will moved to the leader unit
r3_moveJIPafterSec = 0;				  // Move JIP after time (Sec)
r3_moveJIPdistance = 100;				  // Move JIP only if distance to leader bigger then this value

r3_enableEarPlugsOnVehicles = true;        // player can use Ear plugs on Vehicles
r3_savePlayerLoadoutForRespawn = false;     // player respawning with last known loadout

r3_allowColorCorrection = false;            // Allow color correction (Day and Night) (global)
r3_allowSpecialIcons = false;       		   // Allow special icons and player names (global)
r3_SpecialIconsMaxDistance = 200;     	   // maximum distance the icons will shown
r3_allowStaminaBar = false;				   // Allow ShackTac Stamina Bar (global)
r3_allowStaminaScript = false;              // Allow players to enable stamina script
r3_allowAutoHeal = false;       			   // Allow players to enable AutoHeal
r3_allowFSNVG = false;					   // Allow full Screen NightVision

//
//  TIME SETTINGS
//
r3_nightStart = 19.5;  // 19.5 = 19:30 CET
r3_dayStart = 4.7;     // 04.7 = 04:45 CET

//
//  PLAYER RESPAWN (r3_enableRespawnSelection)
//
r3_tmpRespawnMarker = "";					// Marker far away from mission
r3_respawnNames = [];						// Strings for RespawnDialog
r3_respawnPositions = [];					// Objects where the player can spawn
r3_respawnAddPlayers = false;				// Add living players to the respawn selection
r3_respawnMaxLifes = 20;					// Max respawns
//r3_respawnSP = true;						// Enable Singleplayer respawn ( WORKING ON )
//r3_respawnTimeSP = 30;					// Singleplayer respawntime ( WORKING ON )

//
//  VEHICLE RESPAWN / REPAIR (r3_enableVehicleRespawn = true)
//
r3_vehObjects = [];							// Vehicles they will use the functions
r3_vehAllowRepair = 0;						// Allow Repair: 0 = No Repair, 1 = Only with ToolKit, 2 = Always
r3_vehRespawnTime = 0;						// Time in Sec to Respawn vehicle

//
//  REVIVE SETTINGS (r3_enableReviveScript = true)
//
r3_reviveHealTime = 15;                       // how long player need to revive
r3_reviveStabiTime = 7;                       // how long player need to stabilize
r3_reviveBleedOutTime = 240;                  // Seconds | Make sure Dead bodys will not deleted unitil this time !
r3_reviveEnableVoices = true;                 // enable medic voices
r3_reviveTempRespawnMarker = "tmp_respawn";   // temp marker far away form mission location
r3_reviveEnableBloodParticle = true;          // enable Blood effect
r3_reviveEnableAiRevive = true;               // enable AI Revive (Ai can revive player but also other AI units)

//
// AI DOG SETTINGS
//
// TO SPAWN A DOG USE: [this,true] execVM "R34P3R\ai\r3_dog.sqf";
// the second parameter select the randomize. Use FALSE to 100% spawn a DOG. else it spawn random.
//
r3_dogSpotRange = 300;      // Dog max Spotrange in meters 

//
// WEATHER SETTINGS (r3_enableWeatherScript = true)
//
r3_weatherGlobalSetting = "RANDOM";     // values: RANDOM, MIN, MAX (r3_weatherParam can be used as override from parameters)
r3_weatherChangeTime = 900;          // Seconds | 900 = 15 minutes
r3_weatherOvercast_min = 0.33;       // minimum overcast value, 0 to 1
r3_weatherOvercast_max = 0.74;       // max overcast value, 0 to 1
r3_weatherRain_min = 0.1;            // minimum rain value, 0 to 1
r3_weatherRain_max = 0.6;            // max rain value, 0 to 1
r3_weatherWind_min = 2;              // minimum wind value, 1 is good 
r3_weatherWind_max = 6;              // max wind value, 15 seems to be max
r3_weatherWaves_min = 0.4;           // minimum waves value, 0 to 1
r3_weatherWaves_max = 0.9;           // max waves value 0 to 1

/////////////////////////////////////////////////////
//////////////// SETTINGS DONE //////////////////////
/////////////////////////////////////////////////////

// Global Version
call compile preprocessFileLineNumbers "R34P3R\r3_version.sqf";

// set Mission Path global
r3_missionPath = [ ( str missionConfigFile ), 0, -15 ] call BIS_fnc_trimString;

// setting up playable units
if(isNil "r3_playableUnits") then { 
	if(isMultiplayer) then {
		r3_playableUnits = playableUnits;
		
		if(r3_enableRespawnSelection) then {
			if(r3_respawnAddPlayers) then {
				{
					if!(_x == player) then {
						sleep 0.1;
						if(isPlayer _x) then {
							r3_respawnNames pushBack (format ["Player: %1",(name _x)]);
						} else {
							r3_respawnNames pushBack (format ["Ai: %1",(name _x)]);
						};
						r3_respawnPositions pushBack _x;
					};
				}forEach r3_playableUnits;
			};
		};
	} else {
		r3_playableUnits = units group player;
		
		if(r3_enableRespawnSelection) then {
			{
				if!(_x == player) then {
					sleep 0.1;
					r3_respawnNames pushBack format ["Ai: %1",(name _x)];
					r3_respawnPositions pushBack _x;
				};
			}forEach units group player;
		};
	};
};

if(isNil "r3_playerUnits") then { 
	if(isMultiplayer) then {
		r3_playerUnits = [];
		{ if (isPlayer _x) then { r3_playerUnits pushBack _x; }; } forEach playableUnits;
	} else {
		r3_playerUnits = [];
		r3_playerUnits pushBack player; 
	};
};







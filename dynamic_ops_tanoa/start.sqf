diag_log "DRO: Main DYN script started";

#include "sunday_system\sundayFunctions.sqf"
#include "sunday_system\generate_enemies\generateEnemiesFunctions.sqf"

playersFaction = "";
enemyFaction = "";
civFaction = "";
pFactionIndex = 0;
eFactionIndex = 1;
cFactionIndex = 0;
timeOfDay = 0;
insertType = 0;
randomSupports = 0;
customSupports = [0,0,0];
aiSkill = 0;
numObjectives = 0;
aoOptionSelect = 2;
customPos = [];
readyPlayers = [];
playerGroup = [];
civTrue = false;
startVehicle = [0, ""];

diag_log "DRO: Compile scripts";

fnc_generateAO = compile preprocessFile "sunday_system\generateAO.sqf";
fnc_selectObjective = compile preprocessFile "sunday_system\objSelect.sqf";
fnc_defineFactionClasses = compile preprocessFile "sunday_system\defineFactionClasses.sqf";

blackList = [];

// *****
// AO SETUP
// *****

[] execVM "sunday_system\initAO.sqf";

// Faction dialog
diag_log "DRO: Create menu dialog";
_handle = CreateDialog "sundayDialog";
diag_log format ["DRO: Created dialog: %1", _handle];
[] execVM "sunday_system\dialogs\populateStartupMenu.sqf";

diag_log "DRO: Define player group";
_playerGroup = [];
{
	if (alive _x) then {
		_playerGroup = _playerGroup + [_x];
	};
} forEach playableUnits;
{
	if (alive _x) then {
		_playerGroup = _playerGroup + [_x];
	};
} forEach switchableUnits;
groupLeader = _playerGroup select 0;

{
	removeFromRemainsCollector [_x];
} forEach _playerGroup;

unitDirs = [];
{
	if (!isNull _x) then {
		unitDirs set [_forEachIndex, (getDir _x)];
	};
} forEach _playerGroup;
publicVariable "unitDirs";

waitUntil {(missionNameSpace getVariable "factionsChosen") == 1};

// Get player faction
_playerSideNum = (configFile >> "CfgFactionClasses" >> playersFaction >> "side") call BIS_fnc_GetCfgData;
playersSide = west;
publicVariable "playersSide";
playersSideCfgGroups = "West";
publicVariable "playersSideCfgGroups";

switch (_playerSideNum) do {
	case 0: {
		playersSide = east;
		playersSideCfgGroups = "East";
		_grp = createGroup east;
		{[_x] joinSilent _grp} forEach _playerGroup;
	};
	case 1: {
		playersSide = west;
		playersSideCfgGroups = "West"
	};
	case 2: {
		playersSide = resistance;
		playersSideCfgGroups = "Indep";
		_grp = createGroup resistance;
		{[_x] joinSilent _grp} forEach _playerGroup;
	};
	case 3: {
		playersSide = civilian
	};
};

// Prepare data for player lobby

_playersFactionData = [playersFaction] call fnc_defineFactionClasses;

pInfClasses = _playersFactionData select 0;
pOfficerClasses = _playersFactionData select 1;
pCarClasses = _playersFactionData select 2;
pCarNoTurretClasses = _playersFactionData select 3;
pTankClasses = _playersFactionData select 4;
pArtyClasses = _playersFactionData select 5;
pMortarClasses = _playersFactionData select 6;
pHeliClasses = _playersFactionData select 7;
pPlaneClasses = _playersFactionData select 8;
pShipClasses = _playersFactionData select 9;
pAmmoClasses  = _playersFactionData select 10;
pGenericNames = _playersFactionData select 11;
pLanguage = _playersFactionData select 12;
pUAVClasses = _playersFactionData select 13;
pInfClassesForWeights = _playersFactionData select 14;
pInfClassWeights = _playersFactionData select 15;

// Deal with incorrect factions on some Apex LSVs
if (playersFaction == "BLU_F") then {
	pCarClasses = pCarClasses - ["B_LSV_01_armed_F"];
	pCarClasses = pCarClasses - ["B_LSV_01_unarmed_F"];
	pCarNoTurretClasses = pCarNoTurretClasses - ["B_LSV_01_unarmed_F"];
};
if (playersFaction == "OPF_F") then {
	pCarClasses = pCarClasses - ["O_LSV_02_armed_F"];
	pCarClasses = pCarClasses - ["O_LSV_02_unarmed_F"];
	pCarNoTurretClasses = pCarNoTurretClasses - ["O_LSV_02_unarmed_F"];
};

unitList = [];
publicVariable "unitList";

{
	unitList pushBackUnique [_x, ((configfile >> "CfgVehicles" >> _x >> "displayName") call BIS_fnc_getCfgData)];
} forEach pInfClasses;
publicVariable "unitList";

// Init player unit variables
{
	_thisUnitType = (selectRandom unitList);
	//_x setVariable ["unitChoice", (_thisUnitType select 0)];	
	[[_x, _thisUnitType], 'sunday_system\switchUnitLoadout.sqf'] remoteExec ["execVM", _x, false];
	//[_x, _thisUnitType] execVM 'sunday_system\switchUnitLoadout.sqf';
	
	switch (_x) do {
		case u1: {
			_x setVariable ['unitLoadoutIDC', 1201, true];
			_x setVariable ['unitArsenalIDC', 1301, true];
			_x setVariable ['unitDeleteIDC', 1501, true];
		};
		case u2: {
			_x setVariable ['unitLoadoutIDC', 1203, true];
			_x setVariable ['unitArsenalIDC', 1302, true];
			_x setVariable ['unitDeleteIDC', 1502, true];
		};
		case u3: {
			_x setVariable ['unitLoadoutIDC', 1205, true];
			_x setVariable ['unitArsenalIDC', 1303, true];
			_x setVariable ['unitDeleteIDC', 1503, true];
		};
		case u4: {
			_x setVariable ['unitLoadoutIDC', 1207, true];
			_x setVariable ['unitArsenalIDC', 1304, true];
			_x setVariable ['unitDeleteIDC', 1504, true];
		};
		case u5: {
			_x setVariable ['unitLoadoutIDC', 1209, true];
			_x setVariable ['unitArsenalIDC', 1305, true];
			_x setVariable ['unitDeleteIDC', 1505, true];
		};
		case u6: {
			_x setVariable ['unitLoadoutIDC', 1211, true];
			_x setVariable ['unitArsenalIDC', 1306, true];
			_x setVariable ['unitDeleteIDC', 1506, true];
		};
		case u7: {
			_x setVariable ['unitLoadoutIDC', 1213, true];
			_x setVariable ['unitArsenalIDC', 1307, true];
			_x setVariable ['unitDeleteIDC', 1507, true];
		};
		case u8: {
			_x setVariable ['unitLoadoutIDC', 1215, true];
			_x setVariable ['unitArsenalIDC', 1308, true];
			_x setVariable ['unitDeleteIDC', 1508, true];
		};
	};
	
} forEach _playerGroup;



// Get enemy faction
_enemySideNum = (configFile >> "CfgFactionClasses" >> enemyFaction >> "side") call BIS_fnc_GetCfgData;
enemyFactionName = (configFile >> "CfgFactionClasses" >> enemyFaction >> "displayName") call BIS_fnc_GetCfgData;
enemySide = resistance;
enemySideCfgGroups = "Indep";

switch (_enemySideNum) do {
	case 0: {enemySide = east; enemySideCfgGroups = "East"};
	case 1: {enemySide = west; enemySideCfgGroups = "West"};
	case 2: {enemySide = resistance; enemySideCfgGroups = "Indep"};
	case 3: {enemySide = civilian};
};

markerColorPlayers = "colorBLUFOR";
switch (playersSide) do {
	case west: {		
		markerColorPlayers = "colorBLUFOR";
	};
	case east: {		
		markerColorPlayers = "colorOPFOR";
	};
	case resistance: {		
		markerColorPlayers = "colorIndependent";
	};	
};

markerColorEnemy = "colorOPFOR";
switch (enemySide) do {
	case west: {		
		markerColorEnemy = "colorBLUFOR";
	};
	case east: {		
		markerColorEnemy = "colorOPFOR";
	};
	case resistance: {		
		markerColorEnemy = "colorIndependent";
	};	
};


diag_log "DRO: Call AO script";

// Generate AO and collect data
_aoData = [] call fnc_generateAO;
_center = _aoData select 0;
_AREAMARKER_WIDTH = _aoData select 1;
_randomLoc = _aoData select 2;

waitUntil {count _aoData > 0};

// Reconfigure AO markers
"mkrN" setMarkerColor markerColorEnemy;
"mkrS" setMarkerColor markerColorEnemy;
"mkrE" setMarkerColor markerColorEnemy;
"mkrW" setMarkerColor markerColorEnemy;

_enemyFactionFlagIcon = ((configfile >> "CfgFactionClasses" >> enemyFaction >> "flag") call BIS_fnc_GetCfgData);
_enemyFactionName = ((configfile >> "CfgFactionClasses" >> enemyFaction >> "displayName") call BIS_fnc_GetCfgData);
_enemyFactionFlag = "";
_nonBaseFaction = 0;

if (!isNil "_enemyFactionName") then {
	{ 
		if (((configFile >> "CfgMarkers" >> (configName _x) >> "name") call BIS_fnc_GetCfgData) == _enemyFactionName) then {
			_enemyFactionFlag = (configName _x);			
		};
	} forEach ("true" configClasses (configFile / "CfgMarkers"));
};

if (count _enemyFactionFlag == 0) then {
	if (!isNil "_enemyFactionFlagIcon") then {		
		{ 
			if ([((configFile >> "CfgMarkers" >> (configName _x) >> "icon") call BIS_fnc_GetCfgData), _enemyFactionFlagIcon, false] call BIS_fnc_inString) then {
				_enemyFactionFlag = (configName _x);
				_nonBaseFaction = 1;
			};
		} forEach ("true" configClasses (configFile / "CfgMarkers"));

		switch (enemyFaction) do {
			case "BLU_F": {
				_enemyFactionFlag = "flag_NATO";
			};
			case "BLU_G_F": {
				_enemyFactionFlag = "flag_FIA";
			};
			case "IND_F": {
				_enemyFactionFlag = "flag_AAF";
			};
			case "OPF_F": {
				_enemyFactionFlag = "flag_CSAT";
			};
		};
	};
};
if (count _enemyFactionFlag == 0) then {
	deleteMarker "mkrFlag";
} else {
	"mkrFlag" setMarkerType _enemyFactionFlag;
	if (_nonBaseFaction == 1) then {
		"mkrFlag" setMarkerSize [2, 1.3];
	};
};

if (timeOfDay == 0) then {
	timeOfDay = [1,4] call BIS_fnc_randomInt;
};
publicVariable "timeOfDay";

if (aoOptionSelect == 0) then {
	aoOptionSelect = [1,3] call BIS_fnc_randomInt;
};

_debug = 0;
if (_debug == 1) then {
	hint "DEBUG ON";
	player allowDamage false;
	//u2 allowDamage false;
	
	trgMove = createTrigger ["EmptyDetector", getPos player, true];
	trgMove setTriggerArea [0, 0, 0, false];
	trgMove setTriggerActivation ["BRAVO", "PRESENT", true];
	trgMove setTriggerStatements ["this","
		[[u2, u3, u4], getPos player] call Zen_MoveAsSet;
		",""];
		
	trgReinforce = createTrigger ["EmptyDetector", getPos player, true];
	trgReinforce setTriggerArea [0, 0, 0, false];
	trgReinforce setTriggerActivation ["CHARLIE", "PRESENT", true];
	trgReinforce setTriggerStatements ["this","
		[AO_roadPosArray, 'aoSmallMkr', 0, [1,1]] execVM 'sunday_system\reinforce.sqf';
		",""];
		
	trgKill = createTrigger ["EmptyDetector", getPos player, true];
	trgKill setTriggerArea [0, 0, 0, false];
	trgKill setTriggerActivation ["DELTA", "PRESENT", true];
	trgKill setTriggerStatements ["this","
		{
			if (side _x != side player) then {
				_x setDamage 1;
			};
		} forEach allUnits;
	",""];
	
	trgGetVeh = createTrigger ["EmptyDetector", getPos player, true];
	trgGetVeh setTriggerArea [0, 0, 0, false];
	trgGetVeh setTriggerActivation ["ECHO", "PRESENT", true];
	trgGetVeh setTriggerStatements ["this","
		hint str (objectParent player);
	",""];

};

// *****
// WEATHER & TIME
// *****
_year = date select 0;
_month = [1, 12] call BIS_fnc_randomInt;//date select 1;
_day = [1, 28] call BIS_fnc_randomInt;//date select 2;

setDate [_year, _month, _day, 0, 0];

_dawnDusk = date call BIS_fnc_sunriseSunsetTime;

_dawnNum = _dawnDusk select 0;
_duskNum = _dawnDusk select 1;

switch (timeOfDay) do {
	case 1: {
		// DAWN		
		skipTime _dawnNum;		
	};
	case 2: {
		// DAY		
		_dayTime = [_dawnNum, _duskNum] call BIS_fnc_randomNum;
		skipTime _dayTime;		
		
	};
	case 3: {
		// DUSK		
		skipTime _duskNum;		
	};
	case 4: {
		// NIGHT
		_nightTime1 = [(_duskNum + 1), 24] call BIS_fnc_randomNum;
		_nightTime2 = [0, (_dawnNum - 1)] call BIS_fnc_randomNum;
		_nightTime = selectRandom [_nightTime1, _nightTime2];
		skipTime _nightTime;		
	};
};

[['overcast', (random [0, 0.4, 1]), (random [0, 0.4, 1]), 60*30],['fog', (random 0.2), (random 0.2), 60*30],['wind', (random 10), (random 360)]] spawn Zen_SetWeather;
diag_log format ["DRO: time of day is %1", timeOfDay];

// *****
// BRIEFING
// *****

// Intro Music
_musicArray = ["AmbientTrack01b_F", "Track02_SolarPower", "LeadTrack02_F_EPA", "LeadTrack01_F_EPA", "LeadTrack03_F_EPA", "LeadTrack01_F_EPB", "BackgroundTrack02_F_EPC", "BackgroundTrack04_F_EPC"];
_track = selectRandom _musicArray;
[[_track,0,1],"bis_fnc_playmusic",true] call BIS_fnc_MP;

// Mission Name
_name1Array = ["Dust", "Swamp", "Red", "Green", "Black", "Gold", "Silver", "Lion", "Bear", "Dog", "Tiger", "Eagle", "Fox", "North", "Moon", "Watch", "Under", "Key", "Court", "Palm", "Fire", "Fast", "Light", "Blind", "Spite", "Smoke", "Castle"];
_name2Array = ["bowl", "catcher", "fisher", "claw", "house", "master", "man", "fly", "market", "cap", "wind", "break", "cut", "tree", "woods", "fall", "force", "storm", "blade", "knife", "cut", "cutter", "taker", "torch"];
_missionName = format ["Operation %1%2", selectRandom _name1Array, selectRandom _name2Array];

missionNameSpace setVariable ["mName", _missionName];
publicVariable "mName";
missionNameSpace setVariable ["weatherChanged", 1];
publicVariable "weatherChanged";


_civilians = random 100;
if (_civilians > 60) then {
	civTrue = true;	
};


// *****
// PLAYERS SETUP
// *****

// Setup player identities
_firstNameClass = (configFile >> "CfgWorlds" >> "GenericNames" >> pGenericNames >> "FirstNames");
_firstNames = [];
for "_i" from 0 to count _firstNameClass - 1 do {
	_firstNames pushBack (getText (_firstNameClass select _i));
};
_lastNameClass = (configFile >> "CfgWorlds" >> "GenericNames" >> pGenericNames >> "LastNames");
_lastNames = [];
for "_i" from 0 to count _lastNameClass - 1 do {
	_lastNames pushBack (getText (_lastNameClass select _i));
};

_speakersArray = [];
{
	_thisVoice = (configName _x);	
	_scopeVar = typeName ((configFile >> "CfgVoice" >> _thisVoice >> "scope") call BIS_fnc_GetCfgData);
	switch (_scopeVar) do {
		case "STRING": {
			if ( ((configFile >> "CfgVoice" >> _thisVoice >> "scope") call BIS_fnc_GetCfgData) == "public") then {		
				{
					if (typeName _x == "STRING") then {
						if (pLanguage == _x) then {
							_speakersArray pushBack _thisVoice;
						};
					};
				} forEach ((configFile >> "CfgVoice" >> _thisVoice >> "identityTypes") call BIS_fnc_GetCfgData);
			};	
		};		
		case "SCALAR": {
			if ( ((configFile >> "CfgVoice" >> _thisVoice >> "scope") call BIS_fnc_GetCfgData) == 2) then {		
				{			
					if (typeName _x == "STRING") then {
						if (pLanguage == _x) then {
							_speakersArray pushBack _thisVoice;
						};
					};
				} forEach ((configFile >> "CfgVoice" >> _thisVoice >> "identityTypes") call BIS_fnc_GetCfgData);
			};	
		};		
	};	
} forEach ("true" configClasses (configFile / "CfgVoice"));
diag_log format ["DRO: Available voices: %1", _speakersArray];



missionNameSpace setVariable ["initArsenal", 1];
publicVariable "initArsenal";

// *****
// ENEMIES SETUP
// *****



_enemyFactionData = [enemyFaction] call fnc_defineFactionClasses;

eInfClasses = _enemyFactionData select 0;
eOfficerClasses = _enemyFactionData select 1;
eCarClasses = _enemyFactionData select 2;
eCarNoTurretClasses = _enemyFactionData select 3;
eTankClasses = _enemyFactionData select 4;
eArtyClasses = _enemyFactionData select 5;
eMortarClasses = _enemyFactionData select 6;
eHeliClasses = _enemyFactionData select 7;
ePlaneClasses = _enemyFactionData select 8;
eShipClasses = _enemyFactionData select 9;
eAmmoClasses  = _enemyFactionData select 10;
eGenericNames = _enemyFactionData select 11;
eLanguage = _enemyFactionData select 12;
eUAVClasses = _enemyFactionData select 13;
eInfClassesForWeights = _enemyFactionData select 14;
eInfClassWeights = _enemyFactionData select 15;

// *****
// Change units to correct ethnicity and voices
// *****

{
	_thisUnit = _x;			
	if (count _speakersArray > 0) then {
		_firstName = selectRandom _firstNames;
		_lastName = selectRandom _lastNames;
		_speaker = selectRandom _speakersArray;
		[[_thisUnit, _firstName, _lastName, _speaker], 'sun_setNameMP', true] call BIS_fnc_MP;	
	};			
} forEach _playerGroup;

// *****
// OBJECTIVES SETUP
// *****

_numObjs = 1;

if (numObjectives == 0) then {
	_numObjs = [1,3] call BIS_fnc_randomInt;
} else {
	_numObjs = numObjectives;
};

//buildingList = [];
_prevObj = [];
allObjectives = [];
for "_i" from 1 to (_numObjs) do {
	_thisObj = [_center, _prevObj] call fnc_selectObjective;
	_prevObj = _thisObj;	
};


// Collect civilian classes
civClasses = [];
{
	if (((configFile >> "CfgVehicles" >> (configName _x) >> "faction") call BIS_fnc_GetCfgData) == civFaction) then {		
		if ( ((configFile >> "CfgVehicles" >> (configName _x) >> "scope") call BIS_fnc_GetCfgData) == 2) then {	
			if (configName _x isKindOf 'Man') then {
				if (
					(["_vr_", (configName _x), false] call BIS_fnc_inString) ||
					(["driver", (configName _x), false] call BIS_fnc_inString) ||
					(count ((configFile >> "CfgVehicles" >> (configName _x) >> "weapons") call BIS_fnc_GetCfgData) > 2)
				) then {
				
				} else {
					civClasses pushBack (configName _x);
				};
				
			};
		};
	};
} forEach ("true" configClasses (configFile / "CfgVehicles"));

// Civilian setup
if (civTrue) then {
	[_randomLoc] execVM "sunday_system\generateCivilians.sqf";
};

missionNameSpace setVariable ["objectivesSpawned", 1, true];

if (AO_Type == "PEACEKEEPERS" && (count civClasses == 0)) then {
	AO_Type = "DEFAULT";
};
_enemyScriptHandle = nil;
switch (AO_Type) do {
	case "DEFAULT": {_enemyScriptHandle = [_center, _AREAMARKER_WIDTH, markerColorEnemy] execVM "sunday_system\generateEnemies.sqf"};
	case "NOMAD": {_enemyScriptHandle = [_center] execVM "sunday_system\generate_enemies\generateEnemiesNomad.sqf"};
	case "BARRIER": {_enemyScriptHandle = [_center] execVM "sunday_system\generate_enemies\generateEnemiesBarrier.sqf"};
	case "PEACEKEEPERS": {_enemyScriptHandle = [] execVM "sunday_system\generate_enemies\generateEnemiesCivs.sqf"};
};


// *****
// WAIT FOR LOBBY COMPLETION
// *****

waitUntil {(missionNameSpace getVariable "lobbyComplete") == 1};


_setupPlayersHandle = [_center, _playerGroup] execVM "sunday_system\setupPlayersFaction.sqf";
waitUntil {scriptDone _setupPlayersHandle};
diag_log "DRO: setupPlayersFaction completed";

// Create a few empty enemy vehicles for use in escape
_numEscapeVehicles = [1,3] call BIS_fnc_randomInt;
for "_i" from 1 to _numEscapeVehicles do {
	_vehClass = "";
	if (count eCarNoTurretClasses > 0) then {
		_vehClass = [eCarNoTurretClasses, false] call Zen_ArrayGetRandom;
	} else {
		_vehClass = [eCarClasses, false] call Zen_ArrayGetRandom;
	};
	if (count _vehClass > 0) then {
		_pos = [AO_roadPosArray, true] call Zen_ArrayGetRandom;
		_veh = _vehClass createVehicle _pos;
		
		_roadList = _pos nearRoads 10;
		if (count _roadList > 0) then {
			_thisRoad = _roadList select 0;
			_roadConnectedTo = roadsConnectedTo _thisRoad;
			_direction = 0;
			if (count _roadConnectedTo == 0) then {
				_direction = 0; 
			} else {
				_connectedRoad = _roadConnectedTo select 0;
				_direction = [_thisRoad, _connectedRoad] call BIS_fnc_DirTo;
			};
			
			_veh setDir _direction;
			_newPos = [_pos, 4, (_direction + 90)] call Zen_ExtendPosition;
			_veh setPos _newPos;
		};
	};
};


// Ambient flyover setup
_ambientFlyByChance = random 100;
if (_ambientFlyByChance > 60) then {
	_flyerClasses = (eHeliClasses + ePlaneClasses);
	if (count _flyerClasses > 0) then {
		[_center, _flyerClasses] execVM "sunday_system\ambientFlyBy.sqf";
	};
};

[_center] execVM "sunday_system\generateAnimals.sqf";

// Briefing init
_locType = type _randomLoc;
_locName = (missionNameSpace getVariable "aoLocationName");
_briefLocType = _aoData select 3;

[_locName, _locType, _briefLocType, "locMkr", "campMkr", "resupplyMkr", _missionName] execVM "briefing.sqf";

// *****
// SEQUENCING
// *****

// Remove all NVGs
[] execVM "sunday_system\removeNV.sqf";

// Reinforcement trigger
/*
_trgReinf = createTrigger ["EmptyDetector", _center, true];
_trgReinf setTriggerArea [(_AREAMARKER_WIDTH*2.5), (_AREAMARKER_WIDTH*2.5), 0, false];
_trgReinf setTriggerActivation ["ANY", "PRESENT", false];
_trgReinf setTriggerStatements ["
	({alive _x && side _x == enemySide} count thisList) < (({alive _x && group _x == group groupLeader} count thisList)*4.5)
", "diag_log 'DRO: Reinforcing due to player incursion'; [AO_roadPosArray, 'aoSmallMkr', 0, [1,3]] execVM 'sunday_system\reinforce.sqf';", ""];
*/

_taskList = [];
{	
	_thisTask = [_x, player] call BIS_fnc_taskReal;
	_taskList pushBack _thisTask;
} forEach allObjectives;
diag_log format ["DRO: Final allObjectives = %1", _taskList];

waituntil { 
	sleep 10;
	_completeReturn = true;
	{		
		if (!taskCompleted _x) then {
			_completeReturn = false;
		};
	} forEach _taskList;
	//diag_log format ["DRO: Mission complete check = %1", _completeReturn];
	_completeReturn
};

_numPassengers = count (units (group groupLeader));
_heliTransports = [];
{
	if (((configFile >> "CfgVehicles" >> _x >> "transportSoldier") call BIS_fnc_GetCfgData) >= _numPassengers) then {
		_heliTransports pushBack _x;
	};
} forEach pHeliClasses;

_taskExtract = nil;

if ((count _heliTransports) > 0) then {
	
	// Create Task
	[group groupLeader, ["taskExtract"], ["Extract from the AO. A helicopter transport is available to support. Alternatively leave the AO by any means available.", "Extract", ""], objNull, true, 5, true, "default", false] call BIS_fnc_taskCreate;
	
	[
		_heliTransports		
	] execVM 'sunday_system\heliExtractionSupport.sqf';		
	
} else {	
	// Create extraction marker and task	
	[group groupLeader, ["taskExtract"], ["Leave the AO by any means to extract. Helicopter transport is unavailable.", "Extract", ""], objNull, true, 5, true, "default", false] call BIS_fnc_taskCreate;
};
// Extraction success trigger
trgExtract = createTrigger ["EmptyDetector", _center, true];
trgExtract setTriggerArea [(aoSize/2), (aoSize/2), 0, true];
trgExtract setTriggerActivation ["ANY", "PRESENT", false];
trgExtract setTriggerStatements [
	"		
		({vehicle _x in thisList} count (units group (thisTrigger getVariable 'playerUnit')) == 0) &&
		({alive _x} count (units group (thisTrigger getVariable 'playerUnit')) > 0)
	",
	"
		['taskExtract', 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;		
		if (isMultiplayer) then {
			diag_log 'DRO: Ending MP mission: success';
			'Won' call BIS_fnc_endMissionServer;
		} else {
			diag_log 'DRO: Ending SP mission: success';
			'end1' call BIS_fnc_endMission;
		};
		
	",
	""
];
trgExtract setVariable ['playerUnit', player];

/*
((isNull u1 OR !alive u1) OR (!(u1 in thisList) && !(vehicle u1 in thisList))) &&
		((isNull u2 OR !alive u2) OR (!(u2 in thisList) && !(vehicle u2 in thisList))) &&
		((isNull u3 OR !alive u3) OR (!(u3 in thisList) && !(vehicle u3 in thisList))) &&
		((isNull u4 OR !alive u4) OR (!(u4 in thisList) && !(vehicle u4 in thisList))) 
*/

// Send new enemies to chase players
diag_log 'Reinforcing due to mission completion';
[AO_roadPosArray, groupLeader, 1, [2,4]] execVM 'sunday_system\reinforce.sqf';

// Make existing enemies close in on players
diag_log "DRO: Init staggered attack";
[30] execVM 'sunday_system\staggeredAttack.sqf';

// Music
[["LeadTrack02_F_Mark",0,1],"bis_fnc_playmusic",true] call BIS_fnc_MP;




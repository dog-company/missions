cutText ["", "BLACK FADED"];
diag_log format ["DRO: Player %1 waiting for player init", player];
waitUntil {!isNull player};

diag_log format ["clientOwner = %1", clientOwner];

//disableUserInput true;
playerReady = 0;
//unitDirs = [(getDir u1), (getDir u2), (getDir u3), (getDir u4), (getDir u5), (getDir u6), (getDir u7), (getDir u8)];


enableTeamSwitch false;
player linkItem "ItemMap";

#include "Zen_FrameworkFunctions\Zen_InitHeader.sqf"
#include "misc.sqf"
#include "sunday_system\sundayFunctions.sqf"

["Preload"] spawn BIS_fnc_arsenal;

waitUntil {(missionNameSpace getVariable ["serverReady", 0]) == 1};

diag_log format ["DRO: Player %1 init", player];

waitUntil{(missionNameSpace getVariable ["weatherChanged", 0]) == 0};

while {(missionNameSpace getVariable ["weatherChanged", 0]) == 0} do {
	if (!isServer) then {
		cutText ["Please wait while mission is generated", "BLACK FADED"];
	} else {		
		//cutText ["", "BLACK FADED"];
	};
};


diag_log format ["DRO: Player %1 weatherChanged == 1", player];

addWeaponItemEverywhere = compileFinal " _this select 0 addPrimaryWeaponItem (_this select 1); ";
addHandgunItemEverywhere = compileFinal " _this select 0 addHandgunItem (_this select 1); ";
removeWeaponItemEverywhere = compileFinal "_this select 0 removePrimaryWeaponItem (_this select 1)";

// Disable Radio
enableSentences false;
/*
_subjectInfo = player createDiarySubject ["reconInfo","Scenario Info"];
player createDiaryRecord ["reconInfo", ["Scenario Info", "
<img width='250' height='163' image='images\recon_icon.jpg' />
<br />
<br />
<font size='16'>Thank you for playing Dynamic Recon Ops!</font>
<br />
<br />
This mission is designed to be a simple to use randomised way to quickly play a singleplayer or cooperative scenario. 
While no mods are required to run the scenario any mods that add playable factions will create an entry for use when the setup dialog appears.
<br />
Currently testing has been done with the CUP, RHS and Theseus Services mods.
<br />
<br />
The mission scales in difficulty with additional players by adding new enemy groups. The enemy AI skill can be modified between two difficulty values in the setup dialog.
<br />
<br />
Although the scenario has been extensively playtested, because of its random nature there can always be some edge cases that may impact on your ability to proceed. 
As a failsafe, each task has a link in its description that will cancel it if it proves impossible to complete.
"]];
*/

while {(missionNameSpace getVariable ["objectivesSpawned", 0]) == 0} do {
	if (!isServer) then {
		cutText ["Please wait while mission is generated", "BLACK FADED"];
	} else {		
		cutText ["Please wait while mission is generated", "BLACK FADED"];
	};
};

waitUntil{(missionNameSpace getVariable ["objectivesSpawned", 0]) == 1};

diag_log format ["DRO: Player %1 objectivesSpawned == 1", player];

if ((missionNameSpace getVariable "reviveOptionSelect") == 0) then {
	diag_log format ["DRO: Player %1 calling revive script init", player];
	call compile preprocessFileLineNumbers "R34P3R\r3_briefing.sqf";
	call compile preprocessFileLineNumbers "R34P3R\r3_init_client.sqf";
};
diag_log format ["DRO: Player %1 revive options decided", player];

// Get camera target point
_heightEnd = getTerrainHeightASL (missionNameSpace getVariable ["aoCamPos", []]);
_camEndPos = [(missionNameSpace getVariable "aoCamPos") select 0, (missionNameSpace getVariable ["aoCamPos", []]) select 1, 10];
_iconPos = ASLToAGL _camEndPos;

_aoLocationName = (missionNameSpace getVariable "aoLocationName");
_introNameHandle = CreateDialog "DRO_introDialog";

//([0.1, 0.2] call BIS_fnc_randomNum)

((findDisplay 424242) displayCtrl 3000) ctrlSetFade 1;
((findDisplay 424242) displayCtrl 3000) ctrlSetPosition [([-0.6, 0.6] call BIS_fnc_randomNum), ([-0.2, 0.15] call BIS_fnc_randomNum)];
((findDisplay 424242) displayCtrl 3000) ctrlCommit 0;
((findDisplay 424242) displayCtrl 3000) ctrlSetText (toUpper _aoLocationName);
((findDisplay 424242) displayCtrl 3000) ctrlSetFade 0;
((findDisplay 424242) displayCtrl 3000) ctrlCommit 1;

// Create camera start point
_extendPos = [_camEndPos, 500, (random 360)] call Zen_ExtendPosition;
_heightStart = getTerrainHeightASL _extendPos;
if (_heightStart < _heightEnd) then {
	_heightStart = _heightEnd; 
};
if (_heightStart < 20) then {_heightStart = 0};
_camStartPos = [(_extendPos select 0), (_extendPos select 1), (_heightStart+20)];

// Init camera
cam = "camera" camCreate _camStartPos;
cam cameraEffect ["internal", "BACK"];
cam camSetPos _camStartPos;
cam camSetTarget _camEndPos;
cam camCommit 0;
if (timeOfDay == 4) then {
	camUseNVG true;
};	
cameraEffectEnableHUD false;
cam camPreparePos _camEndPos;
cam camCommitPrepared 50;

diag_log format ["DRO: Player %1 camera initialised", player];

waitUntil{(missionNameSpace getVariable ["factionsChosen", 0]) == 1};	

diag_log format ["DRO: Player %1 arsenal start selected", player];
		
cutText ["", "BLACK IN", 1];
sleep 6;
((findDisplay 424242) displayCtrl 3000) ctrlSetFade 1;
((findDisplay 424242) displayCtrl 3000) ctrlCommit 1;
cutText ["", "BLACK OUT", 1];
sleep 1;


closeDialog 1;

//removeMissionEventHandler ["Draw3D", _id];	
cam cameraEffect ["terminate","back"];
camUseNVG false;
camDestroy cam;	
diag_log format ["DRO: Player %1 cam terminated", player];	

// Open map
_mapOpen = openMap [true, false];
mapAnimAdd [0, 0.05, markerPos "centerMkr"];
mapAnimCommit;
cutText ["", "BLACK IN", 1];
//disableUserInput false;
diag_log format ["DRO: Player %1 map initialised", player];

waitUntil {!visibleMap};
//disableUserInput true;
diag_log format ["DRO: Player %1 map closed", player];

player switchCamera "GROUP";

_handle = CreateDialog "DRO_lobbyDialog";
diag_log format ["DRO: Player %1 created DRO_lobbyDialog: %2", player, _handle];
[] execVM "sunday_system\dialogs\populateLobby.sqf";

_actionID = player addAction ["Open Team Planning", 
	{
		_handle = CreateDialog "DRO_lobbyDialog";
		[] execVM "sunday_system\dialogs\populateLobby.sqf";
	}, nil, 6];
	
diag_log format ["DRO: Player %1 waiting for all arsenals to close", player];

while {
	_handle
} do {
	sleep 1;	
	
	if ((getMarkerColor "campMkr" == "")) then {
		((findDisplay 626262) displayCtrl 6006) ctrlSetText "Insertion position: RANDOM";
	} else {
		((findDisplay 626262) displayCtrl 6006) ctrlSetText format ["Insertion position: %1", (mapGridPosition (getMarkerPos 'campMkr'))];			
	};		
	
	if ((missionNameSpace getVariable "lobbyComplete") == 1) exitWith {
		closeDialog 1;			
	};	
};

waitUntil {((missionNameSpace getVariable "lobbyComplete") == 1)};

// Close dialogs twice in case player has arsenal open
closeDialog 1;	
closeDialog 1;	

player removeAction _actionID;

(format ["DRO: Player %1 lobby closed", player]) remoteExec ["diag_log", 2, false];
//diag_log format ["DRO: Player %1 lobby closed", player];
cutText ["", "BLACK FADED"];
player switchCamera "INTERNAL";
sleep 2;

enableSentences true;
	
cutText ["", "BLACK IN", 3];

// Mission info readout
_startPos = (missionNameSpace getVariable "startPos");
_campName = (missionNameSpace getVariable "publicCampName");

diag_log format ["DRO: Player %1 establishing shot initialised", player];

sleep 3;
[parseText format [ "<t font='EtelkaMonospaceProBold' color='#ffffff' size = '1.7'>%1</t>", toUpper _campName], true, nil, 5, 0.7, 0] spawn BIS_fnc_textTiles;
sleep 6;

_hours = "";
if ((date select 3) < 10) then {
	_hours = format ["0%1", (date select 3)];
} else {
	_hours = str (date select 3);
};

_minutes = "";
if ((date select 4) < 10) then {
	_minutes = format ["0%1", (date select 4)];
} else {
	_minutes = str (date select 4);
};

[parseText format [ "<t font='EtelkaMonospaceProBold' color='#ffffff' size = '1.7'>%1  %2</t>", str(date select 1) + "." + str(date select 2) + "." + str(date select 0), _hours + _minutes + " HOURS"], true, nil, 5, 0.7, 0] spawn BIS_fnc_textTiles;
sleep 6;

// Operation title text
_missionName = missionNameSpace getVariable "mName";
_string = format ["<t font='EtelkaMonospaceProBold' color='#ffffff' size = '1.7'>%1</t>", _missionName];
[parseText format [ "<t font='EtelkaMonospaceProBold' color='#ffffff' size = '1.7'>%1</t>", toUpper _missionName], true, nil, 7, 0.7, 0] spawn BIS_fnc_textTiles;



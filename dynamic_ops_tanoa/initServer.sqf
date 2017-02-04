if (!isServer) exitWith {};

if (isMultiplayer) then {
	enableSaving [false, false];
};

call compile preprocessFileLineNumbers "R34P3R\r3_init_server.sqf";

cutText ["", "BLACK FADED"];

missionNameSpace setVariable ["weatherChanged", 0];
publicVariable "weatherChanged";
missionNameSpace setVariable ["factionsChosen", 0];
publicVariable "factionsChosen";
missionNameSpace setVariable ["arsenalComplete", 0];
publicVariable "arsenalComplete";
missionNameSpace setVariable ["aoCamPos", []];
publicVariable "aoCamPos";
missionNameSpace setVariable ["briefingReady", 0];
publicVariable "briefingReady";
missionNameSpace setVariable ["playersReady", 0];
publicVariable "playersReady";
missionNameSpace setVariable ["publicCampName", ""];
publicVariable "publicCampName";
missionNameSpace setVariable ["startPos", []];
publicVariable "startPos";
missionNameSpace setVariable ["initArsenal", 0];
publicVariable "initArsenal";
missionNameSpace setVariable ["allArsenalComplete", 0];
publicVariable "allArsenalComplete";
missionNameSpace setVariable ["aoComplete", 0];
publicVariable "aoComplete";
missionNameSpace setVariable ["objectivesSpawned", 0];
publicVariable "objectivesSpawned";
missionNameSpace setVariable ["aoLocationName", ""];
publicVariable "aoLocationName";
missionNameSpace setVariable ["aoLocation", ""];
publicVariable "aoLocation";
missionNameSpace setVariable ["reviveOptionSelect", 0];
publicVariable "reviveOptionSelect";
missionNameSpace setVariable ["lobbyComplete", 0];
publicVariable "lobbyComplete";

[] execVM "start.sqf";

sleep 1;

missionNameSpace setVariable ["serverReady", 1];
publicVariable "serverReady";
/*
waitUntil{count playersFaction > 0};
if ((missionNameSpace getVariable "reviveOptionSelect") == 0) then {
	call compile preprocessFileLineNumbers "R34P3R\r3_init_server.sqf";
};



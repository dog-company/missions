_heliTransports = _this select 0;
_markerColorPlayers = _this select 1;
	

//[[[playersSide, "HQ"], "Heli extraction is en route, ETA 3 minutes."], "sideChat", true] call BIS_fnc_MP;

//["Speaker Name", "Subtitles to display."] call BIS_fnc_showSubtitle;
[[], "sun_playRadioRandom", true] call BIS_fnc_MP;
[
	["Radio HQ", "Heli extraction is en route, ETA 3 minutes.", 0], 
	["Radio HQ", "The pilot will make contact once they are in range.", 6]
] remoteExec ["BIS_fnc_EXP_camp_playSubtitles", 0, false];


// Create extraction vehicle
_heliSpawnPos = [(getPos player), 3000, 4000, 0, 1, 1, 0] call BIS_fnc_findSafePos;

_heliClass = selectRandom _heliTransports;
_extractHeli = createVehicle [_heliClass, _heliSpawnPos, [], 0, "FLY"];
createVehicleCrew _extractHeli;
_extractHeli setCaptive true;

[_extractHeli, (getPos player), "normal", 70] spawn Zen_OrderVehicleMove;

waitUntil {(_extractHeli distance (getPos player) < 500)};



[_extractHeli, (getPos player), 200, [0, 360], "limited"] spawn Zen_OrderAircraftPatrol;

[[], "sun_playRadioRandom", true] call BIS_fnc_MP;
[
	["Pilot", "Recon team, this is your extract pilot.", 0], 
	["Pilot", "Team lead, signal radio alpha with 0-0-1 when you're in position and I'll make my landing.", 5]
] remoteExec ["BIS_fnc_EXP_camp_playSubtitles", 0, false];

//["Pilot", "Call radio channel alpha when you are in position to mark the LZ."] remoteExec ["BIS_fnc_showSubtitle", 0, false];
//[[[playersSide, "HQ"], "Call radio channel alpha when you are in position to mark the LZ."], "sideChat", true] call BIS_fnc_MP;

// LZ trigger
trgLZ = createTrigger ["EmptyDetector", getPos player, true];
trgLZ setTriggerArea [0, 0, 0, false];
trgLZ setTriggerActivation ["ALPHA", "PRESENT", false];
trgLZ setTriggerStatements [
	"
		this
	",
	"
		[thisTrigger] execVM 'sunday_system\heliExtractionCall.sqf';	
	",
	""];
trgLZ setVariable ["heli", _extractHeli];
trgLZ setVariable ["heliSpawnPos", _heliSpawnPos];



//sleep 120;

// Heli circle player position and wait for LZ to be marked

//_wp = group _extractHeli addWaypoint [_center, 0];



/*
for "_i" from 0 to 4 do {
	_dir = _dir + 90;
	_newPos = [(getPos player), 100, _dir] call Zen_ExtendPosition;	
	_wp = group _extractHeli addWaypoint [_newPos, 0];
	_wp setWaypointType "MOVE";
	
	_markerName = format ["extract%1", _i];
	_markerExtract = createMarker [_markerName, (waypointPosition _wp)];
	_markerExtract setMarkerShape "ICON";
	_markerExtract setMarkerColor _markerColorPlayers;
	_markerExtract setMarkerType "mil_dot";
	
	if (_i == 0) then {		
		_wp setWaypointStatements ["true", "(this) limitSpeed 50"];
	};

	if (_i == 4) then {
		_wp setWaypointType "CYCLE";		
	};
};
*/



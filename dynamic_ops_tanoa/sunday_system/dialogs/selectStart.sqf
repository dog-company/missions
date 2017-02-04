closeDialog 1;

_mapOpen = openMap [true, false];
mapAnimAdd [0, 0.05, markerPos "centerMkr"];
mapAnimCommit;
player switchCamera "INTERNAL";
[
	"mapStartSelect",
	"onMapSingleClick",
	{
		if (_pos inArea "aoCoverMkr") then {
			hint "Start position is inside AO. Ground starts will be moved outside the area automatically."
		};
		deleteMarker "campMkr";
		customPos = _pos;
		markerPlayerStart = createMarker ["campMkr", _pos];
		markerPlayerStart setMarkerShape "ICON";
		markerPlayerStart setMarkerColor markerColorPlayers;
		markerPlayerStart setMarkerType "mil_end";
		markerPlayerStart setMarkerSize [1, 1];
		markerPlayerStart setMarkerText "Insert Position";
	},
	[]
] call BIS_fnc_addStackedEventHandler;

waitUntil {!visibleMap};
["mapStartSelect", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
player switchCamera "GROUP";
_handle = CreateDialog "DRO_lobbyDialog";
[] execVM "sunday_system\dialogs\populateLobby.sqf";
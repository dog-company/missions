closeDialog 1;
cutText ["", "BLACK IN", 1];
_mapOpen = openMap [true, false];
[
	"mapStartSelect",
	"onMapSingleClick",
	{
		deleteMarker "aoSelectMkr";
		_nearestMarker = [locMarkerArray, _pos] call BIS_fnc_nearestPosition;		
		markerPlayerStart = createMarker ["aoSelectMkr", getMarkerPos _nearestMarker];
		markerPlayerStart setMarkerShape "ICON";			
		markerPlayerStart setMarkerType "mil_dot";		
		markerPlayerStart setMarkerAlpha 0;		
		_loc = nearestLocation [getMarkerPos _nearestMarker, ""];
		aoName = text _loc;				
		selectedLocMarker setMarkerColor "ColorPink";		
		selectedLocMarker = _nearestMarker;				
		_nearestMarker setMarkerColor "ColorGreen";	
	},
	[]
] call BIS_fnc_addStackedEventHandler;

waitUntil {!visibleMap};
["mapStartSelect", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

_handle = CreateDialog "sundayDialog";
[] execVM "sunday_system\dialogs\populateStartupMenu.sqf";
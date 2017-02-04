// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ObjectiveSpawnMarker", _this] call Zen_StackAdd;
private ["_objPos", "_side", "_markerColor", "_marker"];

if !([_this, [["VOID"], ["SIDE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_objPos = _this select 0;
_side = _this select 1;

switch (_side) do {
    case west: {_markerColor = "ColorBlufor";};
    case east: {_markerColor = "ColorOpfor";};
    case resistance: {_markerColor = "ColorIndependent";};
    default {_markerColor = "ColorCivilian";};
};

_marker = [_objPos, "", _markerColor, [0.6,0.6], "mil_dot", 0, 0] call Zen_SpawnMarker;

call Zen_StackRemove;
(_marker)

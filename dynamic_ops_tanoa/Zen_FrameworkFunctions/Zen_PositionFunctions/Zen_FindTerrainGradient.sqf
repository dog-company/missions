// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_FindTerrainGradient", _this] call Zen_StackAdd;
private ["_center", "_normal", "_theta", "_radius", "_points"];

if !([_this, [["VOID"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
ZEN_STD_Parse_GetArgumentDefault(_radius, 1, -1)

if (_radius > 0) then {
    _points = ((round (_radius^2 / 4)) max 20) min 500;
    _theta = 0;
    for "_i" from 1 to _points do {
        _normal = surfaceNormal (ZEN_FMW_Math_RandomPoint(_center, _radius));
        _theta = _theta + ((_normal select 1) atan2 (_normal select 0));
    };
    _theta = _theta / _points;
} else {
    _normal = surfaceNormal _center;
    _theta = (_normal select 1) atan2 (_normal select 0);
};

call Zen_StackRemove;
(_theta + 180)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_FindTerrainSlope", _this] call Zen_StackAdd;
private ["_center", "_normal", "_phi", "_radius", "_points"];

if !([_this, [["VOID"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
ZEN_STD_Parse_GetArgumentDefault(_radius, 1, -1)

if (_radius > 0) then {
    _points = ((round (_radius^2 / 4)) max 20) min 500;
    _phi = 0;
    for "_i" from 1 to _points do {
        _normal = surfaceNormal (ZEN_FMW_Math_RandomPoint(_center, _radius));
        _phi = _phi + acos (_normal select 2);
    };
    _phi = _phi / _points;
} else {
    _normal = surfaceNormal _center;
    _phi = acos (_normal select 2);
};

call Zen_StackRemove;
(_phi)

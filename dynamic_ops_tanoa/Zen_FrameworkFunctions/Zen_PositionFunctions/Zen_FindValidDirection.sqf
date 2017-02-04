// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_FindValidDirection", _this] call Zen_StackAdd;
private ["_center", "_avoidPoints", "_avoidDist", "_avoidRanges", "_dirToAvoid", "_distToAvoid", "_distAvoidRatio", "_tangentAngle", "_goodAngles", "_isGood"];

if !([_this, [["VOID"], ["VOID"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_avoidPoints = _this select 1;
_avoidDist = _this select 2;

ZEN_STD_Parse_ToArray(_avoidPoints)
if ((typeName (_avoidPoints select 0)) == "SCALAR") then {
    _avoidPoints = [_avoidPoints]
};

_avoidRanges = [];

{
    _dirToAvoid = [_center, _x] call Zen_FindDirection;
    _distToAvoid = [_center, _x] call Zen_Find2dDistance;
    _distAvoidRatio = _avoidDist / _distToAvoid;

    if (_distAvoidRatio > 1) exitWith {
        _avoidRanges = [[0, 360]];
    };

    _tangentAngle = 2 * (asin (_distAvoidRatio / 2));
    _avoidRanges pushBack [_dirToAvoid - _tangentAngle, _dirToAvoid + _tangentAngle];
} forEach _avoidPoints;

_goodAngles = [];
for "_i" from 0 to 359 do {
    _isGood = true;
    {
        if ([_i, _x] call Zen_IsAngleInSector) exitWith {
            _isGood = false;
        };
    } forEach _avoidRanges;

    if (_isGood) then {
        _goodAngles pushBack _i;
    };
};

call Zen_StackRemove;
(_goodAngles)

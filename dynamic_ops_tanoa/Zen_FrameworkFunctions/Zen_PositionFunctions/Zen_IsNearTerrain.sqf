// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsNearTerrain", _this] call Zen_StackAdd;
private ["_center", "_radius", "_terrainType", "_repeatCount", "_nearLand", "_nearWater", "_distance", "_phi"];

if !([_this, [["VOID"], ["SCALAR"], ["STRING"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_radius = _this select 1;
_terrainType = _this select 2;

_repeatCount = ((2 * _radius) min 500) max 100;

switch (toLower _terrainType) do {
    case "both": {
        _nearLand = false;
        _nearWater = false;
    };
    case "water": {
        _nearLand = true;
        _nearWater = false;
    };
    case "land": {
        _nearLand = false;
        _nearWater = true;
    };
    default {
        0 = ["Zen_IsNearTerrain", "Invalid terrain type given", _this] call Zen_PrintError;
        _nearLand = true;
        _nearWater = true;
    }
};

for "_i" from 1 to _repeatCount do {
    _distance = random _radius;
    _phi = random 360;
    if (!(_nearLand) && {!(surfaceIsWater ([(_center select 0) + (cos _phi) * _distance, (_center select 1) + (sin _phi) * _distance, 0]))}) then {
        _nearLand = true;
    };

    if (!(_nearWater) && {(surfaceIsWater ([(_center select 0) + (cos _phi) * _distance, (_center select 1) + (sin _phi) * _distance, 0]))}) then {
        _nearWater = true;
    };

    if (_nearLand && _nearWater) exitWith {};
};

call Zen_StackRemove;
(_nearLand && _nearWater)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#define BIN_LIMITS 5

_Zen_stack_Trace = ["Zen_FindRoadDirection", _this] call Zen_StackAdd;
private ["_center", "_nearRoads", "_initialRoadPos", "_angle", "_angleArray", "_foundBin"];

if !([_this, [["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;

_nearRoads = _center nearRoads 50;

if (count _nearRoads < 2) exitWith {
    if (Zen_Debug_Arguments) then {
        0 = ["Zen_FindRoadDirection", "Given point does have not a road within 50 meters.", _this] call Zen_PrintError;
        call Zen_StackPrint;
        call Zen_StackRemove;
    };
    (0)
};

// _nearRoads = [_nearRoads, ZEN_FMW_ZAS_DistNearFar(_center)] call Zen_ArraySort;
_nearRoads = [_nearRoads, (compile format ["_this distance %1", _center]), "hash"] call Zen_ArraySort;

if (count _nearRoads < 6) then {
    _nearRoads = ([_nearRoads, 0] call Zen_ArrayGetIndexedSlice);
} else {
    _nearRoads = ([_nearRoads, 0, 5] call Zen_ArrayGetIndexedSlice);
};

_angleArray = [];

{
    _start = _x;
    {
        if (_start distance _x > 3) then {
            0 = [_angleArray, ([_start, _x] call Zen_FindDirection)] call Zen_ArrayAppend;
        };
    } forEach _nearRoads;
} forEach [(_nearRoads select 0), (_nearRoads select (count _nearRoads - 1))];

_rangeBins = [];

{
    if (count _rangeBins == 0) then {
        0 = [_rangeBins, [[_x - BIN_LIMITS, _x + BIN_LIMITS], 1]] call Zen_ArrayAppend;
    } else {
        _angle = _x;
        _foundBin = false;

        {
            if ([_angle, (_x select 0)] call Zen_IsAngleInSector) exitWith {
                _foundBin = true;
                _x set [1, (_x select 1) + 1];
            };
        } forEach _rangeBins;

        if !(_foundBin) then {
            0 = [_rangeBins, [[_x - BIN_LIMITS, _x + BIN_LIMITS], 1]] call Zen_ArrayAppend;
        };
    };
} forEach _angleArray;

// _rangeBins = [_rangeBins, ZEN_FMW_ZAS_IntInArray(1)] call Zen_ArraySort;
_rangeBins = [_rangeBins, {(_this select 1)}, "hash"] call Zen_ArraySort;
reverse _rangeBins;

_angle = [(_rangeBins select 0) select 0] call Zen_ArrayFindAverage;

call Zen_StackRemove;
(_angle)

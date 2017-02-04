// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_AreNotIndoors", _this] call Zen_StackAdd;
private ["_units", "_useComplex", "_isIn", "_notIndoors", "_F_CheckPos3D"];

if !([_this, [["VOID"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

#define COUNT_RAYCAST_SPIN(XY, Z1, Z2, A, V) \
    V = 0; \
    for "_k" from 0 to (360 - A) step A do { \
        if (lineIntersects [ZEN_STD_Math_VectTransform(_3dPos, 0, 0, Z1), ZEN_STD_Math_VectTransform(_3dPos, XY * cos _k, XY * sin _k, Z2), objNull, objNull]) then { \
            V = V + 1; \
        }; \
    };

_F_CheckPos3D = {
    private ["_downWall", "_sideWall", "_3dPos", "_bool", "_k"];
    _3dPos = (getPosASL (_this select 0)) vectorAdd [0, 0, 0.1];
    _bool = false;

    if (!(lineIntersects [_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, -2), objNull, objNull]) && {!(lineIntersects [_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 50), objNull, objNull])}) exitWith {(_bool)};

    COUNT_RAYCAST_SPIN(3, 0.7, -5, 30, _downWall)
    if (_downWall > 8) then {
        if (lineIntersects [ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 0.7), ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 50), objNull, objNull]) then {
            COUNT_RAYCAST_SPIN(25, 0.7, 0.7, 30, _sideWall)
            if (_sideWall > 8) then {
                _bool = true;
            };
        };
    };
    (_bool)
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
ZEN_STD_Parse_GetArgumentDefault(_useComplex, 1, false)

_notIndoors = true;

{
    _isIn = (if (_useComplex) then {
        ([_x] call _F_CheckPos3D)
    } else {
        ((count (lineIntersectsWith [eyePos _x, (eyePos _x) vectorAdd [0, 0, 50], _x])) > 0)
    });

    if (_isIn) exitWith {
        _notIndoors = false;
    };
} forEach _units;

call Zen_StackRemove;
(_notIndoors)

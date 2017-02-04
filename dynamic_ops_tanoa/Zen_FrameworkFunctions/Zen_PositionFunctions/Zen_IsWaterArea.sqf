// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_IsWaterArea", _this] call Zen_StackAdd;
private ["_blacklist", "_center", "_XYSizeArray", "_polyDir", "_markerShape", "_waterCount", "_notWaterCount", "_repeat", "_quantumAngles", "_pos", "_isBlacklisted", "_adjustment", "_xCoord"];

if !([_this, [["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], ["STRING", "SCALAR"], [], [], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_blacklist = [];

if ((typeName (_this select 0)) == "STRING") then {
    _center = getMarkerPos (_this select 0);
    _XYSizeArray = getMarkerSize (_this select 0);
    _polyDir = markerDir (_this select 0);
    _markerShape = markerShape (_this select 0);
    if (count _this > 1) then {
        _blacklist = _this select 1;
    };
} else {
    _center = [(_this select 0)] call Zen_ConvertToPosition;
    _XYSizeArray = _this select 1;
    _polyDir = _this select 2;
    _markerShape = _this select 3;
    if (count _this > 4) then {
        _blacklist = _this select 4;
    };
};

_waterCount = 0;
_notWaterCount = 0;

_repeat = ((_XYSizeArray select 0) * (_XYSizeArray select 1) * 2) min 500;
for "_i" from 1 to _repeat do {
    _pos = _center;

    if (toUpper _markerShape == "RECTANGLE") then {
        _adjustment = [ZEN_STD_Math_RandNegativePositive() * random (_XYSizeArray select 0), ZEN_STD_Math_RandNegativePositive() * random (_XYSizeArray select 1), 0];
        _adjustment = ZEN_STD_Math_VectRotateZ(_adjustment, _polyDir);
        _pos = _center vectorAdd _adjustment;
    } else {
        _xCoord = ZEN_STD_Math_RandNegativePositive() * random (_XYSizeArray select 0);
        _adjustment = [_xCoord, ZEN_STD_Math_RandNegativePositive() * (_XYSizeArray select 1) * random ((1 - (_xCoord^2 / (_XYSizeArray select 0)^2))^0.5), 0];
        _adjustment = ZEN_STD_Math_VectRotateZ(_adjustment, _polyDir);

        _pos = _center vectorAdd _adjustment;
    };

    _isBlacklisted = false;
    {
        _isBlacklisted = ([_pos, _x]) call Zen_IsPointInPoly;
        if (_isBlacklisted) exitWith {};
    } forEach _blacklist;

    if !(_isBlacklisted) then {
        if (surfaceIsWater _pos) then {
            _waterCount = _waterCount + 1;
        } else {
            _notWaterCount = _notWaterCount + 1;
        };
    };
};

call Zen_StackRemove;
if ((_waterCount + _notWaterCount) == 0) exitWith {0};
(_waterCount / (_waterCount + _notWaterCount))

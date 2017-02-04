// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindNearHeight", _this] call Zen_StackAdd;
private ["_center", "_maxRange", "_highLow", "_highHeight", "_repeatCount", "_distance", "_phi", "_point", "_height", "_highPos"];

if !([_this, [["VOID"], ["SCALAR"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_maxRange = _this select 1;

_highLow = "high";
if (count _this > 2) then {
    _highLow = toLower (_this select 2);
};

if (_highLow == "high") then {
    _highHeight = -500;
} else {
    _highHeight = 500;
};

_repeatCount = ((2 * _maxRange) min 500) max 100;

for "_i" from 1 to _repeatCount do {
    _distance = random _maxRange;
    _phi = random 360;
    _point = ([(_center select 0) + (cos _phi) * _distance, (_center select 1) + (sin _phi) * _distance, 0]);
    _height = getTerrainHeightASL _point;

    if (_highLow == "high") then {
        if (_height > _highHeight) then {
            _highPos = _point;
            _highHeight = _height;
        };
    } else {
        if (_height < _highHeight) then {
            _highPos = _point;
            _highHeight = _height;
        };
    };
};

call Zen_StackRemove;
(_highPos)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindAveragePosition", _this] call Zen_StackAdd;
private ["_pos","_xSum","_ySum","_posCount"];

if !([_this, [["VOID"], ["VOID"], ["VOID"], ["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

_xSum = 0;
_ySum = 0;

{
    _pos = [_x] call Zen_ConvertToPosition;
    _xSum = _xSum + (_pos select 0);
    _ySum = _ySum + (_pos select 1);
} forEach _this;

_posCount = count _this;

call Zen_StackRemove;
([(_xSum / _posCount), (_ySum / _posCount), 0])

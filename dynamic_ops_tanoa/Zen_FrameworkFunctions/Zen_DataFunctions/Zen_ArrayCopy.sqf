// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayCopy", _this] call Zen_StackAdd;
private ["_array", "_newData"];

if !([_this, [["ARRAY"], ["ARRAY"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_newData = _this select 1;

{
    _array set [_forEachIndex, _x];
} forEach _newData;

_array resize (count _newData);

call Zen_StackRemove;
if (true) exitWith {};

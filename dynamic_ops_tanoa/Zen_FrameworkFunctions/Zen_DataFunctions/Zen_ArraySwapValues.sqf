// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArraySwapValues", _this] call Zen_StackAdd;
private ["_array", "_index1", "_index2", "_temp"];

if !([_this, [["ARRAY"], ["SCALAR"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_index1 = _this select 1;
_index2 = _this select 2;

_temp = _array select _index1;
_array set [_index1, (_array select _index2)];
_array set [_index2, _temp];

call Zen_StackRemove;
if (true) exitWith {};

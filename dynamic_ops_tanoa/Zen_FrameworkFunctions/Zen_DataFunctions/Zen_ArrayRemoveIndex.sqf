// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveIndex", _this] call Zen_StackAdd;
private ["_array", "_index", "_i"];

if !([_this, [["ARRAY"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_index = _this select 1;

for "_i" from _index to ((count _array) - 2) do {
    _array set [_i, (_array select (_i + 1))];
};

_array resize ((count _array - 1) max 0);
call Zen_StackRemove;
if (true) exitWith {};

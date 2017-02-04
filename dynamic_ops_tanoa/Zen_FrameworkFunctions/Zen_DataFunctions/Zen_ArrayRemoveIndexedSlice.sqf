// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveIndexedSlice", _this] call Zen_StackAdd;
private ["_array", "_indexL", "_indexR", "_i", "_tempArray"];

if !([_this, [["ARRAY"], ["SCALAR"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_indexL = _this select 1;
_indexR = _this select 2;

_tempArray = [];

for "_i" from 0 to (_indexL - 1) do {
    _tempArray set [_i, (_array select _i)];
};

for "_i" from (_indexR + 1) to (count _array - 1) do {
    _tempArray pushBack (_array select _i);
};

call Zen_StackRemove;
(_tempArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayInsertSlice", _this] call Zen_StackAdd;
private ["_array", "_index", "_value", "_i"];

if !([_this, [["ARRAY"], ["SCALAR"], ["VOID"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_index = _this select 1;
_value = _this select 2;

if (typeName _value != "ARRAY") then {
    _value = [_value];
};

_tempArray = [];

for "_i" from 0 to (_index - 1) do {
    _tempArray set [_i, (_array select _i)];
};

{
    _tempArray pushBack _x;
} forEach _value;

for "_i" from _index to (count _array - 1) do {
    _tempArray pushBack (_array select _i);
};

call Zen_StackRemove;
(_tempArray)

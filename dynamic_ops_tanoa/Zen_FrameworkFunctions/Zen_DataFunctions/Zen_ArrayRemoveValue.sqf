// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveValue", _this] call Zen_StackAdd;
private ["_array", "_value", "_indexArray"];

if !([_this, [["ARRAY"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_value = _this select 1;

_indexArray = [];

{
    if ([_x, _value] call Zen_ValuesAreEqual) then {
        _indexArray pushBack _forEachIndex;
    };
} forEach _array;

{
    0 = [_array, _x - _forEachIndex] call Zen_ArrayRemoveIndex;
} forEach _indexArray;

call Zen_StackRemove;
if (true) exitWith {};

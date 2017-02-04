// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayFilterValues", _this] call Zen_StackAdd;
private ["_array", "_blacklist", "_returnArray"];

if !([_this, [["ARRAY"], ["ARRAY"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_array = _this select 0;
_blacklist = _this select 1;

_returnArray = [];

{
    if !([_x, _blacklist] call Zen_ValueIsInArray) then {
        _returnArray pushBack _x;
    };
} forEach _array;

call Zen_StackRemove;
(_returnArray)

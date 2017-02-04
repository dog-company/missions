// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayReplaceSlice", _this] call Zen_StackAdd;
private ["_array", "_startIndex", "_endIndex", "_replaceArray", "_tempArray"];

if !([_this, [["ARRAY"], ["SCALAR"], ["SCALAR"], ["ARRAY"]], [], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_startIndex = _this select 1;
_endIndex = _this select 2;
_replaceArray = _this select 3;

_tempArray = [];

if (_startIndex > 0) then {
    for "_i" from 0 to (_startIndex - 1) do {
        _tempArray pushBack (_array select _i);
    };
};

{
    _tempArray pushBack _x;
} forEach _replaceArray;

if (_endIndex < (count _array - 1)) then {
    for "_i" from (_endIndex + 1) to (count _array - 1) do {
        _tempArray pushBack (_array select _i);
    };
};

call Zen_StackRemove;
(_tempArray)

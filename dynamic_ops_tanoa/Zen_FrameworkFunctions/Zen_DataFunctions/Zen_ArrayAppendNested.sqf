// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayAppendNested", _this] call Zen_StackAdd;
private ["_array"];

if !([_this, [["ARRAY"], ["VOID"], ["VOID"], ["VOID"], ["VOID"], ["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;

{
    if (_forEachIndex > 0) then {
        if (typeName _x == "ARRAY") then {
            {
                _array pushBack _x;
            } forEach _x;
        } else {
            _array pushBack _x;
        };
    };
} forEach _this;

call Zen_StackRemove;
if (true) exitWith {};

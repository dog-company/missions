// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayFindSum", _this] call Zen_StackAdd;
private ["_array", "_sum"];

if !([_this, [["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_array = _this select 0;
_sum = 0;

{
    if (typeName _x == "SCALAR") then {
        _sum = _sum + _x;
    };
} forEach _array;

call Zen_StackRemove;
(_sum)

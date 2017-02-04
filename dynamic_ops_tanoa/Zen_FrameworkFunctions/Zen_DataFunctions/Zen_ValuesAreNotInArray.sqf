// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ValuesAreInArray", _this] call Zen_StackAdd;
private ["_value", "_array", "_areNotInArray"];

if !([_this, [["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_value = _this select 0;
_array = _this select 1;

if (typeName _value != "ARRAY") then {
    _value = [_value];
};

if (typeName _array != "ARRAY") then {
    _array = [_array];
};

_areNotInArray = true;

{
    _areNotInArray = !([_x, _array] call Zen_ValueIsInArray);
    if !(_areNotInArray) exitWith {};
} forEach _value;

call Zen_StackRemove;
(_areNotInArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_AreNotLocal", _this] call Zen_StackAdd;
private ["_units", "_areNotLocal"];

if !([_this, [["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_areNotLocal = true;

{
    if (local _x) exitWith {
        _areNotLocal = false;
    };
} forEach _units;

call Zen_StackRemove;
(_areNotLocal)

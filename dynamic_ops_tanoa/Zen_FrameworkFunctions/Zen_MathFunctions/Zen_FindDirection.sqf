// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindDirection", _this] call Zen_StackAdd;
private ["_point1", "_point2"];

if !([_this, [["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_point1 = [(_this select 0)] call Zen_ConvertToPosition;
_point2 = [(_this select 1)] call Zen_ConvertToPosition;

call Zen_StackRemove;
(((_point2 select 1) - (_point1 select 1)) atan2 ((_point2 select 0) - (_point1 select 0)))

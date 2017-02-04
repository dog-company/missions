// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindTrigAngle", _this] call Zen_StackAdd;
private ["_angle"];

if !([_this, [["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_angle = _this select 0;

call Zen_StackRemove;
(90 - _angle)

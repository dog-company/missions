// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsFacing", _this] call Zen_StackAdd;
private ["_unit", "_target", "_angle", "_dirToTarget", "_unitDir", "_return"];

if !([_this, [["OBJECT"], ["OBJECT"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_unit = _this select 0;
_target = _this select 1;

_angle = 45 / 2;

if (count _this > 2) then {
    _angle = (_this select 2) / 2;
};

if (_unit == _target) exitWith {
    call Zen_StackRemove;
    (false)
};

_dirToTarget = [_unit, _target] call Zen_FindDirection;
_unitDir = [(getDir _unit)] call Zen_FindTrigAngle;
_return = [_unitDir, [(_dirToTarget - _angle), (_dirToTarget + _angle)]] call Zen_IsAngleInSector;

call Zen_StackRemove;
(_return)

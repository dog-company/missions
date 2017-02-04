// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsVisible", _this] call Zen_StackAdd;
private ["_target", "_looker", "_targetEye", "_lookerEye", "_angle", "_isSeen"];

if !([_this, [["OBJECT"], ["OBJECT"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_target = _this select 0;
_looker = _this select 1;

_targetEye = eyePos _target;
_lookerEye = eyePos _looker;

_angle = 45;

if (count _this > 2) then {
    _angle = _this select 2;
};

_isSeen = false;

if (!(terrainIntersect [_targetEye, _lookerEye]) && {!(lineIntersects [_lookerEye, _targetEye, _looker, _target])}) then {
    if ([_looker, _target, _angle] call Zen_IsFacing) then {
        _isSeen = true;
    };
};

call Zen_StackRemove;
(_isSeen)

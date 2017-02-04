// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsSeen", _this] call Zen_StackAdd;
private ["_unit", "_range", "_isSeen", "_viewAngleFunc"];

if !([_this, [["OBJECT"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_unit = _this select 0;
_range = _this select 1;

_isSeen = false;

_viewAngleFunc = {
    (86.69289997 * (0.9970684201 ^ _this))
};

{
    if (((side _x) != (side _unit)) && (_x in allUnits) && ((vehicle _x) == _x)) then {
        _isSeen = [_x, _unit, ((_x distance _unit) call _viewAngleFunc)] call Zen_IsVisible;
    };

    if (_isSeen) exitWith {};
} forEach ((eyePos _unit) nearEntities ["Man", _range]);

call Zen_StackRemove;
(_isSeen)

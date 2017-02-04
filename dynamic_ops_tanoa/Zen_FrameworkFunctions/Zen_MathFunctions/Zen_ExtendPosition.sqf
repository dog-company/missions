// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ExtendPosition", _this] call Zen_StackAdd;
private ["_center", "_dist", "_phi", "_height", "_angleType"];

if !([_this, [["VOID"], ["SCALAR"], ["SCALAR"], ["STRING"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_dist = _this select 1;
_phi = _this select 2;

_angleType = "Compass";
_height = 0;

if (count _this > 3) then {
    _angleType = _this select 3;
};

if ((count _this) > 4) then {
    _height = _this select 4;
};

if ([_angleType, "Compass"] call Zen_ValuesAreEqual) then {
    _phi = [_phi] call Zen_FindTrigAngle;
};

call Zen_StackRemove;
([(_center select 0) + (_dist * (cos _phi)),(_center select 1) + (_dist * (sin _phi)), _height])

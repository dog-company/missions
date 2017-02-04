// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindRayIntersection", _this] call Zen_StackAdd;

if !([_this, [["VOID"], ["VOID"], ["SCALAR"], ["SCALAR"]], [], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

// /* Cartesian
private ["_point1", "_point2", "_angleRay1", "_angleRay2", "_slopeRay1", "_slopeRay2", "_xSol", "_point3", "_distP1_P3"];
_point1 = [(_this select 0)] call Zen_ConvertToPosition;
_point2 = [(_this select 1)] call Zen_ConvertToPosition;
_angleRay1 = _this select 2;
_angleRay2 = _this select 3;

_slopeRay1 = tan _angleRay1;
_slopeRay2 = tan _angleRay2;

_xSol = ((_slopeRay1 * (_point1 select 0)) + (_point2 select 1) - (_slopeRay2 * (_point2 select 0)) - (_point1 select 1)) / (_slopeRay1 - _slopeRay2);
_point3 = [_xSol, (_slopeRay1 * (_xSol - (_point1 select 0))) + (_point1 select 1), 0];

_distP1_P3 = [_point1, _point3] call Zen_Find2dDistance;

if !(([([_point1, _distP1_P3, _angleRay1, "trig"] call Zen_ExtendPosition), _point3] call Zen_Find2dDistance) < 5) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

call Zen_StackRemove;
(_point3)
//*/

/* Polar
private ["_point1", "_point2", "_angleRay1", "_angleRay2", "_dist_P1toP2", "_angle_P1toP2", "_angle_P2toP1", "_angleP2_P1_P3", "_angleP1_P2_P3", "_angleP1_P3_P2", "_dist_P2toP3", "_point3", "_distP1_P3", "_distP2_P3"];
_point1 = [(_this select 0)] call Zen_ConvertToPosition;
_point2 = [(_this select 1)] call Zen_ConvertToPosition;
_angleRay1 = ((_this select 2) + 360) % 360;
_angleRay2 = ((_this select 3) + 360) % 360;

if (_angleRay1 == _angleRay2) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

_dist_P1toP2 = [_point1, _point2] call Zen_Find2dDistance;
_angle_P1toP2 = (([_point1, _point2] call Zen_FindDirection) + 360) % 360;
_angle_P2toP1 = (([_point2, _point1] call Zen_FindDirection) + 360) % 360;

_angleP2_P1_P3 = ((abs (_angle_P1toP2 - _angleRay1)) min (abs (_angle_P1toP2 + 360 - _angleRay1))) min (abs (_angle_P1toP2 - 360 - _angleRay1));
_angleP1_P2_P3 = ((abs (_angle_P2toP1 - _angleRay2)) min (abs (_angle_P2toP1 + 360 - _angleRay2))) min (abs (_angle_P2toP1 - 360 - _angleRay2));

_angleP1_P3_P2 = 180 - _angleP2_P1_P3 - _angleP1_P2_P3;
_dist_P2toP3 = _dist_P1toP2 * (sin _angleP2_P1_P3) / (sin _angleP1_P3_P2);
_point3 = [_point2, _dist_P2toP3, _angleRay2, "trig"] call Zen_ExtendPosition;

_distP1_P3 = [_point1, _point3] call Zen_Find2dDistance;
_distP2_P3 = [_point2, _point3] call Zen_Find2dDistance;

if !((([([_point1, _distP1_P3, _angleRay1, "trig"] call Zen_ExtendPosition), _point3] call Zen_Find2dDistance) < 5) &&((([([_point2, _distP2_P3, _angleRay2, "trig"] call Zen_ExtendPosition), _point3] call Zen_Find2dDistance) < 5))) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

call Zen_StackRemove;
(_point3)
//*/
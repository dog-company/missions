// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsRayInPoly", _this] call Zen_StackAdd;
private ["_centerXYPos", "_phi", "_centerXYPoly", "_XYSizePoly", "_dirPoly", "_shapeType", "_centX", "_centY", "_rayLength", "_evalInt", "_isThruPoly", "_finPos"];

if !([_this, [["VOID"], ["SCALAR"], ["SCALAR"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"]], [[], [], [], [], ["SCALAR"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_centerXYPos = [(_this select 0)] call Zen_ConvertToPosition;
_rayLength = _this select 1;
_phi = _this select 2;

if ((typeName (_this select 3)) == "STRING") then {
    _centerXYPoly = getMarkerPos (_this select 3);
    _XYSizePoly = getMarkerSize (_this select 3);
    _dirPoly = markerDir (_this select 3);
    _shapeType = markerShape (_this select 3);
} else {
    _centerXYPoly = [(_this select 3)] call Zen_ConvertToPosition;
    _XYSizePoly = _this select 4;
    _dirPoly = _this select 5;
    _shapeType = _this select 6;
};

_centX = _centerXYPos select 0;
_centY = _centerXYPos select 1;
_evalInt = _rayLength / 75;
_isThruPoly = false;

for "_r" from 0 to _rayLength step _evalInt do {
    _finPos = [_centerXYPos, _r, _phi, "trig"] call Zen_ExtendPosition;
    if ([_finPos, _centerXYPoly, _XYSizePoly, _dirPoly, _shapeType] call Zen_IsPointInPoly) exitWith {
        _isThruPoly = true;
    };
};

call Zen_StackRemove;
(_isThruPoly)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindDistanceToPolyEdge", _this] call Zen_StackAdd;
private ["_centerXYPos", "_phi", "_centerXYPoly", "_XYSizePoly", "_dirPoly", "_shapeType", "_centX", "_centY", "_evalDist", "_evalInt", "_distance", "_finPos", "_lastPos", "_startedInside", "_isInPoly"];

if !([_this, [["VOID"], ["SCALAR"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"]], [[], [], [], ["SCALAR"]], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_centerXYPos = [(_this select 0)] call Zen_ConvertToPosition;
_phi = _this select 1;

if ((typeName (_this select 2)) == "STRING") then {
    _centerXYPoly = getMarkerPos (_this select 2);
    _XYSizePoly = getMarkerSize (_this select 2);
    _dirPoly = markerDir (_this select 2);
    _shapeType = markerShape (_this select 2);
} else {
    _centerXYPoly = [(_this select 2)] call Zen_ConvertToPosition;
    _XYSizePoly = _this select 3;
    _dirPoly = _this select 4;
    _shapeType = _this select 5;
};

_startedInside = ([_centerXYPos, _centerXYPoly, _XYSizePoly, _dirPoly, _shapeType] call Zen_IsPointInPoly);

if (_startedInside) then {
    _evalDist = (_XYSizePoly select 0) + (_XYSizePoly select 1);
} else {
    _evalDist = [_centerXYPos, _centerXYPoly] call Zen_Find2dDistance;
};

if !([_centerXYPos, _evalDist, _phi, _centerXYPoly, _XYSizePoly, _dirPoly, _shapeType] call Zen_IsRayInPoly) exitWith {
    call Zen_StackRemove;
    (0)
};

_evalInt = _evalDist / 20;
_distance = 0;
_centX = _centerXYPos select 0;
_centY = _centerXYPos select 1;

for "_r" from 0 to _evalDist step _evalInt do {
    _finPos = [_centerXYPos, _r, _phi, "trig"] call Zen_ExtendPosition;
    _isInPoly = [_finPos, _centerXYPoly, _XYSizePoly, _dirPoly, _shapeType] call Zen_IsPointInPoly;

    if ((_isInPoly && !_startedInside) || (!_isInPoly && _startedInside)) exitWith {
        _distance = [_finPos, _centerXYPos] call Zen_Find2dDistance;
    };
};

_centX = _finPos select 0;
_centY = _finPos select 1;

_phi = _phi + 180;
_lastPos = [_finPos, _evalInt, _phi, "trig"] call Zen_ExtendPosition;
_evalDist = [_finPos, _lastPos] call Zen_Find2dDistance;
_evalInt = _evalDist / 20;

for "_r" from 0 to _evalDist step _evalInt do {
    _finPos = [[_centX, _centY], _r, _phi, "trig"] call Zen_ExtendPosition;
    _isInPoly = [_finPos, _centerXYPoly, _XYSizePoly, _dirPoly, _shapeType] call Zen_IsPointInPoly;

    if ((!_isInPoly && !_startedInside) || (_isInPoly && _startedInside)) exitWith {
        _distance = [_finPos, _centerXYPos] call Zen_Find2dDistance;
    };
};

call Zen_StackRemove;
(_distance)

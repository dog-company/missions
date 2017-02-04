// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsPointInPoly", _this] call Zen_StackAdd;
private ["_pos", "_x1", "_y1", "_centX", "_centY", "_radius", "_phi", "_newY", "_newX", "_x2", "_y2", "_radB", "_radA", "_markerShape", "_markerDir", "_XYSizeArray", "_centerXY"];

if !([_this, [["VOID"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"]], [[], [], ["SCALAR"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_pos = [(_this select 0)] call Zen_ConvertToPosition;

if ((typeName (_this select 1)) == "STRING") then {
    _centerXY = getMarkerPos (_this select 1);
    _XYSizeArray = getMarkerSize (_this select 1);
    _markerDir = markerDir (_this select 1);
    _markerShape = markerShape (_this select 1);
} else {
    _centerXY = [(_this select 1)] call Zen_ConvertToPosition;
    _XYSizeArray = _this select 2;
    _markerDir = _this select 3;
    _markerShape = _this select 4;
};

_radA = _XYSizeArray select 0;
_radB = _XYSizeArray select 1;

_radius = [_centerXY, _pos] call Zen_Find2dDistance;

if (_radius < (_radA min _radB)) exitWith {
    call Zen_StackRemove;
    (true)
};

_phi = ([_centerXY, _pos] call Zen_FindDirection) + _markerDir - 90;

_centX = _centerXY select 0;
_centY = _centerXY select 1;

if (_radA == 0) then {
    _radA = random 1;
};

if (_radB == 0) then {
    _radB = random 1;
};

call Zen_StackRemove;
(switch (toUpper _markerShape) do {
    case "RECTANGLE": {
        _newX = _centX + (_radius * cos _phi);
        _newY = _centY + (_radius * sin _phi);

        _x1 = (_centX - _radB);
        _x2 = (_centX + _radB);
        _y1 = (_centY - _radA);
        _y2 = (_centY + _radA);

        (((_y2 - _newY > 0) && (_y1 - _newY < 0) && (_x2 - _newX > 0) && (_x1 - _newX < 0)))
    };
    case "ELLIPSE": {
        _x1 = _radius * sin _phi;
        _y1 = _radius * cos _phi;

        (((_x1^2 / _radA^2) + (_y1^2 / _radB^2) < 1))
    };
})

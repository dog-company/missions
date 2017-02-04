// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#define SMALL_STEP 0.18

_Zen_stack_Trace = ["Zen_QuantizeAngles", _this] call Zen_StackAdd;
private ["_center", "_polyType", "_XYSizeArray", "_markerDir", "_minAngle", "_maxAngle", "_targetArea", "_phiArray", "_phi", "_radius"];

if !([_this, [["ARRAY", "STRING"], ["SCALAR"], ["SCALAR"], ["SCALAR"], ["STRING"]], [["SCALAR"]], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_center = _this select 0;

if (typeName _center == "STRING") then {
    _minAngle = _this select 1;
    _maxAngle = _this select 2;
    _XYSizeArray = markerSize _center;
    _markerDir = markerDir _center;
    _polyType = markerShape _center;
} else {
    _XYSizeArray = _this select 0;
    _minAngle = _this select 1;
    _maxAngle = _this select 2;
    _markerDir = _this select 3;
    _polyType = _this select 4;
};

if (toLower _polyType == "icon") exitWith {
    call Zen_StackRemove;
    ([0])
};

if (toLower _polyType == "rectangle") then {
    _radius = {(((_XYSizeArray select 1) / abs sin (_phi + _markerDir)) min ((_XYSizeArray select 0) / abs cos (_phi + _markerDir)))};
} else {
    _radius = {(((_XYSizeArray select 0)*(_XYSizeArray select 1)) / sqrt ((_XYSizeArray select 1)^2 * (cos (_phi + _markerDir))^2 + (_XYSizeArray select 0)^2 * (sin (_phi + _markerDir))^2))};
};

_targetArea = (_XYSizeArray select 0) * (_XYSizeArray select 1) * SMALL_STEP;

if (_minAngle == 0 || _minAngle == 360) then {
    _minAngle = 0.1;
};

if (_minAngle > _maxAngle) then {
    ZEN_STD_Code_SwapVars(_minAngle, _maxAngle)
};

_phiArray = [_minAngle];
for "_phi" from _minAngle to _maxAngle step 0 do {
    _step = _targetArea / (call _radius)^2;
    _phi = _phi + _step;
    _phiArray pushBack _phi;
};

call Zen_StackRemove;
(_phiArray)

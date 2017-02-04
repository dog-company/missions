// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_FindPositionPoly", _this] call Zen_StackAdd;
private ["_center", "_centerXY", "_XYSizeArray", "_markerDir", "_phiArray", "_rho", "_phi", "_radius", "_polyType"];

if !([_this, [["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], ["SCALAR"], [], [], ["SCALAR"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

_center = _this select 0;

if (typeName _center == "STRING") then {
    _phiArray = _this select 1;
    _centerXY = getMarkerPos _center;
    _XYSizeArray = markerSize _center;
    _markerDir = markerDir _center;
    _polyType = markerShape _center;
} else {
    _centerXY = [(_this select 0)] call Zen_ConvertToPosition;
    _XYSizeArray = _this select 1;
    _markerDir = _this select 2;
    _polyType = _this select 3;
    _phiArray = _this select 4;
};

if (_polyType == "ICON") exitWith {
    call Zen_StackRemove;
    ([(_centerXY select 0), (_centerXY select 1), 0])
};

_rho = sqrt random 1;
_phi = ZEN_STD_Array_RandElement(_phiArray);

if (toLower _polyType == "rectangle") then {
    _radius = (((_XYSizeArray select 1) / abs sin (_phi + _markerDir)) min ((_XYSizeArray select 0) / abs cos (_phi + _markerDir)));
} else {
    _radius = (((_XYSizeArray select 0)*(_XYSizeArray select 1)) / sqrt ((_XYSizeArray select 1)^2 * (cos (_phi + _markerDir))^2 + (_XYSizeArray select 0)^2 * (sin (_phi + _markerDir))^2));
};

call Zen_StackRemove;
([(_centerXY select 0) + _rho * _radius * cos _phi, (_centerXY select 1) + _rho * _radius * sin _phi, 0])

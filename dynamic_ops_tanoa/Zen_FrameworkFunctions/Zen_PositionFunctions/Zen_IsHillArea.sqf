// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define HIGH_LOW_SEARCH_STEP -10
#define SLOPE_COEF_MAX 75
#define GRADIENT_DOWN_COEF 12
#define GRADIENT_DIR_RANGE 85

_Zen_stack_Trace = ["Zen_IsHillArea", _this] call Zen_StackAdd;
private ["_blacklist", "_center", "_XYSizeArray", "_markerShape", "_radiusMin", "_radiusMax", "_lowElevation", "_r", "_highElevation", "_elevationDiff", "_elevationDist", "_resultSlope", "_phi", "_downTotal", "_downCount", "_point", "_normal", "_dir", "_finalResult"];

if !([_this, [["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], ["STRING", "SCALAR"], [], [], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_blacklist = [];

if ((typeName (_this select 0)) == "STRING") then {
    _center = getMarkerPos (_this select 0);
    _XYSizeArray = getMarkerSize (_this select 0);
    _markerShape = markerShape (_this select 0);
    if (count _this > 1) then {
        _blacklist = _this select 1;
    };
} else {
    _center = [(_this select 0)] call Zen_ConvertToPosition;
    _XYSizeArray = _this select 1;
    _markerShape = _this select 3;
    if (count _this > 4) then {
        _blacklist = _this select 4;
    };
};

_radiusMin = (_XYSizeArray select 0) min (_XYSizeArray select 1);
_radiusMax = (_XYSizeArray select 0) max (_XYSizeArray select 1);

for "_r" from _radiusMax to _radiusMin step HIGH_LOW_SEARCH_STEP do {
    _lowElevation = [_center, _r, "low"] call Zen_FindNearHeight;
    if (([_lowElevation] + _this) call Zen_IsPointInPoly) exitWith {};
};

for "_r" from _radiusMax to _radiusMin step HIGH_LOW_SEARCH_STEP do {
    _highElevation = [_center, _r] call Zen_FindNearHeight;
    if (([_highElevation] + _this) call Zen_IsPointInPoly) exitWith {};
};

_elevationDiff = (getTerrainHeightASL _highElevation) - (getTerrainHeightASL _lowElevation);
_elevationDist = [_highElevation, _lowElevation] call Zen_Find2dDistance;
_resultSlope = ((atan (_elevationDiff / _elevationDist)) / SLOPE_COEF_MAX);

_downTotal = 0;
for "_phi" from 0 to 350 step 10 do {
    _downCount = 0;
    for "_r" from 1 to _radiusMin step (_radiusMin / 10) do {
        _point = [_center, _r, _phi] call Zen_ExtendPosition;
        _normal = surfaceNormal _point;
        _dir = ((_normal select 0) atan2 (_normal select 1));

        if ([_dir, [_phi - GRADIENT_DIR_RANGE, _phi + GRADIENT_DIR_RANGE]] call Zen_IsAngleInSector) then {
            _downCount = _downCount + 1;
        };
    };

    if (_downCount > 4) then {
        _downTotal = _downTotal + 1;
    };
};

_finalResult = _resultSlope + (((_downTotal - GRADIENT_DOWN_COEF) max 0) / 36);

call Zen_StackRemove;
((_finalResult) min 1)

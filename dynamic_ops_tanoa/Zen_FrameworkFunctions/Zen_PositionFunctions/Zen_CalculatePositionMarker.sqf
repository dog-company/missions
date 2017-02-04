// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_CalculatePositionMarker", _this] call Zen_StackAdd;
private ["_area", "_min", "_water", "_road", "_pos", "_failures", "_roadDist", "_minAngle", "_maxAngle", "_markerDir", "_markerSizeArray", "_markerCenterXY", "_markerShape", "_i", "_exit", "_nearestRoad", "_roads", "_areaArea", "_iterationCount", "_quantPhi", "_bestPos", "_leastFailures", "_maxFailures"];

_area = _this select 0;
_min = _this select 1;
_water = _this select 6;
_road = _this select 7;
_roadDist = _this select 8;
_minAngle = _this select 9;
_maxAngle = _this select 10;
_maxFailures = _this select 28;

_markerDir = markerDir _area;
_markerSizeArray = getMarkerSize _area;
_markerCenterXY = getMarkerPos _area;
_markerShape = markerShape _area;

_leastFailures = 20;
_bestPos = _markerCenterXY;
_pos = [0,0,0];
_exit = false;

if (_road == 2) then {
    if (_markerShape == "ellipse") then {
        _roads = _markerCenterXY nearRoads ((_markerSizeArray select 0) max (_markerSizeArray select 1));
    } else {
        _roads = _markerCenterXY nearRoads (_markerSizeArray distance [0,0]);
    };

    if (count _roads > 0) then {
        _nearestRoad = [_roads, _area] call Zen_FindMinDistance;
        if !([_nearestRoad, _markerCenterXY, _markerSizeArray, _markerDir, _markerShape] call Zen_IsPointInPoly) then {
            0 = ["Zen_FindGroundPosition", "No valid position possible, no roads within area", _this] call Zen_PrintError;
            call Zen_StackPrint;
            _exit = true;
        };
    } else {
        0 = ["Zen_FindGroundPosition", "No valid position possible, no roads within area", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _exit = true;
    };
};

if (_exit) exitWith {
    call Zen_StackRemove;
    ([_area] call Zen_ConvertToPosition)
};

if (_water > 0) then {
    if (_water == 1) then {
        _exit = !([_markerCenterXY, (_markerSizeArray distance [0,0]), "land"] call Zen_IsNearTerrain);
    } else {
        _exit = !([_markerCenterXY, (_markerSizeArray distance [0,0]), "water"] call Zen_IsNearTerrain);
    };

    if (_exit) then {
        0 = ["Zen_FindGroundPosition", "No valid position possible, water preference impossible", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

if (_exit) exitWith {
    call Zen_StackRemove;
    ([_area] call Zen_ConvertToPosition)
};

if (_markerShape == "Ellipse") then {
    _areaArea = (([_markerSizeArray] call Zen_ArrayFindAverage)^2 * pi) * (abs (_maxAngle - _minAngle));
} else {
    _areaArea = (4 * (_markerSizeArray select 0) * (_markerSizeArray select 1)) * (abs (_maxAngle - _minAngle));
};

_quantPhi = [_markerSizeArray, _minAngle, _maxAngle, _markerDir, _markerShape] call Zen_QuantizeAngles;
_iterationCount = ((round (_areaArea / 225 / pi )) max 20) min 1000;
for "_i" from 1 to _iterationCount step 1 do {
    _pos = [_markerCenterXY, _markerSizeArray, _markerDir, _markerShape, _quantPhi] call Zen_FindPositionPoly;

    if (_road in [1, 2]) then {
        _roads = _pos nearRoads _roadDist;
        _roadRepeat = _roadDist / 5 * 2;
        for "_i" from 1 to _roadRepeat step 1 do {
            if (count _roads == 0) exitWith {};
            _nearestRoad = [_roads, compile format ["-1 * (_this distanceSqr %1)", _pos]] call Zen_ArrayFindExtremum;
            0 = [_roads, _nearestRoad] call Zen_ArrayRemoveValue;
            if (([_nearestRoad, _area] call Zen_IsPointInPoly) && {!([_nearestRoad, getMarkerPos _area, [_min, _min], 0, "ellipse"] call Zen_IsPointInPoly)}) exitWith {
                _pos = [_nearestRoad] call Zen_ConvertToPosition;
            };
        };
    };

    if ([_pos, _markerCenterXY, _markerSizeArray, _markerDir, _markerShape] call Zen_IsPointInPoly) then {
        _this set [29, _pos];
        _failures = _this call Zen_CheckPosition;

        if (_failures < _leastFailures) then {
            _bestPos = _pos;
            _leastFailures = _failures;
        };
    };

    if (_leastFailures <= _maxFailures) exitWith {};
    if (_i == _iterationCount) exitWith {
        0 = ["Zen_FindGroundPosition", "No valid position found", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

call Zen_StackRemove;
(_bestPos)

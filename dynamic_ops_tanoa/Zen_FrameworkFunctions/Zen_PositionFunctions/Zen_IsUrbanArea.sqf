// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsUrbanArea", _this] call Zen_StackAdd;
private ["_blacklist", "_center", "_XYSizeArray", "_markerShape", "_radiusMax", "_buildings", "_roads", "_urbanArea", "_building", "_isBlacklisted", "_box", "_road", "_totalArea"];

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

_radiusMax = (_XYSizeArray select 0) max (_XYSizeArray select 1);
// _buildings = nearestObjects [_center, ["house"], _radiusMax];
_buildings = nearestTerrainObjects [_center, ["Building", "House", "Church", "Chapel", "Fountain", "View-Tower", "FuelStation", "Hospital", "WaterTower"], _radiusMax];

_roads = _center nearRoads _radiusMax;

if (count _buildings < 1) exitWith {
    call Zen_StackRemove;
    (0)
};

_urbanArea = 0;

{
    _building = _x;
    if (([_building] + _this) call Zen_IsPointInPoly) then {
        _isBlacklisted = false;
        {
            _isBlacklisted = ([_building, _x]) call Zen_IsPointInPoly;
            if (_isBlacklisted) exitWith {};
        } forEach _blacklist;

        if !(_isBlacklisted) then {
            _box = boundingBoxReal _building;
            _urbanArea = _urbanArea + abs 5*(((_box select 0) select 0) * (((_box select 0) select 1)));
        };
    };
} forEach _buildings;

{
    _road = _x;
    if (([_road] + _this) call Zen_IsPointInPoly) then {
        _isBlacklisted = false;
        {
            _isBlacklisted = ([_road, _x]) call Zen_IsPointInPoly;
        } forEach _blacklist;

        if !(_isBlacklisted) then {
            _urbanArea = _urbanArea + 200;
        };
    };
} forEach _roads;

if (_markerShape == "Ellipse") then {
    _totalArea = ([_XYSizeArray] call Zen_ArrayFindAverage)^2 * pi;
} else {
    _totalArea = 4 * (_XYSizeArray select 0) * (_XYSizeArray select 1);
};

call Zen_StackRemove;
((_urbanArea / _totalArea) min 1)

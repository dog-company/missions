// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsForestArea", _this] call Zen_StackAdd;
private ["_blacklist", "_center", "_XYSizeArray", "_markerShape", "_radiusMax", "_trees", "_treeArea", "_tree", "_isBlacklisted", "_nearestTree", "_totalArea"];

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
// _trees = [];

// {
    // if (["t_", (str _x)] call Zen_StringIsInString) then {
        // 0 = [_trees, _x] call Zen_ArrayAppend;
    // };
// } forEach (nearestObjects [_center, [], _radiusMax]);

_trees = nearestTerrainObjects[_center, ["Tree", "Small Tree"], _radiusMax];

if (count _trees < 2) exitWith {
    call Zen_StackRemove;
    (0)
};

_treeArea = 0;

{
    _tree = _x;
    if (([_tree] + _this) call Zen_IsPointInPoly) then {
        _isBlacklisted = false;
        {
            _isBlacklisted = ([_tree, _x]) call Zen_IsPointInPoly;
            if (_isBlacklisted) exitWith {};
        } forEach _blacklist;

        if !(_isBlacklisted) then {
            _nearestTree = [([_trees, (_forEachIndex - 3) max 0, (_forEachIndex + 3) min (count _trees - 1)] call Zen_ArrayGetIndexedSlice) - [_tree], _tree] call Zen_FindMinDistance;
            _treeArea = _treeArea + (((((_tree distance _nearestTree) / 2) min 5)^2) * 4);
        };
    };
} forEach _trees;

if (_markerShape == "Ellipse") then {
    _totalArea = ([_XYSizeArray] call Zen_ArrayFindAverage)^2 * pi;
} else {
    _totalArea = 4 * (_XYSizeArray select 0) * (_XYSizeArray select 1);
};

call Zen_StackRemove;
((_treeArea / _totalArea) min 1)

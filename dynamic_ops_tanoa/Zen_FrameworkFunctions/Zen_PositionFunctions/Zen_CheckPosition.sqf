// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define FAIL _failures = _failures + 1;
#define FAIL_CHECK if (_failures > (_maxFailures + 3)) exitWith {(_failures)};

private ["_area", "_min", "_allWhitelist", "_pos", "_failures", "_roadDist", "_minAngle", "_maxAngle", "_ID", "_objSwitch", "_objLimit", "_objDist", "_nearobj","_pointAvoidSwitch","_pointAvoidArray","_pointAvoidDist","_nearWaterSwitch","_nearWaterDist", "_roads", "_water", "_road", "_angleToPos", "_markerDir", "_markerSizeArray", "_markerCenterXY", "_markerShape", "_terrainSlopeSwitch", "_terrainSlopeAngle", "_terrainSlopeRadius", "_ambientClutterSwitch", "_ambientClutterCount", "_ambientClutterRadius", "_heightSwitch", "_heightNumber", "_heightRadius", "_maxFailures", "_height", "_allBlacklist", "_pointIn", "_oneWhitelist"];

_area = _this select 0;
_min = _this select 1;
// _max = _this select 2;
_allBlacklist = _this select 3;
_allWhitelist = _this select 4;
_oneWhitelist = _this select 5;
_water = _this select 6;
_road = _this select 7;
_roadDist = _this select 8;
_minAngle = _this select 9;
_maxAngle = _this select 10;
_objSwitch = _this select 11;
_objLimit = _this select 12;
_objDist = _this select 13;
_pointAvoidSwitch = _this select 14;
_pointAvoidArray = _this select 15;
_pointAvoidDist = _this select 16;
_nearWaterSwitch = _this select 17;
_nearWaterDist = _this select 18;
_terrainSlopeSwitch = _this select 19;
_terrainSlopeAngle = _this select 20;
_terrainSlopeRadius = _this select 21;
_ambientClutterSwitch = _this select 22;
_ambientClutterCount = _this select 23;
_ambientClutterRadius = _this select 24;
_heightSwitch = _this select 25;
_heightNumber = _this select 26;
_heightRadius = _this select 27;
_maxFailures = _this select 28;
_pos = _this select 29;

_failures = 0;

{
    if (([_x, allMapMarkers] call Zen_ValueIsInArray) && {([_pos, _x] call Zen_IsPointInPoly)}) exitWith {
        FAIL
    };
} forEach _allBlacklist;

{
    if (([_x, allMapMarkers] call Zen_ValueIsInArray) && {!([_pos, _x] call Zen_IsPointInPoly)}) exitWith {
        FAIL
    };
} forEach _allWhitelist;

_pointIn = false || (count _oneWhitelist == 0);
{
    if (([_x, allMapMarkers] call Zen_ValueIsInArray) && {([_pos, _x] call Zen_IsPointInPoly)}) exitWith {
        _pointIn = true;
    };
} forEach _oneWhitelist;

if !(_pointIn) then {
    FAIL
};

FAIL_CHECK
switch (_water) do {
    case 1: {
        if (surfaceIsWater [_pos select 0, _pos select 1]) then {FAIL};
    };
    case 2: {
        if !(surfaceIsWater [_pos select 0, _pos select 1]) then {FAIL}
    };
};

if (_road in [2, 3]) then {
    _roads = _pos nearRoads _roadDist;
    switch (_road) do {
        case 2: {
            if (count _roads < 1) then {FAIL};
        };
        case 3: {
            if (count _roads > 1) then {FAIL};
        };
    };
};

FAIL_CHECK
if (([_area, _pos] call Zen_Find2dDistance) < _min) then {FAIL};

FAIL_CHECK
if !(_minAngle == _maxAngle) then {
    _angleToPos = [_area, _pos] call Zen_FindDirection;
    if !([_angleToPos, [_minAngle, _maxAngle]] call Zen_IsAngleInSector) then {FAIL};
};

FAIL_CHECK
if (_objSwitch == 1) then {
    // _nearObjHouse = nearestObjects [_pos, ["House", "Building", "Ruins"], _objDist];
    _nearObjHouse = nearestTerrainObjects[_pos, ["Building", "House", "Church", "Chapel", "Bunker", "Fortress", "Fountain", "View-Tower", "Lighthouse", "FuelStation", "Hospital", "Wall", "WaterTower"], _objDist];
    if ((count _nearObjHouse) > _objLimit) then {FAIL};
} else {
    if (_objSwitch == 2) then {
        // _nearObjHouse = nearestObjects [_pos, ["House", "Building", "Ruins"], _objDist];
       _nearObjHouse = nearestTerrainObjects[_pos, ["Building", "House", "Church", "Chapel", "Bunker", "Fortress", "Fountain", "View-Tower", "Lighthouse", "FuelStation", "Hospital", "Wall", "WaterTower"], _objDist];
        if ((count _nearObjHouse) < _objLimit) then {FAIL};
    };
};

FAIL_CHECK
if (_pointAvoidSwitch != 0) then {
    if (((typeName _pointAvoidArray) == "ARRAY") && {((count _pointAvoidArray) > 0)}) then {
        if (_pointAvoidSwitch == 1) then {
            {
                if (([_pos, _x] call Zen_Find2dDistance) < _pointAvoidDist) exitWith {FAIL};
            } forEach _pointAvoidArray;
        } else {
            if (_pointAvoidSwitch == 2) then {
                {
                    if (([_pos, _x] call Zen_Find2dDistance) > _pointAvoidDist) exitWith {FAIL};
                } forEach _pointAvoidArray;
            };
        };
    };
};

FAIL_CHECK
if (_nearWaterSwitch == 1) then {
    if ([_pos,_nearWaterDist, "water"] call Zen_IsNearTerrain) then {FAIL};
} else {
    if (_nearWaterSwitch == 2) then {
        if !([_pos,_nearWaterDist, "water"] call Zen_IsNearTerrain) then {FAIL};
    };
};

FAIL_CHECK
if (_terrainSlopeSwitch == 1) then {
    if (([_pos] call Zen_FindTerrainSlope) > _terrainSlopeAngle) then {FAIL};
} else {
    if (_terrainSlopeSwitch == 2) then {
        if (([_pos] call Zen_FindTerrainSlope) < _terrainSlopeAngle) then {FAIL};
    };
};

FAIL_CHECK
if (_ambientClutterSwitch == 1) then {
    if (typeName _ambientClutterCount == "ARRAY") then {
        {
            _clutterMax = _ambientClutterCount select _forEachIndex;
            if ((_x > _clutterMax) && {(_clutterMax != -1)}) exitWith {FAIL};
        } forEach ([_pos, _ambientClutterRadius] call Zen_GetAmbientClutterCount);
    } else {
        if (([([_pos, _ambientClutterRadius] call Zen_GetAmbientClutterCount)] call Zen_ArrayFindSum) > _ambientClutterCount) then {FAIL};
    };
} else {
    if (_ambientClutterSwitch == 2) then {
        if (typeName _ambientClutterCount == "ARRAY") then {
            {
                _clutterMax = _ambientClutterCount select _forEachIndex;
                if ((_x < _clutterMax) && {(_clutterMax != -1)}) exitWith {FAIL};
            } forEach ([_pos, _ambientClutterRadius] call Zen_GetAmbientClutterCount);
        } else {
            if (([([_pos, _ambientClutterRadius] call Zen_GetAmbientClutterCount)] call Zen_ArrayFindSum) < _ambientClutterCount) then {FAIL};
        };
    };
};

FAIL_CHECK
if (_heightSwitch == 1) then {
    if (_heightRadius > 0) then {
        _height = getTerrainHeightASL ([_pos, _heightRadius] call Zen_FindNearHeight);
    } else {
        _height = getTerrainHeightASL _pos;
    };
    if (_height > _heightNumber) then {FAIL};
} else {
    if (_heightSwitch == 2) then {
        if (_heightRadius > 0) then {
            _height = getTerrainHeightASL ([_pos, _heightRadius] call Zen_FindNearHeight);
        } else {
            _height = getTerrainHeightASL _pos;
        };
        if (_height < _heightNumber) then {FAIL};
    };
};

(_failures)

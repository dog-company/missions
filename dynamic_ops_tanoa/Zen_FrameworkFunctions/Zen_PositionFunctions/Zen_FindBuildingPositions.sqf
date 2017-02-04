// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

#define HITS_BUILDING(X, Y) (_building in (lineIntersectsWith [X, Y]))

#define COUNT_RAYCAST_SPIN(XY, Z1, Z2, A, V) \
    V = 0; \
    for "_k" from 0 to (360 - A) step A do { \
        if HITS_BUILDING(ZEN_STD_Math_VectTransform(_3dPos, 0, 0, Z1), ZEN_STD_Math_VectTransform(_3dPos, XY * cos _k, XY * sin _k, Z2)) then { \
            V = V + 1; \
        }; \
    };

_Zen_stack_Trace = ["Zen_FindBuildingPositions", _this] call Zen_StackAdd;
private ["_building", "_allowRoof", "_Xdist", "_Ydist", "_points", "_positions", "_i", "_2dPos", "_floorPositions", "_j", "_3dPos", "_sideWall", "_upWall", "_downWall", "_k"];

if !([_this, [["VOID"], ["BOOL"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([[0,0,0]])
};

if ((typeName (_this select 0) == "OBJECT") && {((_this select 0) isKindOf "Building")}) then {
    _building = (_this select 0);
} else {
    _building = nearestBuilding ([(_this select 0)] call Zen_ConvertToPosition);
};

_Xdist = ZEN_STD_OBJ_BBX(_building) / 2;
_Ydist = ZEN_STD_OBJ_BBY(_building) / 2;

ZEN_STD_Parse_GetArgumentDefault(_allowRoof, 1, false)
ZEN_STD_Parse_GetArgumentDefault(_points, 2, (round (_Xdist * _Ydist / 2)) max 5)
_positions = [];

for "_i" from 1 to _points do {
    _2dPos = [(getPosATL _building), [_Xdist, _Ydist], 90 - (getDir _building), "rectangle", [random 360]] call Zen_FindPositionPoly;
    _2dPos set [2, getTerrainHeightASL _2dPos];
    _floorPositions = [];

    for "_j" from 1 to 20 do {
        if !HITS_BUILDING(_2dPos, ZEN_STD_Math_VectTransform(_2dPos, 0, 0, 0.2)) exitWith {};
        _2dPos = ZEN_STD_Math_VectTransform(_2dPos, 0, 0, 0.2);
    };

    if (_allowRoof || HITS_BUILDING(ZEN_STD_Math_VectTransform(_2dPos, 0, 0, 0.1), ZEN_STD_Math_VectTransform(_2dPos, 0, 0, 50))) then {
        _3dPos =+ _2dPos;
        COUNT_RAYCAST_SPIN(3, 0.1, 5, 30, _upWall)
        if (_upWall > 8) then {
            for "_j" from 1 to 200 do {
                if (!HITS_BUILDING(_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, -2)) && {!HITS_BUILDING(_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 50))}) exitWith {};
                if (HITS_BUILDING(_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, -0.25)) && {!HITS_BUILDING(_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 1.5))}) then {
                    COUNT_RAYCAST_SPIN(3, 0.7, -5, 30, _downWall)
                    if (_downWall > 9) then {
                        COUNT_RAYCAST_SPIN(0.3, 0.7, 0.7, 30, _sideWall)
                        if (_sideWall < 2) then {
                            if (HITS_BUILDING(ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 0.7), ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 50)) || {_allowRoof}) then {
                                COUNT_RAYCAST_SPIN(25, 0.7, 0.7, 15, _sideWall)
                                if ((_sideWall > 11) || {((((ASLtoATL _3dPos) select 2) > 2) && _allowRoof)}) then {
                                    _floorPositions pushBack _3dPos;
                                };
                            };
                        };
                    };
                };
                _3dPos = ZEN_STD_Math_VectTransform(_3dPos, 0, 0, 0.2);
            };
        };
        0 = [_positions, _floorPositions] call Zen_ArrayAppendNested;
    };
};

{
    _3dPos =+ _x;
    for "_i" from 1 to 20 do {
        if HITS_BUILDING(_3dPos, ZEN_STD_Math_VectTransform(_3dPos, 0, 0, -0.02)) exitWith {};
        _3dPos = ZEN_STD_Math_VectTransform(_3dPos, 0, 0, -0.02);
    };
    _positions set [_forEachIndex, (ASLToATL _3dPos) vectorAdd [0, 0, 0.15]];
} forEach _positions;

call Zen_StackRemove;
(_positions)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnAmbientVehicles", _this] call Zen_StackAdd;
private ["_center", "_distance", "_numCarsRange", "_townMarkers", "_carPos", "_carType", "_car", "_carClasses", "_carsMin", "_carsMax", "_numCars", "_carObjs", "_roadDir", "_customClasses"];

if !([_this, [["VOID"], ["SCALAR"], ["ARRAY", "SCALAR"], ["STRING", "ARRAY"]], [[], [], ["SCALAR"], ["STRING"]], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_distance = _this select 1;
_numCarsRange = _this select 2;

ZEN_STD_Parse_GetArgumentDefault(_customClasses, 3, "")

_townMarkers = [["NameVillage", "NameCity", "NameCityCapital"]] call Zen_ConfigGetLocations;
_townMarkers = [_townMarkers, (compile format ["(getMarkerPos _this) distance %1", _center]), "hash"] call Zen_ArraySort;

if (typeName _numCarsRange != "ARRAY") then {
    _numCarsRange = [_numCarsRange, _numCarsRange];
};

_carsMin = _numCarsRange select 0;
_carsMax = _numCarsRange select 1;

if ((typeName _customClasses == "ARRAY") && {({isClass (configFile >> "CfgVehicles" >> _x)} count _customClasses) == (count _customClasses)}) then {
    _carClasses = _customClasses;
} else {
    _carClasses = ["car", civilian, "all", "all", "all", "both", _customClasses] call Zen_ConfigGetVehicleClasses;
};

if (count _carClasses == 0) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_SpawnAmbientVehicles", "No vehicle classnames found to spawn.", [])
};

_carObjs = [];
{
    if (([_x, _center] call Zen_Find2dDistance) > _distance) exitWith {};
    _numCars = [_carsMin, _carsMax, true] call Zen_FindInRange;
    for "_i" from 1 to _numCars do {

        _carPos = [_x, 0, 0, 1, [1, 500]] call Zen_FindGroundPosition;
        _carType = [_carClasses] call Zen_ArrayGetRandom;

        _roadDir = [_carPos] call Zen_FindRoadDirection;

        _car = [[_carPos, 4, _roadDir + 90, "trig"] call Zen_ExtendPosition, _carType, 0, 90 - _roadDir] call Zen_SpawnVehicle;
        _carObjs pushBack _car;
    };
} forEach _townMarkers;

call Zen_StackRemove;
(_carObjs)

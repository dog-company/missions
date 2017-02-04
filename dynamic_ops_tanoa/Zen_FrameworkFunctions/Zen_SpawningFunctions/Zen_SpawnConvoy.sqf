// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnConvoy", _this] call Zen_StackAdd;
private ["_startPos", "_sideOrTypes", "_faction", "_vehicleTypes", "_vehicles", "_side", "_leadVehicleType", "_supplyVehicleType", "_troopVehicleType", "_roadDir", "_troopVehicle", "_troopCargo", "_troopGroup", "_leadVehicle", "_vehicleGroup"];

if !([_this, [["VOID"], ["SIDE", "ARRAY", "STRING"], ["STRING", "ARRAY"]], [[], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_startPos = [(_this select 0)] call Zen_ConvertToPosition;
_sideOrTypes = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_faction, 2, "All")

_vehicleTypes = [];
_vehicles = [];

if (typeName _sideOrTypes == "SIDE") then {
    _side = _sideOrTypes;
    if ((count _this < 3) && {_sideOrTypes == west}) then {
        _faction = "blu_f";
    };

    _leadVehicleType = [(["car", _sideOrTypes, "all", _faction, "All", "Armed"] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
    _supplyVehicleType = [(["support", _sideOrTypes, "all", _faction] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
    _troopVehicleType = [(["car", _sideOrTypes, "all", _faction, "All", "Unarmed"] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;

    _vehicleTypes = [_leadVehicleType, _supplyVehicleType, _troopVehicleType];
    if (({typeName _x == "ARRAY"} count _vehicleTypes) > 0) then {
        _leadVehicleType = "";
    };

    if (_leadVehicleType == "") exitWith {
        0 = ["Zen_SpawnConvoy", "Invalid side and faction combination given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        call Zen_StackRemove;
        ([objNull])
    };
} else {
    ZEN_STD_Parse_ToArray(_sideOrTypes);
    _side = [(_sideOrTypes select 0)] call Zen_GetSide;

    _vehicleTypes =+ _sideOrTypes;
    if (count _vehicleTypes == 0) exitWith {
        0 = ["Zen_SpawnConvoy", "No vehicle classnames given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        call Zen_StackRemove;
        ([objNull])
    };
};

_roadDir = random 360;
if ((count (_startPos nearRoads 50)) > 1) then {
    _roadDir = [_startPos] call Zen_FindRoadDirection;
};

{
    _vehicles pushBack ([([_startPos, _forEachIndex * -15 + 1, _roadDir, "trig"] call Zen_ExtendPosition), _x, 90 - _roadDir] call Zen_SpawnGroundVehicle);
} forEach _vehicleTypes;

_troopVehicle = ZEN_STD_Array_LastElement(_vehicles);
_troopCargo = ZEN_STD_OBJ_CountCargoSeats(_troopVehicle) + (count ([_troopVehicle, "cargoFFV"] call Zen_GetTurretPaths));

if (_troopCargo > 0) then {
    _troopGroup = [_startPos, _side, "infantry", [1, _troopCargo]] call Zen_SpawnInfantry;
    0 = [_troopGroup, _troopVehicle, "cargo"] call Zen_MoveInVehicle;
};

_leadVehicle = (_vehicles select 0);
_vehicleGroup = group driver _leadVehicle;

{
    if (_forEachIndex > 0) then {
        (crew _x) join _vehicleGroup;
    };
    _x setUnloadInCombat [true, false];
} forEach _vehicles;

_vehicleGroup setFormation "FILE";
_vehicleGroup setFormDir (getDir _leadVehicle);

call Zen_StackRemove;
(_vehicles)

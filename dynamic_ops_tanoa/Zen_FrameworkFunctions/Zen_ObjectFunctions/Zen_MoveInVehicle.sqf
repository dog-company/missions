// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_MoveInVehicle", _this] call Zen_StackAdd;
private ["_unitsArray", "_vehicle", "_turrets", "_vehicleSlot", "_turretTypes", "_args", "_unUsedTurrets", "_unUsedCargo", "_dummyUnit", "_startTime", "_seats"];

if !([_this, [["VOID"], ["OBJECT"], ["STRING"], ["ARRAY", "STRING"]], [[], [], [], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_unitsArray = [(_this select 0)] call Zen_ConvertToObjectArray;
_vehicle = _this select 1;
ZEN_STD_Parse_GetArgumentDefault(_vehicleSlot, 2, "Cargo")
ZEN_STD_Parse_GetArgumentDefault(_turretTypes, 3, ["All"])

if !(alive _vehicle) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_MoveInVehicle", "Given vehicle is destroyed or does not exist.")
};

switch (toLower _vehicleSlot) do {
    case "cargo": {
        _seats = [_vehicle, "cargoFFV"] call Zen_GetFreeSeats;
        _unUsedTurrets = _seats select 1;
        _unUsedCargo = _seats select 2;

        if (count _unitsArray > (count _unUsedCargo + count _unUsedTurrets)) then {
            0 = ["Zen_MoveInVehicle", "Given vehicle does not have enough passenger positions to hold all of the given units", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };

        if (count _unUsedTurrets > 0) then {
            {
                if (_forEachIndex == count _unitsArray) exitWith {};
                _args = [(_unitsArray select _forEachIndex), _vehicle, _x];
                ZEN_FMW_MP_REClient("Zen_MoveInVehicle_Turret_MP", _args, call, (_unitsArray select _forEachIndex))
            } forEach _unUsedTurrets;

            _startTime = time;
            waitUntil {
                ZEN_STD_Code_SleepFrames(2)
                ((({_x in _vehicle} count _unitsArray) == (count _unUsedTurrets)) || (({_x in _vehicle} count _unitsArray) == (count _unitsArray)) || time > (_startTime + (count _unUsedTurrets)))
            };
        };

        _unitsArray = [_unitsArray, {(vehicle _this != _this)}] call Zen_ArrayFilterCondition;
        if ((count _unitsArray > 0) && {count _unUsedCargo > 0}) then {
            {
                if (_forEachIndex == count _unitsArray) exitWith {};
                _args = [(_unitsArray select _forEachIndex), _vehicle, _x];
                ZEN_FMW_MP_REClient("Zen_MoveInVehicle_Cargo_MP", _args, call, (_unitsArray select _forEachIndex))
            } forEach _unUsedCargo;

            _startTime = time;
            waitUntil {
                ZEN_STD_Code_SleepFrames(2)
                ((({_x in _vehicle} count _unitsArray) == (count _unUsedCargo)) || (({_x in _vehicle} count _unitsArray) == (count _unitsArray)) || time > (_startTime + (count _unUsedCargo)))
            };
        };
    };
    case "driver": {
        if (count _unitsArray > 1) then {
            ZEN_FMW_Code_Error("Zen_MoveInVehicle", "Two or more units cannot be in the driver seat.")
        };

        if !(isNull (driver _vehicle)) exitWith {
            ZEN_FMW_Code_Error("Zen_MoveInVehicle", "Given vehicle already has a driver.")
        };

        _unit = _unitsArray select 0;
        _args = [_unit, _vehicle];
        ZEN_FMW_MP_REClient("Zen_MoveInVehicle_Driver_MP", _args, call, _unit)

        _startTime = time;
        waitUntil {
            ZEN_STD_Code_SleepFrames(2)
            (((driver _vehicle) == _unit) || {time > (_startTime + 1)})
        };
    };
    case "turret": {
        _turrets = [_vehicle, _turretTypes] call Zen_GetTurretPaths;
        _seats = [_vehicle, _turretTypes] call Zen_GetFreeSeats;
        _unUsedTurrets = _seats select 1;

        if (count _unUsedTurrets > 0) then {
            {
                if (_forEachIndex == count _unitsArray) exitWith {};
                _args = [(_unitsArray select _forEachIndex), _vehicle, _x];
                ZEN_FMW_MP_REClient("Zen_MoveInVehicle_Turret_MP", _args, call, (_unitsArray select _forEachIndex))
            } forEach _unUsedTurrets;

            _startTime = time;
            waitUntil {
                ZEN_STD_Code_SleepFrames(2)
                ((({_x in _vehicle} count _unitsArray) == (count _unUsedTurrets)) || (({_x in _vehicle} count _unitsArray) == (count _unitsArray)) || time > (_startTime + (count _unUsedTurrets)))
            };
        };
    };
    case "all": {
        0 = [(_unitsArray select 0), _vehicle, "driver"] call Zen_MoveInVehicle;
        _unitsArray = [_unitsArray, {(vehicle _this != _this)}] call Zen_ArrayFilterCondition;

        if (count _unitsArray > 0) then {
            0 = [_unitsArray, _vehicle, "turret"] call Zen_MoveInVehicle;
            _unitsArray = [_unitsArray, {(vehicle _this != _this)}] call Zen_ArrayFilterCondition;
            if (count _unitsArray > 0) then {
                _h_move = [_unitsArray, _vehicle, "cargo"] call Zen_MoveInVehicle;
            };
        };
    };
    default {
        ZEN_FMW_Code_Error("Zen_MoveInVehicle", "Invalid seat type given.")
    };
};

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetFreeSeats", _this] call Zen_StackAdd;
private ["_vehicle", "_turrets", "_turretTypes", "_args", "_unUsedTurrets", "_unUsedCargo", "_dummyUnit", "_hasDriver", "_group"];

if !([_this, [["OBJECT"], ["ARRAY", "STRING"]], [[], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicle = _this select 0;
ZEN_STD_Parse_GetSetArgumentOptional(_turretTypes, 1, ["All"], ["All"])

if !(alive _vehicle) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_GetFreeSeats", "Given vehicle is destroyed or does not exist.")
};

if (local _vehicle) then {
    _turrets = [_vehicle, _turretTypes] call Zen_GetTurretPaths;
    _hasDriver = true;
    _unUsedTurrets = [];
    _unUsedCargo = [];

    _group = createGroup west;
    _dummyUnit = _group createUnit ["B_Soldier_F", [0,0,0], [], 0, "NONE"];
    _dummyUnit allowDamage false;
    _dummyUnit setCaptive true;
    _dummyUnit hideObjectGlobal true;
    _dummyUnit setBehaviour "careless";

    _dummyUnit assignAsDriver _vehicle;
    _dummyUnit moveInDriver _vehicle;
    if (_dummyUnit in _vehicle) then {
        _hasDriver = false
    };
    _dummyUnit setPosATL [0,0,0];

    {
        _dummyUnit assignAsTurret [_vehicle, _x];
        _dummyUnit moveInTurret [_vehicle, _x];
        if (_dummyUnit in _vehicle) then {
            _unUsedTurrets pushBack _x;
        };
        _dummyUnit setPosATL [0,0,0];
    } forEach _turrets;

    for "_i" from 0 to (ZEN_STD_OBJ_CountCargoSeats(_vehicle) - 1) do {
        _dummyUnit assignAsCargoIndex [_vehicle, _i];
        _dummyUnit moveInCargo [_vehicle, _i];
        if (_dummyUnit in _vehicle) then {
            _unUsedCargo pushBack _i;
        };
        _dummyUnit setPosATL [0,0,0];
    };
    deleteVehicle _dummyUnit;

    _vehicle setVariable ["Zen_Unused_Driver", !(_hasDriver), true];
    _vehicle setVariable ["Zen_Unused_Turret", _unUsedTurrets, true];
    _vehicle setVariable ["Zen_Unused_Cargo", _unUsedCargo, true];
} else {
    ZEN_FMW_MP_REClient("Zen_GetFreeSeats", _this, call, _vehicle)

    waitUntil {
        ZEN_STD_Code_SleepFrames(5)
        (!((_vehicle getVariable ["Zen_Unused_Driver", 0]) isEqualTo 0)
        && {!((_vehicle getVariable ["Zen_Unused_Turret", 0]) isEqualTo 0)}
        && {!((_vehicle getVariable ["Zen_Unused_Cargo", 0]) isEqualTo 0)})
    };
};

call Zen_StackRemove;
([_vehicle getVariable "Zen_Unused_Driver", _vehicle getVariable "Zen_Unused_Turret", _vehicle getVariable "Zen_Unused_Cargo"])

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetTurretPaths", _this] call Zen_StackAdd;
private ["_vehicle", "_turretTypes", "_turretClass", "_turretPaths", "_commanderTurrets", "_gunnerTurrets", "_cargoFFVTurrets", "_turretTypeRef", "_turretType", "_turretEntry", "_turretWeapons"];

if !([_this, [["OBJECT", "STRING"], ["ARRAY", "STRING"]], [[], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_vehicle = _this select 0;
ZEN_STD_Parse_GetArgumentDefault(_turretTypes, 1, ["All"])
ZEN_STD_Parse_ToArray(_turretTypes)

if (typeName _vehicle == "OBJECT") then {
    _vehicle = typeOf _vehicle;
};

_turretClass = configFile >> "CfgVehicles" >> _vehicle >> "Turrets";
_turretPaths = [];
_commanderTurrets = [];
_gunnerTurrets = [];
_cargoFFVTurrets = [];
_turretTypeRef = [_commanderTurrets, _gunnerTurrets, _cargoFFVTurrets];

#define ADD_TURRET(T) \
    T pushBack [_i];

#define ADD_SUBTURRET(T) \
    T pushBack [_i, _forEachIndex];

#define GET_TURRET_TYPE(T) \
    _turretType = ""; \
    _turretWeapons = []; \
    0 = [_turretWeapons, getArray (T >> "weapons")] call Zen_ArrayAppendNested; \
    { \
        _turretWeapons = [_turretWeapons, ZEN_FMW_ZAF_String(_x)] call Zen_ArrayFilterCondition; \
    } forEach ["smoke", "horn", "laser", "flare", "throw", "put"]; \
    if (isClass T) then { \
        if (((getNumber (T >> "primaryGunner")) == 1) || (count _turretWeapons > 0)) then { \
            _turretType = "gunner"; \
        } else { \
            if (((getNumber (T >> "isCopilot")) == 1) || ((getNumber (T >> "primaryObserver")) == 1)) then { \
                _turretType = "commander"; \
            } else { \
                if ((getNumber (T >> "isPersonTurret")) == 1) then { \
                    _turretType = "cargo"; \
                }; \
            }; \
        }; \
    };

if (isClass _turretClass) then {
    for "_i" from 0 to ((count _turretClass) - 1) do {
        _turretEntry = _turretClass select _i;

        if (isClass _turretEntry) then {
            GET_TURRET_TYPE(_turretEntry)

            switch (_turretType) do {
                case "commander": {ADD_TURRET(_commanderTurrets)};
                case "gunner": {ADD_TURRET(_gunnerTurrets)};
                case "cargo": {ADD_TURRET(_cargoFFVTurrets)};
                default {ADD_TURRET(_cargoFFVTurrets)};
            };

            {
                GET_TURRET_TYPE(_x)
                switch (_turretType) do {
                    case "commander": {ADD_SUBTURRET(_commanderTurrets)};
                    case "gunner": {ADD_SUBTURRET(_gunnerTurrets)};
                    case "cargo": {ADD_SUBTURRET(_cargoFFVTurrets)};
                    default {ADD_SUBTURRET(_cargoFFVTurrets)};
                };
            } forEach ("true" configClasses (_turretEntry >> "Turrets"));

        };
    };
};

if (["All", _turretTypes] call Zen_ValueIsInArray) then {
    {
        0 = [_turretPaths, _x] call Zen_ArrayAppendNested;
    } forEach _turretTypeRef;
} else {
    {
        if ([_x, _turretTypes] call Zen_ValueIsInArray) then {
            0 = [_turretPaths, (_turretTypeRef select _forEachIndex)] call Zen_ArrayAppendNested;
        };
    } forEach ["Commander", "Gunner", "CargoFFV"];
};

call Zen_StackRemove;
(_turretPaths)

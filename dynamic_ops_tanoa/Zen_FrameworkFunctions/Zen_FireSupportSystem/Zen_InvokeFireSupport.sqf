// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"
#define RNG(ARR) ([(ARR select 0), (ARR select 1)] call Zen_FindInRange)

_Zen_stack_Trace = ["Zen_InvokeFireSupport", _this] call Zen_StackAdd;
private ["_firePosition", "_nameString", "_templateArray", "_roundType", "_round", "_guided", "_guidanceObject", "_guidanceType", "_artyVehicle", "_roundPosition", "_temp_roundsPerSalvo", "_temp_salvos", "_temp_timePerRound", "_temp_timePerSalvo", "_effectShapeData", "_temp_salvoDrift", "_artyVehicleClass", "_artyMuzzleClass", "_effectMarker", "_artyWeaponMag", "_artyFireMode"];

if !([_this, [["VOID"], ["STRING"], ["OBJECT", "STRING"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_firePosition = [(_this select 0)] call Zen_ConvertToPosition;
_nameString = _this select 1;
_guidanceObject = objNull;
_guidanceType = "designator";

_templateArray = [_nameString] call Zen_GetFireSupportData;

if (count _templateArray == 0) exitWith {
    0 = ["Zen_InvokeFireSupport", "Given template does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

_roundType = _templateArray select 1;
_temp_roundsPerSalvo = _templateArray select 2;
_temp_salvos = _templateArray select 3;
_temp_timePerRound = _templateArray select 4;
_temp_timePerSalvo = _templateArray select 5;
_effectShapeData = _templateArray select 6;
_temp_salvoDrift = _templateArray select 7;
_guided = _templateArray select 8;

if (_guided) then {
    _guidanceObject = _this select 2;
    if (count _this > 3) then {
        _guidanceType = toLower (_this select 3);
    };
};

_effectMarker = [_firePosition, "", "colorBlack", [_effectShapeData select 0, _effectShapeData select 1], _effectShapeData select 2, _effectShapeData select 3, 0] call Zen_SpawnMarker;
_quantAngles = [_effectMarker, 0, 360] call Zen_QuantizeAngles;

sleep RNG(_temp_timePerSalvo);
for "_i" from 1 to RNG(_temp_salvos) do {
    sleep RNG(_temp_timePerSalvo);
    _firePosition = ZEN_FMW_Math_RandomPoint(_firePosition, RNG(_temp_salvoDrift));

    for "_j" from 1 to RNG(_temp_roundsPerSalvo) do {
        sleep RNG(_temp_timePerRound);
        _roundPosition = [_effectMarker, _quantAngles] call Zen_FindPositionPoly;

        if !([_roundType, ["Sh_155mm_AMOS", "Sh_82mm_AMOS", "R_230mm_HE", "smoke_120mm_amos", "mine_155mm_amos_range", "cluster_155mm_amos", "at_mine_155mm_amos_range", "flare_82mm_amos_white", "smoke_82mm_amos_white"]] call Zen_ValueIsInArray) then {
            Zen_Fire_Support_Round_Local = objNull;
            0 = [_roundPosition, _roundType, 1000, 0, true] spawn {
                Zen_Fire_Support_Round_Local = _this call Zen_SpawnVehicle;
            };

            waitUntil {
                !(isNull Zen_Fire_Support_Round_Local)
            };

            _round = Zen_Fire_Support_Round_Local;
            _round setVelocity [0, 0, -200];
            0 = _round spawn {
                while {alive _this} do {
                    _this setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
                };
            };
        } else {
            switch (toLower _roundType) do {
                case "sh_155mm_amos": {
                    _artyVehicleClass = "B_MBT_01_arty_F";
                    _artyMuzzleClass = "mortar_155mm_amos";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "32rnd_155mm_mo_shells";
                };
                case "smoke_120mm_amos": {
                    _artyVehicleClass = "B_MBT_01_arty_F";
                    _artyMuzzleClass = "mortar_155mm_amos";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "6rnd_155mm_mo_smoke";
                };
                case "mine_155mm_amos_range": {
                    _artyVehicleClass = "B_MBT_01_arty_F";
                    _artyMuzzleClass = "mortar_155mm_amos";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "6rnd_155mm_mo_mine";
                };
                case "cluster_155mm_amos": {
                    _artyVehicleClass = "B_MBT_01_arty_F";
                    _artyMuzzleClass = "mortar_155mm_amos";
                    _artyFireMode = "single3";
                    _artyWeaponMag = "2rnd_155mm_mo_cluster";
                };
                case "at_mine_155mm_amos_range": {
                    _artyVehicleClass = "B_MBT_01_arty_F";
                    _artyMuzzleClass = "mortar_155mm_amos";
                    _artyFireMode = "single4";
                    _artyWeaponMag = "6rnd_155mm_mo_at_mine";
                };
                case "sh_82mm_amos": {
                    _artyVehicleClass = "B_Mortar_01_F";
                    _artyMuzzleClass = "mortar_82mm";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "8rnd_82mm_mo_shells";
                };
                case "flare_82mm_amos_white": {
                    _artyVehicleClass = "B_Mortar_01_F";
                    _artyMuzzleClass = "mortar_82mm";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "8rnd_82mm_mo_flare_white";
                };
                case "smoke_82mm_amos_white": {
                    _artyVehicleClass = "B_Mortar_01_F";
                    _artyMuzzleClass = "mortar_82mm";
                    _artyFireMode = "single1";
                    _artyWeaponMag = "8rnd_82mm_mo_smoke_white";
                };
                case "r_230mm_he": {
                    _artyVehicleClass = "B_MBT_01_mlrs_F";
                    _artyMuzzleClass = "rockets_230mm_gat";
                    _artyFireMode = "close";
                    _artyWeaponMag = "12rnd_230mm_rockets";
                };
            };

            _artyVehicle = [([[0,0,0], 50 + random 100, random 360] call Zen_ExtendPosition), _artyVehicleClass, 1000, 0, true] call Zen_SpawnVehicle;
            0 = [_artyVehicle] call Zen_SpawnVehicleCrew;
            hideObject _artyVehicle;
            _artyVehicle allowDamage false;
            _artyVehicle setVelocity [0, 0, 200];

            Zen_Fire_Support_Round_Local = objNull;
            _artyVehicle addEventhandler ["fired", {
                Zen_Fire_Support_Round_Local = _this select 6;
            }];
            _artyVehicle fire [_artyMuzzleClass, _artyFireMode, _artyWeaponMag];

            waitUntil {
                !(isNull Zen_Fire_Support_Round_Local)
            };
            _round = Zen_Fire_Support_Round_Local;

            ZEN_STD_OBJ_DeleteVehCrew(_artyVehicle)
            0 = [_round, _roundPosition, 1000, [0, 0, -200], 0, false] call Zen_TransformObject;
            0 = _round spawn {
                while {alive _this} do {
                    _this setVectorDirAndUp [[0, 0, -1], [0, 1, 0]];
                };
            };
        };

        if (_guided) then {
            if (isServer) then {
                _round setOwner (owner _guidanceObject);
                _args = [_round, _guidanceObject, _guidanceType];
                ZEN_FMW_MP_REClient("Zen_GuideRound", _args, spawn, _guidanceObject)
            } else {
                0 = [_round, _guidanceObject, _guidanceType] spawn Zen_GuideRound;
            };
        };
    };
};

deleteMarker _effectMarker;
call Zen_StackRemove;
if (true) exitWith {};

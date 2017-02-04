// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnGroundVehicle", _this] call Zen_StackAdd;
private ["_spawnPos", "_sideOrClass", "_vehClass", "_veh", "_dir", "_faction", "_DLC"];

if !([_this, [["VOID"], ["SIDE", "ARRAY", "STRING"], ["SCALAR"], ["STRING", "ARRAY"]], [[], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_sideOrClass = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_dir, 2, 0)
ZEN_STD_Parse_GetArgumentDefault(_faction, 3, "All")
ZEN_STD_Parse_GetArgumentDefault(_DLC, 4, "")

if (typeName _sideOrClass != "SIDE") then {
    _vehClass = _sideOrClass;
    if (typeName _vehClass == "ARRAY") then {
        _vehClass = [_vehClass] call Zen_ArrayGetRandom;
    };
} else {
    switch (_sideOrClass) do {
        case west: {
            _vehClass = [([["car", "armored"], _sideOrClass, "All", _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case east: {
            _vehClass = [([["car", "armored"], _sideOrClass, "All", _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case resistance: {
            _vehClass = [([["car", "armored"], _sideOrClass, "All", _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case civilian: {
            _vehClass = [([["car", "armored"], _sideOrClass, "All", _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        default {
            _vehClass = "";
        };
    };
};

if (_vehClass == "") exitWith {
    0 = ["Zen_SpawnGroundVehicle", "Given classname or side is invalid", _this] call Zen_PrintError;
    call Zen_StackRemove;
    (objNull)
};

_veh = [_spawnPos, _vehClass, 0, _dir] call Zen_SpawnVehicle;
0 = [_veh] call Zen_SpawnVehicleCrew;

_veh allowCrewInImmobile true;

call Zen_StackRemove;
(_veh)

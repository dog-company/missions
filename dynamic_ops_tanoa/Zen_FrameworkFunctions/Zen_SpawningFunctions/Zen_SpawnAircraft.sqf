// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnAircraft", _this] call Zen_StackAdd;
private ["_spawnPos", "_sideOrClass", "_aircraftClass", "_aircraft", "_dir", "_height", "_faction", "_DLC"];

if !([_this, [["VOID"], ["SIDE", "ARRAY", "STRING"], ["SCALAR"], ["SCALAR"], ["STRING", "ARRAY"]], [[], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_sideOrClass = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_height, 2, 300)
ZEN_STD_Parse_GetArgumentDefault(_dir, 3, 0)
ZEN_STD_Parse_GetArgumentDefault(_faction, 4, "All")
ZEN_STD_Parse_GetArgumentDefault(_DLC, 5, "")

if (typeName _sideOrClass != "SIDE") then {
    _aircraftClass = _sideOrClass;
    if (typeName _aircraftClass == "ARRAY") then {
        _aircraftClass = [_aircraftClass] call Zen_ArrayGetRandom;
    };
} else {
    switch (_sideOrClass) do {
        case west: {
            _aircraftClass = [([["air", "autonomous"], _sideOrClass, [(localize "str_Zen_UAV"), (localize "str_Zen_Jet")], _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case east: {
            _aircraftClass = [([["air", "autonomous"], _sideOrClass, [(localize "str_Zen_UAV"), (localize "str_Zen_Jet")], _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case resistance: {
            _aircraftClass = [([["air", "autonomous"], _sideOrClass, [(localize "str_Zen_UAV"), (localize "str_Zen_Jet")], _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        };
        case civilian: {
            // 0 = ["Zen_SpawnAircraft", "Civilian side has no planes or UAV's", _this] call Zen_PrintError;
            // call Zen_StackPrint;
            _aircraftClass = [([["air", "autonomous"], _sideOrClass, [(localize "str_Zen_UAV"), (localize "str_Zen_Jet")], _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;};
        default {
            _aircraftClass = "";
        };
    };
};

if (_aircraftClass == "") exitWith {
    0 = ["Zen_SpawnAircraft", "Given classname or side is invalid", _this] call Zen_PrintError;
    call Zen_StackRemove;
    (objNull)
};

_aircraft = [_spawnPos, _aircraftClass, _height, _dir, true] call Zen_SpawnVehicle;
0 = [_aircraft] call Zen_SpawnVehicleCrew;

call Zen_StackRemove;
(_aircraft)

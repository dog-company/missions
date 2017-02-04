// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnInfantry", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_skill", "_group", "_soldierlistrand", "_c", "_spawnNumber", "_cMin", "_cMax", "_soldierlist", "_menType", "_faction", "_filterTypes", "_i", "_DLC"];

if !([_this, [["VOID"], ["SIDE"], ["SCALAR", "ARRAY", "STRING"], ["SCALAR", "ARRAY"], ["STRING"], ["STRING"], ["ARRAY"]], [[], [], ["SCALAR", "ARRAY"], ["SCALAR"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (grpNull)
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;
_skill = _this select 2;
_spawnNumber = _this select 3;

if (typeName _spawnNumber != "ARRAY") then {
    _spawnNumber = [_spawnNumber, _spawnNumber];
};

_menType = "Men";

switch (_side) do {
    case west : {
        _faction = "BLU_F";
    };
    case east: {
        _faction = "OPF_F";
    };
    case resistance: {
        _faction = "IND_F";
    };
    default {
        _faction = "All";
    };
};

if (count _this > 4) then {
    _menType = _this select 4;
};

if (count _this > 5) then {
    _faction = _this select 5;
};

_filterTypes = [];
if (count _this > 6) then {
    _filterTypes = _this select 6;
};

ZEN_STD_Parse_GetArgumentDefault(_DLC, 7, "")

_cMin = _spawnNumber select 0;
_cMax = _spawnNumber select 1;

_soldierlist = [_menType, _side, "All", _faction, "All", "Both", _DLC] call Zen_ConfigGetVehicleClasses;

_soldierlist = [_soldierlist, (["I_crew_F", "I_helipilot_F", "I_helicrew_F", "I_pilot_F", "O_helipilot_F", "O_crew_F", "O_Pilot_F", "O_helicrew_F", "B_Helipilot_F", "B_crew_F", "B_Pilot_F", "B_helicrew_F", "b_soldier_unarmed_f", "b_survivor_f", "b_g_soldier_unarmed_f", "o_soldier_unarmed_f", "i_soldier_unarmed_f", "o_survivor_f", "i_survivor_F", "b_rangemaster_f", "b_competitor_f", "b_g_survivor_F"] + _filterTypes)] call Zen_ArrayFilterValues;

if (count _soldierlist == 0) exitWith {
    0 = ["Zen_SpawnInfantry", "No soldiers found for the given side, type, faction, and blacklist", _this] call Zen_PrintError;
    call Zen_StackRemove;
    (grpNull)
};

_soldierlistrand = [];
_c = [_cMin, _cMax] call Zen_FindInRange;

for "_i" from 1 to _c do {
    _soldierlistrand pushBack ([_soldierlist] call Zen_ArrayGetRandom);
};

_group = [_spawnPos, _soldierlistrand] call Zen_SpawnGroup;

(leader _group) setUnitRank "CORPORAL";
0 = [(units _group), _skill] call Zen_SetAISkill;
_group allowFleeing 0;

call Zen_StackRemove;
(_group)

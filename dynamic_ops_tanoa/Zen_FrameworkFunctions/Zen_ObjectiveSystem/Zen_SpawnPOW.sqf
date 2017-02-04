// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnPOW", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_powClass", "_obj"];

if !([_this, [["VOID"], ["SIDE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;

switch (_side) do {
    case west: {
        _powClass = "b_helipilot_F";
    };
    case east: {
        _powClass = "o_helipilot_F";
    };
    case resistance: {
        _powClass = "i_helipilot_F";
    };
    default {
        0 = ["Zen_SpawnPOW", "Invalid side given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _powClass = "";
    };
};

if (_powClass == "") exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_obj = leader ([_spawnPos, _powClass] call Zen_SpawnGroup);

0 = [_obj, "Crew"] call Zen_SetAISkill;
0 = [_obj, _side, "helicopter pilot"] call Zen_GiveLoadout;

_obj setCaptive true;
_obj disableAI "move";

0 = _obj spawn {
    sleep 0.5;
    removeAllWeapons _this;
    removeBackpack _this;
    removeGoggles _this;
    removeHeadgear _this;
};

call Zen_StackRemove;
([_obj])

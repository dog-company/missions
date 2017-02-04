// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnOfficer", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_officerClass", "_obj"];

if !([_this, [["VOID"], ["SIDE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;

switch (_side) do {
    case west: {
        _officerClass = "b_officer_f";
    };
    case east: {
        _officerClass = "o_officer_f";
    };
    case resistance: {
        _officerClass = "i_officer_f";
    };
    default {
        0 = ["Zen_SpawnOfficer", "Invalid side given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _officerClass = "";
    };
};

if (_officerClass == "") exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_obj = leader ([_spawnPos, _officerClass] call Zen_SpawnGroup);
0 = [_obj, "officer"] call Zen_SetAISkill;
0 = [_obj, _side, "officer"] call Zen_GiveLoadout;

call Zen_StackRemove;
([_obj])

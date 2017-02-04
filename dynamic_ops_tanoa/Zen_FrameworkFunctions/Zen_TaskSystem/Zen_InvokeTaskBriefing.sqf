// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_InvokeTaskBriefing", _this] call Zen_StackAdd;
private ["_units", "_descriptionLong", "_descriptionShort", "_destination", "_nameString", "_parentTask"];

if !([_this, [["VOID"], ["STRING"], ["STRING"], ["STRING"], ["VOID"], ["STRING"]], [], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_descriptionLong = _this select 1;
_descriptionShort = _this select 2;
_nameString = _this select 3;

_destination = [0,0,0];
_parentTask = "";

if (count _this > 4) then {
    if !([(_this select 4), 0] call Zen_ValuesAreEqual) then {
        _destination = [(_this select 4)] call Zen_ConvertToPosition;
    };
};

if (count _this > 5) then {
    _parentTask = _this select 5;
};

if (time > 0.1) exitWith {
    0 = ["Zen_InvokeTaskBriefing", "Use this function only during the briefing", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

Zen_Task_Array_Global pushBack [_nameString, _units, "created", _destination, _descriptionLong, _descriptionShort, _parentTask, []];
0 = [_units, _descriptionLong, _descriptionShort, _destination, false, _nameString, _parentTask] call Zen_InvokeTaskClient;

call Zen_StackRemove;
if (true) exitWith {};

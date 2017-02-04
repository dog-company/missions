// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_InvokeTask", _this] call Zen_StackAdd;
private ["_units", "_descriptionLong", "_descriptionShort", "_destination", "_isCurrent", "_nameString", "_vars", "_parentTask"];

if !([_this, [["VOID"], ["STRING"], ["STRING"], ["VOID"], ["BOOL"], ["STRING"], ["STRING"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_descriptionLong = _this select 1;
_descriptionShort = _this select 2;

_destination = [0,0,0];
_isCurrent = false;
_parentTask = "";
_nameString = format ["Zen_task_global_%1",([10] call Zen_StringGenerateRandom)];

if (count _this > 3) then {
    if !([(_this select 3), 0] call Zen_ValuesAreEqual) then {
        _destination = [(_this select 3)] call Zen_ConvertToPosition;
    };
};

if (count _this > 4) then {
    _isCurrent = _this select 4;
};

if (count _this > 5) then {
    _parentTask = _this select 5;
};

if (count _this > 6) then {
    _nameString = _this select 6;
};

_oldData = [_nameString, false] call Zen_GetTaskDataGlobal;

if (count _oldData > 0) exitWith {
    0 = ["Zen_InvokeTask", "A task with the given name already exists", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (_nameString)
};

Zen_Task_Array_Global pushBack [_nameString, _units, "created", _destination, _descriptionLong, _descriptionShort, _parentTask, []];
publicVariable "Zen_Task_Array_Global";

_vars = [_units, _descriptionLong, _descriptionShort, _destination, _isCurrent, _nameString, _parentTask];
0 = _vars call Zen_InvokeTaskClient;

if (isMultiplayer) then {
    Zen_MP_Closure_Packet = ["Zen_InvokeTaskClient", _vars];
    publicVariable "Zen_MP_Closure_Packet";
};

if (_isCurrent) then {
    0 = [_nameString] call Zen_SetTaskCurrent;
};

if !([_parentTask, ""] call Zen_ValuesAreEqual) then {
    0 = [_parentTask, 0, 0, 0, 0, false, false, _nameString] call Zen_UpdateTask;
};

call Zen_StackRemove;
(_nameString)

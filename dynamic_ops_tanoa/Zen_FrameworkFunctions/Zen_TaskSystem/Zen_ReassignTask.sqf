// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ReassignTask", _this] call Zen_StackAdd;
private ["_nameString", "_unitsAdded", "_unitsRemoved", "_taskArray"];

if !([_this, [["STRING"], ["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_unitsAdded = [(_this select 1)] call Zen_ConvertToObjectArray;

_unitsRemoved = [];

if (count _this > 2) then {
    _unitsRemoved = [(_this select 2)] call Zen_ConvertToObjectArray;
};

_taskArray = [_nameString] call Zen_GetTaskDataGlobal;

if (count _taskArray == 0) exitWith {
    0 = ["Zen_ReassignTask", "Given task does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

0 = [_unitsAdded, (_taskArray select 4), (_taskArray select 5), (_taskArray select 3), false, _nameString, (_taskArray select 6)] call Zen_InvokeTaskClient;

if (count _unitsRemoved > 0) then {
    0 = [_nameString, _unitsRemoved] call Zen_RemoveTaskClient;
};

if (isMultiplayer) then {
    Zen_MP_Closure_Packet = ["Zen_InvokeTaskClient", [_unitsAdded, (_taskArray select 4), (_taskArray select 5), (_taskArray select 3), false, _nameString, (_taskArray select 6)]];
    publicVariable "Zen_MP_Closure_Packet";

    if (count _unitsRemoved > 0) then {
        Zen_MP_Closure_Packet = ["Zen_RemoveTaskClient", [_nameString, _unitsRemoved]];
        publicVariable "Zen_MP_Closure_Packet";
    };
};

{
    if ((_x select 0) == _nameString) exitWith {
        Zen_Task_Array_Global set [_forEachIndex, [(_x select 0), (((_x select 1) - _unitsRemoved) + _unitsAdded), (_x select 2), (_x select 3), (_x select 4), (_x select 5), (_x select 6), (_x select 7)]];
    };
} forEach Zen_Task_Array_Global;
publicVariable "Zen_Task_Array_Global";

0 = [_nameString, 0, 0, 0, 0, false, false] call Zen_UpdateTask;
0 = [] call Zen_CleanGlobalTaskArray;

call Zen_StackRemove;
if (true) exitWith {};

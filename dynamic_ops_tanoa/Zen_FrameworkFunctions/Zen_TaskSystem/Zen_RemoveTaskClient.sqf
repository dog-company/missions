// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

if (count Zen_Task_Array_Local == 0) exitWith {};

_Zen_stack_Trace = ["Zen_RemoveTaskClient", _this] call Zen_StackAdd;
private ["_nameString", "_units", "_unit", "_taskArray", "_localTaskData", "_taskIndexes", "_tasksRemain"];

if !([_this, [["STRING"], ["ARRAY"]], [[], ["OBJECT"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_units = _this select 1;

if (count _units == 0) exitWith {
    call Zen_StackRemove;
};

_taskIndexes = [Zen_Task_Array_Local, _nameString, 0] call Zen_ArrayGetNestedIndex;

if (count _taskIndexes == 0) exitWith {
    call Zen_StackRemove;
};

_localTaskData = Zen_Task_Array_Local select (_taskIndexes select 0);
_taskArray = _localTaskData select 1;
_tasksRemain = [];

{
    _unit = _x;
    {
        if !(isNull _x) then {
            if (_x in simpleTasks _unit) then {
                _unit removeSimpleTask _x;
            } else {
                _tasksRemain pushBack _x;
            };
        };
    } forEach _taskArray;
} forEach _units;

Zen_Task_Array_Local set [(_taskIndexes select 0), [_nameString, _tasksRemain]];
0 = [] call Zen_CleanLocalTaskArray;

if ((!isDedicated && hasInterface) && {(player in _units)}) then {
    0 = ["TaskRemoved", ["", (([_nameString] call Zen_GetTaskDataGlobal) select 5)]] call bis_fnc_showNotification;
};

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_AreTasksComplete", _this] call Zen_StackAdd;
private ["_taskArray", "_taskState", "_tasksComplete", "_taskData"];

if !([_this, [["ARRAY", "STRING"], ["ARRAY", "STRING"]], [["STRING"], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_taskArray = _this select 0;

_taskState = ["failed", "succeeded", "canceled"];
if (count _this > 1) then {
    _taskState = _this select 1;
};

if (typeName _taskArray != "ARRAY") then {
    _taskArray = [_taskArray];
};

_tasksComplete = true;

{
    _taskData = [_x] call Zen_GetTaskDataGlobal;
    if !([(_taskData select 2), _taskState] call Zen_ValueIsInArray) exitWith {
        _tasksComplete = false;
    };
} forEach _taskArray;

call Zen_StackRemove;
(_tasksComplete)

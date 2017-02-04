// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_InvokeTaskClient", _this] call Zen_StackAdd;
private ["_descriptionLong", "_descriptionShort", "_destination", "_isCurrent", "_nameString", "_task", "_units", "_localTaskArray", "_parentTaskLocal", "_parentTask", "_parentDataLocal", "_taskIndex", "_localTaskData", "_taskIndexes"];

if !([_this, [["ARRAY"], ["STRING"], ["STRING"], ["ARRAY"], ["BOOL"], ["STRING"], ["STRING"]], [["OBJECT"], [], [], ["SCALAR"]], 7] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = _this select 0;
_descriptionLong = _this select 1;
_descriptionShort = _this select 2;
_destination = _this select 3;
_isCurrent = _this select 4;
_nameString = _this select 5;
_parentTask = _this select 6;

if (count _units == 0) exitWith {
    call Zen_StackRemove;
};

_localTaskArray = [];
_parentTaskLocal = taskNull;

{
    private "_unit";
    _unit = _x;

    if !([_parentTask, ""] call Zen_ValuesAreEqual) then {
        _parentDataLocal = [_parentTask] call Zen_GetTaskDataLocal;
        if (count _parentDataLocal == 0) then {
            if (time > 0.25) then {
                0 = ["Zen_InvokeTaskClient", "Given parent task does not exist.", _this] call Zen_PrintError;
                call Zen_StackPrint;
            } else {
                0 = [+_Zen_stack_Trace, _this] spawn {
                    private ["_Zen_stack_Trace", "_args"];
                    _Zen_stack_Trace = _this select 0;
                    _args = _this select 1;
                    sleep 1;
                    0 = ["Zen_InvokeTaskClient", "Given parent task does not exist.", _args] call Zen_PrintError;
                    call Zen_StackPrint;
                };
            };
        } else {
            {
                if (_x in simpleTasks _unit) exitWith {
                    _parentTaskLocal = _x;
                };
            } forEach (([_parentTask] call Zen_GetTaskDataLocal) select 1);
        };
    };

    _task = _unit createSimpleTask [(format ["Zen_task_local_%1",([10] call Zen_StringGenerateRandom)]), _parentTaskLocal];
    _task setSimpleTaskDescription [_descriptionLong, _descriptionShort, _descriptionShort];

    if !([_destination, [0,0,0]] call Zen_ValuesAreEqual) then {
        _task setSimpleTaskDestination _destination;
    };

    _localTaskArray pushBack _task;
} forEach _units;

_localTaskData = [_nameString] call Zen_GetTaskDataLocal;

if (count _localTaskData > 0) then {
    _taskIndexes = [Zen_Task_Array_Local, _nameString, 0] call Zen_ArrayGetNestedIndex;

    if (count _taskIndexes == 0) then {
        _taskIndex = count Zen_Task_Array_Local;
    } else {
        _taskIndex = _taskIndexes select 0;
    };

    Zen_Task_Array_Local set [_taskIndex, [_nameString, ((_localTaskData select 1) + _localTaskArray)]];
} else {
    Zen_Task_Array_Local pushBack [_nameString, _localTaskArray];
};

if (!(_isCurrent) && {(!isDedicated && hasInterface)}) then {
    if (player in _units) then {
        0 = ["TaskCreated", ["", _descriptionShort]] call bis_fnc_showNotification;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

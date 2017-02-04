// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

if ((count Zen_Task_Array_Global) == 0) exitWith {};
if ((count Zen_Task_Array_Local) == 0) exitWith {};

_Zen_stack_Trace = ["Zen_UpdateTaskClient", _this] call Zen_StackAdd;
private ["_unitsTasksArrayGlobal", "_unitsTasksArrayLocal", "_nameString", "_currentTaskArray", "_destination", "_state", "_taskState", "_description", "_title", "_cfgNotifyClass", "_units", "_showNotification"];

if !([_this, [["STRING"], ["STRING", "SCALAR"], ["BOOL"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_taskState = _this select 1;
_showNotification = _this select 2;

_unitsTasksArrayGlobal = [_nameString] call Zen_GetTaskDataGlobal;
_unitsTasksArrayLocal = [_nameString] call Zen_GetTaskDataLocal;

if ((count _unitsTasksArrayGlobal) == 0) exitWith {
    call Zen_StackRemove;
};

if ((count _unitsTasksArrayLocal) == 0) exitWith {
    call Zen_StackRemove;
};

_currentTaskArray = _unitsTasksArrayLocal select 1;

_units = _unitsTasksArrayGlobal select 1;
_state = _unitsTasksArrayGlobal select 2;
_destination = _unitsTasksArrayGlobal select 3;
_description = _unitsTasksArrayGlobal select 4;
_title = _unitsTasksArrayGlobal select 5;

if !([_destination, [0,0,0]] call Zen_ValuesAreEqual) then {
    {
        _x setSimpleTaskDestination _destination;
    } forEach _currentTaskArray;
} else {
    {
        cancelSimpleTaskDestination _x;
    } forEach _currentTaskArray;
};

{
    if !((_x == currentTask player) && {(_state == "created")}) then {
        _x setTaskState _state;
    };
    _x setSimpleTaskDescription [_description, _title, _title];
} forEach _currentTaskArray;

if (!(isDedicated && hasInterface) && {_showNotification}) then {
    if (player in _units) then {
        if !([_taskState, "Created"] call Zen_ValuesAreEqual) then {
            _cfgNotifyClass = "Task" + ([(toLower _state)] call Zen_StringCapitalizeLetter);
        } else {
            _cfgNotifyClass = "TaskUpdated";
        };
        0 = [_cfgNotifyClass, ["", _title]] call bis_fnc_showNotification;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

if ((count Zen_Task_Array_Local) == 0) exitWith {};

_Zen_stack_Trace = ["Zen_SetTaskTargetClient", _this] call Zen_StackAdd;
private ["_nameString", "_taskArray", "_localTaskData", "_globalTaskData", "_taskUnits", "_target"];

if !([_this, [["STRING"], ["OBJECT"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_target = _this select 1;

_localTaskData = [_nameString] call Zen_GetTaskDataLocal;
_globalTaskData = [_nameString] call Zen_GetTaskDataGlobal;

_taskArray = _localTaskData select 1;
_taskUnits = _globalTaskData select 1;

{
    _x setSimpleTaskTarget [_target, true];
} forEach _taskArray;

if ((!isDedicated && hasInterface) && {(player in _taskUnits)}) then {
    0 = ["TaskUpdated", ["", (_globalTaskData select 5)]] call bis_fnc_showNotification;
};

call Zen_StackRemove;
if (true) exitWith {};

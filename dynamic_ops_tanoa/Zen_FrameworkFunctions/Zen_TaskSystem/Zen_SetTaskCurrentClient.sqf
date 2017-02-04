// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetTaskCurrentClient", _this] call Zen_StackAdd;
private ["_nameString", "_units", "_taskArray", "_unit", "_localTaskData"];

if !([_this, [["STRING"], ["ARRAY"]], [[], ["OBJECT"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_units = _this select 1;

_localTaskData = [_nameString] call Zen_GetTaskDataLocal;

if (count _localTaskData == 0) then {
    waitUntil {
        sleep 1;
        ((count ([_nameString] call Zen_GetTaskDataLocal)) > 0)
    };

    _localTaskData = [_nameString] call Zen_GetTaskDataLocal;
};

_taskArray = _localTaskData select 1;

{
    _unit = _x;
    {
        if (_x in simpleTasks _unit) then {
            _unit setCurrentTask _x;
        };
    } forEach _taskArray;
} forEach _units;

if ((!isDedicated && hasInterface) && {(player in _units)}) then {
    0 = ["TaskAssigned", ["", (([_nameString] call Zen_GetTaskDataGlobal) select 5)]] call bis_fnc_showNotification;
};

call Zen_StackRemove;
if (true) exitWith {};

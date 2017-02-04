// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_RemoveTask", _this] call Zen_StackAdd;
private ["_nameString", "_units", "_taskArray"];

if !([_this, [["STRING"], ["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;

_taskArray = [_nameString] call Zen_GetTaskDataGlobal;

if (count _taskArray == 0) exitWith {
    0 = ["Zen_RemoveTask", "Given task does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

if (count _this > 1) then {
    _units = [(_this select 1)] call Zen_ConvertToObjectArray;
} else {
    _units = _taskArray select 1;
};

{
    if ((_x select 0) == _nameString) then {
        Zen_Task_Array_Global set [_forEachIndex, [(_x select 0), ((_x select 1) - _units), (_x select 2), (_x select 3), (_x select 4), (_x select 5), (_x select 6), (_x select 7)]];
    };
} forEach Zen_Task_Array_Global;
publicVariable "Zen_Task_Array_Global";

0 = [_nameString, _units] call Zen_RemoveTaskClient;

if (isMultiplayer) then {
    Zen_MP_Closure_Packet = ["Zen_RemoveTaskClient", [_nameString, _units]];
    publicVariable "Zen_MP_Closure_Packet";
};

0 = [] call Zen_CleanGlobalTaskArray;

call Zen_StackRemove;
if (true) exitWith {};

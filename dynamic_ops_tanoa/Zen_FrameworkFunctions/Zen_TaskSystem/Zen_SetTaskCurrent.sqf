// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetTaskCurrent", _this] call Zen_StackAdd;
private ["_vars", "_nameString", "_taskArray", "_units"];

if !([_this, [["STRING"], ["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;

if (count _this > 1) then {
    _units = [(_this select 1)] call Zen_ConvertToObjectArray;
    _vars = [_nameString, _units];
} else {
    _vars = [_nameString, (([_nameString] call Zen_GetTaskDataGlobal) select 1)];
};

_taskArray = [_nameString] call Zen_GetTaskDataGlobal;

if (count _taskArray == 0) exitWith {
    0 = ["Zen_SetTaskCurrent", "Given task does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

0 = _vars call Zen_SetTaskCurrentClient;

if (isMultiplayer) then {
    Zen_MP_Closure_Packet = ["Zen_SetTaskCurrentClient", _vars];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

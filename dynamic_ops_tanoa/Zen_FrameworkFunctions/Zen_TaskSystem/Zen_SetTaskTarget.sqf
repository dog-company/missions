// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetTaskTarget", _this] call Zen_StackAdd;
private ["_taskString", "_destination", "_taskArray"];

if !([_this, [["STRING"], ["OBJECT"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_taskString = _this select 0;
_destination = _this select 1;

_taskArray = [_taskString] call Zen_GetTaskDataGlobal;

if (count _taskArray == 0) exitWith {
    0 = ["Zen_SetTaskTarget", "Given task does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

0 = _this call Zen_SetTaskTargetClient;

if (isMultiplayer) then {
    Zen_MP_Closure_Packet = ["Zen_SetTaskTargetClient", _this];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

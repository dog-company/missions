// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetTaskDataGlobal", _this] call Zen_StackAdd;
private ["_nameString", "_printError", "_taskArray"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_nameString = _this select 0;

_printError = true;
if (count _this > 1) then {
    _printError = _this select 1;
};

_taskArray = [];

{
    if ([(_x select 0), _nameString] call Zen_ValuesAreEqual) exitWith {
        _taskArray =+ _x;
    };
} forEach Zen_Task_Array_Global;

if ((_printError) && {count _taskArray == 0}) then {
    0 = ["Zen_GetTaskDataGlobal", "Given task does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(_taskArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetTaskDataLocal", _this] call Zen_StackAdd;
private ["_nameString", "_taskArray"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_nameString = _this select 0;
_taskArray = [];

{
    if ([(_x select 0), _nameString] call Zen_ValuesAreEqual) exitWith {
        _taskArray =+ _x;
    };
} forEach Zen_Task_Array_Local;

call Zen_StackRemove;
(_taskArray)

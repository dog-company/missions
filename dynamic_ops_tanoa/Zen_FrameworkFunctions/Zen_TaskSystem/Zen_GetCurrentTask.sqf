// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetCurrentTask", _this] call Zen_StackAdd;
private ["_unit", "_unitTasks"];

if !([_this, [["OBJECT"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_unit = _this select 0;

if (local _unit) then {
    _nameString = "";
    _curTask = currentTask _unit;

    if !(isNull _curTask) then {
        {
            if (_curTask in (_x select 1)) exitWith {
                _nameString = _x select 0;
            };
        } forEach Zen_Task_Array_Local;
    };

    _unit setVariable ["Zen_Current_Task", _nameString, true];
} else {
    ZEN_FMW_MP_REClient("Zen_GetCurrentTask", _this, call, _unit)

    waitUntil {
        ZEN_STD_Code_SleepFrames(5)
        !((_unit getVariable ["Zen_Current_Task", 0]) isEqualTo 0)
    };
};

call Zen_StackRemove;
(_unit getVariable "Zen_Current_Task")

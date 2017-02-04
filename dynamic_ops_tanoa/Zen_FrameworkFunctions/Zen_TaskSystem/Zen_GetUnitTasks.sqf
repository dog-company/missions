// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetUnitTasks", _this] call Zen_StackAdd;
private ["_unit", "_unitTasks"];

if !([_this, [["OBJECT"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_unit = _this select 0;
_unitTasks = [];

{
    if (_unit in (_x select 1)) then {
        _unitTasks pushBack (_x select 0);
    };
} forEach Zen_Task_Array_Global;

call Zen_StackRemove;
(_unitTasks)

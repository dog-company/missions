// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_RemoveFireSupport", _this] call Zen_StackAdd;
private ["_fireSupportName", "_indexes"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_fireSupportName = _this select 0;

_indexes = [Zen_Fire_Support_Array_Global, _fireSupportName, 0] call Zen_ArrayGetNestedIndex;

if (count _indexes == 0) exitWith {
    0 = ["Zen_RemoveFireSupport", "Given template does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

0 = [Zen_Fire_Support_Array_Global, (_indexes select 0)] call Zen_ArrayRemoveIndex;
publicVariable "Zen_Fire_Support_Array_Global";

call Zen_StackRemove;
if (true) exitWith {};

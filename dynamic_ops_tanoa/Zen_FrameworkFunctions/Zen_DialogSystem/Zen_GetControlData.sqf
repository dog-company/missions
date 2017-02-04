// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetControlData", _this] call Zen_StackAdd;
private ["_controlID", "_index", "_controlData"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_controlID = _this select 0;

_index = [Zen_Control_Classes_Global, _controlID, 0] call Zen_ArrayGetNestedIndex;
if (count _index == 0) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_GetControlData", "Invalid control class given", [])
};

_index = _index select 0;
_controlData = Zen_Control_Classes_Global select _index;

call Zen_StackRemove;
(+_controlData)

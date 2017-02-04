// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_RemoveTemplate", _this] call Zen_StackAdd;
private ["_template", "_indexes"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_template = _this select 0;

_indexes = [Zen_Template_Array_Global, _template, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes < 1) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveTemplate", "Invalid template name")
};

0 = [Zen_Template_Array_Global, (_indexes select 0)] call Zen_ArrayRemoveIndex;

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_RemoveDialog", _this] call Zen_StackAdd;
private ["_dialogID", "_index"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_dialogID = _this select 0;

_index = [Zen_Dialog_Classes_Global, _dialogID, 0] call Zen_ArrayGetNestedIndex;
if (count _index == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveDialog", "Invalid dialog class given")
};

_index = _index select 0;
0 = [Zen_Dialog_Classes_Global, _index] call Zen_ArrayRemoveIndex;
publicVariable "Zen_Dialog_Classes_Global";

call Zen_StackRemove;
if (true) exitWith {};

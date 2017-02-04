// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_CreateDialog", _this] call Zen_StackAdd;
private ["_ID"];

if !([_this, [["STRING"]], [], 0] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_ID = "Zen_Dialog_" + ([10] call Zen_StringGenerateRandom);
ZEN_STD_Parse_GetArgument(_ID, 0)

Zen_Dialog_Classes_Global pushBack [_ID, []];
publicVariable "Zen_Dialog_Classes_Global";

call Zen_StackRemove;
(_ID)

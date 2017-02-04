// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_RemoveCache", _this] call Zen_StackAdd;
private ["_nameString", "_indexes"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;

if ([_nameString] call Zen_IsCached) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveCache", "Cannot remove a cached identifier.")
};

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveCache", "Invalid cache identifier given.")
};

0 = [Zen_Cache_Array, (_indexes select 0)] call Zen_ArrayRemoveIndex;

call Zen_StackRemove;
if (true) exitWith {};

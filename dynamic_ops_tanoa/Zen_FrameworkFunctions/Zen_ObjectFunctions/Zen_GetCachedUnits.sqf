// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetCachedUnits", _this] call Zen_StackAdd;
private ["_nameString", "_indexes", "_array"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_nameString = _this select 0;

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_GetCachedUnits", "Invalid cache identifier given.", [])
};

_array = Zen_Cache_Array select (_indexes select 0);

call Zen_StackRemove;
+(_array select 2)

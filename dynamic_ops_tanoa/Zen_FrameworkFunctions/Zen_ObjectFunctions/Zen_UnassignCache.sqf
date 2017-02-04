// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_UnassignCache", _this] call Zen_StackAdd;
private ["_nameString", "_indexes"];

if !([_this, [["VOID"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_nameString = _this select 1;

if ([_nameString] call Zen_IsCached) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_UnassignCache", "Cannot unassign from a cached identifier.")
};

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_UnassignCache", "Invalid cache identifier given.")
};

_array = Zen_Cache_Array select (_indexes select 0);
_indexesToRemove = [];
{
    _groupedUnits = _x;
    {
        0 = [_groupedUnits, _x] call Zen_ArrayRemoveValue;
    } forEach _units;
    if (count _x == 0) then {
        _indexesToRemove pushBack _forEachIndex;
    };
} forEach (_array select 2);

ZEN_FMW_Array_RemoveIndexes((_array select 2), _indexesToRemove)

call Zen_StackRemove;
if (true) exitWith {};

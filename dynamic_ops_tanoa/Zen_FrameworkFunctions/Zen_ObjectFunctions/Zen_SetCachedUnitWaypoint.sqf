// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SetCachedUnitWaypoint", _this] call Zen_StackAdd;
private ["_nameString", "_indexes", "_array", "_unit", "_index", "_mode", "_waypoints"];

if !([_this, [["STRING"], ["OBJECT"], ["SCALAR"], ["STRING"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_unit = _this select 1;
_index = _this select 2;
ZEN_STD_Parse_GetArgumentDefault(_mode, 3, "Relative")

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_SetCachedUnitWaypoint", "Invalid cache identifier given.")
};

_array = Zen_Cache_Array select (_indexes select 0);

_indexes = [(_array select 2), _unit, -1] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_SetCachedUnitWaypoint", "Given unit is not assigned to given identifier.")
};

if (toUpper _mode == "ABSOLUTE") then {
    _waypoints = (_array select 4);
    _waypoints set [(_indexes select 0), _index];
} else {
    _waypoints = (_array select 4);
    _waypoints set [(_indexes select 0), (_waypoints select (_indexes select 0)) + _index];
};

call Zen_StackRemove;
if (true) exitWith {};

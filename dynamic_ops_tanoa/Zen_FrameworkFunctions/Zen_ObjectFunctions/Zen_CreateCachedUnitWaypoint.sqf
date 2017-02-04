// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_CreateCachedUnitWaypoint", _this] call Zen_StackAdd;
private ["_nameString", "_indexes", "_array", "_unit", "_index", "_behavior", "_combatMode", "_radius", "_formation", "_loiterRadius", "_loiter", "_pos", "_script", "_speed", "_statements", "_timeOut", "_type", "_waypoints", "_statementsDef"];

if !([_this, [["STRING"], ["OBJECT"], ["VOID"], ["STRING", "SCALAR"], ["SCALAR"], ["STRING", "SCALAR"], ["STRING", "SCALAR"], ["STRING", "SCALAR"], ["STRING", "SCALAR"], ["SCALAR"], ["STRING", "SCALAR"], ["STRING", "SCALAR"], ["ARRAY"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_unit = _this select 1;
_pos = [(_this select 2)] call Zen_ConvertToPosition;

_statementsDef = [true, ""];
ZEN_STD_Parse_GetArgumentDefault(_type, 3, "Move")
ZEN_STD_Parse_GetArgumentDefault(_radius, 4, -1)
ZEN_STD_Parse_GetArgumentDefault(_behavior, 5, "Aware")
ZEN_STD_Parse_GetArgumentDefault(_combatMode, 6, "Yellow")
ZEN_STD_Parse_GetArgumentDefault(_speed, 7, "Normal")
ZEN_STD_Parse_GetArgumentDefault(_formation, 8, "Wedge")
ZEN_STD_Parse_GetArgumentDefault(_loiterRadius, 9, -1)
ZEN_STD_Parse_GetArgumentDefault(_loiter, 10, "Circle")
ZEN_STD_Parse_GetArgumentDefault(_script, 11, "")
ZEN_STD_Parse_GetArgumentDefault(_statements, 12, _statementsDef)
ZEN_STD_Parse_GetArgumentDefault(_timeOut, 13, 0)

if (typeName _behavior == "SCALAR") then {
    _behavior = "Aware";
};

if (typeName _combatMode == "SCALAR") then {
    _combatMode = "Yellow";
};

if (typeName _formation == "SCALAR") then {
    _formation = "Wedge";
};

if (typeName _loiter == "SCALAR") then {
    _loiter = "Circle";
};

if (typeName _script == "SCALAR") then {
    _script = "";
};

if (typeName _speed == "SCALAR") then {
    _speed = "Normal";
};

if !([_nameString] call Zen_IsCached) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_UnassignCache", "Cannot unassign an abstract waypoint to an uncached identifier.")
};

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_CreateCachedUnitWaypoint", "Invalid cache identifier given.")
};

_array = Zen_Cache_Array select (_indexes select 0);

_indexes = [(_array select 2), _unit, -1] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_CreateCachedUnitWaypoint", "Given unit is not assigned to given identifier.")
};

_waypoints = (_array select 3) select (_indexes select 0);
_waypoints pushBack [_behavior, _combatMode, _radius, _formation, _loiterRadius, _loiter, _pos, _script, _speed, _statements, _timeOut, _type];

call Zen_StackRemove;
if (true) exitWith {};

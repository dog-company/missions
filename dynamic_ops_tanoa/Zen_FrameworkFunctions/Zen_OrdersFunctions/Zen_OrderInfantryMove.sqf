// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderInfantryMove", _this] call Zen_StackAdd;
private ["_group", "_movePos", "_speedMode", "_behaviorMode", "_combatMode"];

if !([_this, [["OBJECT", "GROUP"], ["VOID"], ["STRING"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_group = _this select 0;
_movePos = [(_this select 1)] call Zen_ConvertToPosition;

ZEN_STD_Parse_GetArgumentDefault(_speedMode, 2, "normal")
ZEN_STD_Parse_GetArgumentDefault(_behaviorMode, 3, "safe")
ZEN_STD_Parse_GetArgumentDefault(_combatMode, 4, "green")

if (typeName _group == "OBJECT") then {
    _group = group _group;
};

_group setCurrentWaypoint (_group addWaypoint [_movePos, -1]);
_group setBehaviour _behaviorMode;
_group setCombatMode _combatMode;
_group setSpeedMode _speedMode;
_group allowFleeing 0;

sleep 5;

waitUntil {
    sleep 2;
    (((alive leader _group) && {(unitReady leader _group)}) || (({alive _x} count units _group) == 0) || (([_group, _movePos] call Zen_Find2dDistance) < 25))
};

// _group move (getPosATL (leader _group));

call Zen_StackRemove;
if (true) exitWith {};

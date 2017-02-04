// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_UnCache", _this] call Zen_StackAdd;
private ["_F_Uncache", "_nameString", "_units", "_indexes", "_array", "_side", "_group"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_F_Uncache = {
    {
        _x hideObjectGlobal false;
        _x enableSimulationGlobal true;
        if (_x isKindOf "Man") then {
            ZEN_FMW_MP_REClient("Zen_UnCache_AIDisable_MP", _x, call, _x)
        };
    } forEach (_this select 0);
};

_nameString = _this select 0;
_units = [_nameString] call Zen_GetCachedUnits;
_waypoints = [_nameString] call Zen_GetCachedUnitsWaypoints;

_indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
_array = Zen_Cache_Array select (_indexes select 0);

{
    if ((count _x > 0) && {((_x select 0) isKindOf "MAN")}) then {
        _side = side (_x select 0);
        if (({side _x == _side} count allGroups) <= 143) then {
            _group = createGroup _side;
            _x join _group;

            {
                _waypoint = _group addWaypoint [(_x select 6), (_x select 2), _forEachIndex];
                _waypoint setWaypointBehaviour (_x select 0);
                _waypoint setWaypointCombatMode (_x select 1);
                // _waypoint setWaypointCompletionRadius _x,
                _waypoint setWaypointFormation (_x select 3);
                _waypoint setWaypointLoiterRadius (_x select 4);
                _waypoint setWaypointLoiterType (_x select 5);
                // _waypoint setWaypointPosition ,
                _waypoint setWaypointScript (_x select 7);
                _waypoint setWaypointSpeed (_x select 8);
                _waypoint setWaypointStatements (_x select 9);
                _waypoint setWaypointTimeout (_x select 10);
                _waypoint setWaypointType (_x select 11);
            } forEach ((_waypoints select 0) select _forEachIndex);

            if ((count ((_waypoints select 0) select _forEachIndex)) > 0) then {
                _group setCurrentWaypoint [_group, ((_waypoints select 1) select _forEachIndex) - 1];
            };

        } else {
            ZEN_FMW_Code_Error("Zen_Uncache", "Uncaching some units would exceed the maximum number of groups.")
        };
    };
} forEach _units;

0 = [([_units] call Zen_ConvertToObjectArray)] call _F_Uncache;
_array set [1, false];
publicVariable "Zen_Cache_Array";

call Zen_StackRemove;
if (true) exitWith {};

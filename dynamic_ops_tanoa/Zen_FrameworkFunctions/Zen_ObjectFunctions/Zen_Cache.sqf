// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_Cache", _this] call Zen_StackAdd;
private ["_F_Cache", "_F_SideToIndex", "_group", "_refUnit", "_nameString", "_units", "_cacheType", "_indexesToRemove", "_vehicles", "_men", "_cachedData", "_unit", "_unitsGrouped", "_indexes", "_array", "_waypointData", "_waypoints"];

if !([_this, [["VOID"], ["STRING"], ["OBJECT", "GROUP"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_F_Cache = {
    {
        _x hideObjectGlobal true;
        _x enableSimulationGlobal false;
        if (_x isKindOf "Man") then {
            ZEN_FMW_MP_REClient("Zen_Cache_AIDisable_MP", _x, call, _x)
        };
    } forEach (_this select 0);
};

_F_SideToIndex = {
    (switch (_this select 0) do {
        case west: {
            (0)
        };
        case east: {
            (1)
        };
        case resistance: {
            (2)
        };
        case civilian: {
            (3)
        };
        default {
            (-1)
        }
    })
};

if (count Zen_Cache_Group_Array == 0) then {
    {
        Zen_Cache_Group_Array pushBack (createGroup _x);
        _group = [[0,0,0], _x, 0, 1] call Zen_SpawnInfantry;
        (units _group) join (Zen_Cache_Group_Array select _forEachIndex);
        0 = [(units _group)] call _F_Cache;
    } forEach [west, east, resistance, civilian];
    // } forEach [west];
    publicVariable "Zen_Cache_Group_Array";
};

_refUnit = objNull;
if (typeName (_this select 0) == "STRING") then {
    _nameString = _this select 0;
    _units = [([_nameString] call Zen_GetCachedUnits)] call Zen_ConvertToObjectArray;
    _cacheType = "ID";
} else {
    _units = [(_this select 0)] call Zen_ConvertToObjectArray;
    if (count _this > 1) then {
        _cacheType = "ADD";
        _nameString = _this select 1;
        if (count _this > 2) then {
            _refUnit = _this select 2;
            if (typeName _refUnit == "GROUP") then {
                _refUnit = leader _refUnit;
            };
        };
    } else {
        _cacheType = "NEW";
        _nameString = format ["Zen_cache_set_%1",([10] call Zen_StringGenerateRandom)];
    };
};

_indexesToRemove = [];
{
    if !(alive _x) then {
        _indexesToRemove pushBack _forEachIndex;
    };
} forEach _units;
ZEN_FMW_Array_RemoveIndexes(_units, _indexesToRemove)

if ((count _units) == 0) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_Cache", "No cacheable units given", "")
};

_vehicles = [_units, {(_this isKindOf "Man")}] call Zen_ArrayFilterCondition;
_men = [_units, {!(_this isKindOf "Man")}] call Zen_ArrayFilterCondition;

_cachedData = [];
_waypointData = [];
_currentWaypoints = [];
if (isNull _refUnit) then {
    while {count _men > 0} do {
        _unit = _men select 0;
        _unitsGrouped = (units group _unit) arrayIntersect _men;
        {
            0 = [_men, _x] call Zen_ArrayRemoveValue;
        } forEach _unitsGrouped;
        _cachedData pushBack _unitsGrouped;

        _waypoints = [];
        {
            if (_forEachIndex > 0) then {
                _waypoints pushBack [
                    waypointBehaviour _x,
                    waypointCombatMode _x,
                    waypointCompletionRadius _x,
                    waypointFormation _x,
                    waypointLoiterRadius _x,
                    waypointLoiterType _x,
                    waypointPosition _x,
                    waypointScript _x,
                    waypointSpeed _x,
                    waypointStatements _x,
                    waypointTimeout _x,
                    waypointType _x
                ];
            };
        } forEach (waypoints group _unit);
        _waypointData pushBack _waypoints;
        _currentWaypoints pushBack (currentWaypoint group _unit);

        _unitsGrouped join (Zen_Cache_Group_Array select ([side _unit] call _F_SideToIndex));
    };
};

if (count _vehicles > 0) then {
    _cachedData pushBack _vehicles;
};

if (_cacheType == "NEW") then {
    Zen_Cache_Array pushBack [_nameString, true, _cachedData, _waypointData, _currentWaypoints];
    0 = [_units] call _F_Cache;
    publicVariable "Zen_Cache_Array";
} else {
    _indexes = [Zen_Cache_Array, _nameString, 0] call Zen_ArrayGetNestedIndex;
    _array = Zen_Cache_Array select (_indexes select 0);
    if (_cacheType == "ID") then {
        _array set [1, true];
        _array set [2, _cachedData];
        _array set [3, _waypointData];
        _array set [4, _currentWaypoints];

        publicVariable "Zen_Cache_Array";
        0 = [_units] call _F_Cache;
    } else {
        if !(isNull _refUnit) then {
            {
                if (_refUnit in _x) exitWith {
                    _x append _men;
                };
            } forEach (_array select 2);

            (_array select 2) pushBack _vehicles;
            if !(_array select 1) then {
                _men join _refUnit;
            };
        } else {
            (_array select 2) append _cachedData;
            (_array select 3) append _waypointData;
            (_array select 4) append _currentWaypoints;
        };

        if (_array select 1) then {
            0 = [_units] call _F_Cache;
        } else {
            0 = [_nameString] call Zen_Cache;
        };
    };
};

call Zen_StackRemove;
(_nameString)

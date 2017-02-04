// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_CreateObjective", _this] call Zen_StackAdd;
private ["_objType", "_objPos", "_objects", "_rangers", "_convoyStart", "_convoySpeed", "_taskUniqueName", "_side", "_extraVars1", "_extraVars2", "_markerColor", "_objClass", "_triggerType", "_objMarker", "_spawned", "_h_arrive"];

if !([_this, [["VOID"], ["VOID"], ["SIDE"], ["ARRAY", "STRING"], ["STRING"], ["VOID"], ["STRING"]], [[], [], [], ["STRING"], [], ["SCALAR", "STRING"]], 5] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_objPos = [(_this select 0)] call Zen_ConvertToPosition;
_rangers = [(_this select 1)] call Zen_ConvertToObjectArray;
_side = _this select 2;
_objType = _this select 3;
_triggerType = _this select 4;

_objects = [objNull];
_extraVars1 = "";
_extraVars2 = "";

if (typeName _objType == "ARRAY") then {
    if ([["custom", "convoy"], _objType] call Zen_ValuesAreInArray) then {
        0 = ["Zen_CreateObjective", "Both Custom and Convoy cannot be given in random type array", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
    _objType = [_objType] call Zen_ArrayGetRandom;
};

if (count _this > 5) then {
    _extraVars1 = _this select 5;
};

if (count _this > 6) then {
    _extraVars2 = _this select 6;
};

_taskUniqueName = [_rangers, _objType, _objPos, _side, _extraVars1, _triggerType] call Zen_ObjectiveCreateTask;
_objMarker = [_objPos, _side] call Zen_ObjectiveSpawnMarker;

_objMarker setMarkerText (([_taskUniqueName] call Zen_GetTaskDataGlobal) select 5);
0 = [_objMarker, _rangers] call Zen_ShowHideMarkers;

switch (toLower _objType) do {
    case "box": {
        _objects = [([_objPos, _side, true] call Zen_SpawnAmmoBox)];
        0 = [_objPos, 10] call Zen_SpawnFortification;
    };
    case "mortar": {
        _objects = [_objPos, _side] call Zen_SpawnMortar;
        _objects = _objects + (crew (_objects select 0)) + (crew (_objects select 1));
        0 = [_objPos, 10] call Zen_SpawnFortification;
    };
    case "wreck": {
        _objects = [_objPos, _side] call Zen_SpawnWreck;
    };
    case "officer": {
        _objects = [_objPos, _side] call Zen_SpawnOfficer;
        0 = [([_objPos, 5, random 360] call Zen_ExtendPosition)] call Zen_SpawnCamp;
    };
    case "pow": {
        _objects = [_objPos, _side] call Zen_SpawnPOW;
        0 = [([_objPos, 5, random 360] call Zen_ExtendPosition)] call Zen_SpawnCamp;
    };
    case "convoy": {
        _convoyStart = _extraVars1;
        _convoySpeed = "limited";
        if (count _this > 6) then {
            _convoySpeed = _extraVars2;
        };

        _objects = [_convoyStart, _side] call Zen_SpawnConvoy;
        _h_arrive = [(_objects select 0), _objPos, _convoySpeed] spawn Zen_OrderVehicleMove;
        _objDir = (90 - ([(_objects select 0), _objPos] call Zen_FindDirection));

        if !([getDir (_objects select 0), [_objDir - 90, _objDir + 90]] call Zen_IsAngleInSector) then {
            0 = [_objects, 180] call Zen_RotateAsSet;
            sleep 0.2;
            {
                _x setDir ((getDir _x) + 180);
                _x setDamage 0;
            } forEach _objects;
        };

        switch (_side) do {
            case west: {_markerColor = "ColorBlufor";};
            case east: {_markerColor = "ColorOpfor";};
            case resistance: {_markerColor = "ColorIndependent";};
            case civilian: {_markerColor = "ColorCivilian";};
            default {
                0 = ["Zen_CreateObjective", "Invalid side given", _this] call Zen_PrintError;
                call Zen_StackPrint;
            };
        };

        0 = [_convoyStart, "Convoy Start", _markerColor, [0.7,0.7]] call Zen_SpawnMarker;
        0 = [_objects, _objPos] spawn {
            private ["_troopVeh", "_vehicles", "_endPoint", "_troopUnits", "_patrolGroup"];

            _vehicles = _this select 0;
            _endPoint = _this select 1;
            _troopVeh = ZEN_STD_Array_LastElement((_this select 0));

            waitUntil {
                sleep 5;
                (!(canMove _troopVeh) || (((_troopVeh distance _endPoint) < 50) && {(speed _troopVeh < 1)}))
            };

            _troopUnits = (assignedCargo _troopVeh);
            doStop driver _troopVeh;
            ZEN_STD_OBJ_OrderGetOut(_troopUnits, _troopVeh)

            _troopUnits = [_troopUnits] call Zen_ArrayRemoveDead;
            if (count _troopUnits == 0) exitWith {};

            _patrolGroup = createGroup (side (_troopUnits select 0));
            _troopUnits join _patrolGroup;

            sleep 5;
            _troopUnits = [_troopUnits] call Zen_ArrayRemoveDead;
            if (count _troopUnits == 0) exitWith {};

            0 = [_troopUnits, (_troopUnits select 0), [10, 75]] spawn Zen_OrderInfantryPatrol;
            if (true) exitWith {};
        };
    };
    case "custom": {
        if (count _this < 5) exitWith {
            0 = ["Zen_CreateObjective", "Custom objective requires extra arguments", _this] call Zen_PrintError;
            call Zen_StackPrint;
            call Zen_StackRemove;
        };

        _objClass = _extraVars1;
        if (typeName _objClass != "ARRAY") then {
            _objClass = [_objClass];
        };

        _objects = [];
        {
            if (_x isKindOf "man") then {
                _spawned = ([_objPos, _x] call Zen_SpawnGroup);
            } else {
                _spawned = [([_objPos, _x] call Zen_SpawnVehicle)];
            };
            _objects pushBack _spawned;
        } forEach _objClass;

        _objects = [_objects] call Zen_ConvertToObjectArray;
    };
    default {
        0 = ["Zen_CreateObjective", "Invalid objective identifier given", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

switch (toLower _triggerType) do {
    case "eliminate": {
        0 = [_objects, _taskUniqueName, "succeeded"] spawn Zen_TriggerAreDead;
    };
    case "protect": {
        0 = [_objects, _taskUniqueName, "failed"] spawn Zen_TriggerAreDead;
    };
    case "rescue": {
        0 = [_objects, _rangers, _taskUniqueName] spawn Zen_TriggerAreRescued;
    };
    case "reach": {
        0 = [_rangers, _taskUniqueName, "succeeded", _objects] spawn Zen_TriggerAreNear;
    };
    default {
        0 = ["Zen_CreateObjective", "Invalid trigger condition identifier given", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

call Zen_StackRemove;
([_objects, _taskUniqueName])

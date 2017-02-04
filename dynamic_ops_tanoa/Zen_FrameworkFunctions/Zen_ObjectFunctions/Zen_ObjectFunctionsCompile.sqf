// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

Zen_Template_Array_Global = [];
Zen_Cache_Group_Array = [];
Zen_Cache_Array = [];

Zen_DeleteTemplate = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_DeleteTemplate.sqf";
Zen_AreInArea = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreInArea.sqf";
Zen_AreIndoors = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreIndoors.sqf";
Zen_AreInVehicle = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreInVehicle.sqf";
Zen_AreLocal = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreLocal.sqf";
Zen_AreNotInArea = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreNotInArea.sqf";
Zen_AreNotIndoors = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreNotIndoors.sqf";
Zen_AreNotInVehicle = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreNotInVehicle.sqf";
Zen_AreNotLocal = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_AreNotLocal.sqf";
Zen_Cache = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_Cache.sqf";
Zen_CreateCachedUnitWaypoint = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_CreateCachedUnitWaypoint.sqf";
Zen_CreateTemplate = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_CreateTemplate.sqf";
Zen_GetAllInArea = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetAllInArea.sqf";
Zen_GetAllInBuilding = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetAllInBuilding.sqf";
Zen_GetCachedUnits = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetCachedUnits.sqf";
Zen_GetCachedUnitsWaypoints = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetCachedUnitsWaypoints.sqf";
Zen_GetFreeSeats = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetFreeSeats.sqf";
Zen_GetSide = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetSide.sqf";
Zen_GetSideColor = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetSideColor.sqf";
Zen_GetTemplateObjects = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetTemplateObjects.sqf";
Zen_GetTurretPaths = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_GetTurretPaths.sqf";
Zen_IsCached = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_IsCached.sqf";
Zen_IsFacing = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_IsFacing.sqf";
Zen_IsReady = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_IsReady.sqf";
Zen_IsSeen = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_IsSeen.sqf";
Zen_IsVisible = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_IsVisible.sqf";
Zen_MoveAsSet = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_MoveAsSet.sqf";
Zen_MoveInVehicle = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_MoveInVehicle.sqf";
Zen_RemoveCache = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_RemoveCache.sqf";
Zen_RemoveTemplate = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_RemoveTemplate.sqf";
Zen_RotateAsSet = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_RotateAsSet.sqf";
Zen_SetAISkill = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_SetAISkill.sqf";
Zen_SetCachedUnitWaypoint = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_SetCachedUnitWaypoint.sqf";
Zen_SpawnTemplate = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_SpawnTemplate.sqf";
Zen_TrackGroups = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_TrackGroups.sqf";
Zen_TrackInfantry = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_TrackInfantry.sqf";
Zen_TrackVehicles = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_TrackVehicles.sqf";
Zen_TransformObject = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_TransformObject.sqf";
Zen_UnassignCache = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_UnassignCache.sqf";
Zen_UnCache = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_UnCache.sqf";

Zen_Cache_AIDisable_MP = {
    _this disableConversation true;
    {
        _this disableAI _x;
    } forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM", "AIMINGERROR", "SUPPRESSION", "CHECKVISIBLE", "COVER", "AUTOCOMBAT", "PATH"];
};

Zen_UnCache_AIDisable_MP = {
    _this disableConversation false;
    {
        _this enableAI _x;
    } forEach ["TARGET", "AUTOTARGET", "MOVE", "ANIM", "FSM", "AIMINGERROR", "SUPPRESSION", "CHECKVISIBLE", "COVER", "AUTOCOMBAT", "PATH"];
};

Zen_MoveInVehicle_Cargo_MP = {
    private ["_unit", "_vehicle", "_index", "_startTime"];

    _unit = _this select 0;
    _vehicle = _this select 1;
    _index = _this select 2;

    _startTime = time;
    while {(_vehicle != (vehicle _unit)) && {(time < (_startTime + 1))}} do {
        _unit assignAsCargoIndex [_vehicle, _index];
        _unit moveInCargo [_vehicle, _index];
        ZEN_STD_Code_SleepFrames(2)
    };

    if (true) exitWith {};
};

Zen_MoveInVehicle_Driver_MP = {
    private ["_unit", "_vehicle", "_startTime"];

    _unit = _this select 0;
    _vehicle = _this select 1;
    _startTime = time;

    while {!(_unit in _vehicle) && {(time < (_startTime + 1))}} do {
        _unit assignAsDriver _vehicle;
        _unit moveInDriver _vehicle;
        ZEN_STD_Code_SleepFrames(2)
    };

    if (true) exitWith {};
};

Zen_MoveInVehicle_Turret_MP = {
    private ["_unit", "_vehicle", "_turret", "_startTime"];

    _unit = _this select 0;
    _vehicle = _this select 1;
    _turret = _this select 2;
    _startTime = time;

    while {!(_unit in _vehicle) && {(time < (_startTime + 1))}} do {
        _unit assignAsTurret [_vehicle, _turret];
        _unit moveInTurret [_vehicle, _turret];
        ZEN_STD_Code_SleepFrames(2)
    };

    if (true) exitWith {};
};

Zen_TransformObject_Orient_MP = {
    private ["_vehicle", "_velocity", "_dir", "_setNormal"];

    _vehicle = _this select 0;
    _velocity = _this select 1;
    _dir = _this select 2;
    _setNormal = _this select 3;

    ZEN_STD_Code_SleepFrames(5)
    _vehicle setDir _dir;
    if (_setNormal) then {
        _vehicle setVectorUp (surfaceNormal (getPosATL _vehicle));
    };

    ZEN_STD_Code_SleepFrames(5)
    _vehicle setVelocity (ZEN_STD_Math_VectCylCart(_velocity));

    if (true) exitWith {};
};

if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderVehicleMove", _this] call Zen_StackAdd;
private ["_vehicle", "_inPos", "_speedMode", "_vehicleDriver", "_vehicleGrp", "_height", "_cleanupEnd", "_cleanupCrash", "_isCrash", "_completionDistance"];

if !([_this, [["OBJECT"], ["VOID"], ["STRING"], ["SCALAR"], ["BOOL"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicle = _this select 0;
_inPos = [(_this select 1)] call Zen_ConvertToPosition;

_speedMode = "normal";
_height = 50;

if (count _this > 2) then {
    _speedMode = _this select 2;
};

if (count _this > 3) then {
    _height = _this select 3;
};

ZEN_STD_Parse_GetArgumentDefault(_cleanupEnd, 4, false)
ZEN_STD_Parse_GetArgumentDefault(_cleanupCrash, 5, false)

_vehicleDriver = driver _vehicle;
_vehicleGrp = group (driver _vehicle);

_vehicle land "none";

_vehicleDriver enableAI "Move";
_vehicleDriver allowFleeing 0;

if (_vehicle isKindOf "AIR") then {
    _inPos = [_vehicle, _inPos, 75] call Zen_ExtendRay;
};

(group _vehicleDriver) setCurrentWaypoint ((group _vehicleDriver) addWaypoint [_inPos, -1]);

_vehicleGrp setBehaviour "safe";
_vehicleGrp setCombatMode "green";
_vehicleGrp setSpeedMode _speedMode;

if (_vehicle isKindOf "AIR") then {
    _vehicle flyInHeight _height;
    _vehicleGrp setBehaviour "careless";

    _vehicleDriver disableAI "FSM";
    _vehicleDriver disableAI "Target";
    _vehicleDriver disableAI "AutoTarget";
};

_completionDistance = 25;
if (_vehicle isKindOf "AIR") then {
    _completionDistance = 100;
    if (_vehicle isKindOf "PLANE") then {
        _completionDistance = 300;
    };
};

sleep 5;
_isCrash = false;
waitUntil {
    sleep 2;

    if (!(alive _vehicle) || !(alive driver _vehicle) || !(canMove _vehicle)) then {
        _isCrash = true;
    };

    if (_cleanupCrash && {_isCrash && {(ZEN_FMW_Math_DistGreater2D(_vehicle, _inPos, _completionDistance))}}) then {
        if (_vehicle isKindOf "AIR") then {
            waitUntil {
                sleep 2;
                (ZEN_STD_OBJ_ATLPositionZ(_vehicle) < 10)
            };
        };

        sleep 30;
        {
            deleteVehicle _x;
        } forEach ((units _vehicleGrp) + [_vehicle]);
    };

    (((unitReady (driver _vehicle)) || (([_vehicle] call Zen_IsReady))) || (([_vehicle, _inPos] call Zen_Find2dDistance) < _completionDistance) || _isCrash || ((_vehicle isKindOf "SHIP") && ((getTerrainHeightASL getPosATL _vehicle) > -1)))
};

_vehicleDriver enableAI "Move";

sleep 2;
if (_cleanupEnd && {(([_vehicle, _inPos] call Zen_Find2dDistance) < _completionDistance)}) then {
    ZEN_STD_OBJ_DeleteVehCrew(_vehicle);
};

call Zen_StackRemove;
if (true) exitWith {};

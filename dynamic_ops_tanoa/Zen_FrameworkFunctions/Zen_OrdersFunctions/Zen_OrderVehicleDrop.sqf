// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderVehicleDrop", _this] call Zen_StackAdd;
private ["_vehicle", "_posArray", "_className", "_speed", "_heliZ", "_dropPoint", "_dirToDrop", "_destination", "_landScript", "_drop", "_vehicleGrp", "_isCrash", "_vehicleGrp", "_vehicleGrp", "_cleanupCrash"];

if !([_this, [["OBJECT"], ["VOID"], ["OBJECT", "STRING"], ["STRING"], ["SCALAR"], ["BOOL"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicle = _this select 0;
_posArray = _this select 1;
_className = _this select 2;

_speed = "normal";
_heliZ = 80;

if (count _this > 3) then {
    _speed = _this select 3;
};

if (count _this > 4) then {
    _heliZ = _this select 4;
};

ZEN_STD_Parse_GetArgumentDefault(_cleanupCrash, 5, false)

{
    _posArray set [_forEachIndex, ([_x] call Zen_ConvertToPosition)];
} forEach _posArray;

_dropPoint = _posArray select 0;

sleep 2;

_vehicleGrp = group driver _vehicle;
_destination = [_vehicle, _dropPoint, 800] call Zen_ExtendRay;
_landScript = [_vehicle, _destination, _speed, _heliZ] spawn Zen_OrderVehicleMove;

sleep 5;
_isCrash = false;
waitUntil {
    sleep 0.25;

    if (!(alive _vehicle) || !(alive driver _vehicle) || !(canMove _vehicle)) then {
        _isCrash = true;
    };

    if (_cleanupCrash && {_isCrash && {(ZEN_FMW_Math_DistGreater2D(_vehicle, _dropPoint, 100))}}) then {
        waitUntil {
            sleep 2;
            (ZEN_STD_OBJ_ATLPositionZ(_vehicle) < 10)
        };

        sleep 30;
        {
            deleteVehicle _x;
        } forEach ((units _vehicleGrp) + [_vehicle]);
    };

    _dirToDrop = [_vehicle, _dropPoint] call Zen_FindDirection;
    _dirHeli = [(getDir _vehicle)] call Zen_FindTrigAngle;
    ((!([_dirToDrop, [(_dirHeli - 85), (_dirHeli + 85)]] call Zen_IsAngleInSector) && (([_vehicle, _dropPoint] call Zen_Find2dDistance) < 300)) || _isCrash)
};

if !(_isCrash) then {
    ZEN_STD_OBJ_AnimateDoors(_vehicle, 1)
    if (typeName _className == "STRING") then {
        _drop = [_vehicle, _className, (ZEN_STD_OBJ_ATLPositionZ(_vehicle) - 10)] call Zen_SpawnVehicle;
    } else {
        _drop = _className;
    };

    0 = [_drop, _vehicle, -10, ZEN_STD_Math_VectCartCyl((velocity _vehicle)), (random 360)] call Zen_TransformObject;
    sleep 2;
    0 = [_drop] spawn Zen_SpawnParachute;
    sleep 5;
    terminate _landScript;

    ZEN_STD_OBJ_AnimateDoors(_vehicle, 0)
    _landScript = [_vehicle, (_posArray select 1), _speed, _heliZ, false, true] spawn Zen_OrderHelicopterLand;

    waitUntil {
        sleep 2;
        scriptDone _landScript;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

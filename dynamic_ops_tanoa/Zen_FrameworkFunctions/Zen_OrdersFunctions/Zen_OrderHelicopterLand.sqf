// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderHelicopterLand", _this] call Zen_StackAdd;
private ["_heli", "_heliDriver", "_heliGrp", "_heliZ", "_inPos", "_heliCorrectLandPos", "_heliDirToLand", "_speedMode", "_heliPad", "_fastRope", "_cleanupCrash", "_isCrash"];

if !([_this, [["OBJECT"], ["VOID"], ["STRING"], ["SCALAR"], ["BOOL"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_heli = _this select 0;
_inPos = [(_this select 1)] call Zen_ConvertToPosition;

_speedMode = "normal";
_heliZ = 40;
_fastRope = false;

if ((count _this) > 2) then {
    _speedMode = _this select 2;
};

if ((count _this) > 3) then {
    _heliZ = _this select 3;
};

if (count _this > 4) then {
    _fastRope = _this select 4;
};

ZEN_STD_Parse_GetArgumentDefault(_cleanupCrash, 5, false)

_heliDriver = driver _heli;
_heliGrp = group _heliDriver;

if !(_fastRope) then {
    _heliPad = [_inPos, "Land_helipadempty_f", 0, 0, true] call Zen_SpawnVehicle;
};

{
    _x enableAI "Move";
    _x allowFleeing 0;
    _x enableAttack false;
} forEach (units _heliGrp);

_heli land "none";
_heliCorrectLandPos = [_heli, _inPos, 50] call Zen_ExtendRay;

ZEN_STD_OBJ_AnimateDoors(_heli, 0)

_heliDriver disableAI "FSM";
_heliDriver disableAI "Target";
_heliDriver disableAI "AutoTarget";

(group _heliDriver) setCurrentWaypoint ((group _heliDriver) addWaypoint [_heliCorrectLandPos, -1]);
_heliGrp setBehaviour "careless";
_heliGrp setCombatMode "green";
_heliGrp setSpeedMode _speedMode;
_heli flyInHeight _heliZ;

_isCrash = false;
waitUntil {
    sleep 2;

    if (!(alive _heli) || !(alive driver _heli) || !(canMove _heli)) then {
        _isCrash = true;
    };

    if (_cleanupCrash && {_isCrash && {(ZEN_FMW_Math_DistGreater2D(_heli, _inPos, 100))}}) then {
        waitUntil {
            sleep 2;
            (ZEN_STD_OBJ_ATLPositionZ(_heli) < 10)
        };

        sleep 30;
        {
            deleteVehicle _x;
        } forEach ((units _heliGrp) + [_heli]);
    };

    ((unitReady _heliDriver) || {_isCrash})
};

if !(_isCrash) then {
    if (_fastRope) then {
        while {([_heli, _inPos] call Zen_Find2dDistance) > 0.5} do {
            sleep 0.1;
            _heliDirToLand = [_heli, _inPos] call Zen_FindDirection;
            _heli setVelocity [10 * (cos _heliDirToLand), 10 * (sin _heliDirToLand), 0];
        };

        _heli setVelocity [0, 0, -5];
        _heli setVectorUp [0, 0, 1];

        _heli flyInHeight 30;
        waitUntil {
            sleep 0.2;
            _heli setVelocity [0, 0, -5];
            ((ZEN_STD_OBJ_ATLPositionZ(_heli) < 31) || !(alive _heli))
        };

        _heli setVelocity [0, 0, 0];
        _heli setVectorUp [0, 0, 1];
        _heli land "none";
        // sleep 1;
    } else {
        if !(surfaceIsWater (getPosATL _heli)) then {
            _heli flyInHeight 0;
            _heli land "land";

            waitUntil {
                sleep 1;
                ((isTouchingGround _heli) || !(alive _heli))
            };

            _heli flyInHeight 0;
        } else {
            _heli land "none";
            _heli flyInHeight 4;

            waitUntil {
                sleep 1;
                ((ZEN_STD_OBJ_ASLPositionZ(_heli) < 6) || !(alive _heli))
            };
        };

        ZEN_STD_OBJ_AnimateDoors(_heli, 1)
        // deleteVehicle _heliPad;
    };
};

// sleep 2;

call Zen_StackRemove;
if (true) exitWith {};

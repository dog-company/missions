// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderFastRope", _this] call Zen_StackAdd;
private ["_heli", "_activator", "_units", "_h_holdPos", "_offsetL", "_stopHeight", "_ropeStartPos", "_groundPos", "_linkGround", "_ropeGround", "_linkAir", "_ropeAir", "_args"];

if !([_this, [["OBJECT"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_heli = _this select 0;

if (count _this > 2) then {
    _activator = _this select 1;
    _units = [_activator];

    _turrets = [_heli, "CargoFFV"] call Zen_GetTurretPaths;
    _turretUnits = [];
    {
        _turretUnits pushBack (_heli turretUnit _x);
    } forEach _turrets;

    // player commandChat str _turrets;
    // player commandChat str _turretUnits;
    _turretUnits = [_turretUnits] call Zen_ArrayRemoveDead;
    if (_activator == leader group _activator) then {
        {
            if (!(isPlayer _x) && (_x in _heli) && {((_x in assignedCargo _heli) || (_x in _turretUnits))}) then {
                _units pushBack _x;
            };
        } forEach (units group _activator);
    };
} else {
    _units = [(_this select 1)] call Zen_ConvertToObjectArray;
};

// player commandChat str _units;

_h_holdPos = _heli spawn {
    while {true} do {
        _this land "none";
        if !(isPlayer (driver _this)) then {
            _this setVelocity [0, 0, -2];
            _this setVectorUp [0, 0, 1];
        };
        sleep 0.1;
    };
};

switch (typeOf _heli) do {
    case "O_Heli_Light_02_unarmed_F": {
        _offsetL = [-1.4, 1.4, 0];
    };
    case "O_Heli_Light_02_F": {
        _offsetL = [-1.4, 1.4, 0];
    };
    case "B_Heli_Transport_01_F": {
        _offsetL = [-0.9, 3, 0.5];
    };
    case "B_Heli_Transport_01_camo_F": {
        _offsetL = [-0.9, 3, 0.5];
    };
    case "O_Heli_Attack_02_F": {
        _offsetL = [-1.2, 1.5, 0.5];
    };
    case "O_Heli_Attack_02_black_F": {
        _offsetL = [-1.2, 1.5, 0.5];
    };
    case "I_Heli_Transport_02_F": {
        _offsetL = [-0.1, -5.1, -1];
    };
    case "B_Heli_Light_01_F": {
        _offsetL = [-1.2, 0.5, -0.5];
    };
    case "I_Heli_light_03_F": {
        _offsetL = [-1.35, 3.5, -0.5];
    };
    case "I_Heli_light_03_unarmed_F": {
        _offsetL = [-1.35, 3.5, -0.5];
    };
    case "B_Heli_Transport_03_F": {
        _offsetL = [0, -5, 0];
    };
    case "B_Heli_Transport_03_unarmed_F": {
        _offsetL = [0, -5, 0];
    };
    case "O_Heli_Transport_04_covered_F": {
        _offsetL = [0, -5.1, 0.2];
    };
    default {
        _offsetL = [-1, 1.5, 0];
    };
};

ZEN_STD_OBJ_AnimateDoors(_heli, 1)
sleep 2;

#define COMPUTE_GROUND_POS \
_stopHeight = ((getPos _heli) vectorDiff (getPosATL _heli)) select 2; \
_ropeStartPos = _heli modelToWorld _offsetL; \
_groundPos =+ _ropeStartPos; \
_groundPos set [2, _stopHeight];
COMPUTE_GROUND_POS

_linkGround = [_groundPos, "Land_PenBlack_F", 0, 0, true] call Zen_SpawnVehicle;
_linkGround allowDamage false;

_ropeGround = ropeCreate [_heli, _offsetL, _linkGround, [0,0,0], ZEN_STD_OBJ_ATLPositionZ(_heli) + 2];
{
    COMPUTE_GROUND_POS
    _linkGround setPosATL _groundPos;
    ropeUnwind [_ropeGround, 10, (_ropeStartPos select 2)];

    _linkAir = [_linkGround, "Land_PenBlack_F", ZEN_STD_OBJ_ATLPositionZ(_heli) - 2, 0, true] call Zen_SpawnVehicle;
    _linkAir allowDamage false;

    _ropeAir = ropeCreate [_heli, _offsetL, _linkAir, [0,0,0], 6];

    _args = ["unassignVehicle", [_x]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

    if (isPlayer _x) then {
        _args = ["action", [_x, ["eject", _heli]]];
        ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)
    } else {
        _x setPosATL _groundPos;
    };

    waitUntil {
        ((vehicle _x) == _x)
    };

    _args = ["setVectorUp", [_x, [0,0,1]]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

    _x attachTo [_linkAir, [0,-0.25,-0.5]];
    ropeUnwind [_ropeAir, 7, (_ropeStartPos select 2) + 3];

    sleep 0.5;
    _args = ["switchMove", [_x, "commander_apctracked3_out"]];
    ZEN_FMW_MP_REAll("Zen_ExecuteCommand", _args, call)

    _args = ["allowDamage", [_x, false]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

    waitUntil {
        sleep 0.25;
        (((abs (ZEN_STD_OBJ_ATLPositionZ(_x) - _stopHeight)) < 0.8) || (ZEN_STD_OBJ_ASLPositionZ(_x) < 0.8) || !(alive _heli))
    };

    detach _x;

    _args = ["unassignVehicle", [_x]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

    _args = ["setVectorUp", [_x, [0,0,1]]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

    _args = ["switchMove", [_x, ""]];
    ZEN_FMW_MP_REAll("Zen_ExecuteCommand", _args, call)

    ropeDestroy _ropeAir;
    deleteVehicle _linkAir;
    sleep 1;

    _args = ["allowDamage", [_x, true]];
    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)
} forEach _units;

sleep 1;
ZEN_STD_OBJ_AnimateDoors(_heli, 0)
sleep 2;

ropeDestroy _ropeGround;
deleteVehicle _linkGround;
terminate _h_holdPos;

call Zen_StackRemove;
if (true) exitWith {};

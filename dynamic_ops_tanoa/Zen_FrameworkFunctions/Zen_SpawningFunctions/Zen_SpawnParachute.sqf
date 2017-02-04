// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnParachute", _this] call Zen_StackAdd;
private ["_object", "_parachute", "_height", "_signalGrenadeClass", "_velocity"];

if !([_this, [["OBJECT"], ["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_object = _this select 0;

ZEN_STD_Parse_GetArgumentDefault(_signalGrenadeClass, 1, "SmokeShell")

_velocity = ZEN_STD_Math_VectCartCyl((velocity _object) vectorMultiply 0.33);
_parachute = createVehicle ["B_Parachute_02_F", getPosATL _object, [], 0, "CAN_COLLIDE"];
_parachute setPosATL getPosATL _object;

_object enableSimulation false;
_height = ZEN_STD_OBJ_BBZ(_object) / 2;
_height = _height max 1.2;

sleep 2;
_object attachTo [_parachute, [0, 0, -_height]];
_object enableSimulation true;
_parachute setMass (getMass _object + getMass _parachute);
0 = [_parachute, _parachute, 0, _velocity] call Zen_TransformObject;

_stopHeight = ((getPos _object) vectorDiff (getPosATL _object)) select 2;
sleep 2;

waitUntil {
    sleep 0.2;
    ((ZEN_STD_OBJ_ATLPositionZ(_object) < (_height + _stopHeight)) || (ZEN_STD_OBJ_ASLPositionZ(_object) < 1))
};

_object allowDamage false;
detach _object;

if ((_signalGrenadeClass != "") && {isClass (configFile >> "CfgMagazines" >> _signalGrenadeClass)}) then {
    0 = [_object, _signalGrenadeClass] call Zen_SpawnVehicle;
};

sleep 1;
_object allowDamage true;

call Zen_StackRemove;
if (true) exitWith {};

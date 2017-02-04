// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_AddFastRope", _this] call Zen_StackAdd;
private ["_vehicles", "_sendPacket"];

if !([_this, [["ARRAY", "OBJECT"], ["BOOL"]], [["OBJECT"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicles = [(_this select 0)] call Zen_ConvertToObjectArray;
ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 1, true, false)

{
    _x addAction ["<t color='#2D8CE0'>Fast Rope</t>", {ZEN_FMW_MP_REClient("Zen_OrderFastRope", _this, spawn, (_this select 0))}, [], 6, false, true, "", "(_this in _target) && (_this != driver _target) && (speed _target < 10) && (((getPosATL _target) select 2) > 5)"];
} forEach _vehicles;

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_AddFastRope", _this];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

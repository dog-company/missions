// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_AddEject", _this] call Zen_StackAdd;
private ["_units", "_sendPacket"];

if !([_this, [["VOID"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 1, true, false)

{
    _x addAction ["<t color='#2D8CE0'>Eject</t>", {(_this select 1) setPosATL ([(_this select 1), 3, getDir (_this select 1) - 90, "compass", ((getPosATL (_this select 1)) select 2) - 2] call Zen_ExtendPosition); (_this select 1) setVelocity velocity (_this select 0); if (isEngineOn (_this select 0)) then {(_this select 0) engineOn true};}, [], 6, false, true, "", "(_this in _target) && !(_this in (assignedCargo _target))"];
} forEach _units;

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_AddEject", _this];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

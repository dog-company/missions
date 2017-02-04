// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_AddGiveMagazine", _this] call Zen_StackAdd;
private ["_units", "_sendPacket"];

if !([_this, [["VOID"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 1, true, false)

if (!isDedicated && hasInterface) then {
    {
        0 = _x addAction ["<t color='#2D8CE0'>Give Magazine</t>", Zen_GiveMagazine, 0, 1, false, true, "", "((_target == _this) && !(surfaceIsWater (getPosATL _this)) && (vehicle _this == _this) && {(({(side _x == side _this) && ([_this, _x, 120] call Zen_IsFacing)} count (((getPosATL _target) nearEntities ['Man', 3]) - [_this])) > 0)})"];
    } forEach _units;
};

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_AddGiveMagazine", (_this)];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

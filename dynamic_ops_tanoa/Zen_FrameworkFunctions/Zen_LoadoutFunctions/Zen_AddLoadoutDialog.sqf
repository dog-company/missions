// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_AddLoadoutDialog", _this] call Zen_StackAdd;
private ["_objects", "_kits", "_maxUses", "_sendPacket", "_id"];

if !([_this, [["ARRAY", "OBJECT"], ["ARRAY"], ["SCALAR"], ["BOOL"]], [["OBJECT"], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_objects = _this select 0;
_kits = _this select 1;

_maxUses = -1;

if (count _this > 2) then {
    _maxUses = _this select 2;
} else {
    _this set [2, -1];
};

ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 3, true, false)

if (typeName _objects != "ARRAY") then {
    _objects = [_objects];
};

_dialogID = [] call Zen_CreateDialog;

_controlCancel = ["Button", ["Text", "Cancel"], ["Position", [35, 2]], ["Size", [5,2]], ["ActivationFunction", "Zen_CloseDialog"]] call Zen_CreateControl;
_controlList = ["List", ["List", _kits], ["ListData", _kits], ["Position", [0, 0]], ["Size", [35,40]]] call Zen_CreateControl;
_controlOK = ["Button", ["Text", "OK"], ["Position", [35, 0]], ["Size", [5,2]], ["ActivationFunction", "Zen_LoadoutDialogEquip"], ["LinksTo", [_controlList]]] call Zen_CreateControl;

{
    0 = [_dialogID, _x] call Zen_LinkControl;
} forEach [_controlOK, _controlCancel, _controlList];

if (!isDedicated && hasInterface) then {
    {
        _id = _x addAction ["<t color='#2D8CE0'>Select Loadout</t>", Zen_ShowLoadoutDialog, _dialogID, 1, false, true, "", "(alive _target && {((_target distance _this) < (1 + (((boundingBoxReal _target) select 0) distance ((boundingBoxReal _target) select 1)) / 2))})"];
        Zen_Loadout_Action_Array_Local pushBack [_id, _maxUses, 0];
    } forEach _objects;
};

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_AddLoadoutDialog", _this];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

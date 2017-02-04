// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_InvokeFireSupportAction", _this] call Zen_StackAdd;
private ["_nameString", "_pos", "_fireSupportTime", "_marker", "_guideType", "_guideObj", "_templateData", "_salvoTime", "_commArray", "_EHID", "_args", "_data", "_supportTemplate"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_data = [_nameString] call Zen_GetFireSupportActionData;

_supportTemplate = _data select 3;
_guideObj = _data select 4;
_guideType = _data select 5;

if ((typeName _guideObj == "STRING") && {(toUpper _guideObj isEqualTo "PLAYER")}) then {
    _guideObj = player;
};

if ((_data select 6) == (_data select 7)) exitWith {
    player groupChat "This support has been used the maximum number of times.";
};

openMap true;
hintSilent "Hold Left-click on the desired fire support target.";
Zen_Fire_Support_Target_Pos_Local = [];
_EHID = "Zen_Fire_Support_Map_EH" + ([10] call Zen_StringGenerateRandom);
0 = [_EHID, "onMapSingleClick", {Zen_Fire_Support_Target_Pos_Local = _pos;}] call BIS_fnc_AddStackedEventHandler;

waitUntil {
    ((count Zen_Fire_Support_Target_Pos_Local) > 0)
};

_pos =+ Zen_Fire_Support_Target_Pos_Local;
0 = [_EHID, "onMapSingleClick"] call BIS_fnc_RemoveStackedEventHandler;
hintSilent "";

_templateData = [_supportTemplate] call Zen_GetFireSupportData;
if (count _templateData == 0) exitWith {};

_args = [[_pos, _supportTemplate, _guideObj, _guideType], player, _nameString, false, []];
if ((typeName _guideObj == "OBJECT") && {(_guideType == "designator")}) then {
    ZEN_FMW_MP_REClient("Zen_InvokeFireSupportAction_Fire_MP", _args, spawn, _guideObj)
} else {
    0 = _args spawn Zen_InvokeFireSupportAction_Fire_MP;
};

_salvoTime = _templateData select 4;
_fireSupportTime = 2 * ([_salvoTime select 0, _salvoTime select 1] call Zen_FindInRange);

_args = [player, _pos, _fireSupportTime];
ZEN_FMW_MP_REAll("Zen_InvokeFireSupportAction_SideChat_MP", _args, call)

_marker = [_pos, "Fire Support Target", "colorRed", [0.6, 0.6], "mil_destroy", 45, 0] call Zen_SpawnMarker;
0 = [_marker, player] call Zen_ShowHideMarkers;

0 = _marker spawn {
    sleep 60;
    deleteMarker _this;
};

_args = [_nameString, player];
ZEN_FMW_MP_REServerOnly("Zen_InvokeFireSupportAction_CheckCount_Server_MP", _args, call)

call Zen_StackRemove;
if (true) exitWith {};

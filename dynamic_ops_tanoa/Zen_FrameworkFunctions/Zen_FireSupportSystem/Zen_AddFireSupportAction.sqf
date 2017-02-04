// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_AddFireSupportAction", _this] call Zen_StackAdd;
private ["_units", "_supportString", "_titleString", "_maxCalls", "_guideObj", "_guideType", "_args", "_descr"];

if !([_this, [["VOID"], ["STRING"], ["STRING"], ["SCALAR"], ["STRING"], ["OBJECT","STRING"], ["STRING"]], [], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_supportString = _this select 1;
_titleString = _this select 2;
_maxCalls = _this select 3;

ZEN_STD_Parse_GetArgumentDefault(_descr, 4, "")
ZEN_STD_Parse_GetArgumentDefault(_guideObj, 5, "NULL")
ZEN_STD_Parse_GetArgumentDefault(_guideType, 6, "designator")

if (count ([_supportString] call Zen_GetFireSupportData) == 0) exitWith {};

if ((count Zen_Fire_Support_Action_Array_Global) == 0) then {
    Zen_Fire_Support_Action_Array_Global pushBack ["Zen_fire_support_action_global_null_init_flag", [], "", "", objNull, "", 0, 0];
    _dialogID = [] call Zen_CreateDialog;

    _controlList = ["List", ["List", []], ["ListData", []], ["Position", [0, 0]], ["Size", [35,11.5]], ["SelectionFunction", "Zen_AddFireSupportAction_DialogListSel_MP"]] call Zen_CreateControl;
    _controlOK = ["Button", ["Text", "Call"], ["Position", [35, 0]], ["Size", [5,2]], ["ActivationFunction", "Zen_AddFireSupportAction_DialogOK_MP"], ["LinksTo", [_controlList]]] call Zen_CreateControl;
    _controlCancel = ["Button", ["Text", "Cancel"], ["Position", [35, 2]], ["Size", [5,2]], ["ActivationFunction", "Zen_AddFireSupportAction_DialogCancel_MP"], ["LinksTo", [_controlList]]] call Zen_CreateControl;
    _controlRefresh = ["Button", ["Text", "Refresh"], ["Position", [35, 4]], ["Size", [5,2]], ["ActivationFunction", "Zen_AddFireSupportAction_DialogRefresh_MP"]] call Zen_CreateControl;
    _controlClose = ["Button", ["Text", "Close"], ["Position", [35, 6]], ["Size", [5,2]], ["ActivationFunction", "Zen_CloseDialog"]] call Zen_CreateControl;
    _controlDecr = ["Text", ["Position", [0, 12]], ["Size", [35,2]], ["Text", ""]] call Zen_CreateControl;

    {
        0 = [_dialogID, _x] call Zen_LinkControl;
    } forEach [_controlOK, _controlCancel, _controlList, _controlDecr, _controlClose, _controlRefresh];

    Zen_Fire_Support_Action_Dialog_Data = [_dialogID, _controlList, _controlDecr];
    publicVariable "Zen_Fire_Support_Action_Dialog_Data";

    {
        _args = ["addAction", [_x, ["<t color='#990000'>Fire Support</t>", {0 = [] spawn Zen_AddFireSupportAction_ShowDialog_MP}, [], 1, false, true, "", "((player == _this) && {(({player in (_x select 1)} count Zen_Fire_Support_Action_Array_Global) > 0)})"]]];
        ZEN_FMW_MP_REAll("Zen_ExecuteCommand", _args, call)
    } forEach allUnits;
};

_nameString = format ["Zen_fire_support_action_global_%1",([10] call Zen_StringGenerateRandom)];
Zen_Fire_Support_Action_Array_Global pushBack [_nameString, _units, _titleString, _supportString, _guideObj, _guideType, _maxCalls, 0, _descr, false, []];
publicVariable "Zen_Fire_Support_Action_Array_Global";

// _args = [_nameString, _units, _titleString, _supportString, _guideObj, _guideType, _maxCalls];
_args = [_nameString];
ZEN_FMW_MP_REAll("Zen_AddFireSupportAction_AddLocal_MP", _args, call)

call Zen_StackRemove;
(_nameString)

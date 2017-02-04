// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

Zen_Dialog_Classes_Global = [];
Zen_Control_Classes_Global = [];
Zen_Active_Dialog_Control_Data = [];
Zen_Active_Dialog = "";
uiNamespace setVariable ["Zen_Dialog_Object_Local", ["", []]];

Zen_LinkControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_LinkControl.sqf";
Zen_CopyControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_CopyControl.sqf";
Zen_CopyDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_CopyDialog.sqf";
Zen_CreateDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_CreateDialog.sqf";
Zen_CreateControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_CreateControl.sqf";
Zen_ExecuteEvent = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_ExecuteEvent.sqf";
Zen_InvokeDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_InvokeDialog.sqf";
Zen_GetControlData = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_GetControlData.sqf";
Zen_GetDialogControls = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_GetDialogControls.sqf";
Zen_RemoveControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_RemoveControl.sqf";
Zen_RemoveDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_RemoveDialog.sqf";
Zen_UnlinkControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_UnlinkControl.sqf";
Zen_UpdateControl = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_UpdateControl.sqf";

Zen_CloseDialog = {
    uiNamespace setVariable ["Zen_Dialog_Object_Local", ["", []]];
    (findDisplay 76) closeDisplay 0;
    closeDialog 0;
    if (true) exitWith {};
};

Zen_RefreshDialog = {
    disableSerialization;
    with uiNamespace do {
        missionNamespace setVariable ["Zen_Active_Dialog", Zen_Dialog_Object_Local select 0];
        missionNamespace setVariable ["Zen_Active_Dialog_Control_Data", +(Zen_Dialog_Object_Local select 1)];
    };

    if (Zen_Active_Dialog != "") then {
        _dialogControls = [Zen_Active_Dialog] call Zen_GetDialogControls;
        _controlsToRepeat = [];
        {
            _oldHash = _x select 2;

            if ((_x select 0) in _dialogControls) then {
                _newHash = [_x select 0] call Zen_HashControlData;
                if ((_newHash != "") && {_oldHash != _newHash}) then {
                    _controlsToRepeat pushBack (_x select 0);
                    ctrlDelete (_x select 1);
                };
            };
        } forEach Zen_Active_Dialog_Control_Data;
        0 = [Zen_Active_Dialog, _controlsToRepeat] spawn Zen_InvokeDialog;
    };

    if (true) exitWith {};
};

Zen_HashControlData = {
    _controlID = _this select 0;

    _controlData = [_controlID] call Zen_GetControlData;
    _hashString = "";
    if (_controlData isEqualTo []) exitWith {""};

    _F_Hash = {
        _return = "";
        if (typeName _this == "ARRAY") then {
            {
                _return = _return + (_x call _F_Hash);
            } forEach _this;
        } else {
            _return = switch (typeName _this) do {
                case "SCALAR": {
                    (str round (_this % 10^6));
                };
                case "STRING": {
                    _hash = "";
                    {
                        _hash = _hash + str _x;
                    } forEach (toArray _this);
                    (_hash)
                };
                default {
                    _hash = "";
                    {
                        _hash = _hash + str _x;
                    } forEach (toArray str _this);
                    (_hash)
                };
            };
        };
        (_return)
    };

    _totalHash = ((_controlData select 1) call _F_Hash) + "--";
    {
        _totalHash = _totalHash + ((_x select 1) call _F_Hash) + "--";
    } forEach (_controlData select 2);
    (_totalHash)
};

if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

disableSerialization;
#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_InvokeDialog", _this] call Zen_StackAdd;
private ["_dialogID", "_controlsArray", "_Zen_Dialog_Controls_Local", "_idcCur", "_display", "_controlData", "_controlType", "_controlBlocks", "_controlInstanClass", "_control", "_blockID", "_data", "_doRefresh"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_dialogID = _this select 0;

if (count _this > 1) then {
    _doRefresh = true;
    _controlsArray = _this select 1;
} else {
    _doRefresh = false;
    _controlsArray = [_dialogID] call Zen_GetDialogControls;
};

_Zen_Dialog_Controls_Local = [];
_idcCur = 7600;
#define NEXT_IDC _idcCur]; _idcCur = _idcCur + 1;
#define GRID_DIVISION 0.025
#define COLOR_STEP 255
#define FONT_DIVISION 300

if !(_doRefresh) then {
    (findDisplay 76) closeDisplay 0;
    closeDialog 0;

    _display = (findDisplay 46) createDisplay "Zen_Dialog";
    createDialog "Zen_Dialog";
} else {
    _display = (findDisplay 76);
};

{
    _controlID = _x;
    _controlData = [_controlID] call Zen_GetControlData;
    if (count _controlData > 0) then {
        _controlType = _controlData select 1;
        _controlBlocks = _controlData select 2;

        _controlInstanClass = switch (toUpper _controlType) do {
            case "BUTTON": {("RSCButton")};
            case "LIST": {("RscListBox")};
            case "TEXT": {("RscText")};
            case "SLIDER": {("RscXSliderH")};
            case "PICTURE": {("RscPicture")};
            // case "CHECKBOXES": {("RscCheckBox")};
            // case "RADIOBUTTONS": {("RscToolboxButton")};
            case "TEXTFIELD": {("RscEdit")};
            // case "BACKGROUND": {("RscBackground")};
            case "DROPLIST": {("RscCombo")};
            case "PROGRESSBAR": {("RscProgress")};
            default {("")};
        };

        if (_controlInstanClass != "") then {
            _control = _display ctrlCreate [_controlInstanClass, NEXT_IDC
            _Zen_Dialog_Controls_Local pushBack [_controlID, _control, ([_controlID] call Zen_HashControlData)];

            if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                {
                    if ((toUpper (_x select 0)) == "LIST") then {
                        {
                            _control lbAdd _x;
                        } forEach (_x select 1);
                    };
                } forEach _controlBlocks;
            };

            if (toUpper _controlType in ["LIST","DROPLIST"]) then {
                _control lbSetCurSel 0;
            };

            if (toUpper _controlType in ["SLIDER"]) then {
                _control sliderSetPosition 0;
                _control sliderSetSpeed [1, 5];
            };

            if (toUpper _controlType in ["PROGRESSBAR"]) then {
                _control progressSetPosition 0;
            };

            {
                _blockID = _x select 0;
                _data = _x select 1;
                switch (toUpper _blockID) do {
                    case "PROGRESS": {
                        _control progressSetPosition (((_data max 0) min 255) / 255);
                    };
                    case "FONTCOLORSELECTED": {
                        if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetSelectColor [_i, [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP]];
                            };
                        } else {
                            _control ctrlSetActiveColor [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                        };
                    };
                    case "PICTURE": {
                        if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetPicture [_i, _data select _i];
                            };
                        } else {
                            if ([".paa", _data] call Zen_StringIsInString) then {
                                _control ctrlSetText _data;
                            };
                        };
                    };
                    case "PICTURECOLOR": {
                        if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetPictureColor [_i, [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP]];
                            };
                        };
                    };
                    case "PICTURECOLORSELECTED": {
                        if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetPictureColorSelected [_i, [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP]];
                            };
                        };
                    };
                    case "FOREGROUNDCOLOR": {
                        _control ctrlSetForegroundColor [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                    };
                    case "SLIDERPOSITIONS": {
                        _control sliderSetRange [0, _data max 1];
                    };
                    case "BACKGROUNDCOLOR": {
                        _control ctrlSetBackgroundColor [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                    };
                    case "TOOLTIPFONTCOLOR": {
                        _control ctrlSetTooltipColorText [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                    };
                    case "TOOLTIPBACKGROUNDCOLOR": {
                        _control ctrlSetTooltipColorShade [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                    };
                    case "TOOLTIPBORDERCOLOR": {
                        _control ctrlSetTooltipColorBox [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                    };
                    case "TOOLTIP": {
                        _control ctrlSetTooltip _data;
                    };
                    case "LISTTOOLTIP": {
                        if ((toUpper _controlType) in ["LIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetTooltip [_i, _data select _i];
                            };
                        };
                    };
                    case "TEXT": {
                        _control ctrlSetText _data;
                    };
                    case "FONT": {
                        _control ctrlSetFont _data;
                    };
                    case "FONTSIZE": {
                        _control ctrlSetFontHeight _data / FONT_DIVISION;
                    };
                    case "FONTCOLOR": {
                        if ((toUpper _controlType) in ["LIST","DROPLIST"]) then {
                            for "_i" from 0 to (lbSize _control - 1) do {
                                _control lbSetColor [_i, [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP]];
                            };
                        } else {
                            _control ctrlSetTextColor [(_data select 0) / COLOR_STEP, (_data select 1) / COLOR_STEP, (_data select 2) / COLOR_STEP, (_data select 3) / COLOR_STEP];
                        };
                    };
                    case "POSITION": {
                        _control ctrlSetPosition [(_data select 0) * GRID_DIVISION, (_data select 1) * GRID_DIVISION];
                    };
                    case "SIZE": {
                        _oldPos = ctrlPosition _control;
                        _control ctrlSetPosition (([_oldPos, 0, 1] call Zen_ArrayGetIndexedSlice) + [(_data select 0) * GRID_DIVISION, (_data select 1) * GRID_DIVISION]);
                    };
                    case "ACTIVATIONFUNCTION": {
                        switch (toUpper _controlType) do {
                            case "BUTTON": {
                                _control buttonSetAction (format ["['%1', 'ActivationFunction'] spawn Zen_ExecuteEvent", _controlID]);
                            };
                            case "LIST": {
                                _control ctrlSetEventHandler ["LBDblClick", (format ["['%1', 'ActivationFunction'] spawn Zen_ExecuteEvent", _controlID])]
                            };
                        };
                    };
                    case "SELECTIONFUNCTION": {
                        if ((toUpper _controlType) in ["LIST", "DROPLIST"]) then {
                            _control ctrlSetEventHandler ["LBSelChanged", (format ["['%1', 'SelectionFunction'] spawn Zen_ExecuteEvent", _controlID])];
                        };

                        if ((toUpper _controlType) in ["SLIDER"]) then {
                            _control ctrlSetEventHandler ["SliderPosChanged", (format ["['%1', 'SelectionFunction'] spawn Zen_ExecuteEvent", _controlID])];
                        };
                    };
                    default {};
                };
                _control ctrlCommit 0;
            } forEach _controlBlocks;

            _control ctrlCommit 0;
        };
    };
} forEach _controlsArray;

if !(_doRefresh) then {
    uiNamespace setVariable ["Zen_Dialog_Object_Local", [_dialogID, _Zen_Dialog_Controls_Local]];
} else {
    _oldLocalData = uiNamespace getVariable "Zen_Dialog_Object_Local";
    _localToAdd = +(_oldLocalData select 1);

    {
        _refreshedControlID = _x select 0;
        {
            if ((_x select 0) == _refreshedControlID) exitWith {
                0 = [_localToAdd, _forEachIndex] call Zen_ArrayRemoveIndex;
            };
        } forEach +_localToAdd;
    } forEach _Zen_Dialog_Controls_Local;

    uiNamespace setVariable ["Zen_Dialog_Object_Local", [_dialogID, _Zen_Dialog_Controls_Local + _localToAdd]];
};

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_CreateControl", _this] call Zen_StackAdd;
private ["_controlType", "_ID", "_dataTypes", "_dataArray", "_type", "_data"];

if !([_this, [["STRING"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_controlType = _this select 0;
_ID = "Zen_Control_" + ([10] call Zen_StringGenerateRandom);

_controlTypes = ["Button","List","Text", "BACKGROUND", "DROPLIST", "SLIDER", "PICTURE", "CHECKBOXES", "RADIOBUTTONS", "TEXTFIELD", "PROGRESSBAR"];

if !([_controlType, _controlTypes] call Zen_ValueIsInArray) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_CreateControl", "Invalid control type given", (""))
};

_dataTypes = ["LinksTo","Text","FontColor","Position","Size","ActivationFunction", "SelectionFunction","List","ListData","Data","FontSize", "Font", "FontColorSelected", "ListTooltip", "ForegroundColor", "BackgroundColor", "Tooltip", "TooltipFontColor", "TooltipBackgroundColor", "TooltipBorderColor", "Picture", "PictureColor", "PictureColorSelected", "SliderPositions", "Progress"];
_dataArray = [];

{
    _type = _x select 0;
    _data = _x select 1;
    if ((toUpper _type) isEqualTo "NAME") then {
        if (typeName _data == "STRING") then {
            _ID = _data;
        };
    } else {
        if ([_type, _dataTypes] call Zen_ValueIsInArray) then {
            _dataArray pushBack _x;
        } else {
            ZEN_FMW_Code_Error("Zen_UpdateControl", "Invalid control property identifier given.")
        };
    };
} forEach ([_this, 1] call Zen_ArrayGetIndexedSlice);

Zen_Control_Classes_Global pushBack [_ID, _controlType, _dataArray];
publicVariable "Zen_Control_Classes_Global";

call Zen_StackRemove;
(_ID)

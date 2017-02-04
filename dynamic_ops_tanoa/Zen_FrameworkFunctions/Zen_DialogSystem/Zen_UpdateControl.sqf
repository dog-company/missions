// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_UpdateControl", _this] call Zen_StackAdd;
private ["_controlType", "_ID", "_dataTypes", "_dataArray", "_type", "_data"];

if !([_this, [["STRING"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_controlID = _this select 0;
_controlTypes = ["Button","List","Text", "BACKGROUND", "DROPLIST", "SLIDER", "PICTURE", "CHECKBOXES", "RADIOBUTTONS", "TEXTFIELD", "PROGRESSBAR"];
_dataTypes = ["LinksTo","Text","FontColor","Position","Size","ActivationFunction", "SelectionFunction","List","ListData","Data","FontSize", "Font", "FontColorSelected", "ListTooltip", "ForegroundColor", "BackgroundColor", "Tooltip", "TooltipFontColor", "TooltipBackgroundColor", "TooltipBorderColor", "Picture", "PictureColor", "PictureColorSelected", "SliderPositions", "Progress"];

_index = [Zen_Control_Classes_Global, _controlID, 0] call Zen_ArrayGetNestedIndex;
if (count _index == 0) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_UpdateControl", "Invalid control class given")
};

_index = _index select 0;
_controlData = Zen_Control_Classes_Global select _index;
_controlType = _controlData select 1;
_dataArray = _controlData select 2;

{
    _type = _x select 0;
    _data = _x select 1;
    if ((toUpper _type) isEqualTo "TYPE") then {
        if ([_data, _controlTypes] call Zen_ValueIsInArray) then {
            _controlType = _data;
        } else {
            ZEN_FMW_Code_Error("Zen_UpdateControl", "Invalid control type given.")
        };
    } else {
        _index = [_dataArray, _type, 0] call Zen_ArrayGetNestedIndex;
        if (count _index > 0) then {
            _index = _index select 0;
            _dataBlock = _dataArray select _index;
            _dataBlock set [1, _data];
        } else {
            if ([_type, _dataTypes] call Zen_ValueIsInArray) then {
                _dataArray pushBack _x;
            } else {
                ZEN_FMW_Code_Error("Zen_UpdateControl", "Invalid control property identifier given.")
            };
        };
    };
} forEach ([_this, 1] call Zen_ArrayGetIndexedSlice);

_controlData set [1, _controlType];
publicVariable "Zen_Control_Classes_Global";

call Zen_StackRemove;
if (true) exitWith {};

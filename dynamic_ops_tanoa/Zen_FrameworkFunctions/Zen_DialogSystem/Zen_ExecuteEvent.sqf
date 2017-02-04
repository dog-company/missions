// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

disableSerialization;
#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_ExecuteEvent", _this] call Zen_StackAdd;
private ["_controlID", "_controlData", "_controlBlocks", "_index", "_function"];

if !([_this, [["STRING"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_controlID = _this select 0;
_functionType = _this select 1;

_linkedArgs = [];
_Zen_Dialog_Object_Local = uiNamespace getVariable "Zen_Dialog_Object_Local";
_Zen_DialogID = _Zen_Dialog_Object_Local select 0;
_Zen_Dialog_Controls_Local = _Zen_Dialog_Object_Local select 1;

_controlData = [_controlID] call Zen_GetControlData;
_type = _controlData select 1;
_controlBlocks = _controlData select 2;

_index = [_controlBlocks, _functionType, 0] call Zen_ArrayGetNestedIndex;
if (count _index == 0) exitWith {};
_index = _index select 0;
_function = (_controlBlocks select _index) select 1;

_index = [_controlBlocks, "Data", 0] call Zen_ArrayGetNestedIndex;
if (count _index > 0) then {
    _index = _index select 0;
    _linkedArgs pushBack ((_controlBlocks select _index) select 1);
};

if ((toUpper _type) in ["LIST", "DROPLIST"]) then {
    _curControlIndex = ([_Zen_Dialog_Controls_Local, _controlID, 0] call Zen_ArrayGetNestedIndex) select 0;
    _currentControl = (_Zen_Dialog_Controls_Local select _curControlIndex) select 1;

    _index = [_controlBlocks, "ListData", 0] call Zen_ArrayGetNestedIndex;
    if (count _index > 0) then {
        _index = _index select 0;
        _linkedArgs pushBack (((_controlBlocks select _index) select 1) select (lbCurSel _currentControl));
    };
};

if ((toUpper _type) in ["SLIDER"]) then {
    _curControlIndex = ([_Zen_Dialog_Controls_Local, _controlID, 0] call Zen_ArrayGetNestedIndex) select 0;
    _currentControl = (_Zen_Dialog_Controls_Local select _curControlIndex) select 1;

    _linkedArgs pushBack round (sliderPosition _currentControl);
};

_index = [_controlBlocks, "LinksTo", 0] call Zen_ArrayGetNestedIndex;
if (count _index > 0) then {
    _linkedControls = (_controlBlocks select (_index select 0)) select 1;
    _dialogControls = [_Zen_DialogID] call Zen_GetDialogControls;
    {
        _controlData = [_x] call Zen_GetControlData;
        _type = _controlData select 1;
        _properties = _controlData select 2;
        switch (true) do {
            case ((toUpper _type) in ["LIST", "DROPLIST"]): {
                _indexLinkedControlLocal = [_Zen_Dialog_Controls_Local, _x, 0] call Zen_ArrayGetNestedIndex;
                if (count _indexLinkedControlLocal > 0) then {
                    _indexLinkedControlLocal = _indexLinkedControlLocal select 0;
                    _linkedControl = (_Zen_Dialog_Controls_Local select _indexLinkedControlLocal) select 1;
                    _listDataIndex = lbCurSel _linkedControl;

                    _indexLinkControlBlock = [_properties, "Data", 0] call Zen_ArrayGetNestedIndex;
                    if (count _indexLinkControlBlock > 0) then {
                        _indexLinkControlBlock = _indexLinkControlBlock select 0;
                        _linkedArgs pushBack (((_properties select _indexLinkControlBlock) select 1) select _listDataIndex);
                    };

                    _indexLinkControlBlock = [_properties, "ListData", 0] call Zen_ArrayGetNestedIndex;
                    if (count _indexLinkControlBlock > 0) then {
                        _indexLinkControlBlock = _indexLinkControlBlock select 0;
                        _linkedArgs pushBack (((_properties select _indexLinkControlBlock) select 1) select _listDataIndex);
                    };
                };
            };
            case ((toUpper _type) in ["TEXTFIELD"]) : {
                _curControlIndex = ([_Zen_Dialog_Controls_Local, _x, 0] call Zen_ArrayGetNestedIndex) select 0;
                _currentControl = (_Zen_Dialog_Controls_Local select _curControlIndex) select 1;

                _linkedArgs pushBack (ctrlText _currentControl);
            };
            default {
                _indexLinkControlBlock = [_properties, "Data", 0] call Zen_ArrayGetNestedIndex;
                if (count _indexLinkControlBlock > 0) then {
                    _indexLinkControlBlock = _indexLinkControlBlock select 0;
                    _linkedArgs pushBack ((_properties select _indexLinkControlBlock) select 1);
                };
            };
        };
    } forEach (_linkedControls arrayIntersect _dialogControls);
};

0 = _linkedArgs spawn (missionNamespace getVariable _function);

call Zen_StackRemove;
if (true) exitWith {};

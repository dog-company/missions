// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_DeleteTemplate", _this] call Zen_StackAdd;
private ["_template", "_indexes", "_objects", "_spawnedDataArray", "_objectData"];

if !([_this, [["STRING"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_template = _this select 0;
_objects = _this select 1;

_indexes = [Zen_Template_Array_Global, _template, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes < 1) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveTemplate", "Invalid template name")
};

_spawnedDataArray = (Zen_Template_Array_Global select (_indexes select 0)) select 2;

_indexes = [_spawnedDataArray, _objects, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes < 1) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_RemoveTemplate", "Invalid spawned template name")
};

_objectData = (_spawnedDataArray select (_indexes select 0)) select 1;
{
    deleteVehicle _x;
} forEach _objectData;

0 = [_spawnedDataArray, (_indexes select 0)] call Zen_ArrayRemoveIndex;

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnGroup", _this] call Zen_StackAdd;
private ["_side", "_pos", "_classes", "_group"];

if !([_this, [["VOID"], ["ARRAY", "STRING"]], [[], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (grpNull)
};

_pos = [(_this select 0)] call Zen_ConvertToPosition;
_classes = _this select 1;

if (typeName _classes != "ARRAY") then {
    _classes = [_classes];
};

_side = [(_classes select 0)] call Zen_GetSide;

if (({side _x == _side} count allGroups) >= 144) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_SpawnGroup", "Exceeded the limit of 144 groups per side.", grpNull)
};

_group = createGroup _side;
{
    if (_x isKindOf "Man") then {
        0 = _group createUnit [_x, _pos, [], 0, "NONE"];
    } else {
        0 = ["Zen_SpawnGroup", format ["Non-human classname given at %1, can only spawn soldiers", _forEachIndex], _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
} forEach _classes;

if ((count units _group == 0) || (isNull _group)) exitWith {
    deleteGroup _group;
    0 = ["Zen_SpawnGroup", "No units could be spawned, group is empty and null", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (grpNull)
};

if (surfaceIsWater _pos) then {
    {
        _x setPosASL ([_pos, random 2, random 360, "compass", _pos select 2] call Zen_ExtendPosition);
    } forEach (units _group);
} else {
    {
        _x setPosATL ([_pos, random 2, random 360, "compass", _pos select 2] call Zen_ExtendPosition);
    } forEach (units _group);
};

call Zen_StackRemove;
(_group)

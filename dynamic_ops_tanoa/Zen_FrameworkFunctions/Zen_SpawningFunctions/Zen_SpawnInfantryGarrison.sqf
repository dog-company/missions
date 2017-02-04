// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnInfantryGarrison", _this] call Zen_StackAdd;
private ["_centerPos", "_buildingName", "_buildingPositions", "_group", "_i"];

if !([_this, [["VOID"], ["SIDE"], ["SCALAR", "ARRAY", "STRING"], ["SCALAR", "ARRAY"], ["STRING"], ["STRING"], ["ARRAY"]], [[], [], ["SCALAR"], ["SCALAR"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (grpNull)
};

_centerPos = [(_this select 0)] call Zen_ConvertToPosition;

_buildingName = nearestBuilding _centerPos;
_buildingPositions = [_centerPos] call Zen_FindBuildingPositions;

if (count _buildingPositions == 0) then {
    _buildingPositions = [getPosATL _buildingName];
};

_group = ([([_buildingName, 15, random 360] call Zen_ExtendPosition)] + ([_this, 1] call Zen_ArrayGetIndexedSlice)) call Zen_SpawnInfantry;

{
    0 = [_x, ZEN_STD_Array_RandElement(_buildingPositions), 0.02, 0, (random 360)] call Zen_TransformObject;
    _x setUnitPosWeak "up";
    doStop _x;
} forEach (units _group);

call Zen_StackRemove;
(_group)

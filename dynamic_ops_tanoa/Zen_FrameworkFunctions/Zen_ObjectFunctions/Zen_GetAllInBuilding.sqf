// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_GetAllInBuilding", _this] call Zen_StackAdd;
private ["_center", "_sidesAllowed", "_building", "_boundingBox", "_buidingSize", "_objectArray"];

if !([_this, [["VOID"], ["ARRAY", "SIDE"]], [[], ["SIDE"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_sidesAllowed = [West, East, Resistance, Civilian];

if (count _this > 1) then {
    _sidesAllowed = _this select 1;
};

if (typeName _sidesAllowed != "ARRAY") then {
    _sidesAllowed = [_sidesAllowed];
};

_building = nearestBuilding _center;
_buidingSize = [ZEN_STD_OBJ_BBX(_building), ZEN_STD_OBJ_BBY(_building)] distance [0,0];

_objectArray = [];
{
    if ((((getPosATL _x select 2) > 2) || {([_x] call Zen_AreIndoors)}) && {(side _x) in _sidesAllowed}) then {
        _objectArray pushBack _x;
    };
} forEach ((getPosATL _building) nearEntities [["Man"], (sqrt (2*(_buidingSize^2)))]);

call Zen_StackRemove;
(_objectArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnItemsOnTable", _this] call Zen_StackAdd;
private ["_tableArray", "_table", "_item", "_itemClassname", "_itemArray", "_itemClassArray", "_angles"];

if !([_this, [["ARRAY"], ["ARRAY"]], [["STRING"], ["OBJECT"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_itemClassArray = _this select 0;
_tableArray = _this select 1;
_itemArray = [];

{
    if (_forEachIndex >= count _tableArray) exitWith {};
    _itemClassname = _x;
    _table = _tableArray select _forEachIndex;

    _item = createVehicle [_itemClassname, (getPosATL _table), [], 0, "NONE"];
    _itemArray pushBack _item;

    0 = [_item, _table, ZEN_STD_OBJ_BBZ(_table), 0, (random 360)] call Zen_TransformObject;

    0 = [_item, (vectorUp _table)] spawn {
        sleep 0.1;
        (_this select 0) setVectorUp (_this select 1);
    };

    _item enableSimulationGlobal false;
    _table enableSimulationGlobal false;

    _offset = [[0,0,0], [((ZEN_STD_OBJ_BBX(_table)) / 2), ((ZEN_STD_OBJ_BBY(_table)) / 2)], getDir _table, "rectangle", [random 360]] call Zen_FindPositionPoly;
    ZEN_STD_OBJ_TransformATL(_item, (_offset select 0), (_offset select 1), 0)
} forEach _itemClassArray;

call Zen_StackRemove;
(_itemArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderInfantryPatrolBuilding", _this] call Zen_StackAdd;
private ["_units", "_centerPos", "_unitsRemove", "_patrolOutside", "_behavior", "_houseCount", "_positions", "_randHouseIndex", "_randPosArray", "_randHouse"];

if !([_this, [["VOID"], ["VOID"], ["BOOL"], ["STRING"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_centerPos = [(_this select 1)] call Zen_ConvertToPosition;

ZEN_STD_Parse_GetArgumentDefault(_patrolOutside, 2, false)
ZEN_STD_Parse_GetArgumentDefault(_behavior, 3, "aware")
ZEN_STD_Parse_GetArgumentDefault(_houseCount, 4, 1)

_nearBuilding = nearestBuilding _centerPos;
// _housesArray = nearestObjects [getPosATL _nearBuilding, ["House"], 100];
_housesArray = nearestTerrainObjects[getPosATL _nearBuilding, ["Building", "House"], 100];
// player sideChat str (nearestTerrainObjects[getPosATL player, ["BUILDING", "HOUSE"], 100]);
// player sideChat str (nearestObjects [getPosATL player, ["House"], 100]);

_housesArray resize _houseCount;

_housePosArray = [];
{
    _positions = [_x] call Zen_FindBuildingPositions;
    if (count _positions == 0) then {
        _positions = [_x, true] call Zen_FindBuildingPositions;
    };
    _housePosArray pushBack _positions;
} forEach _housesArray;

{
    doStop _x;
    _randHouseIndex = ZEN_STD_Array_RandIndex(_housesArray);
    _randPosArray = _housePosArray select _randHouseIndex;
    _x doMove ZEN_STD_Array_RandElement(_randPosArray);
    _x setUnitPos "up";
} forEach _units;

while {(count _units > 0)} do {
    {
        if (isNull _x || {!(alive _x)}) then {
            _units set [_forEachIndex, 0];
        } else {
            (group _x) setBehaviour _behavior;
            if ((unitReady _x) || (vectorMagnitude velocity _x < 0.1)) then {
                _x setUnitPos "up";
                _randHouseIndex = ZEN_STD_Array_RandIndex(_housesArray);
                _randHouse = _housesArray select _randHouseIndex;
                if (_patrolOutside && {((random 1) > 0.7)}) then {
                    _x doMove ([_randHouse, 30, (random 360)] call Zen_ExtendPosition);
                } else {
                    _randPosArray = _housePosArray select _randHouseIndex;
                    _x doMove ZEN_STD_Array_RandElement(_randPosArray);
                };
            };
        };
    } forEach _units;
    0 = [_units, 0] call Zen_ArrayRemoveValue;
    sleep 10;
};

call Zen_StackRemove;
if (true) exitWith {};

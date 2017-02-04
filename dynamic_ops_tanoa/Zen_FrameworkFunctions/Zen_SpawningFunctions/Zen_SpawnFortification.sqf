// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#define FORT_CLASSES ["Land_BagBunker_Small_F", "Land_BagFence_Long_F", "Land_BagFence_Long_F", "Land_BagFence_Long_F", "Land_BagFence_Long_F", "Land_CncBarrierMedium_F", "Land_CncBarrierMedium_F", "Land_HBarrier_3_F", "Land_HBarrier_3_F", "Land_HBarrier_3_F"]

_Zen_stack_Trace = ["Zen_SpawnFortification", _this] call Zen_StackAdd;
private ["_center", "_distance", "_i", "_hasMG", "_class", "_distanceError", "_spawnPos", "_direction", "_object", "_mgSpawnPos", "_size2d", "_phi", "_staticClass", "_staticWeapon"];

if !([_this, [["VOID"], ["SCALAR"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_distance = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_staticClass, 2, "B_HMG_01_high_F")

_i = 0;
_hasMG = false;
_staticWeapon = objNull;

while {_i < 352} do {
    _class = [FORT_CLASSES] call Zen_ArrayGetRandom;
    _distanceError = [-2, 2] call Zen_FindInRange;
    _spawnPos = [_center, _distance + _distanceError, _i] call Zen_ExtendPosition;

    _direction = [_center, _spawnPos] call Zen_FindDirection;
    _direction = [_direction] call Zen_FindTrigAngle;

    if ([_class, "Land_BagBunker_Small_F"] call Zen_ValuesAreEqual) then {
        _direction = 180 + _direction;
    };

    _object = [_spawnPos, _class, 0, _direction, true] call Zen_SpawnVehicle;

    if (!_hasMG && [_class, "Land_BagFence_Long_F"] call Zen_ValuesAreEqual) then {
        _hasMG = true;
        _mgSpawnPos = [_object, 1.75, (_direction + 180), "compass"] call Zen_ExtendPosition;
        _staticWeapon = [_mgSpawnPos, _staticClass, 0, _direction, true] call Zen_SpawnVehicle;
    };

    _size2d = [ZEN_STD_OBJ_BBX(_object), ZEN_STD_OBJ_BBY(_object)] distance [0,0];
    _phi = atan (_size2d / 2 / _distance);
    _i = _i + 2.5*_phi + 5;
};

call Zen_StackRemove;
(_staticWeapon)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnMortar", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_mortarClass", "_mortar1", "_mortar2", "_ammoBox"];

if !([_this, [["VOID"], ["SIDE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;

switch (_side) do {
    case west: {
        _mortarClass = "B_Mortar_01_F";
    };
    case east: {
        _mortarClass = "O_Mortar_01_F";
    };
    case resistance: {
        _mortarClass = "I_Mortar_01_F";
    };
    default {
        0 = ["Zen_SpawnMortar", "Invalid side given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _mortarClass = "";
    };
};

if (_mortarClass == "") exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_mortar1 = [_spawnPos, _mortarClass] call Zen_SpawnVehicle;
_mortar2 = [([_spawnPos, 2 + random 2, (random 360)] call Zen_ExtendPosition), _mortarClass] call Zen_SpawnVehicle;
_ammoBox = [([_spawnPos, 3 + random 3, (random 360)] call Zen_ExtendPosition), _side, true] call Zen_SpawnAmmoBox;

0 = [_mortar1, _side] call Zen_SpawnVehicleCrew;
0 = [_mortar2, _side] call Zen_SpawnVehicleCrew;

_objects = [_mortar1,_mortar2,_ammoBox];
0 = [_objects, (random 360)] call Zen_RotateAsSet;

call Zen_StackRemove;
(_objects)

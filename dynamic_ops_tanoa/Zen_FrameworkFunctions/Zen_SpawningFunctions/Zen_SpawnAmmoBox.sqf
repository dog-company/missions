// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnAmmoBox", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_boxClass", "_obj", "_backpackClass", "_addObjKit"];

if !([_this, [["VOID"], ["SIDE"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;

_addObjKit = false;
if (count _this > 2) then {
    _addObjKit = _this select 2;
};

_boxClass = [(["ammo", _side] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;

switch (_side) do {
    case west: {
        _backpackClass = "B_AssaultPack_mcamo";
    };
    case east: {
        _backpackClass = "B_FieldPack_ocamo";
    };
    case resistance: {
        _backpackClass = "B_FieldPack_oli";
    };
    default {
        0 = ["Zen_SpawnAmmoBox", "Invalid side given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _backpackClass = "";
    };
};

if (_backpackClass == "") exitWith {
    call Zen_StackRemove;
    (objNull)
};

_obj = [_spawnPos, _boxClass] call Zen_SpawnVehicle;

if (_addObjKit) then {
    _obj addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 2];
    _obj addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 1];
    _obj addBackpackCargoGlobal [_backpackClass, 1];
};

call Zen_StackRemove;
(_obj)

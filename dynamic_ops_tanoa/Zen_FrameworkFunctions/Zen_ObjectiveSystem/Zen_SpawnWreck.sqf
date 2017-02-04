// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnWreck", _this] call Zen_StackAdd;
private ["_spawnPos", "_side", "_wreckClass", "_obj", "_backpackClass", "_deadUnits", "_unitFaction"];

if !([_this, [["VOID"], ["SIDE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_spawnPos = [(_this select 0)] call Zen_ConvertToPosition;
_side = _this select 1;

switch (_side) do {
    case west: {
        _wreckClass = [([["car", "armored"], _side] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        _backpackClass = "B_AssaultPack_mcamo";
        _unitFaction = "blu_f";
    };
    case east: {
        _wreckClass = [([["car", "armored"], _side] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        _backpackClass = "B_FieldPack_ocamo";
        _unitFaction = "opf_f";
    };
    case resistance: {
        _wreckClass = [([["car", "armored"], _side] call Zen_ConfigGetVehicleClasses)] call Zen_ArrayGetRandom;
        _backpackClass = "B_FieldPack_oli";
        _unitFaction = "ind_f";
    };
    default {
        0 = ["Zen_SpawnWreck", "Invalid side given", _this] call Zen_PrintError;
        call Zen_StackPrint;
        _wreckClass = "";
    };
};

if (_wreckClass == "") exitWith {
    call Zen_StackRemove;
    ([objNull])
};

_obj = [_spawnPos, _wreckClass] call Zen_SpawnVehicle;

_obj setVehicleAmmo 0;
_obj setDamage 0.7;
_obj setFuel 0;
_obj lock true;

_spawnPos = [(getPosATL _obj), 4 + (random 5), (random 360)] call Zen_ExtendPosition;
_deadUnits = [_spawnPos, _side, 1, [1,1], "men", _unitFaction] call Zen_SpawnInfantry;
0 = [_deadUnits, _side, "rifleman"] call Zen_GiveLoadout;

{
    _x setDamage 1;
} forEach (units _deadUnits);

_obj addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 2];
_obj addBackpackCargoGlobal [_backpackClass, 1];

call Zen_StackRemove;
([_obj])

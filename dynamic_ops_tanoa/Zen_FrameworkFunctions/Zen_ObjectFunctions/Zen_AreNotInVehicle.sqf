// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_AreNotInVehicle", _this] call Zen_StackAdd;
private ["_unitsArray", "_areNotInVehicle", "_vehicle"];

if !([_this, [["VOID"], ["OBJECT"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_unitsArray = [([(_this select 0)] call Zen_ConvertToObjectArray)] call Zen_ArrayRemoveDead;
_areNotInVehicle = true;

if (count _this > 1) then {
    _vehicle = _this select 1;
    {
        if (_x in _vehicle) exitWith {
            _areNotInVehicle = false;
        };
    } forEach _unitsArray;
} else {
    {
        if (vehicle _x != _x) exitWith {
            _areNotInVehicle = false;
        };
    } forEach _unitsArray;
};

call Zen_StackRemove;
(_areNotInVehicle)

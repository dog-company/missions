// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

private ["_cleanUnitsArray"];

{
    _cleanUnitsArray = _x select 1;
    if (count _cleanUnitsArray == 0) then {
        Zen_Task_Array_Global set [_forEachIndex, 0];
    } else {
        _x set [1, _cleanUnitsArray];
    };
} forEach Zen_Task_Array_Global;

0 = [Zen_Task_Array_Global, 0] call Zen_ArrayRemoveValue;
publicVariable "Zen_Task_Array_Global";

if (true) exitWith {};

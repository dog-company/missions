// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

{
    if ((count (_x select 1) == 0)) then {
        Zen_Task_Array_Local set [_forEachIndex, 0];
    };
} forEach Zen_Task_Array_Local;

0 = [Zen_Task_Array_Local, 0] call Zen_ArrayRemoveValue;
if (true) exitWith {};

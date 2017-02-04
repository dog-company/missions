// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_StringRemoveWhiteSpace", _this] call Zen_StackAdd;
private ["_string"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_string = toArray (_this select 0);

if (count _string == 0) then {
    0 = ["Zen_StringRemoveWhiteSpace", "Given string is empty", _this] call Zen_PrintError
    call Zen_StackPrint;
};

_string = _string - [32];
_string = _string - [9];
_string = _string - [13];
_string = _string - [10];

call Zen_StackRemove;
(toString _string)

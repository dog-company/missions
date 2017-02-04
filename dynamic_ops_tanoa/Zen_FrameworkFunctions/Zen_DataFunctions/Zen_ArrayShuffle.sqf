// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_ArrayShuffle", _this] call Zen_StackAdd;
private ["_array", "_i", "_j"];

if !([_this, [["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_array = _this select 0;

for "_i" from 0 to (count _array - 1) do {
    _j = [_i, (count _array) - 1, true] call Zen_FindInRange;
    0 = [_array, _i, _j] call Zen_ArraySwapValues;
};

for "_i" from 0 to (count _array - 1) do {
    _j = [_i, (count _array) - 1, true] call Zen_FindInRange;
    0 = [_array, _i, _j] call Zen_ArraySwapValues;
};

call Zen_StackRemove;
(_array)

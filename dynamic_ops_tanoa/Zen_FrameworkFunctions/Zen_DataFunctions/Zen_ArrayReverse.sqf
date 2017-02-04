// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayReverse", _this] call Zen_StackAdd;
private ["_array", "_tempArray", "_i"];

if !([_this, [["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;

_tempArray = [];

for "_i" from (count _array - 1) to 0 step -1 do {
    _tempArray pushBack (_array select _i);
};

call Zen_StackRemove;
(_tempArray)

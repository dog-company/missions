// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_ArrayGetIndexedSlice", _this] call Zen_StackAdd;
private ["_i", "_arrayPart", "_array", "_indexEnd", "_indexStart"];

if !([_this, [["ARRAY"], ["SCALAR"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_array = _this select 0;
_indexStart = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_indexEnd, 2, (count _array) - 1)

_arrayPart = [];

if (_indexStart >= (count _array)) then {
    0 = ["Zen_ArrayGetIndexedSlice", "Start index is out of bounds", _this] call Zen_PrintError;
    call Zen_StackPrint;
} else {
    for "_i" from _indexStart to (_indexEnd min ((count _array) - 1)) do {
        _arrayPart pushBack (_array select _i);
    };
};

call Zen_StackRemove;
(_arrayPart)

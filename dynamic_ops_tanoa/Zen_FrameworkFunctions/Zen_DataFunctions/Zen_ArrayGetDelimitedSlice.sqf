// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayGetDelimitedSlice", _this] call Zen_StackAdd;
private ["_totalArray", "_returnArray", "_startIndex", "_startDelimiter", "_endDelimiter", "_i"];

if !([_this, [["ARRAY"], ["VOID"], ["VOID"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_totalArray = _this select 0;
_startDelimiter = _this select 1;
_endDelimiter = _this select 2;

_returnArray = [];
_startIndex = -1;

if (count _totalArray > 2) then {
    {
        if ([_x, _startDelimiter] call Zen_ValuesAreEqual) then {
            _startIndex = _forEachIndex;
        };
    } forEach _totalArray;

    if (_startIndex >= 0) then {
        for "_i" from (_startIndex + 1) to (count _totalArray - 1) do {
            if ([(_totalArray select _i), _endDelimiter] call Zen_ValuesAreEqual) exitWith {};
            _returnArray pushBack (_totalArray select _i);
        };
    };
} else {
    0 = ["Zen_ArrayGetDelimitedSlice", "The given array is too short, minimum 3 elements", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(_returnArray)

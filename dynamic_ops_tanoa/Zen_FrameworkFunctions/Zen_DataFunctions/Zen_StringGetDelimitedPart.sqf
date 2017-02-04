// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_StringGetDelimitedPart", _this] call Zen_StackAdd;
private ["_patternString", "_totalString", "_returnString", "_startIndex", "_startDelimiter", "_endDelimiter", "_i"];

if !([_this, [["STRING"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_totalString = toArray (_this select 0);
_startDelimiter = toArray (_this select 1);
_endDelimiter = toArray (_this select 2);

_returnString = [];
_startIndex = -1;

if (count _totalString >= (count _startDelimiter + count _endDelimiter + 1)) then {
    {
        if ((_x == (_startDelimiter select 0)) && {(_startDelimiter isEqualTo ([_totalString, _forEachIndex, (_forEachIndex + (count _startDelimiter - 1)) min (count _totalString - 1)] call Zen_ArrayGetIndexedSlice))}) then {
            _startIndex = _forEachIndex + (count _startDelimiter);
        };
    } forEach _totalString;

    if (_startIndex > 0) then {
        for "_i" from _startIndex to (count _totalString - 1) do {
            if (((_totalString select _i) == (_endDelimiter select 0)) && {(_endDelimiter isEqualTo ([_totalString, _i, (_i + (count _endDelimiter - 1)) min (count _totalString - 1)] call Zen_ArrayGetIndexedSlice))}) exitWith {};
            _returnString pushBack (_totalString select _i);
        };
    };
} else {
    0 = ["Zen_StringGetDelimitedPart", "The given string is too short.", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(toString _returnString)

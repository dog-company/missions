// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_ArraySearch(", _this] call Zen_StackAdd;
private ["_arrays", "_indexes", "_ranges", "_hashes", "_counts", "_returnIndexes", "_arrayIndex", "_array", "_checksPassed", "_element", "_range", "_hashFunc", "_elementHash", "_lowerBound", "_upperBound"];

if !([_this, [["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"]], [["ARRAY"], ["SCALAR"], ["ARRAY"], ["CODE", "STRING"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (-1)
};

_arrays = _this select 0;
_indexes = _this select 1;
_ranges = _this select 2;
_hashes = _this select 3;

_counts = [count _indexes, count _ranges, count _hashes];
0 = [_counts, count _indexes] call Zen_ArrayRemoveValue;
if (count _counts != 0) exitWith {
    0 = ["Zen_ArraySearch", "Given index, value range, and hash function arrays are different lengths.", _this] call Zen_PrintError;
    call Zen_StackRemove;
    ([])
};

{
    if ((_x select 0) > (_x select 1)) then {
        0 = [_x, 0, 1] call Zen_ArraySwapValues;
    };
} forEach _ranges;

_returnIndexes = [];
{
    _arrayIndex = _forEachIndex;
    _array = _x;
    _checksPassed = 0;
    {
        if (_x >= count _array) exitWith {
            0 = ["Zen_ArraySearch", format ["Index %1 is out of bounds for nested array at %2.", _forEachIndex, _arrayIndex], _this] call Zen_PrintError;
        };

        _element = _array select _x;
        _range = _ranges select _forEachIndex;
        _hashFunc = _hashes select _forEachIndex;

        if (typeName _hashFunc == "CODE") then {
            _elementHash = _element call _hashFunc;
        } else {
            _elementHash = _element call (missionNamespace getVariable _hashFunc);
        };

        _lowerBound = _range select 0;
        _upperBound = _range select 1;

        if !((_elementHash >= _lowerBound) && {(_elementHash <= _upperBound)}) exitWith {};
        _checksPassed = _checksPassed + 1;
    } forEach _indexes;

    if (_checksPassed == count _indexes) then {
        _returnIndexes pushBack _arrayIndex;
    };
} forEach _arrays;

call Zen_StackRemove;
(_returnIndexes)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"
#define INSERT_CUTOFF 7
#define EVAL(X) (X call _comparator)
#define COMP(X, Y) ([X, Y] call _comparator)

_Zen_stack_Trace = ["Zen_ArraySort", _this] call Zen_StackAdd;
private ["_array", "_comparator", "_insertionSort", "_shellSort", "_quickSort", "_comparatorType", "_hashedArray"];

if !([_this, [["ARRAY"], ["CODE"], ["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;

_comparator = {_this};
_comparatorType = "hash";

if (count _this > 1) then {
    _comparator = _this select 1;
    _comparatorType = "compare";
};

if (count _this > 2) then {
    _comparatorType = toLower (_this select 2);
};

_insertionSort = {
    private ["_i", "_j", "_count", "_array", "_value", "_valueOrder"];

    _array = _this;
    if (count _array < 2) exitWith {};

    _count = count _array - 1;

    for "_i" from 1 to _count step 1 do {
        scopeName "forI";
        _value = _array select _i;
        if (_comparatorType == "hash") then {
            _valueOrder = EVAL(_value);
        };

        for [{_j = _i}, {_j >= 1}, {_j = _j - 1}] do {
            if (_comparatorType == "hash") then {
                if (_valueOrder > EVAL(_array select (_j - 1))) then {
                    breakTo "forI";
                };
            } else {
                if (COMP(_value, (_array select (_j - 1))) > 0) then {
                    breakTo "forI";
                };
            };

            _array set [_j, _array select (_j - 1)];
        };

        _array set [_j, _value];
    };
    if (true) exitWith {};
};

/* 
_shellSort = {
    private ["_gaps", "_i", "_j", "_valueOrder", "_count", "_array", "_valueOrder"];

    _array = _this;
    _gaps = [701, 301, 132, 57, 23, 10, 4, 1];
    _count = count _array - 1;

    {
        for "_i" from _x to _count step 1 do {
            if (_i <= _count) then {
            scopeName "if";
                _value = _array select _i;
                _valueOrder = EVAL(_value);
                for [{_j = _i}, {_j >= _x}, {_j = _j - _x}] do {
                    if (_comparatorType == "hash") then {
                        if (_valueOrder > EVAL(_array select (_j - _x))) then {
                            breakTo "if";
                        };
                    } else {
                        if (COMP(_value, (_array select (_j - _x))) > 0) then {
                            breakTo "if";
                        };
                    };

                    _array set [_j, _array select (_j - _x)];
                };

                _array set [_j, _value];
            };
        };
    } forEach _gaps;
    if (true) exitWith {};
};
// */

_quickSort = {
    private ["_array", "_pivot", "_less", "_greater", "_equal", "_pivotValue", "_value"];

    _array = _this;

    _pivotArray = [_array select 0, _array select (count _array - 1), _array select ((count _array) / 2)];
    0 = [_pivotArray] call _insertionSort;
    _pivot = _pivotArray select 1;

    _less = [];
    _equal = [];
    _greater = [];

    if (_comparatorType == "hash") then {
        _pivotValue = EVAL(_pivot);
        {
            _value = EVAL(_x);
            if (_value < _pivotValue) then {
                _less pushBack _x;
            } else {
                if (_value == _pivotValue) then {
                    _equal pushBack _x;
                } else {
                    _greater pushBack _x;
                };
            };
        } forEach _array;
    } else {
        {
            switch (COMP(_x, _pivot)) do {
                case -1: {
                    _less pushBack _x;
                };
                case 0: {
                    _equal pushBack _x;
                };
                case 1: {
                    _greater pushBack _x;
                };
            };
        } forEach _array;
    };

    if (count _less < INSERT_CUTOFF) then {
        0 = _less call _insertionSort;
    } else {
        _less = _less call _quickSort;
    };

    if (count _greater < INSERT_CUTOFF) then {
        0 = _greater call _insertionSort;
    } else {
        _greater = _greater call _quickSort;
    };

    (_less + _equal + _greater)
};

if (count _array < 15) then {
    0 = _array call _insertionSort;
} else {
    _array = _array call _quickSort;
};

call Zen_StackRemove;
(_array)

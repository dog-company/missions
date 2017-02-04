// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_StringFindReplace", _this] call Zen_StackAdd;
private ["_findString", "_replaceString", "_totalString", "_useCase", "_stringPiece", "_char", "_j"];

if !([_this, [["STRING"], ["STRING"], ["STRING"], ["BOOL"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_totalString = _this select 0;
_findString = _this select 1;
_replaceString = _this select 2;

_useCase = false;

if (count _this > 3) then {
    _useCase = _this select 3;
};

if !(_useCase) then {
    _findString = toUpper _findString;
    _replaceString = toUpper _replaceString;
    _totalString = toUpper _totalString;
};

_findString = toArray _findString;
_replaceString = toArray _replaceString;
_totalString = toArray _totalString;

if (_findString isEqualTo _totalString) then {
    _totalString = _replaceString;
} else {
    if ((count _findString) <= (count _totalString)) then {
        for "_j" from 0 to ((count _totalString) - 1) do {
            _char = _totalString select _j;
            if ((count _findString) > ((count _totalString) - _j)) exitWith {};

            if (_char == (_findString select 0)) then {
                _stringPiece = [_totalString, _j, ((count _findString) - 1 + _j)] call Zen_ArrayGetIndexedSlice;
                if (_stringPiece isEqualTo _findString) then {
                    for "_i" from _j to ((count _findString) - 1 + _j) do {
                        _totalString set [_i, -1];
                    };

                    for "_i" from _j to ((count _replaceString) - 1 + _j) do {
                        if ((_totalString select _i) != -1) then {
                            0 = [_totalString, _i, (_replaceString select (_i - _j))] call Zen_ArrayInsert;
                        } else {
                            _totalString set [_i, (_replaceString select (_i - _j))];
                        };
                    };
                };
            };
        };
        _totalString = _totalString - [-1];
    } else {
        0 = ["Zen_StringFindReplace", "The string to find is longer than the string to search in.", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

call Zen_StackRemove;
(toString _totalString)
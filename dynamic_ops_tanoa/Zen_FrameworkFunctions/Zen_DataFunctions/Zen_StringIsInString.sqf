// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_StringIsInString", _this] call Zen_StackAdd;
private ["_keyString", "_totalString", "_useCase", "_keyIsInTotal", "_stringPiece"];

if !([_this, [["STRING"], ["STRING"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_keyString = _this select 0;
_totalString = _this select 1;

_useCase = false;
if ((count _this) > 2) then {
    _useCase = _this select 2;
};

if !(_useCase) then {
    _keyString = toUpper _keyString;
    _totalString = toUpper _totalString;
};

_keyString = toArray _keyString;
_totalString = toArray _totalString;

if ((count _keyString == 0) || (count _totalString == 0)) exitWith {
    0 = ["Zen_StringIsInString", "One or more given strings is empty", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (false)
};

_keyIsInTotal = false;

if ((count _keyString) <= (count _totalString)) then {
    {
        if ((count _keyString) > ((count _totalString) - _forEachIndex)) exitWith {};

        if (_x == (_keyString select 0) || ((_keyString select 0) == 35)) then {
            _stringPiece = [_totalString, _forEachIndex, ((count _keyString) - 1 + _forEachIndex)] call Zen_ArrayGetIndexedSlice;
            {
                if (_x == 35) then {
                    _stringPiece set [_forEachIndex, _x];
                };
            } forEach _keyString;
            _keyIsInTotal = _stringPiece isEqualTo _keyString;
        };
        if (_keyIsInTotal) exitWith {};
    } forEach _totalString;
};

call Zen_StackRemove;
(_keyIsInTotal)

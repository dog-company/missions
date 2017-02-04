// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveValuedSlice", _this] call Zen_StackAdd;
private ["_keyArray", "_totalArray", "_keyIsInTotal", "_stringPiece"];

if !([_this, [["ARRAY"], ["ARRAY"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_totalArray = _this select 0;
_keyArray = _this select 1;

_keyIsInTotal = false;

if ((count _keyArray) <= (count _totalArray)) then {
    {
        if ((count _keyArray) > ((count _totalArray) - _forEachIndex)) exitWith {};

        if ([_x, (_keyArray select 0)] call Zen_ValuesAreEqual) then {
            _stringPiece = [_totalArray, _forEachIndex, ((count _keyArray) - 1 + _forEachIndex)] call Zen_ArrayGetIndexedSlice;
            _keyIsInTotal = _stringPiece isEqualTo _keyArray;
        };

        if (_keyIsInTotal) exitWith {
            _totalArray = [_totalArray, _forEachIndex, ((count _keyArray) - 1 + _forEachIndex)] call Zen_ArrayRemoveIndexedSlice;
        };
    } forEach _totalArray;
} else {
    0 = ["Zen_ArrayRemoveValuedSlice", "Given array to search for is larger than the array to remove from", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayReplaceValueNested", _this] call Zen_StackAdd;
private ["_array", "_searchValue", "_replaceValue"];

if !([_this, [["ARRAY"], ["VOID"], ["VOID"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_array = _this select 0;
_searchValue = _this select 1;
_replaceValue = _this select 2;

{
    if (typeName _x == "ARRAY") then {
        0 = [_x, _searchValue, _replaceValue] call Zen_ArrayReplaceValue;
    } else {
        if ([_x, _searchValue] call Zen_ValuesAreEqual) then {
            _array set [_forEachIndex, _replaceValue];
        };
    };
} forEach _array;

call Zen_StackRemove;
if (true) exitWith {};

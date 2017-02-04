// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ValueFindInArray", _this] call Zen_StackAdd;
private ["_value", "_array", "_index"];

if !([_this, [["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (-1)
};

_value = _this select 0;
_array = _this select 1;

if (typeName _array != "ARRAY") then {
    _array = [_array];
};

_index = -1;

if ((typeName _value) in ["ARRAY", "STRING"]) then {
    {
        if ([_x, _value] call Zen_ValuesAreEqual) exitWith {
            _index = _forEachIndex;
        };
    } forEach _array;
} else {
    _index = _array find _value;
};

call Zen_StackRemove;
(_index)

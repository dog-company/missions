// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ValueIsInArray", _this] call Zen_StackAdd;
private ["_value", "_array", "_isInArray"];

if !([_this, [["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_value = _this select 0;
_array = _this select 1;

if (typeName _array != "ARRAY") then {
    _array = [_array];
};

_isInArray = false;

if (typeName _value != "ARRAY") then {
    if (typeName _value == "STRING") then {
        {
            if (typeName _x == "ARRAY") then {
                _isInArray = [_value, _x] call Zen_ValueIsInArray;
            } else {
                _isInArray = [_value, _x] call Zen_ValuesAreEqual;
            };

            if (_isInArray) exitWith {};
        } forEach _array;
    } else {
        if (_value in _array) exitWith {
            _isInArray = true;
        };

        {
            if (typeName _x == "ARRAY") then {
                _isInArray = [_value, _x] call Zen_ValueIsInArray;
            };

            if (_isInArray) exitWith {};
        } forEach _array;
    };
} else {
    {
        if (typeName _x == "ARRAY") then {
            if ([_value, _x] call Zen_ValuesAreEqual) then {
                _isInArray = true;
                if (true) exitWith {};
            } else {
                _isInArray = [_value, _x] call Zen_ValueIsInArray;
            };
        };

        if (_isInArray) exitWith {};
    } forEach _array;
};

call Zen_StackRemove;
(_isInArray)

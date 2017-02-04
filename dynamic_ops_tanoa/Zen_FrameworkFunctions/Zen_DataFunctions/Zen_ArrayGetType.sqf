// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayGetType", _this] call Zen_StackAdd;
private ["_array", "_type", "_return"];

if !([_this, [["ARRAY"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_array = _this select 0;
_type = _this select 1;

if (typeName _type != "STRING") then {
    _type = typeName _type;
} else {
    if (_type == "") then {
        _type = "STRING";
    };
};

_return = [];

{
    if ((_type != "ARRAY") && {(typeName _x == "ARRAY")}) then {
        0 = [_x, _type] call Zen_ArrayGetType;
    } else {
        if (typeName _x == _type) then {
            _return pushBack _x;
        };
    };
} forEach _array;

call Zen_StackRemove;
(_return)

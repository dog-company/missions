// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayFindExtremum", _this] call Zen_StackAdd;
private ["_array", "_function", "_return", "_returnHash", "_tempHash", "_i"];

if !([_this, [["ARRAY"], ["CODE"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_array = _this select 0;
_function = _this select 1;

if (count _array == 0) exitWith {
    call Zen_StackRemove;
    (0)
};

if (count _array == 1) exitWith {
    call Zen_StackRemove;
    (_array select 0)
};

_i = 0;
_return = 0;
for "_i" from 0 to (count _array - 1) do {
    _return = (_array select _i);
    _returnHash = _return call _function;
    if (typeName _returnHash == "SCALAR") exitWith {};
};

for "_j" from _i to (count _array - 1) do {
    _tempHash = (_array select _j) call _function;
    if (typeName _tempHash == "SCALAR") then {
        if (_tempHash > _returnHash) then {
            _return = (_array select _j);
            _returnHash = _tempHash;
        };
    };
};

call Zen_StackRemove;
(_return)

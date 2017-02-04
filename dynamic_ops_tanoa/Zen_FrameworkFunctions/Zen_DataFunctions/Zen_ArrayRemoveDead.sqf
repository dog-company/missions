// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveDead", _this] call Zen_StackAdd;
private ["_array", "_returnObjectArray", "_nestedObjects"];

if !([_this, [["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_array = _this select 0;
_returnObjectArray = [];

{
    switch (typeName _x) do {
        case "OBJECT": {
            if (!(isNull _x) && {(alive _x)}) then {
                _returnObjectArray pushBack _x;
            };
        };
        case "GROUP": {
            if (!(isNull _x) && {(({alive _x} count units _x) > 0)}) then {
                _returnObjectArray pushBack _x;
            };
        };
        case "ARRAY": {
            if (count _x > 0) then {
                _nestedObjects = [_x] call Zen_ArrayRemoveDead;
                if (count _nestedObjects > 0) then {
                    _returnObjectArray pushBack _nestedObjects;
                };
            };
        };
        default {
            _returnObjectArray pushBack _x;
        };
    };
} forEach _array;

call Zen_StackRemove;
(_returnObjectArray)

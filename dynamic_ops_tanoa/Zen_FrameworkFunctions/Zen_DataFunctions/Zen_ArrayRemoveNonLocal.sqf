// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveNonLocal", _this] call Zen_StackAdd;
private ["_objectArray", "_returnObjectArray"];

if !([_this, [["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_objectArray = [(_this select 0)] call Zen_ConvertToObjectArray;
_returnObjectArray = [];

{
    if ((typeName _x == "OBJECT") && {(local _x)}) then {
        _returnObjectArray pushBack _x;
    } else {
        if (typeName _x == "ARRAY") then {
            _returnObjectArray pushBack ([_x] call Zen_ArrayRemoveNonLocal);
        };
    };
} forEach _objectArray;

call Zen_StackRemove;
(_returnObjectArray)

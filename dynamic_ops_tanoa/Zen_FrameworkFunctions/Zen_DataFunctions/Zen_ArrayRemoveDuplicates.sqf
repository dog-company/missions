// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ArrayRemoveDuplicates", _this] call Zen_StackAdd;
private ["_givenArray", "_returnArray"];

if !([_this, [["ARRAY"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_givenArray = _this select 0;
_returnArray = [];

_returnArray = [];
{
    if !([_x, _returnArray] call Zen_ValueIsInArray) then {
        _returnArray pushBack _x;
    };
} forEach _givenArray;

call Zen_StackRemove;
(_returnArray)

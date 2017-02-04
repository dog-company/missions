// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindMaxDistance", _this] call Zen_StackAdd;
private ["_testArray", "_center", "_outElement"];

if !([_this, [["ARRAY"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 1)
};

_testArray = _this select 0;
_center = [(_this select 1)] call Zen_ConvertToPosition;

_outElement = 0;

if (count _testArray > 0) then {
    _outElement = _testArray select 0;
    {
        if (([_x, _center] call Zen_Find2dDistance) > ([_center, _outElement] call Zen_Find2dDistance)) then {
            _outElement = _x;
        };
    } forEach _testArray;
} else {
    0 = ["Zen_FindMaxDistance", "Given array to compare to the center is empty", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(_outElement)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetFireSupportData", _this] call Zen_StackAdd;
private ["_nameString", "_templateArray"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_nameString = _this select 0;
_templateArray = [];

{
    if ([(_x select 0), _nameString] call Zen_ValuesAreEqual) exitWith {
        _templateArray =+ _x;
    };
} forEach Zen_Fire_Support_Array_Global;

if (count _templateArray == 0) then {
    0 = ["Zen_GetFireSupportData", "Given template does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(_templateArray)

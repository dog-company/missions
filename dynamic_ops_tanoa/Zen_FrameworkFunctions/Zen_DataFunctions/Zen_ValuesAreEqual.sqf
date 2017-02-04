// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ValuesAreEqual", _this] call Zen_StackAdd;
private ["_value1", "_value2"];

if !([_this, [["VOID"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_value1 = _this select 0;
_value2 = _this select 1;

if ((typeName _value1 == "STRING") && (typeName _value2 == "STRING")) then {
    _value1 = toLower _value1;
    _value2 = toLower _value2;
};

call Zen_StackRemove;
(_value1 isEqualTo _value2)

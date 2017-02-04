// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_StringCapitalizeLetter", _this] call Zen_StackAdd;
private ["_givenString", "_letter", "_index"];

if !([_this, [["STRING"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (_this select 0)
};

_givenString = toArray (_this select 0);
_index = 0;

if (count _this > 1) then {
    _index = _this select 1;
};

if (_index >= (count _givenString)) exitWith {
    0 = ["Zen_StringCapitalizeLetter", "Given index is out of bounds", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (_givenString)
};

_letter = _givenString select _index;
_givenString set [_index, ((toArray (toUpper (toString [_letter]))) select 0)];

call Zen_StackRemove;
(toString _givenString)

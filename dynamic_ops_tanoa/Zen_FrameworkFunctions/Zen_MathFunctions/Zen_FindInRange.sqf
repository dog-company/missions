// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindInRange", _this] call Zen_StackAdd;
private ["_rangeMin", "_rangeMax", "_return", "_isWholeNumber", "_maxTemp"];

if !([_this, [["SCALAR"], ["SCALAR"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (0)
};

_rangeMin = _this select 0;
_rangeMax = _this select 1;

_isWholeNumber = false;
if (count _this > 2) then {
    _isWholeNumber = _this select 2;
};

if (_rangeMin > _rangeMax) then {
    _maxTemp = _rangeMax;
    _rangeMax = _rangeMin;
    _rangeMin = _maxTemp;
};

_return = _rangeMin + (random (_rangeMax - _rangeMin));

if (_isWholeNumber) then {
    _return = round _return;
};

call Zen_StackRemove;
(_return)

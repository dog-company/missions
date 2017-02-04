// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_AreNotInArea", _this] call Zen_StackAdd;
private ["_unitsArray", "_polygonArgs", "_areNotInArea", "_unit", "_isInArea", "_isInBlacklist", "_blacklist", "_inAreaArgs"];

if !([_this, [["VOID"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], [], ["SCALAR", "STRING"], [], [], ["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_unitsArray = [(_this select 0)] call Zen_ConvertToObjectArray;

_blacklist = [];

if (count _this > 3) then {
    _polygonArgs = [_this, 1, 4] call Zen_ArrayGetIndexedSlice;
    if (count _this > 5) then {
        _blacklist = _this select 5;
    };
} else {
    _polygonArgs = _this select 1;
    if (count _this > 2) then {
        _blacklist = _this select 2;
    };
};

_areNotInArea = true;

{
    _inAreaArgs = [];
    _unit = _x;
    0 = [_inAreaArgs, _unit, _polygonArgs] call Zen_ArrayAppendNested;
    _isInArea = _inAreaArgs call Zen_IsPointInPoly;

    _isInBlacklist = false;
    if (count _blacklist > 0) then {
        {
            _isInBlacklist = [_unit, _x] call Zen_IsPointInPoly;
            if (_isInBlacklist) exitWith {};
        } forEach _blacklist;
    };

    if (_isInArea && {!_isInBlacklist}) exitWith {
        _areNotInArea = false;
    };
} forEach _unitsArray;

call Zen_StackRemove;
(_areNotInArea)

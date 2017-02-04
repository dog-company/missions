// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetAllInArea", _this] call Zen_StackAdd;
private ["_center", "_sidesAllowed", "_XYSizeArray", "_objectArray", "_polygonArgs", "_blacklist", "_inAreaArgs", "_isInArea"];

if !([_this, [["VOID"], ["ARRAY"], ["SIDE", "ARRAY", "SCALAR"], ["STRING"], ["ARRAY"], ["SIDE", "ARRAY"]], [[], ["STRING", "SCALAR"], ["SIDE"], [], ["STRING"], ["SIDE"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_sidesAllowed = [West, East, Resistance, Civilian];
_blacklist = [];

if (count _this > 3) then {
    _polygonArgs = [_this, 0, 3] call Zen_ArrayGetIndexedSlice;
    _XYSizeArray = _polygonArgs select 1;
    if (count _this > 4) then {
        _blacklist = _this select 4;
    };
    if (count _this > 5) then {
        _sidesAllowed = _this select 5;
    };
} else {
    _polygonArgs = _this select 0;
    _XYSizeArray = getMarkerSize _polygonArgs;
    if (count _this > 1) then {
        _blacklist = _this select 1;
    };
    if (count _this > 2) then {
        _sidesAllowed = _this select 2;
    };
};

_objectArray = [];
_inAreaArgs = [];
0 = [_inAreaArgs, "", _polygonArgs, _blacklist] call Zen_ArrayAppendNested;

{
    _inAreaArgs set [0, _x];
    _isInArea = _inAreaArgs call Zen_AreInArea;

    if !(_x isKindOf "Animal") then {
        if (_isInArea && {((alive _x) && ([(side _x), _sidesAllowed] call Zen_ValueIsInArray))}) then {
            if (_x isKindOf "Man") then {
                _objectArray pushBack _x;
            } else {
                0  = [_objectArray, (crew _x)] call Zen_ArrayAppendNested;
            };
        };
    };
} forEach (_center nearEntities [["Man", "Armored", "Car", "Air", "Ship"], ([_XYSizeArray] call Zen_ArrayFindSum)]);

call Zen_StackRemove;
(_objectArray)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_RotateAsSet", _this] call Zen_StackAdd;
private ["_moveObjects", "_center", "_moveMarkers", "_newPos", "_rotateAngle", "_redir"];

if !([_this, [["VOID"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_moveEntities = _this select 0;
_rotateAngle = _this select 1;
ZEN_STD_Parse_GetArgumentDefault(_redir, 2, false)

if (typeName _moveEntities != "ARRAY") then {
    _moveEntities = [_moveEntities];
};

_moveMarkers = [_moveEntities, ""] call Zen_ArrayGetType;
_moveObjects = [_moveEntities] call Zen_ConvertToObjectArray;

0 = [_moveObjects, _moveMarkers] call Zen_ArrayAppendNested;
_center = _moveObjects call Zen_FindAveragePosition;

{
    _relativePos = ([_x] call Zen_ConvertToPosition) vectorDiff _center;
    _rotRelativePos = ZEN_STD_Math_VectRotateZ(_relativePos, _rotateAngle);
    _newPos = _center vectorAdd _rotRelativePos;

    if (typeName _x == "STRING") then {
        _x setMarkerPos _newPos;
        if (_redir) then {
            _x setMarkerDir (markerDir _x + _rotateAngle);
        };
    } else {
        if (_redir) then {
            0 = [_x, _newPos, (if (_x isKindOf "LandVehicle") then {(0.2)} else {(0)}), 0, (getDir _x) + _rotateAngle, true] call Zen_TransformObject;
        } else {
            0 = [_x, _newPos, (if (_x isKindOf "LandVehicle") then {(0.2)} else {(0)}), 0, (getDir _x), true] call Zen_TransformObject;
        };
    };
} forEach _moveObjects;

call Zen_StackRemove;
if (true) exitWith {};

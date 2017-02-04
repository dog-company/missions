// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_TransformObject", _this] call Zen_StackAdd;
private ["_obj", "_pos", "_heightChange", "_velocity", "_dir", "_isNormal", "_setNormal"];

if !([_this, [["OBJECT"], ["VOID"], ["SCALAR"], ["SCALAR", "ARRAY"], ["SCALAR"], ["BOOL"]], [[], [], [], ["SCALAR"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_obj = _this select 0;
_pos = [(_this select 1)] call Zen_ConvertToPosition;

ZEN_STD_Parse_GetArgumentDefault(_heightChange, 2, 0)
ZEN_STD_Parse_GetArgumentDefault(_velocity, 3, 0)
ZEN_STD_Parse_GetArgumentDefault(_dir, 4, (getDir _obj))
ZEN_STD_Parse_GetArgumentDefault(_isNormal, 5, false)

if (_velocity isEqualTo 0) then {
    _velocity = ZEN_STD_Math_VectCartCyl((velocity _obj));
};

if (surfaceIsWater _pos) then {
    _pos set [2, ((_pos select 2) + _heightChange) max (getTerrainHeightASL _pos)];
} else {
    _pos set [2, ((_pos select 2) + _heightChange) max 0];
};

_obj setPosATL _pos;
_setNormal = (_isNormal && {!(_obj isKindOf "Man")});

if (local _obj) then {
    0 = [_obj, _velocity, _dir, _setNormal] spawn Zen_TransformObject_Orient_MP;
} else {
    Zen_MP_Closure_Packet = ["Zen_TransformObject_Orient_MP", [_obj, _velocity, _dir, _setNormal]];
    (owner _obj) publicVariableClient "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

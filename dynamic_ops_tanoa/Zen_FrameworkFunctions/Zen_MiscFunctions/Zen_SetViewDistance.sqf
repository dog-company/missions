// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetViewDistance", _this] call Zen_StackAdd;
private ["_viewDist", "_objDist", "_shadowDist", "_sendPacket"];

if !([_this, [["SCALAR"], ["SCALAR"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_viewDist = _this select 0;

if (_viewDist != -1) then {
    setViewDistance _viewDist;
};

_objDist = -1;
_shadowDist = -1;
_sendPacket = true;

if (count _this > 1) then {
    _objDist = _this select 1;
} else {
    _this set [1,-1];
};

if (count _this > 2) then {
    _shadowDist = _this select 2;
} else {
    _this set [2,-1];
};

if (count _this > 3) then {
    _sendPacket = _this select 3;
};

if (_objDist != -1) then {
    setObjectViewDistance _viewDist;
};

if (_shadowDist != -1) then {
    setShadowDistance _viewDist;
};

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_SetViewDistance", (_this + [false])];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

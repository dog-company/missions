// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_GuideRound", _this] call Zen_StackAdd;
private ["_round", "_guidanceObject", "_guidanceType", "_offTargetDistance", "_angleToTarget", "_roundAdjust", "_roundPosition"];

if !([_this, [["VOID"], ["VOID"], ["VOID"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_round = _this select 0;
_guidanceObject = _this select 1;
_guidanceType = _this select 2;

if ((_guidanceType == "designator") && {!(local _guidanceObject)}) exitWith {
    call Zen_StackRemove;
};

scopeName "main";
while {!(isNull _round) && {(alive _round)}} do {
    if (_guidanceType == "designator") then {
        if !(isNull laserTarget _guidanceObject) then {
            _roundPosition = getPosATL laserTarget _guidanceObject;
        } else {
            _roundPosition = getPosATL _round;
        };
    } else {
        _roundPosition = getPosATL _guidanceObject;
    };

    _offTargetDistance = [_roundPosition, _round] call Zen_Find2dDistance;
    _angleToTarget = [_round, _roundPosition] call Zen_FindDirection;

    if (_offTargetDistance > 5) then {
        _roundAdjust = [_round, 8 + random 4, _angleToTarget, "trig", 0] call Zen_ExtendPosition;
    } else {
        _roundAdjust = [_round, _offTargetDistance, _angleToTarget, "trig", 0] call Zen_ExtendPosition;
        breakTo "main";
    };

    _round setPosATL [(_roundAdjust select 0), (_roundAdjust select 1), ZEN_STD_OBJ_ATLPositionZ(_round) - 1];
    _round setVelocity [0, 0, -200];
    sleep 0.1;
};

call Zen_StackRemove;
if (true) exitWith {};

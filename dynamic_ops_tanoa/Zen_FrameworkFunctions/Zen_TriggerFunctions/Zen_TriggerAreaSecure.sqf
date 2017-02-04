// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TriggerAreaSecure", _this] call Zen_StackAdd;
private ["_defenders", "_attackers", "_taskUniqueName", "_polygonArgs", "_attackersAreIn", "_taskResult", "_blacklist", "_inAreaArgs"];

if !([_this, [["VOID"], ["VOID"], ["STRING", "ARRAY"], ["STRING"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], [], ["STRING"], [], [], ["STRING", "SCALAR"], [], [], ["STRING"]], 5] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_defenders = [(_this select 0)] call Zen_ConvertToObjectArray;
_attackers = [(_this select 1)] call Zen_ConvertToObjectArray;
_taskUniqueName = _this select 2;
_taskResult = _this select 3;

if (typeName _taskUniqueName == "STRING") then {
    _taskUniqueName = [_taskUniqueName];
};

_blacklist = [];

if (count _this > 6) then {
    _polygonArgs = [_this, 4, 7] call Zen_ArrayGetIndexedSlice;
    if (count _this > 8) then {
        _blacklist = _this select 8;
    };
} else {
    _polygonArgs = _this select 4;
    if (count _this > 5) then {
        _blacklist = _this select 5;
    };
};

while {true} do {
    sleep 10;

    if ([_taskUniqueName, _taskResult] call Zen_AreTasksComplete) exitWith {};

    if (typeName (_this select 1) == "SIDE") then {
        _attackers = [(_this select 1)] call Zen_ConvertToObjectArray;
    };

    _attackers = [_attackers] call Zen_ArrayRemoveDead;
    if (count _attackers == 0) exitWith {};

    _inAreaArgs = [];
    0 = [_inAreaArgs, [_attackers], _polygonArgs, _blacklist] call Zen_ArrayAppendNested;
    _attackersAreIn = !(_inAreaArgs call Zen_AreNotInArea);

    if (typeName (_this select 0) == "SIDE") then {
        _defenders = [(_this select 0)] call Zen_ConvertToObjectArray;
    };

    _defendersAreOut = true;
    _defenders = [_defenders] call Zen_ArrayRemoveDead;
    if (count _defenders > 0) then {
        _inAreaArgs = [];
        0 = [_inAreaArgs, [_defenders], _polygonArgs, _blacklist] call Zen_ArrayAppendNested;
        _defendersAreOut = _inAreaArgs call Zen_AreNotInArea;
    };


    if (_defendersAreOut && {_attackersAreIn}) exitWith {
        {
            0 = [_x, _taskResult] call Zen_UpdateTask;
            sleep 2;
        } forEach _taskUniqueName;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

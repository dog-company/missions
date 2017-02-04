// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TriggerAreaClear", _this] call Zen_StackAdd;
private ["_defenders", "_blacklist", "_taskUniqueName", "_polygonArgs", "_defendersAreOut", "_taskResult", "_inAreaArgs"];

if !([_this, [["VOID"], ["STRING", "ARRAY"], ["STRING"], ["VOID"], ["ARRAY"], ["SCALAR"], ["STRING"], ["ARRAY"]], [[], ["STRING"], [], [], ["STRING", "SCALAR"], [], [], ["STRING"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_defenders = [(_this select 0)] call Zen_ConvertToObjectArray;
_taskUniqueName = _this select 1;
_taskResult = _this select 2;

if (typeName _taskUniqueName == "STRING") then {
    _taskUniqueName = [_taskUniqueName];
};

_blacklist = [];

if (count _this > 5) then {
    _polygonArgs = [_this, 3, 6] call Zen_ArrayGetIndexedSlice;
    if (count _this > 7) then {
        _blacklist = _this select 7;
    };
} else {
    _polygonArgs = _this select 3;
    if (count _this > 4) then {
        _blacklist = _this select 4;
    };
};

while {true} do {
    sleep 10;

    if ([_taskUniqueName, _taskResult] call Zen_AreTasksComplete) exitWith {};

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

    if (_defendersAreOut) exitWith {
        {
            0 = [_x, _taskResult] call Zen_UpdateTask;
            sleep 2;
        } forEach _taskUniqueName;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

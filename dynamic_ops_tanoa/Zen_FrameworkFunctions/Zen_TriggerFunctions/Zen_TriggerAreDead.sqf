// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TriggerAreDead", _this] call Zen_StackAdd;
private ["_taskUniqueName", "_taskResult", "_maxAlive", "_objectsArray"];

if !([_this, [["VOID"], ["STRING", "ARRAY"], ["STRING"], ["SCALAR"]], [[], ["STRING"]], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_objectsArray = [(_this select 0)] call Zen_ConvertToObjectArray;
_taskUniqueName = _this select 1;
_taskResult = _this select 2;

_maxAlive = 0;
if (count _this > 3) then {
    _maxAlive = _this select 3;
};

if (_maxAlive > count _objectsArray) then {
    0 = ["Zen_TriggerAreDead", "Given number of max living units exceeds the number of units to check", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

if (typeName _taskUniqueName == "STRING") then {
    _taskUniqueName = [_taskUniqueName];
};

while {true} do {
    sleep 5;

    if ([_taskUniqueName, _taskResult] call Zen_AreTasksComplete) exitWith {};

    if (typeName (_this select 0) == "SIDE") then {
        _objectsArray = [(_this select 0)] call Zen_ConvertToObjectArray;
    };

    _objectsArray = [_objectsArray] call Zen_ArrayRemoveDead;

    if ((count _objectsArray <= _maxAlive) || (count _objectsArray == 0)) exitWith {
        {
            0 = [_x, _taskResult] call Zen_UpdateTask;
            sleep 2;
        } forEach _taskUniqueName;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

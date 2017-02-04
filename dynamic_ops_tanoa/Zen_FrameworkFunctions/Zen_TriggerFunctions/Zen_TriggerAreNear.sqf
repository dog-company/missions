// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TriggerAreNear", _this] call Zen_StackAdd;
private ["_objPos", "_rangers", "_taskUniqueName", "_taskResult", "_areNear", "_distance", "_pos", "_requiredUnits", "_givenPos"];

if !([_this, [["VOID"], ["STRING", "ARRAY"], ["STRING"], ["VOID"], ["STRING"], ["SCALAR"]], [[], ["STRING"]], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_rangers = [(_this select 0)] call Zen_ConvertToObjectArray;
_taskUniqueName = _this select 1;
_taskResult = _this select 2;
_givenPos = _this select 3;

_requiredUnits = "one";
_distance = 10;

if (count _this > 4) then {
    _requiredUnits = toLower (_this select 4);
};

if (count _this > 5) then {
    _distance = _this select 5;
};

if (typeName _givenPos != "ARRAY") then {
    _givenPos = [_givenPos];
};

if (typeName (_givenPos select 0) == "SCALAR") then {
    _objPos = [_givenPos];
} else {
    _objPos = [];
    {
        if ((typeName _x) in ["OBJECT", "GROUP"]) then {
            _pos = _x;
        } else {
            _pos = [_x] call Zen_ConvertToPosition;
        };
        _objPos pushBack _pos;
    } forEach _givenPos;
};

if (typeName _taskUniqueName == "STRING") then {
    _taskUniqueName = [_taskUniqueName];
};

while {true} do {
    sleep 5;

    if ([_taskUniqueName, _taskResult] call Zen_AreTasksComplete) exitWith {};

    if (typeName (_this select 1) == "SIDE") then {
        _rangers = [(_this select 1)] call Zen_ConvertToObjectArray;
    };

    _rangers = [_rangers] call Zen_ArrayRemoveDead;
    if (count _rangers == 0) exitWith {};

    _areNear = true;
    if (_requiredUnits == "one") then {
        {
            if ([_rangers, _x, [_distance, _distance], 0, "ellipse"] call Zen_AreNotInArea) then {
                _areNear = false;
            }
        } forEach _objPos;
    } else {
        {
            if !([_rangers, _x, [_distance, _distance], 0, "ellipse"] call Zen_AreInArea) then {
                _areNear = false;
            }
        } forEach _objPos;
    };

    if (_areNear) exitWith {
        {
            0 = [_x, _taskResult] call Zen_UpdateTask;
            sleep 2;
        } forEach _taskUniqueName;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

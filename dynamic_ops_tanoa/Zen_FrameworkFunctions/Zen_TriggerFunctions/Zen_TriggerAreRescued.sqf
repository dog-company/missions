// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_TriggerAreRescued", _this] call Zen_StackAdd;
private ["_hostages", "_rescuers", "_tasks", "_hostagesRemove", "_unitsIn", "_hostage", "_nearRescuer", "_hostagesRescued"];

if !([_this, [["VOID"], ["VOID"], ["STRING", "ARRAY"]], [[], [], ["STRING"]], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_hostages = [(_this select 0)] call Zen_ConvertToObjectArray;
_rescuers = [(_this select 1)] call Zen_ConvertToObjectArray;
_tasks = _this select 2;

if (typeName _tasks != "ARRAY") then {
    _tasks = [_tasks];
};

{
    _x setCaptive true;
} forEach _hostages;

_hostagesRescued = [];

while {true} do {
    sleep 10;

    if ([_tasks, "succeeded"] call Zen_AreTasksComplete) exitWith {};
    _hostagesRemove = [];
    {
        _hostage = _x;
        if (alive _hostage) then {
            if !(_hostage in _hostagesRescued) then {

                if (typeName (_this select 1) == "SIDE") then {
                    _rescuers = [(_this select 1)] call Zen_ConvertToObjectArray;
                };

                _rescuers = [_rescuers] call Zen_ArrayRemoveDead;
                if (count _rescuers == 0) exitWith {};

                _unitsIn = [_hostage, [5, 5], 0, "ellipse"] call Zen_GetAllInArea;

                {
                    if ((_x in _unitsIn) && {(abs (ZEN_STD_OBJ_ATLPositionZ(_x) - ZEN_STD_OBJ_ATLPositionZ(_hostage))) < 2}) exitWith {
                        _nearRescuer = [_rescuers, _hostage] call Zen_FindMinDistance;
                        [_hostage] join _nearRescuer;
                        _hostage enableAI "MOVE";
                        _hostage setCaptive false;
                        _hostagesRescued pushBack _hostage;
                    };
                } forEach _rescuers;
            };
        } else {
            _hostagesRemove pushBack _hostage;
        };
    } forEach _hostages;

    _hostages = _hostages - _hostagesRemove;

    if (count _hostages == 0) exitWith {
        {
            0 = [_x, "failed"] call Zen_UpdateTask;
            sleep 2;
        } forEach _tasks;
    };

    if ((count _hostagesRescued > 0) && {(count _hostages == count _hostagesRescued)}) exitWith {
        {
            0 = [_x, "succeeded"] call Zen_UpdateTask;
            sleep 2;
        } forEach _tasks;
    };
};

while {true} do {
    sleep 10;

    if ([_tasks, "failed"] call Zen_AreTasksComplete) exitWith {};
    _hostages = [_hostages] call Zen_ArrayRemoveDead;

    if (count _hostages == 0) exitWith {
        {
            0 = [_x, "failed"] call Zen_UpdateTask;
            sleep 2;
        } forEach _tasks;
    };
};

call Zen_StackRemove;
if (true) exitWith {};

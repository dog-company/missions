// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_AreUnitsTasksComplete", _this] call Zen_StackAdd;
private ["_units", "_areComplete", "_taskState", "_includeTaskArray", "_excludeTaskArray", "_orgIncludeType", "_unitsTasks"];

if !([_this, [["VOID"], ["ARRAY", "STRING", "SCALAR"], ["ARRAY", "STRING"]], [[], ["STRING"], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;

_includeTaskArray = 0;
_excludeTaskArray = [];

if (count _this > 1) then {
    _includeTaskArray = _this select 1;
};
if (count _this > 2) then {
    _excludeTaskArray = _this select 2;
};

if (typeName _includeTaskArray == "STRING") then {
    _includeTaskArray = [_includeTaskArray];
};

if (typeName _excludeTaskArray == "STRING") then {
    _excludeTaskArray = [_excludeTaskArray];
};

_areComplete = true;
_orgIncludeType = (typeName _includeTaskArray);

{
    _unitsTasks = [_x] call Zen_GetUnitTasks;
    if (count _unitsTasks > 0) then {
        if (_orgIncludeType == "SCALAR") then {
            _includeTaskArray = _unitsTasks;
        };
        
        {
            if (([_x, _includeTaskArray] call Zen_ValueIsInArray) && !([_x, _excludeTaskArray] call Zen_ValueIsInArray)) then {
                _taskState = ([_x] call Zen_GetTaskDataGlobal) select 2;
                if !([_taskState, ["failed", "succeeded", "canceled"]] call Zen_ValueIsInArray) then {
                    _areComplete = false;
                };
            };
        } forEach _unitsTasks;
    };
} forEach _units;

call Zen_StackRemove;
(_areComplete)

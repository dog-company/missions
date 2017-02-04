// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

// This folder contains framework source code version 7/10/16

#include "Zen_StandardLibrary.sqf"
#include "Zen_FrameworkLibrary.sqf"

_Zen_Is_JIP = false;
if (!isServer && {isNull player}) then {
   _Zen_Is_JIP = true;
    waitUntil {
        (!(isNull player) && {local player})
    };
};
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DataFunctions\Zen_DataFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_DialogSystem\Zen_DialogSystemCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_FireSupportSystemCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_LoadoutFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_MathFunctions\Zen_MathFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_MiscFunctions\Zen_MiscFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectFunctions\Zen_ObjectFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_ObjectiveSystem\Zen_ObjectiveSystemCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_OrdersFunctions\Zen_OrdersFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_PositionFunctions\Zen_PositionFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_SpawningFunctions\Zen_SpawningFunctionsCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_TaskSystemCompile.sqf";
call compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TriggerFunctions\Zen_TriggerFunctionsCompile.sqf";
Zen_StackAdd = {
    (if (isNil "_Zen_stack_Trace") then {
        ([[(_this select 0), (_this select 1), time]])
    } else {
        _Zen_stack_Trace pushBack [(_this select 0), (_this select 1), time];
        (_Zen_stack_Trace)
    })
};
Zen_StackPrint = {
    for "_i" from (count _Zen_stack_Trace - 1) to 0 step -1 do {
        if (Zen_Print_All_Errors) then {
            systemChat str (_Zen_stack_Trace select _i);
        };
        diag_log (_Zen_stack_Trace select _i);
    };
};
Zen_StackRemove = {
    _Zen_stack_Trace resize ((count _Zen_stack_Trace) - 1);
};
Zen_Debug_Arguments = true;
Zen_Print_All_Errors = true;
Zen_MP_Closure_Packet = [];
"Zen_MP_Closure_Packet" addPublicVariableEventHandler {
    private ["_this", "_code", "_args"];
    _this = _this select 1;
    _code = _this select 0;
    if (count _this > 1) then {
        _args = _this select 1;
    } else {
        _args = [];
    };
    if ((typeName _code) == "STRING") then {
        if !(isNil {(missionNamespace getVariable _code)}) then {
            0 = _args spawn (missionNamespace getVariable _code);
        } else {
            if (isServer) then {
                0 = ["Zen_MP_Closure_Packet", "Given function string is undefined", _code] call Zen_PrintError;
            } else {
                Zen_MP_Closure_Packet = ["Zen_PrintError", ["Zen_MP_Closure_Packet", "Given function string is undefined", _code]];
                publicVariableServer "Zen_MP_Closure_Packet";
            };
        };
    } else {
        0 = _args spawn _code;
    };
};
finishMissionInit;
if ({side _x == east} count allUnits == 0) then {
    createCenter east;
};
if ({side _x == west} count allUnits == 0) then {
    createCenter west;
};
if ({side _x == resistance} count allUnits == 0) then {
    createCenter resistance;
};
if ({side _x == civilian} count allUnits == 0) then {
    createCenter civilian;
};
_Zen_Stack_Trace = ["Init"];

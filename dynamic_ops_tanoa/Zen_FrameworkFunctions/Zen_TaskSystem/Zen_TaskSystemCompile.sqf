// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

Zen_Task_Array_Global = [];
Zen_Task_Array_Local = [];

Zen_AreTasksComplete = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_AreTasksComplete.sqf";
Zen_AreUnitsTasksComplete = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_AreUnitsTasksComplete.sqf";
Zen_CleanGlobalTaskArray = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_CleanGlobalTaskArray.sqf";
Zen_CleanLocalTaskArray = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_CleanLocalTaskArray.sqf";
Zen_GetCurrentTask = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_GetCurrentTask.sqf";
Zen_GetTaskDataGlobal = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_GetTaskDataGlobal.sqf";
Zen_GetTaskDataLocal = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_GetTaskDataLocal.sqf";
Zen_GetUnitTasks = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_GetUnitTasks.sqf";
Zen_InvokeTask = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_InvokeTask.sqf";
Zen_InvokeTaskBriefing = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_InvokeTaskBriefing.sqf";
Zen_InvokeTaskClient = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_InvokeTaskClient.sqf";
Zen_ReassignTask = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_ReassignTask.sqf";
Zen_RemoveTask = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_RemoveTask.sqf";
Zen_RemoveTaskClient = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_RemoveTaskClient.sqf";
Zen_SetTaskCurrent = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_SetTaskCurrent.sqf";
Zen_SetTaskTarget = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_SetTaskTarget.sqf";
Zen_SetTaskTargetClient = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_SetTaskTargetClient.sqf";
Zen_SetTaskCurrentClient = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_SetTaskCurrentClient.sqf";
Zen_UpdateTask = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_UpdateTask.sqf";
Zen_UpdateTaskClient = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_TaskSystem\Zen_UpdateTaskClient.sqf";

if (true) exitWith {};

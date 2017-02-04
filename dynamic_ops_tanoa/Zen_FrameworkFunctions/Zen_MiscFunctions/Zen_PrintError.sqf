// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

//  DO NOT PUT Zen_PrintError ON THE STACK
//  DO NOT CALL ANY OTHER FUNCTIONS
//  DO NOT USE Zen_CheckArguments
private ["_scriptName", "_errorDesc", "_scriptArgs"];

_scriptName = _this select 0;
_errorDesc = _this select 1;
_scriptArgs = _this select 2;

diag_log format ["-- %1 Error --", _scriptName];
diag_log _errorDesc;
diag_log time;
diag_log _scriptArgs;

if (Zen_Print_All_Errors) then {
    hint format ["-- %1 Error --\n  %2\n%3\n%4", _scriptName, _errorDesc, time, _scriptArgs];
    systemChat format ["-- %1 Error --%2 %3 %4", _scriptName, _errorDesc, time, _scriptArgs];
};

if (true) exitWith {};

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define SPRF call Zen_StackPrint; \
call Zen_StackRemove; \
false;

#define SPM call Zen_StackPrint; \
_match = false;

if !(Zen_Debug_Arguments) exitWith {true};
_Zen_stack_Trace = ["Zen_CheckArguments", (_this select 0)] call Zen_StackAdd;
private ["_checkArray", "_matchTypesArray", "_match", "_matchTypes", "_subTypesArray"];

_checkArray = _this select 0;
_matchTypesArray = _this select 1;
_subTypesArray = _this select 2;
_minCount = _this select 3;

if (isNil "_checkArray") exitWith {
    0 = ["Zen_CheckArguments", "Given argument list is void", _checkArray] call Zen_PrintError;
    SPRF
};

if (typeName _checkArray != "ARRAY") exitWith {
    0 = ["Zen_CheckArguments", "Given argument is not an array", _checkArray] call Zen_PrintError;
    SPRF
};

if (count _checkArray < _minCount) exitWith {
    0 = ["Zen_CheckArguments", format ["Too few arguments, %1 given, %2 required", (count _checkArray), _minCount], _checkArray] call Zen_PrintError;
    SPRF
};

_match = true;
{
    if (isNil "_x") exitWith {
        0 = ["Zen_CheckArguments", format ["Argument %1 is void", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
        SPM
    };

    if (((typeName _x) in ["OBJECT", "GROUP", "TASK", "SCRIPT", "DISPLAY", "CONTROL"]) && {(isNull _x)}) then {
        0 = ["Zen_CheckArguments", format ["Argument %1 is void", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
        SPM
    };

    if (count _matchTypesArray == _forEachIndex) exitWith {};
    _matchTypes = _matchTypesArray select _forEachIndex;

    if ((count _matchTypes == 1) && {"FUNCTION" in _matchTypes}) then {
        if (typeName _x != "STRING") exitWith {
            0 = ["Zen_CheckArguments", format ["Argument %1 is the wrong type", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
            SPM
        };

        if (isNil _x) exitWith {
            0 = ["Zen_CheckArguments", format ["Argument %1 is not a defined function", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
            SPM
        };
    } else {
        if (!("VOID" in _matchTypes) && {!((typeName _x) in _matchTypes)}) exitWith {
            0 = ["Zen_CheckArguments", format ["Argument %1 is the wrong type", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
            SPM
        };
    };

    if ((typeName _x == "ARRAY") && {count _subTypesArray > _forEachIndex}) then {
        _subTypes = _subTypesArray select _forEachIndex;
        if ((count _subTypes > 0) && (!(({(typeName _x in _subTypes)} count _x) == count _x))) exitWith {
            0 = ["Zen_CheckArguments", format ["Argument %1 contains a wrong type", (_forEachIndex + 1)], _checkArray] call Zen_PrintError;
            SPM
        };
    };
} forEach _checkArray;

call Zen_StackRemove;
(_match)

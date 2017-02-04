// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_UpdateFireSupport", _this] call Zen_StackAdd;
private ["_nameString", "_roundType", "_roundsPerSalvo", "_salvos", "_timePerRound", "_timePerSalvo", "_targetArea", "_salvoDrift", "_guided", "_templateOld", "_templateNew"];

if !([_this, [["STRING"], ["SCALAR", "STRING"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["STRING", "SCALAR"], ["ARRAY", "SCALAR"], ["BOOL"]], [[], [], ["SCALAR"], ["SCALAR"], ["SCALAR"], ["SCALAR"], [], ["SCALAR"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_roundType = _this select 1;

_roundsPerSalvo = -1;
_salvos = -1;
_timePerRound = -1;
_timePerSalvo = -1;
_targetArea = -1;
_salvoDrift = -1;
_guided = -1;

if (count _this > 2) then {
    _roundsPerSalvo = _this select 2;
};

if (count _this > 3) then {
    _salvos = _this select 3;
};

if (count _this > 4) then {
    _timePerRound = _this select 4;
};

if ((count _this) > 5) then {
    _timePerSalvo = _this select 5;
};

if (count _this > 6) then {
    _targetArea = _this select 6;
};

if (count _this > 7) then {
    _salvoDrift = _this select 7;
};

if (count _this > 8) then {
    _guided = _this select 8;
};

_templateOld = [_nameString] call Zen_GetFireSupportData;
if (count _templateOld == 0) exitWith {};

if (_roundType isEqualTo -1) then {_roundType = _templateOld select 1};
if (_roundsPerSalvo isEqualTo -1) then {_roundsPerSalvo = _templateOld select 2};
if (_salvos isEqualTo -1) then {_salvos = _templateOld select 3};
if (_timePerRound isEqualTo -1) then {_timePerRound = _templateOld select 4};
if (_timePerSalvo isEqualTo -1) then {_timePerSalvo = _templateOld select 5};
if (_targetArea isEqualTo -1) then {_targetArea = _templateOld select 6};
if (_salvoDrift isEqualTo -1) then {_salvoDrift = _templateOld select 7};
if (_guided isEqualTo -1) then {_guided = _templateOld select 8};

if (typeName _roundsPerSalvo != "ARRAY") then {
    _roundsPerSalvo = [_roundsPerSalvo, _roundsPerSalvo];
};

if (typeName _salvos != "ARRAY") then {
    _salvos = [_salvos, _salvos];
};

if (typeName _timePerRound != "ARRAY") then {
    _timePerRound = [_timePerRound, _timePerRound];
};

if (typeName _timePerSalvo != "ARRAY") then {
    _timePerSalvo = [_timePerSalvo, _timePerSalvo];
};

switch (typeName _targetArea) do {
    case "SCALAR": {
        (_templateOld select 5) set [0, _targetArea];
        (_templateOld select 5) set [1, _targetArea];
        _targetArea = _templateOld select 5;
    };
    case "STRING": {
        if ([_targetArea, allMapMarkers] call Zen_ValueIsInArray) then {
            _targetArea = getMarkerSize _targetArea + [markerShape _targetArea, markerDir _targetArea];
        } else {
            _targetArea = _templateOld select 5;
            0 = ["Zen_UpdateFireSupport", "Given marker for fire support shape does not exist", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };
    };
    case "ARRAY": {};
};

if (typeName _salvoDrift != "ARRAY") then {
    _salvoDrift = [_salvoDrift, _salvoDrift];
};

_templateNew = [_nameString, _roundType, _roundsPerSalvo, _salvos, _timePerRound, _timePerSalvo, _targetArea, _salvoDrift, _guided];

{
    if ((_x select 0) == _nameString) then {
        Zen_Fire_Support_Array_Global set [_forEachIndex, _templateNew];
    };
} forEach Zen_Fire_Support_Array_Global;
publicVariable "Zen_Fire_Support_Array_Global";

call Zen_StackRemove;
if (true) exitWith {};

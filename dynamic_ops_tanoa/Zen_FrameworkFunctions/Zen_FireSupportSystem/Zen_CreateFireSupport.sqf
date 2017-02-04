// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_CreateFireSupport", _this] call Zen_StackAdd;
private ["_nameString", "_roundType", "_roundsPerSalvo", "_salvos", "_timePerRound", "_timePerSalvo", "_targetArea", "_salvoDrift", "_guided", "_xRadius", "_yRadius", "_shape", "_angle"];

if !([_this, [["STRING"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["SCALAR", "STRING"], ["ARRAY", "SCALAR"], ["BOOL"]], [[], ["SCALAR"], ["SCALAR"], ["SCALAR"], ["SCALAR"], [], ["SCALAR"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_roundType = _this select 0;

_nameString = format ["Zen_fire_support_%1", ([10] call Zen_StringGenerateRandom)];
_roundsPerSalvo = 5;
_salvos = 1;
_timePerRound = 5;
_timePerSalvo = 10;

_xRadius = 100;
_yRadius = 100;
_shape = "ellipse";
_angle = 0;

_salvoDrift = 25;
_guided = false;

if (count _this > 1) then {
    _roundsPerSalvo = _this select 1;
};

if (count _this > 2) then {
    _salvos = _this select 2;
};

if (count _this > 3) then {
    _timePerRound = _this select 3;
};

if (count _this > 4) then {
    _timePerSalvo = _this select 4;
};

if (count _this > 5) then {
    _targetArea = _this select 5;
    if (typeName _targetArea == "SCALAR") then {
        _xRadius = _targetArea max 1;
        _yRadius = _targetArea max 1;
    } else {
        if ([_targetArea, allMapMarkers] call Zen_ValueIsInArray) then {
            _xRadius = getMarkerSize _targetArea select 0;
            _yRadius = getMarkerSize _targetArea select 1;
            _shape = markerShape _targetArea;
            _angle = markerDir _targetArea;
        } else {
            0 = ["Zen_CreateFireSupport", "Given marker for fire support shape does not exist", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };
    };
};

if (count _this > 6) then {
    _salvoDrift = _this select 6;
};

if (count _this > 7) then {
    _guided = _this select 7;
};

if (typeName _roundsPerSalvo != "ARRAY") then {
    _roundsPerSalvo = [_roundsPerSalvo  max 1, _roundsPerSalvo  max 1];
};

if (typeName _salvos != "ARRAY") then {
    _salvos = [_salvos max 1, _salvos max 1];
};

if (typeName _timePerRound != "ARRAY") then {
    _timePerRound = [_timePerRound max 1, _timePerRound max 1];
};

if (typeName _timePerSalvo != "ARRAY") then {
    _timePerSalvo = [_timePerSalvo max 1, _timePerSalvo max 1];
};

if (typeName _salvoDrift != "ARRAY") then {
    _salvoDrift = [_salvoDrift max 1, _salvoDrift max 1];
};

Zen_Fire_Support_Array_Global pushBack [_nameString, _roundType, _roundsPerSalvo, _salvos, _timePerRound, _timePerSalvo, [_xRadius, _yRadius, _shape, _angle], _salvoDrift, _guided];
publicVariable "Zen_Fire_Support_Array_Global";

call Zen_StackRemove;
(_nameString)

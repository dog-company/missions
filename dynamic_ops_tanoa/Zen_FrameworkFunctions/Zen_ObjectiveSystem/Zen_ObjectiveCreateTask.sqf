// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ObjectiveCreateTask", _this] call Zen_StackAdd;
private ["_units", "_txt1", "_txt2", "_objType", "_taskDest", "_side", "_sideString", "_objClass", "_triggerType", "_taskReturn"];

if !([_this, [["ARRAY"], ["STRING"], ["ARRAY"], ["SIDE"], ["VOID"], ["STRING"]], [["OBJECT"], [], ["SCALAR"]], 5] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_units = _this select 0;
_objType = _this select 1;
_taskDest = _this select 2;
_side = _this select 3;
_objClass = _this select 4;
_triggerType = _this select 5;

if (typeName _objClass == "ARRAY") then {
    _objClass = _objClass select 0;
};

switch (_side) do {
    case west: {
        _sideString = "Blufor";
    };
    case east: {
        _sideString = "Opfor";
    };
    case resistance: {
        _sideString = "Indfor";
    };
    default {
        _sideString = "Unknown";
    };
};

switch (toLower _objType) do {
    case "box": {
        _txt1 = format ["The %1 are stockpiling ammunition, %2 the ammo cache.", _sideString, ([_triggerType] call Zen_StringCapitalizeLetter)];
        _txt2 = format ["%1 the Cache", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "mortar": {
        _txt1 = format ["The %1 have set up a mortar position.  %2 the mortar crew, the mortars, and their ammunition.", _sideString, ([_triggerType] call Zen_StringCapitalizeLetter)];
        _txt2 = format ["%1 the Mortars", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "wreck": {
        _txt1 = format ["A %1 vehicle has been disabled and abandoned.  You must %2 it.", _sideString, toLower _triggerType];
        _txt2 = format ["%1 the Wreck", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "officer": {
        _txt1 = format ["%2 the %1 officer, who is near the marked point on the map.", _sideString, ([_triggerType] call Zen_StringCapitalizeLetter)];
        _txt2 = format ["%1 the Officer", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "pow":{
        _txt1 = format ["The %1 POW is near the marked point on the map, you must %2 him.", _sideString, toLower _triggerType];
        _txt2 = format ["%1 the POW", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "convoy": {
        _txt1 = format ["The %1 are moving troops and supplies in a convoy.  %2 all of the vehicles.", _sideString, ([_triggerType] call Zen_StringCapitalizeLetter)];
        _txt2 = format ["%1 the Convoy", ([_triggerType] call Zen_StringCapitalizeLetter)];
    };
    case "custom": {
        _txt1 = format ["Find the %1 %2 and %3 %4.", _sideString, (getText (configFile >> "CfgVehicles" >> _objClass >> "DisplayName")), toLower _triggerType, (if (_objClass isKindOf "Man") then {"him"} else {"it"})];
        _txt2 = format ["%1 the %2", ([_triggerType] call Zen_StringCapitalizeLetter), (getText (configFile >> "CfgVehicles" >> _objClass >> "DisplayName"))];
    };
    default {
        _txt1 = "";
        _txt2 = "";
        0 = ["Zen_ObjectiveCreateTask", "Invalid objective identifier given", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

_taskReturn = [_units, _txt1, _txt2, _taskDest] call Zen_InvokeTask;
call Zen_StackRemove;
(_taskReturn)

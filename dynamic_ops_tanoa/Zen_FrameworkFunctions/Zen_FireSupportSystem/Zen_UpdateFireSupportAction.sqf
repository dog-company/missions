// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_UpdateFireSupportAction", _this] call Zen_StackAdd;
private ["_nameString", "_unitsToAdd", "_maxCalls", "_supportString", "_guideObj", "_guideType", "_indexes", "_data", "_args", "_newSupportTemplateData", "_descr", "_customArgs"];

if !([_this, [["STRING"], ["VOID"], ["STRING", "SCALAR"], ["SCALAR", "STRING", "OBJECT"], ["STRING", "SCALAR"], ["SCALAR"], ["STRING"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_nameString = _this select 0;
_unitsToAdd = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_supportString, 2, 0)
ZEN_STD_Parse_GetArgumentDefault(_guideObj, 3, 0)
ZEN_STD_Parse_GetArgumentDefault(_guideType, 4, 0)
ZEN_STD_Parse_GetArgumentDefault(_maxCalls, 5, 0)
ZEN_STD_Parse_GetArgumentDefault(_descr, 6, 0)
ZEN_STD_Parse_GetArgumentDefault(_customArgs, 7, [])

if (typeName _unitsToAdd != "SCALAR") then {
    _unitsToAdd = [_unitsToAdd] call Zen_ConvertToObjectArray;
};

_indexes = [Zen_Fire_Support_Action_Array_Global, _nameString, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes == 0) exitWith {
    ZEN_FMW_Code_Error("Zen_UpdateFireSupportAction", "Given action identifier does not exist.")
};

_data = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);

if (typeName _unitsToAdd != "SCALAR") then {
    _oldUnits = _data select 1;
    0 = [_oldUnits, _unitsToAdd] call Zen_ArrayAppendNested;
};

if (typeName _supportString != "SCALAR") then {
    _newSupportTemplateData = [_supportString] call Zen_GetFireSupportData;
    _data set [3, _supportString];
};

if (typeName _guideObj != "SCALAR") then {
    _data set [4, _guideObj];
};

if (typeName _guideType != "SCALAR") then {
    _data set [5, _guideType];
};

if (_maxCalls != 0) then {
    _data set [6, _maxCalls];
};

if (typeName _descr != "SCALAR") then {
    _data set [7, _descr];
};

if (_customArgs != []) then {
    _data set [10, _customArgs];
};

publicVariable "Zen_Fire_Support_Action_Array_Global";
call Zen_StackRemove;
if (true) exitWith {};

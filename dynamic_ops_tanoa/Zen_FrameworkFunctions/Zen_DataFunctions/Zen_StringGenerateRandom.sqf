// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf";
#include "..\Zen_FrameworkLibrary.sqf";

_Zen_stack_Trace = ["Zen_StringGenerateRandom", _this] call Zen_StackAdd;
private ["_count", "_string", "_i", "_ch", "_set", "_chars", "_characterLimits"];

if !([_this, [["SCALAR"], ["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_count = _this select 0;
ZEN_STD_Parse_GetArgumentDefault(_set, 1, "all")

_chars =  [];
_characterLimits = [];
switch (toLower _set) do {
    case "all": {
        _characterLimits pushBack [33,126];
    };
    case "alpha": {
        _characterLimits pushBack [65,90];
        _characterLimits pushBack [97,122];
    };
    case "alphanumeric": {
        _characterLimits pushBack [48,57];
        _characterLimits pushBack [65,90];
        _characterLimits pushBack [97,122];
    };
    case "numeric": {
        _characterLimits pushBack [48,57];
    };
};

{
    for "_i" from (_x select 0) to (_x select 1) do {
        _chars pushBack _i;
    };
} forEach _characterLimits;

if (count _chars == 0) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_StringGenerateRandom", "Invalid character set given", "")
};

_string = [];
for "_i" from 1 to _count do {
    _ch = ZEN_STD_Array_RandElement(_chars);
    if !(_ch in [34, 39]) then {
        _string set [(_i - 1), _ch];
    } else {
        _i = _i - 1;
    };
};

call Zen_StackRemove;
(toString _string)

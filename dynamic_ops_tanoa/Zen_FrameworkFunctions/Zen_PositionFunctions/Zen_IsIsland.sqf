// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_IsIsland", _this] call Zen_StackAdd;
private ["_center", "_distance", "_checkAnglesAdd", "_checkAddIndex", "_waterSectors", "_checkPos"];

if !([_this, [["VOID"], ["SCALAR"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
ZEN_STD_Parse_GetArgumentDefault(_distance, 1, 500)

_checkAnglesAdd = [0, 2, 4, 6, 8, 10, 8, 6, 4, 2];
_checkAddIndex = 0;

_waterSectors = 0;

for "_phi" from 0 to 350 step 10 do {
    for "_r" from 10 to _distance step 10 do {
        _checkPos = [_center, _r, _phi + (_checkAnglesAdd select _checkAddIndex), "trig"] call Zen_ExtendPosition;
        if (surfaceIsWater _checkPos) exitWith {
            _waterSectors = _waterSectors + 1;
        };
    };
    _checkAddIndex = (_checkAddIndex + 1) % 10;
};

call Zen_StackRemove;
(_waterSectors / 36);

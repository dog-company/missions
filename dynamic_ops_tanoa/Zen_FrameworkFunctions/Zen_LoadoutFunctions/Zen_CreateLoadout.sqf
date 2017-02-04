// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_CreateLoadout", _this] call Zen_StackAdd;
private ["_loadoutData", "_nameString", "_oldData"];

if !([_this, [["ARRAY"], ["STRING"]], [["ARRAY"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_loadoutData = _this select 0;

if (count _this > 1) then {
    _nameString = _this select 1;
} else {
    _nameString = format ["Zen_loadout_%1", ([10] call Zen_StringGenerateRandom)];
};

_oldData = [_nameString, false] call Zen_GetLoadoutData;

if (count _oldData > 0) exitWith {
    0 = ["Zen_CreateLoadout", "Given loadout name is already used, use Zen_UpdateLoadout", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (_nameString)
};

Zen_Loadout_Array_Global pushBack [_nameString, _loadoutData];
publicVariable "Zen_Loadout_Array_Global";

call Zen_StackRemove;
(_nameString)

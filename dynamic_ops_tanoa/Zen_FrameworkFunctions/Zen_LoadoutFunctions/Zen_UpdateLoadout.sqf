// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_UpdateLoadout", _this] call Zen_StackAdd;
private ["_loadoutName", "_loadoutData", "_indexes"];

if !([_this, [["STRING"], ["ARRAY"]], [[], ["ARRAY"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_loadoutName = _this select 0;
_loadoutData = _this select 1;

_indexes = [Zen_Loadout_Array_Global, _loadoutName, 0] call Zen_ArrayGetNestedIndex;

if (count _indexes == 0) exitWith {
    0 = ["Zen_UpdateLoadout", "Given loadout does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

Zen_Loadout_Array_Global set [(_indexes select 0), [_loadoutName, _loadoutData]];
publicVariable "Zen_Loadout_Array_Global";

call Zen_StackRemove;
if (true) exitWith {};

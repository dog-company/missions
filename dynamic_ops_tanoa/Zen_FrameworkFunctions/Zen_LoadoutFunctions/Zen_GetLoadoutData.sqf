// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetLoadoutData", _this] call Zen_StackAdd;
private ["_nameString", "_loadout", "_reportError"];

if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_nameString = _this select 0;

_reportError = true;
if (count _this > 1) then {
    _reportError = _this select 1;
};

_loadout = [];

{
    if ([(_x select 0), _nameString] call Zen_ValuesAreEqual) exitWith {
        _loadout =+ _x;
    };
} forEach Zen_Loadout_Array_Global;

if ((count _loadout == 0) && {_reportError}) then {
    0 = ["Zen_GetLoadoutData", "Given loadout does not exist", _this] call Zen_PrintError;
    call Zen_StackPrint;
};

call Zen_StackRemove;
(_loadout)

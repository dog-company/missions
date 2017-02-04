// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_LoadoutDialogEquip", _this] call Zen_StackAdd;
private ["_kit", "_unit", "_object", "_id", "_index", "_maxCount", "_curCount", "_loadoutData"];

_kit = _this select 0;
_object = player getVariable "Zen_LoadoutsDialogObject";
_unit = player getVariable "Zen_LoadoutsDialogUser";
_id = player getVariable "Zen_LoadoutsDialogAction";

player setVariable ["Zen_LoadoutsDialogObject", nil];
player setVariable ["Zen_LoadoutsDialogUser", nil];
player setVariable ["Zen_LoadoutsDialogAction", nil];

_index = ([Zen_Loadout_Action_Array_Local, _id, 0] call Zen_ArrayGetNestedIndex) select 0;
_maxCount = (Zen_Loadout_Action_Array_Local select _index) select 1;
_curCount = ((Zen_Loadout_Action_Array_Local select _index) select 2) + 1;

if ((_maxCount != -1) && {_curCount >= _maxCount}) then {
    _object removeAction _id;
    0 = [Zen_Loadout_Action_Array_Local, _index] call Zen_ArrayRemoveIndex;
} else {
    Zen_Loadout_Action_Array_Local set [_index, [_id, _maxCount, _curCount]];
};

_loadoutData = [_kit, false] call Zen_GetLoadoutData;
if (count _loadoutData > 0) then {
    0 = [_unit, _kit] call Zen_GiveLoadoutCustom;
} else {
    0 = [_unit, (side _unit), _kit] call Zen_GiveLoadout;
};

call Zen_CloseDialog;
call Zen_StackRemove;
if (true) exitWith {};

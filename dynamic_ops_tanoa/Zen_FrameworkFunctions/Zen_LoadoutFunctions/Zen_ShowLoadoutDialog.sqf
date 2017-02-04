// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ShowLoadoutDialog", _this] call Zen_StackAdd;
private ["_object", "_index", "_kitArray", "_user", "_id"];

if !([_this, [["OBJECT"], ["OBJECT"], ["SCALAR"], ["STRING"]], [], 4] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_object = _this select 0;
_user = _this select 1;
_id = _this select 2;
_dialogID = _this select 3;

player setVariable ["Zen_LoadoutsDialogObject", _object];
player setVariable ["Zen_LoadoutsDialogAction", _id];
player setVariable ["Zen_LoadoutsDialogUser", _user];

0 = [_dialogID] spawn Zen_InvokeDialog;

call Zen_StackRemove;
if (true) exitWith {};

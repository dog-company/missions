// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

Zen_Loadout_Array_Global = [];
Zen_Loadout_Action_Array_Local = [];

Zen_AddGiveMagazine = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_AddGiveMagazine.sqf";
Zen_AddLoadoutDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_AddLoadoutDialog.sqf";
Zen_AddRepackMagazines = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_AddRepackMagazines.sqf";
Zen_CreateLoadout = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_CreateLoadout.sqf";
Zen_GetLoadoutData = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GetLoadoutData.sqf";
Zen_GetUnitLoadout = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GetUnitLoadout.sqf";
Zen_GiveLoadout = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveLoadout.sqf";
Zen_GiveLoadoutBlufor = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveLoadoutBlufor.sqf";
Zen_GiveLoadoutCustom = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveLoadoutCustom.sqf";
Zen_GiveLoadoutIndfor = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveLoadoutIndfor.sqf";
Zen_GiveLoadoutOpfor = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveLoadoutOpfor.sqf";
Zen_GiveMagazine = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_GiveMagazine.sqf";
Zen_LoadoutDialogEquip = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_LoadoutDialogEquip.sqf";
Zen_RemoveLoadout = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_RemoveLoadout.sqf";
Zen_RepackMagazines = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_RepackMagazines.sqf";
Zen_ShowLoadoutDialog = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_ShowLoadoutDialog.sqf";
Zen_UpdateLoadout = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_LoadoutFunctions\Zen_UpdateLoadout.sqf";

Zen_GiveMagazine_ReceiverHint_MP = {
    private ["_receiver", "_giver", "_magazine"];

    _receiver = _this select 0;
    _giver = _this select 1;
    _magazine = _this select 2;

    if (player == _receiver) then {
        hint format ["%1 has given you a %2 magazine", (name _giver), _magazine];
    };

    if (true) exitWith {};
};

if (true) exitWith {};

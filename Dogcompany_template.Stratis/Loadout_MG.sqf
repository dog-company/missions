// Dog Company Loadouts by 4ner
//................................

// Teamleader loadout

private ["_unit", "_primaryMag", "_secondaryMag", "_flashbang"];
_unit = _this select 0;
waitUntil {!isNull _unit};
_primaryMag = "rhs_200rnd_556x45_T_SAW";
_secondaryMag = "11Rnd_45ACP_Mag";
_flashbang = "ACE_M84";

comment "Remove existing items";
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

Comment "Weapon";
_unit addWeapon "rhs_weap_m249_pip_S";
_unit addPrimaryWeaponItem "ACE_acc_pointer_green";
this addPrimaryWeaponItem "optic_Hamr";
_unit addWeapon "hgun_Pistol_heavy_01_F";

Comment "Uniform";
_unit forceAddUniform "U_B_CombatUniform_mcam_tshirt";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "ACE_Flashlight_XL50";
_unit addItemToUniform "ACE_EarPlugs";
_unit addItemToUniform "ACE_microDAGR";
for "_i" from 1 to 1 do {_unit addItemToUniform _primaryMag;};
for "_i" from 1 to 3 do {_unit addItemToUniform _secondaryMag;};

Comment "Vest";
_unit addVest "V_PlateCarrier2_rgr";
for "_i" from 1 to 4 do {_unit addItemToVest _flashbang;};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addItemToVest "ACE_Chemlight_HiRed";
for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellBlue";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellRed";};

Comment "Backpack";
_unit addBackpack "B_TacticalPack_oli";
for "_i" from 1 to 8 do {_unit addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 6 do {_unit addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 3 do {_unit addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToBackpack _flashbang;};
for "_i" from 1 to 2 do {_unit addItemToBackpack _primaryMag;};

Comment "Helmet";
_unit addHeadgear "milgp_h_airframe_Combat_rgr";

Comment "Items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "tf_anprc152";
_unit linkItem "NVGoggles_OPFOR";

// Dog Company Loadouts by 4ner 
//................................

// Medic loadout

waitUntil {!isNull player};
_unit = _this select 0;

comment "Remove existing items";
removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

Comment "Uniform";
_unit forceAddUniform "TRYK_U_B_Woodland";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "ACE_Flashlight_XL50";
_unit addItemToUniform "ACE_EarPlugs";
_unit addItemToUniform "ACE_microDAGR";

Comment "Vest";
_unit addVest "milgp_v_marciras_Medic_belt_mc";
for "_i" from 1 to 4 do {_unit addItemToVest "ACE_M84";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addItemToVest "ACE_Chemlight_HiRed";
for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellBlue";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellRed";};

Comment "Backpack";
_unit addBackpack "TRYK_B_Alicepack";
for "_i" from 1 to 30 do {_unit addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "ACE_M84";};
for "_i" from 1 to 4 do {_unit addItemToBackpack "ACE_bloodIV";};
_unit AddItemToBackpack "G_Balaclava_TI_G_blk_F";

Comment "Helmet";
_unit addHeadgear "TRYK_H_Helmet_WOOD";
_unit addGoggles "avon_ct12_strapless";

Comment "Weapon";
_unit addWeapon "SMA_ACRREMblk";
_unit addPrimaryWeaponItem "SMA_SFFL_BLK";
_unit addPrimaryWeaponItem "SMA_eotechG33_3XDOWN";
_unit addWeapon "hgun_Pistol_heavy_01_F";


Comment "Magazines";
for "_i" from 1 to 1 do {_unit addItemToUniform "SMA_30Rnd_68x43_SPC_FMJ_Tracer";};
for "_i" from 1 to 12 do {_unit addItemToVest "SMA_30Rnd_68x43_SPC_FMJ_Tracer";};
for "_i" from 1 to 5 do {_unit addItemToBackpack "SMA_30Rnd_68x43_SPC_FMJ_Tracer";};
for "_i" from 1 to 3 do {_unit addItemToUniform "11Rnd_45ACP_Mag";};

Comment "Items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "tf_microdagr";
_unit linkItem "tf_anprc148jem_1";
_unit linkItem "NVGoggles_OPFOR";
if(true) exitWith{true};

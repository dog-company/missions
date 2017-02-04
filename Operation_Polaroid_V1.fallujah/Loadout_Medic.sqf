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


Comment "Uniform";
_unit forceAddUniform "rhs_uniform_g3_tan";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "ACE_Flashlight_XL50";
_unit addItemToUniform "ACE_EarPlugs";

Comment "Vest";
_unit addVest "rhsusf_iotv_ocp_SAW";
for "_i" from 1 to 4 do {_unit addItemToVest "ACE_M84";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addItemToVest "ACE_Chemlight_HiRed";
for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellBlue";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellRed";};

Comment "Backpack";
_unit addBackpack "B_Kitbag_cbr";
for "_i" from 1 to 30 do {_unit addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "ACE_M84";};

Comment "Helmet";
_unit addHeadgear "rhsusf_ach_bare_tan_headset";

Comment "Weapon";
_unit addWeapon "rhs_weap_m4a1_blockII_d";
_unit addPrimaryWeaponItem "muzzle_snds_m_snd_F";
_unit addPrimaryWeaponItem "acc_flashlight";
_unit addPrimaryWeaponItem "optic_ERCO_snd_F";
_unit addPrimaryWeaponItem "bipod_01_F_snd";
_unit addWeapon "hgun_P07_F";
_unit addHandgunItem "muzzle_snds_L";

Comment "Magazines";
for "_i" from 1 to 1 do {_unit addItemToUniform "30Rnd_556x45_Stanag_Tracer_Red";};
for "_i" from 1 to 12 do {_unit addItemToVest "30Rnd_556x45_Stanag_Tracer_Red";};
for "_i" from 1 to 8 do {_unit addItemToBackpack "30Rnd_556x45_Stanag_Tracer_Red";};
for "_i" from 1 to 3 do {_unit addItemToUniform "30Rnd_9x21_Mag";};

Comment "Items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "tf_anprc148jem_1";
_unit linkItem "rhsusf_ANPVS_15";
if(true) exitWith{};

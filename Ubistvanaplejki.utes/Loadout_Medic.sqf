// Dog Company Loadouts by 4ner
//................................

// Medic loadout

waitUntil {!isNull player};
private ["_unit", "_primaryMag", "_secondaryMag", "_flashbang"];
_unit = _this select 0;
_primaryMag = "rhs_30Rnd_762x39mm";
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
_unit addWeapon "rhs_weap_m70ab2";
_unit addWeapon "hgun_Pistol_heavy_01_F";

Comment "Uniform";
_unit forceAddUniform "rhssaf_uniform_m10_digital_summer";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "ACE_Flashlight_XL50";
_unit addItemToUniform "ACE_EarPlugs";
_unit addItemToUniform "ACE_microDAGR";
for "_i" from 1 to 1 do {_unit addItemToUniform _primaryMag;};
for "_i" from 1 to 2 do {_unit addItemToUniform _secondaryMag;};

Comment "Vest";
_unit addVest "V_PlateCarrier1_blk";
for "_i" from 1 to 4 do {_unit addItemToVest _flashbang;};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addItemToVest "ACE_Chemlight_HiRed";
for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellBlue";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellRed";};
for "_i" from 1 to 12 do {_unit addItemToVest _primaryMag;};

Comment "Backpack";
_unit addBackpack "rhs_assault_umbts_engineer_empty";
for "_i" from 1 to 30 do {_unit addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToBackpack _flashbang;};
for "_i" from 1 to 2 do {_unit addItemToBackpack _primaryMag;};

Comment "Helmet";
_unit addHeadgear "rhssaf_helmet_m97_digital_black_ess_bare";

Comment "Items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "tf_anprc152";
_unit linkItem "rhs_1PN138";
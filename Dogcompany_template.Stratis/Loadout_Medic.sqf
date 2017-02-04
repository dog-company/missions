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
_unit forceAddUniform "TRYK_U_B_ACU";
_unit addItemToUniform "ACE_CableTie";
_unit addItemToUniform "ACE_Flashlight_XL50";
_unit addItemToUniform "ACE_EarPlugs";
_unit addItemToUniform "ACE_microDAGR";

Comment "Vest";
_unit addVest "milgp_v_marciras_Medic_belt_rgr";
for "_i" from 1 to 4 do {_unit addItemToVest "ACE_M84";};
for "_i" from 1 to 2 do {_unit addItemToVest "HandGrenade";};
_unit addItemToVest "ACE_Chemlight_HiRed";
for "_i" from 1 to 4 do {_unit addItemToVest "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellBlue";};
for "_i" from 1 to 2 do {_unit addItemToVest "SmokeShellRed";};

Comment "Backpack";
_unit addBackpack "milgp_bp_marciras_Hydration_rgr";
for "_i" from 1 to 30 do {_unit addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 20 do {_unit addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SmokeShell";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "ACE_M84";};

Comment "Helmet";
_unit addHeadgear "milgp_h_airframe_Combat_rgr";

Comment "Weapon";
_unit addWeapon "SMA_HK416afg";
_unit addPrimaryWeaponItem "SMA_SFFL_BLK";
_unit addWeapon "hgun_Pistol_heavy_01_F";

Comment "Magazines";
for "_i" from 1 to 1 do {_unit addItemToUniform "SMA_30Rnd_556x45_M855A1_Tracer";};
for "_i" from 1 to 12 do {_unit addItemToVest "SMA_30Rnd_556x45_M855A1_Tracer";};
for "_i" from 1 to 2 do {_unit addItemToBackpack "SMA_30Rnd_556x45_M855A1_Tracer";};
for "_i" from 1 to 2 do {_unit addItemToUniform "11Rnd_45ACP_Mag";};

Comment "Items";
_unit linkItem "ItemMap";
_unit linkItem "ItemCompass";
_unit linkItem "tf_microdagr";
_unit linkItem "tf_anprc148jem_1";
_unit linkItem "NVGoggles_OPFOR";
if(true) exitWith{};

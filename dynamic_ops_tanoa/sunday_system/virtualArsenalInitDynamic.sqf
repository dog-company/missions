//Init stuff
_vaWeapons = _this select 0;
_vaBackpacks = _this select 1;
_vaItems = _this select 2;
_vaMagazines = _this select 3;
_vaUniforms = _this select 4;
_vaBinos = _this select 5;
_vaNV = _this select 6;
_vaSilencers = _this select 7;

_extraItems = [
	"FirstAidKit",
	"Medikit"
];

_extraMags = [
	"DemoCharge_Remote_Mag",
	"SatchelCharge_Remote_Mag",
	"ATMine_Range_Mag",
	"APERSMine_Range_Mag",
	"SLAMDirectionalMine_Wire_Mag",
	"APERSTripMine_Wire_Mag",
	"ClaymoreDirectionalMine_Remote_Mag",
	"APERSBoundingMine_Range_Mag"
];

_extraBackpacks = [
	"B_AssaultPack_blk",
	"B_AssaultPack_cbr",
	"B_AssaultPack_rgr",
	"B_AssaultPack_khk",
	"B_AssaultPack_mcamo",
	"B_AssaultPack_sgg",
	"B_Carryall_cbr",
	"B_Carryall_khk",
	"B_Carryall_mcamo",
	"B_Carryall_oli",
	"B_FieldPack_blk",
	"B_FieldPack_cbr",
	"B_FieldPack_khk",
	"B_FieldPack_oli",
	"B_Kitbag_cbr",
	"B_Kitbag_rgr",
	"B_Kitbag_mcamo",
	"B_Kitbag_sgg",
	"B_TacticalPack_blk",
	"B_TacticalPack_rgr",
	"B_TacticalPack_mcamo",
	"B_TacticalPack_oli"
];

_extraGoggles = [
	"G_Combat",
	"G_Lowprofile",
	"G_Squares_Tinted",
	"G_Tactical_Black",
	"G_Tactical_Clear",
	"G_Bandanna_blk",
	"G_Aviator",
	"G_Balaclava_blk",
	"G_Bandanna_aviator",
	"G_Bandanna_beast",
	"G_Bandanna_khk",
	"G_Balaclava_combat",
	"G_Bandanna_tan",
	"G_B_Diving"
];

//Populate with predefined items and whatever is already in the crate
[missionNameSpace, (_vaBackpacks + _extraBackpacks), true] call BIS_fnc_addVirtualBackpackCargo;
[missionNameSpace, (_vaItems + _vaUniforms + _vaSilencers + _vaNV + _extraItems + _extraGoggles), true] call BIS_fnc_addVirtualItemCargo;
[missionNameSpace, (_vaWeapons + _vaBinos), true] call BIS_fnc_addVirtualWeaponCargo;
[missionNameSpace, (_vaMagazines + _extraMags), true] call BIS_fnc_addVirtualMagazineCargo;
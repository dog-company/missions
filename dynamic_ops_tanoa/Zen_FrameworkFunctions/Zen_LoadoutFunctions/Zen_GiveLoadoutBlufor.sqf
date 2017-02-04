// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

#define RECON_VEST ["V_Chestrig_khk", "V_Chestrig_rgr", "V_Chestrig_oli", "V_TacVest_camo", "V_TacVest_khk", "V_TacVest_oli"]
#define RECON_HEADGEAR ["H_MilCap_mcamo", "H_Watchcap_sgg", "H_Bandanna_mcamo", "H_Cap_tan_specops_US", "H_Cap_oli_hs", "H_HelmetB_light_snakeskin", "H_HelmetB_light_desert", "H_HelmetB_light_black", "H_HelmetB_light_sand"]
#define STD_UNIFORM ["U_B_CombatUniform_mcam", "U_B_CombatUniform_mcam_tshirt", "U_B_CombatUniform_mcam_vest", "U_B_CombatUniform_mcam_worn", "U_B_CTRG_1", "U_B_CTRG_2", "U_B_CTRG_3", "U_B_SpecopsUniform_sgg"]
#define STD_VEST ["V_PlateCarrier1_blk", "V_PlateCarrier1_rgr", "V_PlateCarrier2_rgr", "V_PlateCarrier3_rgr", "V_PlateCarrierGL_rgr", "V_PlateCarrierL_CTRG", "V_PlateCarrierH_CTRG"]
#define STD_RUCK ["B_AssaultPack_mcamo", "B_Kitbag_mcamo", "B_Bergen_mcamo", "B_TacticalPack_mcamo", "B_Carryall_mcamo", "B_OutdoorPack_tan", "B_Kitbag_cbr", "B_Carryall_cbr"]
#define STD_HEADGEAR ["H_HelmetB_light", "H_HelmetB_light_snakeskin", "H_HelmetB_light_snakeskin", "H_HelmetB_light_desert", "H_HelmetB_light_black", "H_HelmetB_light_sand"]
#define STD_GOGGLES ["G_Bandanna_oli", "G_Bandanna_khk", "G_Bandanna_tan", "G_Tactical_Clear", "G_Lowprofile", "G_Tactical_Black", "", "", "", "", ""]
#define SMOKE ["SmokeShell", "SmokeShellYellow", "SmokeShellGreen", "SmokeShellRed", "SmokeShellPurple", "SmokeShellOrange", "SmokeShellBlue"]
#define CHEMLIGHT ["Chemlight_green", "Chemlight_red", "Chemlight_blue", "Chemlight_yellow"]

#define GUER_WEAPON ["arifle_TRG21_F", "arifle_TRG20_F", "srifle_EBR_F", "arifle_Mk20_F", "arifle_Mk20_plain_F", "arifle_Mk20C_plain_F", "LMG_Zafir_F", "LMG_Mk200_F"]
#define GUER_UNIFORM ["U_IG_Guerilla1_1", "U_IG_Guerilla2_2", "U_IG_Guerilla2_3", "U_IG_Guerilla3_1", "U_IG_Guerilla3_2", "U_IG_Guerilla2_1", "U_BG_Guerilla1_1", "U_BG_Guerilla2_1", "U_BG_Guerilla2_2", "U_BG_Guerilla2_3", "U_BG_Guerilla3_1", "U_BG_Guerilla3_2", "U_C_Poor_1", "U_C_Poor_2", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_redwhite", "U_IG_Guerrilla_6_1", "U_BG_leader", "U_I_G_Story_Protagonist_F"]
#define GUER_VEST ["V_BandollierB_khk", "V_BandollierB_cbr", "V_BandollierB_rgr", "V_BandollierB_blk", "V_BandollierB_oli", "V_TacVest_khk", "V_TacVest_brn", "V_TacVest_oli", "V_TacVest_blk", "V_TacVest_camo", "V_TacVest_blk_POLICE", "V_TacVestIR_blk", "V_TacVestCamo_khk", "V_Chestrig_khk", "V_Chestrig_rgr", "V_Chestrig_blk", "V_Chestrig_oli", "V_PlateCarrierIA1_dgtl"]
#define GUER_RUCK ["B_AssaultPack_khk", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_AssaultPack_cbr", "B_FieldPack_khk", "B_FieldPack_oli", "B_FieldPack_cbr", "B_OutdoorPack_tan", "B_HuntingBackpack", "B_Kitbag_sgg", "B_Kitbag_cbr", "B_Bergen_sgg", "B_Bergen_mcamo", "B_Bergen_rgr", "B_BergenG", "B_BergenC_grn", "B_Carryall_oli", "B_Carryall_khk", "B_Carryall_cbr", "B_TacticalPack_rgr", "B_TacticalPack_oli"]
#define GUER_HEADGEAR ["H_Booniehat_khk", "H_Booniehat_grn", "H_Booniehat_tan", "H_Booniehat_dirty", "H_Booniehat_khk_hs", "H_MilCap_gry", "H_Cap_red", "H_Cap_blu", "H_Cap_oli", "H_Cap_tan", "H_Cap_blk", "H_Cap_grn", "H_Cap_grn_BI", "H_Cap_blk_Raven", "H_Cap_brn_SERO", "H_Cap_blk_ION", "H_Cap_oli_hs", "H_Shemag_khk", "H_Shemag_tan", "H_Shemag_olive", "H_ShemagOpen_khk", "H_ShemagOpen_tan", "H_Shemag_olive_hs", "H_Beret_blk", "H_Beret_blk_POLICE", "H_Beret_grn", "H_Beret_02", "H_Hat_blue", "H_Hat_brown", "H_Hat_camo", "H_Hat_grey", "H_Hat_checker", "H_Hat_tan", "H_StrawHat", "H_StrawHat_dark", "H_Watchcap_blk", "H_Watchcap_khk", "H_Watchcap_camo", "H_Watchcap_sgg", "H_Bandanna_surfer", "H_Bandanna_khk", "H_Bandanna_cbr", "H_Bandanna_sgg", "H_Bandanna_gry", "H_Bandanna_camo", "H_Bandanna_khk_hs", "H_Cap_press", "H_Cap_marshal", "H_Cap_police", "H_Watchcap_cbr", "H_Booniehat_oli"]
#define GUER_GOGGLES ["G_Bandanna_blk", "G_Bandanna_oli", "G_Bandanna_khk", "G_Bandanna_tan", "G_Bandanna_beast", "G_Bandanna_shades", "G_Bandanna_sport", "G_Bandanna_aviator", "G_Balaclava_blk", "G_Balaclava_oli", "G_Balaclava_combat", "G_Balaclava_lowprofile", "G_Aviator", "G_Tactical_Clear", "G_Tactical_Black"]

#define CIV_UNIFORM ["U_C_Poloshirt_blue", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_stripped", "U_C_Poloshirt_tricolour", "U_C_Poloshirt_salmon", "U_C_Poloshirt_redwhite", "U_C_Poor_1", "U_C_Poor_2", "U_C_WorkerCoveralls", "U_C_Poor_shorts_1", "U_C_Commoner_shorts", "U_C_ShirtSurfer_shorts", "U_C_TeeSurfer_shorts_1", "U_C_TeeSurfer_shorts_2"]
#define CIV_HEADGEAR ["H_Cap_red", "H_Cap_blu", "H_Cap_brn_SERO", "H_Booniehat_grn", "H_Booniehat_tan", "H_Booniehat_dirty", "H_Booniehat_dgtl", "H_Booniehat_khk", "H_Hat_blue", "H_Hat_brown", "H_Hat_camo", "H_Hat_grey", "H_Hat_checker", "H_Hat_tan", "H_Cap_tan", "H_Cap_blk", "H_Cap_grn", "H_Cap_grn_BI", "H_Cap_surfer", "H_Watchcap_blk", "H_Watchcap_khk", "H_Watchcap_camo", "H_Watchcap_sgg", "H_Bandanna_surfer", "H_Bandanna_khk", "H_Bandanna_cbr", "H_Bandanna_sgg", "H_Bandanna_gry", "H_StrawHat", "H_StrawHat_dark", "H_Cap_press", "H_Watchcap_cbr", "H_Booniehat_oli"]
#define CIV_GOGGLES ["G_Shades_Black", "G_Shades_Blue", "G_Sport_Blackred", "G_Spectacles", "G_Spectacles_Tinted", "G_Shades_Green", "G_Shades_Red", "G_Squares", "G_Squares_Tinted", "G_Sport_BlackWhite", "G_Sport_Blackyellow", "G_Sport_Greenblack", "G_Sport_Checkered", "G_Sport_Red", "G_Aviator"]

#define GIVE_GOGGLES \
    _goggles = ([STD_GOGGLES] call Zen_ArrayGetRandom); \
    if (_goggles != "") then { \
        _x addGoggles _goggles; \
    }; \

_Zen_stack_Trace = ["Zen_GiveLoadoutBlufor", _this] call Zen_StackAdd;
private ["_units", "_kit", "_giveGL", "_i", "_weapon", "_magazine", "_unit", "_goggles", "_kits", "_sendPacket"];

if !([_this, [["VOID"], ["ARRAY", "STRING"], ["BOOL"]], [[], ["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;

ZEN_STD_Parse_GetSetArgumentOptional(_kits, 1, "", "")
ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 2, true, false)

{
    if (local _x) then {
        _unit = _x;
        _unitAnim = animationState _unit;
        if ([_kits, ""] call Zen_ValuesAreEqual) then {
            _kit = [["Rifleman", "AT Rifleman", "Assistant AA", "Assistant AT", "Assistant AR", "Team Leader", "Squad Leader", "Grenadier", "Auto Rifleman", "Marksman", "Medic", "AA Specialist", "AT Specialist", "Sapper", "Miner", "EOD Specialist"]] call Zen_ArrayGetRandom;
        } else {
            _kit = [_kits] call Zen_ArrayGetRandom;
        };

        removeAllWeapons _x;
        removeAllContainers _x;
        removeAllAssignedItems _x;
        removeBackpack _x;
        removeVest _x;
        removeGoggles _x;
        removeHeadgear _x;

        {
            _unit linkItem _x;
        } forEach ["ItemGPS", "ItemWatch", "ItemRadio", "ItemMap", "ItemCompass", "NVGoggles"];

        removeUniform _x;

        switch (toLower ([_kit] call Zen_StringRemoveWhiteSpace)) do {
            case "recon": {
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (1 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 3)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (7 + floor random 3)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([RECON_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addMagazines [([CHEMLIGHT] call Zen_ArrayGetRandom), 2];
                _x addMagazineGlobal "B_IR_Grenade";

                _x addWeaponGlobal "Rangefinder";
                _x addWeaponGlobal "arifle_MX_Black_F";

                _x addPrimaryWeaponItem "muzzle_snds_H";
                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "rifleman": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (11 + floor random 4)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];
                (uniformContainer _x) addItemCargoGlobal ["acc_flashlight", 1];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "grenadier": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 3)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (10 + floor random 5)];
                _x addMagazines ["1Rnd_HE_Grenade_shell", (11 + floor random 6)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_GL_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "autorifleman": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 3)];
                _x addMagazines ["100Rnd_65x39_caseless_mag", (7 + floor random 3)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_SW_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "marksman": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (9 + floor random 3)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_MXM_F";

                _x addPrimaryWeaponItem "optic_Hamr";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "teamleader": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _giveGL = random 1;

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (3 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (10 + floor random 4)];

                if (_giveGL > 0.5) then {
                    _x addMagazines ["1Rnd_HE_Grenade_shell", (10 + floor random 5)];
                } else {
                    _x addMagazines ["30Rnd_65x39_caseless_mag", (3 + floor random 2)];
                };

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];
                (uniformContainer _x) addItemCargoGlobal ["acc_flashlight", 1];

                _x addWeaponGlobal "Binocular";

                if (_giveGL > 0.5) then {
                    _x addWeaponGlobal "arifle_MX_GL_F";
                } else {
                    _x addWeaponGlobal "arifle_MX_F";
                };

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "squadleader": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (4 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (10 + floor random 5)];
                _x addMagazines ["1Rnd_HE_Grenade_shell", (10 + floor random 4)];
                _x addMagazines ["1Rnd_smokegreen_Grenade_shell", (5 + floor random 2)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "rangefinder";
                _x addWeaponGlobal "arifle_MX_GL_F";

                _x addPrimaryWeaponItem "optic_Hamr";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "atrifleman": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (9 + floor random 3)];
                _x addMagazines ["NLAW_F", 2];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";
                _x addWeaponGlobal "launch_NLAW_F";
                _x addMagazines ["NLAW_F", 1];

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "atspecialist": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 5)];
                _x addMagazines ["Titan_AT", 2];
                _x addMagazines ["Titan_AP", 1];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";
                _x addWeaponGlobal "launch_B_Titan_short_F";

                _x addMagazines ["Titan_AP", 1];

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "aaspecialist": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (7 + floor random 5)];
                _x addMagazines ["Titan_AA", 1];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";
                _x addWeaponGlobal "launch_B_Titan_F";
                _x addMagazines ["Titan_AA", 1];

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "assistantaa": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 4)];
                _x addMagazines ["Titan_AA", 2];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "assistantat": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 4)];
                _x addMagazines ["Titan_AT", 2];
                _x addMagazines ["Titan_AP", 1];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "assistantar": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 4)];
                _x addMagazines ["100Rnd_65x39_caseless_mag", (9 + floor random 3)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "medic": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (3 + floor random 3)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 4)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (backpackContainer _x) addItemCargoGlobal ["Medikit", 1];
                (backpackContainer _x) addItemCargoGlobal ["FirstAidKit", 6];
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];
                (uniformContainer _x) addItemCargoGlobal ["acc_flashlight", 1];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "sapper": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 3)];
                _x addMagazines ["SLAMDirectionalMine_Wire_Mag", 3];
                _x addMagazines ["SatchelCharge_Remote_Mag", 2];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "miner": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 3)];
                _x addMagazines ["ATMine_Range_Mag", 1];
                _x addMagazines ["APERSBoundingMine_Range_Mag", 2];
                _x addMagazines ["APERSTripMine_Wire_Mag", 2];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "eodspecialist": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([STD_RUCK] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 3)];
                _x addMagazines ["DemoCharge_Remote_Mag", 3];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];
                (backpackContainer _x) addItemCargoGlobal ["MineDetector", 1];
                (backpackContainer _x) addItemCargoGlobal ["ToolKit", 1];

                _x addWeaponGlobal "arifle_MX_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "sniper": {
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);
                _x forceAddUniform "U_B_GhillieSuit";

                _x addMagazines ["11Rnd_45ACP_Mag", 3];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["7Rnd_408_Mag", (8 + floor random 3)];

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "Rangefinder";

                _x addWeaponGlobal "srifle_LRR_F";
                _x addWeaponGlobal "hgun_Pistol_heavy_01_F";

                _x addPrimaryWeaponItem "optic_LRPS";
            };
            case "spotter": {
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);

                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 2)];
                _x addMagazineGlobal "LaserBatteries";

                _x forceAddUniform "U_B_GhillieSuit";

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "Laserdesignator";

                _x addWeaponGlobal "arifle_MX_Black_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "uavoperator": {
                _x addVest ([STD_VEST] call Zen_ArrayGetRandom);
                _x addBackpack "B_UAV_01_backpack_F";

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (8 + floor random 3)];

                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([STD_HEADGEAR] call Zen_ArrayGetRandom);
                GIVE_GOGGLES

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];
                _x addWeaponGlobal "arifle_MX_F";

                _x unlinkItem "itemGPS";
                _x linkItem "B_UAVterminal";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "crewman": {
                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);

                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + random 2)];
                _x addMagazines ["HandGrenade", (2 + random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (5 + floor random 2)];

                _x addHeadgear "H_HelmetCrew_B";

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_MX_F";
                _x addPrimaryWeaponItem "optic_Aco";
            };
            case "officer": {
                _x addVest "V_BandollierB_cbr";
                _x forceAddUniform ([STD_UNIFORM] call Zen_ArrayGetRandom);

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addMagazines ["HandGrenade", 1];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), 1];
                _x addMagazines ["11Rnd_45ACP_Mag", 2];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (5 + floor random 2)];

                _x addHeadgear "H_MilCap_mcamo";

                _x addWeaponGlobal "binocular";
                _x addWeaponGlobal "arifle_MX_F";
                _x addWeaponGlobal "hgun_Pistol_heavy_01_F";

                _x addPrimaryWeaponItem "optic_ACO";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "helicopterpilot": {
                _x forceAddUniform "U_B_HeliPilotCoveralls";
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);

                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 3)];
                _x addMagazines ["30Rnd_45ACP_Mag_SMG_01", (6 + floor random 2)];

                _x addHeadgear "H_PilotHelmetHeli_B";

                _x addMagazines [([CHEMLIGHT] call Zen_ArrayGetRandom), 2];
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "Binocular";
                _x addWeaponGlobal "SMG_01_F";
            };
            case "helicoptercrew": {
                _x forceAddUniform "U_B_HeliPilotCoveralls";
                _x addVest ([RECON_VEST] call Zen_ArrayGetRandom);

                _x addMagazines ["HandGrenade", 1];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (7 + floor random 2)];

                _x addHeadgear "H_CrewHelmetHeli_B";

                _x addMagazines [([CHEMLIGHT] call Zen_ArrayGetRandom), 2];
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_MX_F";
            };
            case "fighterpilot": {
                _x forceAddUniform "U_B_PilotCoveralls";
                _x addBackpack "B_Parachute";

                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), 2];
                _x addMagazines ["11Rnd_45ACP_Mag", (3 + floor random 2)];

                _x addHeadgear "H_PilotHelmetFighter_B";

                _x addMagazines [([CHEMLIGHT] call Zen_ArrayGetRandom), 2];
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "Binocular";
                _x addWeaponGlobal "hgun_Pistol_heavy_01_F";
            };
            case "diver": {
                _x forceAddUniform "U_B_Wetsuit";
                _x addVest "V_RebreatherB";

                _x addMagazines ["HandGrenade", (1 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 2)];
                _x addMagazines ["20Rnd_556x45_UW_mag", (4 + floor random 2)];
                _x addMagazines ["30Rnd_556x45_Stanag", (4 + floor random 2)];

                _x addGoggles "G_Diving";
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_SDAR_F";
            };
            case "diversapper": {
                _x forceAddUniform "U_B_Wetsuit";
                _x addVest "V_RebreatherB";
                _x addBackpack "B_AssaultPack_blk";

                _x addMagazines ["HandGrenade", (1 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 2)];
                _x addMagazines ["20Rnd_556x45_UW_mag", (4 + floor random 2)];
                _x addMagazines ["30Rnd_556x45_Stanag", (4 + floor random 2)];
                _x addMagazines ["SatchelCharge_Remote_Mag", 2];

                _x addGoggles "G_Diving";
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];

                _x addWeaponGlobal "arifle_SDAR_F";
            };
            case "diverland": {
                _x forceAddUniform "U_B_Wetsuit";
                _x addVest "V_RebreatherB";
                _x addBackpack "B_AssaultPack_blk";

                _x addMagazines ["HandGrenade", (1 + floor random 3)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (1 + floor random 3)];
                _x addMagazines ["30Rnd_65x39_caseless_mag", (7 + floor random 3)];

                _x addGoggles "G_Diving";

                (unitBackpack _x) addItemCargoGlobal [([STD_UNIFORM] call Zen_ArrayGetRandom), 1];
                (unitBackpack _x) addItemCargoGlobal [([STD_VEST] call Zen_ArrayGetRandom), 1];
                (unitBackpack _x) addItemCargoGlobal [([STD_HEADGEAR] call Zen_ArrayGetRandom), 1];

                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 2];
                _x addWeaponGlobal "arifle_MX_Black_F";

                _x addPrimaryWeaponItem "optic_Aco";
                _x addPrimaryWeaponItem "acc_pointer_IR";
            };
            case "guerrilla": {
                _x unassignItem "NVGoggles";
                _x removeItem "NVGoggles";
                _x unlinkItem "itemGPS";

                _x addVest ([GUER_VEST] call Zen_ArrayGetRandom);
                _x addBackpack ([GUER_RUCK] call Zen_ArrayGetRandom);

                _weapon = ([GUER_WEAPON] call Zen_ArrayGetRandom);
                _magazine = (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0;

                _x addMagazines ["HandGrenade", (2 + floor random 2)];
                _x addMagazines [([SMOKE] call Zen_ArrayGetRandom), (2 + floor random 2)];
                _x addMagazines [_magazine, (8 + floor random 4)];

                _x addHeadgear ([GUER_HEADGEAR] call Zen_ArrayGetRandom);
                _x addGoggles ([GUER_GOGGLES] call Zen_ArrayGetRandom);
                _x forceAddUniform ([GUER_UNIFORM] call Zen_ArrayGetRandom);
                (uniformContainer _x) addItemCargoGlobal ["FirstAidKit", 1];
                _x addWeaponGlobal _weapon;
            };
            case "civilian": {
                _x unassignItem "NVGoggles";
                _x removeItem "NVGoggles";
                _x unlinkItem "itemGPS";

                _x forceAddUniform ([CIV_UNIFORM] call Zen_ArrayGetRandom);
                _x addHeadgear ([CIV_HEADGEAR] call Zen_ArrayGetRandom);
                _x addGoggles ([CIV_GOGGLES] call Zen_ArrayGetRandom);
            };
            default {
                0 = ["Zen_GiveLoadoutBlufor", "Invalid loadout identifier given", _this] call Zen_PrintError;
                call Zen_StackPrint;
            };
        };

        if !((toLower ([_kit] call Zen_StringRemoveWhiteSpace)) in ["guerrilla", "civilian"]) then {
            if (sunOrMoon == 1) then {
                _x unassignItem "NVGoggles";
            } else {
                _x action ["NVGoggles", _x];
            };
        };

        if (vehicle _unit == _unit) then {
            _unit switchMove _unitAnim;
        };
    } else {
        if (isMultiplayer && {_sendPacket}) then {
            _args = [_x, _kits, false];
            Zen_MP_Closure_Packet = ["Zen_GiveLoadoutBlufor", _args];
            (owner _x) publicVariableClient "Zen_MP_Closure_Packet";
        };
    };
} forEach _units;

call Zen_StackRemove;
if (true) exitWith {};

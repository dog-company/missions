class RscTitles
{
	class st_stamina_bar_visualizer 
	{
		idd = 10777;
		movingEnable = 1;
		enableSimulation = 1;
		enableDisplay = 1;
		onLoad = "st_stamina_bar_visualizer = _this; disableSerialization;";
		onunLoad = "";
		duration = 9999;
		fadein = 0;
		fadeout = 0;

		class controls {

			class IGUIBack_2200: IGUIBack {
				idc = 2200;
				x = "2 * GUI_GRID_W + GUI_GRID_X";
				y = "23 * GUI_GRID_H + GUI_GRID_Y";
				w = "16 * GUI_GRID_W";
				h = "0.25 * GUI_GRID_H";
			};

			class IGUIBack_2201: IGUIBack {
				idc = 2201;
				x = "2 * GUI_GRID_W + GUI_GRID_X";
				y = "22.65 * GUI_GRID_H + GUI_GRID_Y";
				w = "16 * GUI_GRID_W";
				h = "0.25 * GUI_GRID_H";
			};

			class IGUIBack_2202: IGUIBack {
				idc = 2202;
				x = "2 * GUI_GRID_W + GUI_GRID_X";
				y = "23 * GUI_GRID_H + GUI_GRID_Y";
				w = "16 * GUI_GRID_W";
				h = "0.25 * GUI_GRID_H";
			};

			class IGUIBack_2203: IGUIBack {
				idc = 2203;
				x = "2 * GUI_GRID_W + GUI_GRID_X";
				y = "22.65 * GUI_GRID_H + GUI_GRID_Y";
				w = "16 * GUI_GRID_W";
				h = "0.25 * GUI_GRID_H";
			};
		};
	};

	class st_stamina_bar_close 
	{
		idd = 10778;
		movingEnable = 1;
		enableSimulation = 1;
		enableDisplay = 1;
		onLoad = "";
		duration = 0;
		fadein = 0;
		fadeout = 0;
	};
};

class Revive_dialog
{
	idd=33991;
	movingenable=false;
	fadeIn = 2;
	fadeOut = 1;
	
	class controlsBackground {
		class boverlay: RscPicture
		{
			idc = 1200;
			text = "R34P3R\img\blood_overlay.paa";
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH;
		};	
		class dia_background: RscPicture
		{
			idc = 2200;
			x = 0.2;
			y = 0;
			w = 0.5875;
			h = 0.18;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			text = "R34P3R\img\dia_bg1.jpg";
		};	
	};
	
	class controls 
	{
		class btRevCamBack: RscShortcutButton
		{
			idc = -1;
			text = "‹";
			x = 0.22;
			y = 0.1;
			w = 0.041;
			h = 0.041;
			SizeEx = 0.032;
			font = "PuristaBold";
			action = "[0] spawn r3_changeRevCamPos";
		};
		class btCallMedic: RscShortcutButton
		{
			idc = 1600;
			text = "Call Medic";
			x = 0.28;
			y = 0.1;
			w = 0.2;
			h = 0.041;
			SizeEx = 0.032;
			default = true;
			action = "[] spawn r3_callForMedic";
		};
		class btSuicide: RscShortcutButton
		{
			idc = 1601;
			text = "Suicide";
			x = 0.505;
			y = 0.1;
			w = 0.2;
			h = 0.041;
			SizeEx = 0.032;
			action = "[] spawn r3_playerSuicide";
		};
		class btRevCamFwd: RscShortcutButton
		{
			idc = -1;
			text = "›";
			x = 0.725;
			y = 0.1;
			w = 0.041;
			h = 0.041;
			SizeEx = 0.032;
			font = "PuristaBold";
			action = "[1] spawn r3_changeRevCamPos";
		};
	};
};

class Respawn_dialog
{
	idd=33993;
	movingenable=false;
	onLoad = "[_this] call r3_initRespawnDialog";
	
	class controlsBackground {
		class dia_background: RscPicture
		{
			idc = 2200;
			x = 0.2;
			y = 0.02;
			w = 0.5875;
			h = 0.18;
			colorBackground[] = {0,0,0,0.6};
			colorActive[] = {0,0,0,0.6};
			text = "R34P3R\img\dia_bg1.jpg";
		};		
	};
	
	class controls 
	{
		class txtLable: RscText
		{
			idc = -1;
			text = "Select respawn position:";
			x = 0.215;
			y = 0.068;
			w = 0.55;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		class comboBox: RscCombo
		{
			idc = 2100;
			x = 0.225;
			y = 0.12;
			w = 0.35;
			h = 0.04;
			SizeEx = 0.032;
			onLBSelChanged = "[_this select 1] spawn r3_rsObjChanged";
		};
		class respawnBt: RscShortcutButton
		{
			idc = 1600;
			text = "Respawn"; //--- ToDo: Localize;
			x = 0.6;
			y = 0.12;
			w = 0.1625;
			h = 0.041;
			SizeEx = 0.032;
			action = "[] spawn r3_respawnButtonPressed";
		};
	};
};

class pSettings_dialog
{
	idd=33994;
	movingenable=false;
	enableSimulation = 1;
	enableDisplay = 1;
	onLoad = "pSettings_dialog = _this; disableSerialization;";
	onunLoad = "";
	fadein = 1;
	fadeout = 1;
	onMouseMoving = "['Option description will shown here...'] call pSettings_changeToolText";
	
	class controlsBackground {
		class dia_background: RscPicture
		{
			idc = 2200;
			x = 0.1;
			y = 0.02;
			w = 0.8;
			h = 0.65;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			text = "R34P3R\img\settings_bg.jpg";
		};		
	};
	
	class controls 
	{
		class txtVersion: RscText
		{
			idc = 2100;
			text = "";
			x = 0.72;
			y = 0.021;
			w = 0.2;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class txtShowNames: RscText
		{
			idc = -1;
			text = "Show unit names:";
			x = 0.12;
			y = 0.1;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstShowNames: RscCombo {
			idc = 2101;
			x = 0.35;
			y = 0.11;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Unit names: Show unit/player names above there heads. (this require up to 3 FPS)'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_showNames = true} else {r3_showNames = false}";
		};

		class txtShowTaskIcon: RscText
		{
			idc = -1;
			text = "Show task destination:";
			x = 0.12;
			y = 0.15;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstShowTaskIcon: RscCombo {
			idc = 2102;
			x = 0.35;
			y = 0.16;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Task destination: Enable or disable a little green destination icon, to find your way quicker. (will only shown if taskDestination is set by mission-builder)'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_showTaskIcon = true} else {r3_showTaskIcon = false}";
		};

		class txtIconsMaxDistance: RscText
		{
			idc = -1;
			text = "Icons/Names max distance:";
			x = 0.12;
			y = 0.20;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstIconsMaxDistance: RscCombo {
			idc = 2103;
			x = 0.35;
			y = 0.21;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Max distance: Set the maximum distance in meter, unit names and revive icons will shown. Default is 200.'] call pSettings_changeToolText";
			onLBSelChanged = "r3_SpecialIconsMaxDistance = parseNumber lbText [2103, (_this select 1)]";
		};

		class txtShowStaminaBar: RscText
		{
			idc = -1;
			text = "Show Stamina Bar:";
			x = 0.12;
			y = 0.25;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstShowStaminaBar: RscCombo {
			idc = 2104;
			x = 0.35;
			y = 0.26;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Stamina Bar: Enable or disable the included Stamina Bar which will shown in the TOP/RIGHT corner. If you already using ShackTac MODs, this will automatic disabled.'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_showStaminaBar = true; [] spawn fn_st_stamina_bar_launch} else {r3_showStaminaBar = false}";
		};
		
		class txtEnableColorCorrect: RscText
		{
			idc = -1;
			text = "Color Correction:";
			x = 0.12;
			y = 0.3;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstEnableColorCorrect: RscCombo {
			idc = 2105;
			x = 0.35;
			y = 0.31;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Color Correction: Enable or disable the Script-internal color correction. It take 5 - 10 seconds to change this setting.'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_enableColorCorrection = true; r3_currentDayState = ''} else {r3_enableColorCorrection = false; if(!r3_nvg_on) then {[0] call r3_apply_colorCorrection};};";
		};

		class txtEnableStaminaScript: RscText
		{
			idc = -1;
			text = "Stamina Script:";
			x = 0.12;
			y = 0.35;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstEnableStaminaScript: RscCombo {
			idc = 2106;
			x = 0.35;
			y = 0.36;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Stamina Script: If enabled you can sprint a bit longer and recover your stamina faster.'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_enableStaminaScript = true} else {r3_enableStaminaScript = false}";
		};
		
		class txtEnableAutoheal: RscText
		{
			idc = -1;
			text = "Enable Autoheal:";
			x = 0.12;
			y = 0.4;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstEnableAutoheal: RscCombo {
			idc = 2107;
			x = 0.35;
			y = 0.41;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Autoheal: If enabled the script will heal you up slowly, but only the last 20%. So if you use FirstAid Kit, you will now fully healed.'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_enableAutoHeal = true} else {r3_enableAutoHeal = false}";
		};
		
		class txtEnableFSNVG: RscText
		{
			idc = -1;
			text = "Enable full screen NVG:";
			x = 0.12;
			y = 0.45;
			w = 0.4;
			h = 0.04;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.03;
		};
		
		class lstEnableFSNVG: RscCombo {
			idc = 2108;
			x = 0.35;
			y = 0.46;
			w = 0.1;
			h = 0.03;
			SizeEx = 0.03;
			wholeHeight = 0.1;
			onMouseHolding = "['Full screen NVG: Enable or disable the script-internal full screen night vision. This will remove the black ring on your NV. It take 5 - 10 seconds to change this setting.'] call pSettings_changeToolText";
			onLBSelChanged = "if((_this select 1) == 0) then {r3_enableFSNVG = true} else {r3_enableFSNVG = false; r3_nvg_on = false;}";
		};

		class txtToolTip: RscText
		{
			idc = 2120;
			access = 0;
			type = 0;
			style = 16;
			linespacing = 1;
			text = "Option description will shown here...";
			x = 0.49;
			y = 0.1;
			w = 0.39;
			h = 0.5;
			shadow = 0;
			fixedWidth = 0;
			colorText[] = {0.76,0.76,0.76,1};
			colorBackground[] = {0,0,0,0};
			SizeEx = 0.032;
		};
		
		class btClose: RscShortcutButton
		{
			idc = 1600;
			text = "Save";
			x = 0.7;
			y = 0.6;
			w = 0.1625;
			h = 0.041;
			SizeEx = 0.03;
			action = "[] call pSettings_saveSettings";
			onMouseHolding = "['Save settings: All settings will saved in your profile, If you play any other missions which using this Framework the settings will be auto loaded. But make sure, all options can disabled by mission-builder.'] call pSettings_changeToolText";
		};
	};
};




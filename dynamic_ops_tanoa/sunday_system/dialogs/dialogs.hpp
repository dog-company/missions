
class DRO_introDialog {
	idd = 424242;
	movingenable = false;
	class controls {
		class lobbyTitle: sundayHeading
		{
			idc = 3000;
			text = "";
			x = 0.2 * safezoneW + safezoneX;
			y = 0.2 * safezoneH + safezoneY;
			w = 0.4 * safezoneW;
			h = 0.2 * safezoneH;
			font = "EtelkaMonospaceProBold";
			sizeEx = 0.11;
		};
	};
};

class DRO_lobbyDialog {
	idd = 626262;
	movingenable = false;
	
	class controls {
		
		class lobbyTitle: sundayHeading
		{
			idc = 6002;
			style = ST_LEFT;
			text = "  TEAM PLANNING";
			x = 0.25 * safezoneW + safezoneX;
			y = 0.245 * safezoneH + safezoneY;
			w = 0.49 * safezoneW;
			h = 0.05 * safezoneH;
			colorBackground[] = {0.20,0.40,0.65, 0.8};
		};
		class lobbyOptionsBackground0: RscText
		{
			idc = 6001;			
			x = 0.25 * safezoneW + safezoneX;
			y = 0.344 * safezoneH + safezoneY;
			w = 0.26 * safezoneW;
			h = 0.305 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 0.8 };
			text = "";
		};
		class lobbyOptionsTitle0: sundayHeading
		{
			idc = 6101;
			style = ST_LEFT;
			text = "  SQUAD LOADOUT";
			x = 0.25 * safezoneW + safezoneX;
			y = 0.305 * safezoneH + safezoneY;
			w = 0.26 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.04;
			colorBackground[] = {0.20,0.40,0.65, 0.8};
		};	
		class lobbyOptionsBackground1: RscText
		{
			idc = 6007;			
			x = 0.515 * safezoneW + safezoneX;
			y = 0.344 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.305 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 0.8 };
			text = "";
		};
		class lobbyOptionsTitle1: sundayHeading
		{
			idc = 6102;
			style = ST_LEFT;
			text = "  INSERTION";
			x = 0.515 * safezoneW + safezoneX;
			y = 0.305 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.04;
			colorBackground[] = {0.20,0.40,0.65, 0.8};
		};
		class lobbyOptionsBackground2: RscText
		{
			idc = 6100;			
			x = 0.63 * safezoneW + safezoneX;
			y = 0.344 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.305 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 0.8 };
			text = "";
		};
		class lobbyOptionsTitle2: sundayHeading
		{
			idc = 6103;
			style = ST_LEFT;
			text = "  SUPPORTS";
			x = 0.63 * safezoneW + safezoneX;
			y = 0.305 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.04;
			colorBackground[] = {0.20,0.40,0.65, 0.8};
		};
		class lobbySelectStart: DROBasicButton
		{			
			idc = 6004;
			text = "Set Insert Location";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.04 * safezoneH;			
			action = "_nil=[]ExecVM 'sunday_system\dialogs\selectStart.sqf';";		
		};
		class lobbySelectStartClear: DROBasicButton
		{			
			idc = 6005;
			text = "Clear Insert Location";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.445 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.04 * safezoneH;			
			action = "deleteMarker 'campMkr';";		
		};
		class lobbySelectStartText: sundayText {
			idc = 6006;
			text = "Insertion position: RANDOM";
			x = 0.515 * safezoneW + safezoneX;
			y = 0.50 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;		
		};				
		class lobbyComboInsert: DROCombo
		{
			idc = 6009;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.36 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "insertType = (_this select 1)";					
		};
		class lobbySelectVehText: sundayText {
			idc = 6012;
			text = "Starting ground vehicle";
			x = 0.515 * safezoneW + safezoneX;
			y = 0.53 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			tooltip = "Picks a custom ground vehicle for insertion. If the chosen vehicle does not have enough room for all units additional random vehicles will be chosen.";
		};	
		class lobbyComboVeh: DROCombo
		{
			idc = 6013;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.57 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "startVehicle = [(_this select 1), (_this select 0) lbData (_this select 1)]";					
		};
		class lobbySupportCombo: DROCombo
		{
			idc = 6010;
			x = 0.635 * safezoneW + safezoneX;
			y = 0.36 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;			
			onLBSelChanged = "randomSupports = (_this select 1);";					
		};		
		class lobbySupportOptions: DROCheckBoxSupports
		{
			idc = 6011;
			x = 0.635 * safezoneW + safezoneX;
			y = 0.40 * safezoneH + safezoneY;
			onCheckBoxesSelChanged = "customSupports set [(_this select 1), (_this select 2)]; lbSetCurSel [6010, 1]; randomSupports = 1;";
		};		
		class lobbyGoButton: DROBigButton
		{			
			idc = 6050;
			text = "START MISSION";
			x = 0.63 * safezoneW + safezoneX;
			y = 0.65 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.06 * safezoneH;			
			action = "missionNameSpace setVariable ['lobbyComplete', 1, true]; publicVariable 'lobbyComplete';";		
		};		
		// Unit Loadouts		
		class sundayUnitTitle1: sundayText {
			idc = 1200;
			text = "Unit 1 (AI):";
			x = 0.40 * safezoneW + safezoneX;
			y = 0.467 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo1: DROCombo
		{
			idc = 1201;
			x = 0.43 * safezoneW + safezoneX;
			y = 0.48 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;	
			onLBSelChanged = "_nil=[u1, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";			
		};
		class DRO_Unit1VAButton: DROBasicButton
		{
			idc = 1301;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";			
			x = 0.58 * safezoneW + safezoneX;
			y = 0.477 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u1') then {_nil=[u1]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit1DelAI: DROCheckBoxRemove
		{
			idc = 1501;							
			x = 0.35 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u1, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};			
		class sundayUnitTitle2: sundayText {
			idc = 1202;
			text = "Unit 2 (AI):"; //--- ToDo: Localize;
			x = 0.40 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo2: DROCombo
		{
			idc = 1203;
			x = 0.43 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;	
			onLBSelChanged = "_nil=[u2, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf';";			
		};
		class DRO_Unit2VAButton: DROBasicButton
		{
			idc = 1302;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.58 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u2') then {_nil=[u2]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit2DelAI: DROCheckBoxRemove
		{
			idc = 1502;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u2, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};		
		class sundayUnitTitle3: sundayText {
			idc = 1204;
			text = "Unit 3 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo3: DROCombo
		{
			idc = 1205;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;	
			onLBSelChanged = "_nil=[u3, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit3VAButton: DROBasicButton
		{
			idc = 1303;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u3') then {_nil=[u3]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit3DelAI: DROCheckBoxRemove
		{
			idc = 1503;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u3, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle4: sundayText {
			idc = 1206;
			text = "Unit 4 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo4: DROCombo
		{
			idc = 1207;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.565 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			onLBSelChanged = "_nil=[u4, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit4VAButton: DROBasicButton
		{
			idc = 1304;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.565 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u4') then {_nil=[u4]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit4DelAI: DROCheckBoxRemove
		{
			idc = 1504;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u4, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle5: sundayText {
			idc = 1208;
			text = "Unit 5 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo5: DROCombo
		{
			idc = 1209;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.595 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			onLBSelChanged = "_nil=[u5, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit5VAButton: DROBasicButton
		{
			idc = 1305;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.595 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u5') then {_nil=[u5]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit5DelAI: DROCheckBoxRemove
		{
			idc = 1505;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u5, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle6: sundayText {
			idc = 1210;
			text = "Unit 6 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo6: DROCombo
		{
			idc = 1211;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			onLBSelChanged = "_nil=[u6, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit6VAButton: DROBasicButton
		{
			idc = 1306;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u6') then {_nil=[u6]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit6DelAI: DROCheckBoxRemove
		{
			idc = 1506;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u6, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle7: sundayText {
			idc = 1212;
			text = "Unit 7 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.64 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo7: DROCombo
		{
			idc = 1213;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			onLBSelChanged = "_nil=[u7, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit7VAButton: DROBasicButton
		{
			idc = 1307;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u7') then {_nil=[u7]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit7DelAI: DROCheckBoxRemove
		{
			idc = 1507;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u7, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle8: sundayText {
			idc = 1214;
			text = "Unit 8 (AI):"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.67 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo8: DROCombo
		{
			idc = 1215;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.685 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			onLBSelChanged = "_nil=[u8, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";
		};
		class DRO_Unit8VAButton: DROBasicButton
		{
			idc = 1308;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.685 * safezoneH + safezoneY;
			w = 0.018 * safezoneW;
			h = 0.026 * safezoneH;
			sizeEx = 0.025;
			action = "if (!isNil 'u8') then {_nil=[u8]ExecVM 'sunday_system\dialogs\openArsenal.sqf'}";
		};
		class DRO_Unit8DelAI: DROCheckBoxRemove
		{
			idc = 1508;						
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;						
			onCheckBoxesSelChanged = "_nil=[u8, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
	
	};
};


class sundayDialog {
	idd = 52525;
	movingenable = false;
		
	class controls {
		
		class menuBackground: RscText
		{
			idc = 1095;			
			x = -1;
			y = -1;
			w = 3;
			h = 3;
			colorBackground[] = { 0, 0, 0, 1 };
			text = "";
		};
		
		class sundayTitlePic: RscPicture
		{
			idc = 1098;
			text = "images\recon_icon.jpg";
			x = 0.424 * safezoneW + safezoneX;
			y = 0.18 * safezoneH + safezoneY;
			w = 0.153 * safezoneW;
			h = 0.153 * safezoneH;			
		};
		/*
		class titleChooseBackground: RscText
		{
			idc = 1100;			
			x = 0.33 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.34 * safezoneW;
			h = 0.06 * safezoneH;
			colorBackground[] = {0.20,0.40,0.65,1};
			text = "";
		};
		*/
		class sundayTitleChoose: sundayHeading
		{
			idc = 1101;			
			style = ST_LEFT;
			text = "  MISSION GENERATION"; //--- ToDo: Localize;
			x = 0.33 * safezoneW + safezoneX;
			y = 0.34 * safezoneH + safezoneY;
			w = 0.34 * safezoneW;
			h = 0.05 * safezoneH;
			sizeEx = 0.04;
			colorBackground[] = {0.20,0.40,0.65,1};
		};
		class menuTitle1: sundayHeading
		{
			idc = 1030;
			style = ST_LEFT;
			text = "  FACTIONS";
			x = 0.33 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.035;
			colorBackground[] = {0.20,0.40,0.65, 1};
		};	
		class menuBackground1: RscText {
			idc = 1050;			
			x = 0.33 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.31 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 1 };
			text = "";
		};
		class menuTitle2: sundayHeading
		{
			idc = 1031;
			style = ST_LEFT;
			text = "  SCENARIO";
			x = 0.445 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.035;
			colorBackground[] = {0.20,0.40,0.65, 1};
		};	
		class menuBackground2: RscText {
			idc = 1051;			
			x = 0.445 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.31 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 1 };
			text = "";
		};
		class menuTitle3: sundayHeading
		{
			idc = 1032;
			style = ST_LEFT;
			text = "  AO OPTIONS";
			x = 0.56 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.04 * safezoneH;
			sizeEx = 0.035;
			colorBackground[] = {0.20,0.40,0.65, 1};
		};	
		class menuBackground3: RscText {
			idc = 1052;			
			x = 0.56 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.31 * safezoneH;
			colorBackground[] = { 0.1, 0.1, 0.1, 1 };
			text = "";
		};
		
		class sundayTitlePlayer: sundayText
		{
			idc = 1102;
			text = "Player faction"; //--- ToDo: Localize;
			x = 0.33 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};		
		class sundayComboPlayerFactions: DROCombo
		{
			idc = 2100;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			onLBSelChanged = "pFactionIndex = (_this select 1)";				
		};		
		
		class sundayTitleEnemy: sundayText
		{
			idc = 1103;
			text = "Enemy faction"; //--- ToDo: Localize;
			x = 0.33 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboEnemyFactions: DROCombo
		{
			idc = 2101;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.56 * safezoneH + safezoneY;		
			onLBSelChanged = "eFactionIndex = (_this select 1)";
		};
		class sundayTitleCivilians: sundayText
		{
			idc = 1104;
			text = "Civilian faction"; //--- ToDo: Localize;
			x = 0.33 * safezoneW + safezoneX;
			y = 0.59 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboCivFactions: DROCombo
		{
			idc = 2102;
			x = 0.335 * safezoneW + safezoneX;
			y = 0.63 * safezoneH + safezoneY;
			onLBSelChanged = "cFactionIndex = (_this select 1)";			
		};
		
		class sundayTitleTime: sundayText
		{
			idc = 1105;
			text = "Time of day"; //--- ToDo: Localize;
			x = 0.445 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};		
		class sundayTBTime: DROCombo
		{
			idc = 2103;
			x = 0.45 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "timeOfDay = (_this select 1)";		
		};		
		class sundayTitleObjs: sundayText
		{
			idc = 1108;
			text = "Number of objectives"; //--- ToDo: Localize;
			x = 0.445 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayTBObjs: DROCombo
		{
			idc = 2106;
			x = 0.45 * safezoneW + safezoneX;
			y = 0.56 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "numObjectives = (_this select 1)";			
		};		
		class sundayTitleAI: sundayText
		{
			idc = 1107;
			text = "Enemy force style"; //--- ToDo: Localize;
			x = 0.445 * safezoneW + safezoneX;
			y = 0.59 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Different styles of enemy makeup: 'Action' has more enemies with lower skills, 'Milsim' has fewer enemies with default skills.";
		};
		class sundayTBAI: DROCombo
		{
			idc = 2105;
			x = 0.45 * safezoneW + safezoneX;
			y = 0.63 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "aiSkill = (_this select 1)";				
		};
		class sundayTitleRevive: sundayText
		{
			idc = 1110;
			text = "Revive"; //--- ToDo: Localize;
			x = 0.445 * safezoneW + safezoneX;
			y = 0.66 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Enable or disable revive script. Disable for use with mods such as ACE3.";
		};
		class sundayTBRevive: DROCombo
		{
			idc = 2108;
			x = 0.45 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "missionNameSpace setVariable ['reviveOptionSelect', (_this select 1)]; publicVariable  'reviveOptionSelect';";			
		};
		class sundayTitleAO: sundayText
		{
			idc = 1109;
			text = "Size of AO"; //--- ToDo: Localize;
			x = 0.56 * safezoneW + safezoneX;
			y = 0.45 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "As well as changing the AO size this will also affect how many enemies are spawned.";
		};
		class sundayTBAO: DROCombo
		{
			idc = 2107;
			x = 0.565 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;						
			onLBSelChanged = "aoOptionSelect = (_this select 1)";
		};
		
		class droSelectAO: DROBasicButton
		{			
			idc = 2200;
			text = "Select Custom AO Location";
			x = 0.565 * safezoneW + safezoneX;
			y = 0.53 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.04 * safezoneH;			
			action = "_nil=[]ExecVM 'sunday_system\dialogs\selectAO.sqf';";		
		};
		
		class droSelectAOClear: DROBasicButton
		{			
			idc = 2201;
			text = "Clear AO Location";
			x = 0.565 * safezoneW + safezoneX;
			y = 0.575 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.04 * safezoneH;			
			action = "deleteMarker 'aoSelectMkr'; aoName = nil; ctrlSetText [2202, 'AO location: RANDOM']; selectedLocMarker setMarkerColor 'ColorPink';";		
		};
		class droSelectAOText: sundayText {
			idc = 2202;
			text = "AO location: RANDOM";
			x = 0.565 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.04 * safezoneH;		
		};
		
		class sundayOkArsButton: DROBigButton
		{
			idc = 1601;
			text = "START";
			x = 0.56 * safezoneW + safezoneX;
			y = 0.75 * safezoneH + safezoneY;
			w = 0.11 * safezoneW;
			h = 0.055 * safezoneH;			
			action = "_nil=[]ExecVM 'sunday_system\dialogs\okAO.sqf';";
		};		
		
		
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////		
		
	};
	
};
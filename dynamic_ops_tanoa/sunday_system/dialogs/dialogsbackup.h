////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by Mark, v1.063, #Detoqy)
////////////////////////////////////////////////////////

class DRO_lobbyDialog {
	idd = 626262;
	movingenable = false;
	
	class controls {
		
		class lobbyBackground: RscText
		{
			idc = 6001;			
			x = -1;
			y = -1;
			w = 3;
			h = 3;
			colorBackground[] = { 0, 0, 0, 1 };
			text = "";
		};
		
		class sundayFrame: RscFrame
		{
			idc = 6000;			
			x = 0.33 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.34 * safezoneW;
			h = 0.43 * safezoneH;			
		};
		
		
		// Unit Loadouts
		class sundayUnitTitle1: sundayText {
			idc = 1200;
			text = "Unit 1:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.46 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo1: RscCombo
		{
			idc = 1201;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;	
			onLBSelChanged = "_nil=[u1, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";			
		};
		class DRO_Unit1VAButton: RscButton
		{
			idc = 1301;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			//text = "VA"; //--- ToDo: Localize;
			x = 0.52 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u1]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit1ReadyButton: DROCheckBox
		{
			idc = 1401;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u1]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit1DelAI: RscButton
		{
			idc = 1501;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.475 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u1, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};		
		class sundayUnitTitle2: sundayText {
			idc = 1202;
			text = "Unit 2:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.49 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo2: RscCombo
		{
			idc = 1203;
			x = 0.39 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.03;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;	
			onLBSelChanged = "_nil=[u2, _this]ExecVM 'sunday_system\switchUnitLoadout.sqf'";			
		};
		class DRO_Unit2VAButton: RscButton
		{
			idc = 1302;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u2]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit2ReadyButton: DROCheckBox
		{
			idc = 1402;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u2]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit2DelAI: RscButton
		{
			idc = 1502;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.505 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u2, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};			
		class sundayUnitTitle3: sundayText {
			idc = 1204;
			text = "Unit 3:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo3: RscCombo
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
		class DRO_Unit3VAButton: RscButton
		{
			idc = 1303;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u3]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit3ReadyButton: DROCheckBox
		{
			idc = 1403;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u3]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit3DelAI: RscButton
		{
			idc = 1503;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.535 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u3, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle4: sundayText {
			idc = 1206;
			text = "Unit 4:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.55 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo4: RscCombo
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
		class DRO_Unit4VAButton: RscButton
		{
			idc = 1304;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.565 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u4]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit4ReadyButton: DROCheckBox
		{
			idc = 1404;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.565 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u4]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit4DelAI: RscButton
		{
			idc = 1504;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.565 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u4, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle5: sundayText {
			idc = 1208;
			text = "Unit 5:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo5: RscCombo
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
		class DRO_Unit5VAButton: RscButton
		{
			idc = 1305;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.595 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u5]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit5ReadyButton: DROCheckBox
		{
			idc = 1405;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.595 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u5]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit5DelAI: RscButton
		{
			idc = 1505;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.595 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u5, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle6: sundayText {
			idc = 1210;
			text = "Unit 6:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.61 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo6: RscCombo
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
		class DRO_Unit6VAButton: RscButton
		{
			idc = 1306;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u6]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit6ReadyButton: DROCheckBox
		{
			idc = 1406;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u6]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit6DelAI: RscButton
		{
			idc = 1506;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.625 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u6, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle7: sundayText {
			idc = 1212;
			text = "Unit 7:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.64 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo7: RscCombo
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
		class DRO_Unit7VAButton: RscButton
		{
			idc = 1307;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u7]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit7ReadyButton: DROCheckBox
		{
			idc = 1407;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u7]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit7DelAI: RscButton
		{
			idc = 1507;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.655 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u7, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};
		class sundayUnitTitle8: sundayText {
			idc = 1214;
			text = "Unit 8:"; //--- ToDo: Localize;
			x = 0.36 * safezoneW + safezoneX;
			y = 0.67 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;			
		};
		class sundayUnitCombo8: RscCombo
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
		class DRO_Unit8VAButton: RscButton
		{
			idc = 1308;
			style = 48;
			text = "\A3\ui_f\data\igui\cfg\simpleTasks\types\rifle_ca.paa";
			x = 0.52 * safezoneW + safezoneX;
			y = 0.685 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[u8]ExecVM 'sunday_system\dialogs\openArsenal.sqf';";
		};
		class DRO_Unit8ReadyButton: DROCheckBox
		{
			idc = 1408;						
			x = 0.56 * safezoneW + safezoneX;
			y = 0.685 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;			
			onCheckBoxesSelChanged = "_nil=[u8]ExecVM 'sunday_system\dialogs\readyButton.sqf'";
		};
		class DRO_Unit8DelAI: RscButton
		{
			idc = 1508;			
			text = "X";			
			x = 0.28 * safezoneW + safezoneX;
			y = 0.685 * safezoneH + safezoneY;
			w = 0.02 * safezoneW;
			h = 0.02 * safezoneH;
			sizeEx = 0.025;			
			colorBackground[] = {1, 0, 0, 1};
			onButtonClick = "_nil=[u8, _this]ExecVM 'sunday_system\dialogs\removeAI.sqf'";
		};	
	};
};


class sundayDialog {
	idd = 52525;
	movingenable = false;
		
	class controls {
		
		class sundayFrame: RscFrame
		{
			idc = 1099;			
			x = 0.33 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.34 * safezoneW;
			h = 0.43 * safezoneH;			
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
		class sundayTitle: sundayHeading
		{
			idc = 1100;
			text = "Sunday Afternoon Combat"; //--- ToDo: Localize;
			x = 0.37625 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.257813 * safezoneW;
			h = 0.044 * safezoneH;
		};
		*/
		class sundayTitleChoose: sundayText
		{
			idc = 1101;
			style = ST_CENTER;
			text = "Select combat options"; //--- ToDo: Localize;
			x = 0.438125 * safezoneW + safezoneX;
			y = 0.35 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayTitlePlayer: sundayText
		{
			idc = 1102;
			text = "Player faction"; //--- ToDo: Localize;
			x = 0.345 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};		
		class sundayComboPlayerFactions: RscCombo
		{
			idc = 2100;
			x = 0.35 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};		
		// Enemy and Civilian options
		class sundayTitleEnemy: sundayText
		{
			idc = 1103;
			text = "Enemy faction"; //--- ToDo: Localize;
			x = 0.345 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboEnemyFactions: RscCombo
		{
			idc = 2101;
			x = 0.35 * safezoneW + safezoneX;
			y = 0.62 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			
		};
		class sundayTitleCivilians: sundayText
		{
			idc = 1104;
			text = "Civilian faction"; //--- ToDo: Localize;
			x = 0.345 * safezoneW + safezoneX;
			y = 0.64 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboCivFactions: RscCombo
		{
			idc = 2102;
			x = 0.35 * safezoneW + safezoneX;
			y = 0.68 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;
			
		};
		
		class sundayTitleTime: sundayText
		{
			idc = 1105;
			text = "Time of day"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.4 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboTime: RscCombo
		{
			idc = 2103;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.44 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class sundayTitleInsert: sundayText
		{
			idc = 1106;
			text = "Insertion"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.46 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "How you will enter the AO. Ground insertion also gives a small chance to insert via boat.";
		};
		class sundayComboInsert: RscCombo
		{
			idc = 2104;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.5 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class sundayTitleAI: sundayText
		{
			idc = 1107;
			text = "AI Skill"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.52 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "The aiming and spotting ability of enemy AI units.";
		};
		class sundayComboAI: RscCombo
		{
			idc = 2105;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.56 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class sundayTitleObjs: sundayText
		{
			idc = 1108;
			text = "Number of Objectives"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.58 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
		};
		class sundayComboObjs: RscCombo
		{
			idc = 2106;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.62 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class sundayTitleAO: sundayText
		{
			idc = 1109;
			text = "Size of AO"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.64 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "As well as changing the AO size this will also affect how many enemies are spawned.";
		};
		class sundayComboAO: RscCombo
		{
			idc = 2107;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.68 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class sundayTitleRevive: sundayText
		{
			idc = 1110;
			text = "Revive"; //--- ToDo: Localize;
			x = 0.545 * safezoneW + safezoneX;
			y = 0.70 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.044 * safezoneH;
			tooltip = "Enable or disable revive script. Disable for use with mods such as ACE3.";
		};
		class sundayComboRevive: RscCombo
		{
			idc = 2108;
			x = 0.55 * safezoneW + safezoneX;
			y = 0.74 * safezoneH + safezoneY;
			w = 0.1 * safezoneW;
			h = 0.018 * safezoneH;
			sizeEx = 0.035;
			rowHeight = 0.03;
			wholeHeight = 4 * 0.10;			
		};
		class okFrame: RscFrame
		{
			idc = 1602;			
			x = 0.68 * safezoneW + safezoneX;
			y = 0.6 * safezoneH + safezoneY;
			w = 0.09 * safezoneW;
			h = 0.18 * safezoneH;			
		};
		
		class sundayOkArsButton: RscButton
		{
			idc = 1601;
			text = "START WITH ARSENAL"; //--- ToDo: Localize;
			x = 0.69 * safezoneW + safezoneX;
			y = 0.7 * safezoneH + safezoneY;
			w = 0.07 * safezoneW;
			h = 0.055 * safezoneH;
			sizeEx = 0.025;
			action = "_nil=[]ExecVM 'sunday_system\dialogs\okAO.sqf';";
		};		
		
		////////////////////////////////////////////////////////
		// GUI EDITOR OUTPUT END
		////////////////////////////////////////////////////////		
		
	};
	
};

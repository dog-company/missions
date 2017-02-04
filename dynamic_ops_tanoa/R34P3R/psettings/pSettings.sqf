waitUntil{!isNull player};

pSettings_changeToolText = {
	_text = _this select 0;
    ctrlSetText [2120, _text];
};
/*
pSettings_saveSettings = {
	profileNamespace setVariable ["r3_showNames", r3_showNames];
	profileNamespace setVariable ["r3_showTaskIcon", r3_showTaskIcon];
	profileNamespace setVariable ["r3_SpecialIconsMaxDistance", r3_SpecialIconsMaxDistance];
	profileNamespace setVariable ["r3_showStaminaBar", r3_showStaminaBar];
	profileNamespace setVariable ["r3_enableColorCorrection", r3_enableColorCorrection];
	profileNamespace setVariable ["r3_enableStaminaScript", r3_enableStaminaScript];
	profileNamespace setVariable ["r3_enableAutoHeal", r3_enableAutoHeal];
	profileNamespace setVariable ["r3_enableFSNVG", r3_enableFSNVG];
	saveprofileNamespace;
	closeDialog 33994;
};

pSettings_loadSettings = {
	if(r3_allowSpecialIcons) then {
		r3_showNames = profileNamespace getVariable ["r3_showNames", true];
		r3_showTaskIcon = profileNamespace getVariable ["r3_showTaskIcon", true];
		r3_SpecialIconsMaxDistance = profileNamespace getVariable ["r3_SpecialIconsMaxDistance", 200];
	};
	if(r3_allowStaminaBar) then {
		r3_showStaminaBar = profileNamespace getVariable ["r3_showStaminaBar", true];
	};
	if(r3_allowColorCorrection) then {
		r3_enableColorCorrection = profileNamespace getVariable ["r3_enableColorCorrection", true];
	};
	if(r3_allowStaminaScript) then {
		r3_enableStaminaScript = profileNamespace getVariable ["r3_enableStaminaScript", true];
	};
	if(r3_allowAutoHeal) then {
		r3_enableAutoHeal = profileNamespace getVariable ["r3_enableAutoHeal", true];
	};
	if(r3_allowFSNVG) then {
		r3_enableFSNVG = profileNamespace getVariable ["r3_enableFSNVG", true];
	};
};
*/
/*
pSettings_open_dialog = {

	disableSerialization;
	
	_handle = createDialog "pSettings_dialog";
	waitUntil {sleep 0.01; (!(isNull (findDisplay 33994)))};
	
	ctrlEnable [2120, false];
	ctrlSetText [2100, format ["Version: %1",r3_version]];
	
	//r3_showNames
	_lb = lbAdd [2101, "ON"];
	_lb = lbAdd [2101, "OFF"];
	
	//r3_showTaskIcon
	_lb = lbAdd [2102, "ON"];
	_lb = lbAdd [2102, "OFF"];	

	//r3_SpecialIconsMaxDistance
	_lb = lbAdd [2103, "50"];
	_lb = lbAdd [2103, "100"];
	_lb = lbAdd [2103, "200"];
	_lb = lbAdd [2103, "500"];
		
	if(r3_allowSpecialIcons) then {
	
		if(r3_showNames) then {
			lbSetCurSel [2101, 0];
		} else {
			lbSetCurSel [2101, 1];
		};
		
		if(r3_showTaskIcon) then {
			lbSetCurSel [2102, 0];
		} else {
			lbSetCurSel [2102, 1];
		};
			
		switch(r3_SpecialIconsMaxDistance) do {
			case 50: {lbSetCurSel [2103, 0]};
			case 100: {lbSetCurSel [2103, 1]};
			case 200: {lbSetCurSel [2103, 2]};
			case 500: {lbSetCurSel [2103, 3]};
			default {
				lbSetCurSel [2103, 2];
				r3_SpecialIconsMaxDistance = 200;
			};
		};

	} else {
		lbSetCurSel [2101, 1];
		lbSetCurSel [2102, 1];
		lbSetCurSel [2103, 1];
		ctrlEnable [2101, false];
		ctrlEnable [2102, false];
		ctrlEnable [2103, false];
	};
	
	// r3_showStaminaBar
	_lb = lbAdd [2104, "ON"];
	_lb = lbAdd [2104, "OFF"];
	
	if(r3_allowStaminaBar) then {
		if(r3_showStaminaBar) then {
			lbSetCurSel [2104, 0];
		} else {
			lbSetCurSel [2104, 1];
		};		
	} else {
		lbSetCurSel [2104, 1];
		ctrlEnable [2104, false];
	};
	
	// r3_enableColorCorrection
	_lb = lbAdd [2105, "ON"];
	_lb = lbAdd [2105, "OFF"];
	
	if(r3_allowColorCorrection) then {
		if(r3_enableColorCorrection) then {
			lbSetCurSel [2105, 0];
		} else {
			lbSetCurSel [2105, 1];
		};		
	} else {
		lbSetCurSel [2105, 1];
		ctrlEnable [2105, false];
	};
	
	// r3_enableStaminaScript
	_lb = lbAdd [2106, "ON"];
	_lb = lbAdd [2106, "OFF"];
	
	if(r3_allowStaminaScript) then {
		if(r3_enableStaminaScript) then {
			lbSetCurSel [2106, 0];
		} else {
			lbSetCurSel [2106, 1];
		};		
	} else {
		lbSetCurSel [2106, 1];
		ctrlEnable [2106, false];
	};
	
	// r3_enableAutoHeal
	_lb = lbAdd [2107, "ON"];
	_lb = lbAdd [2107, "OFF"];
	
	if(r3_allowAutoHeal) then {
		if(r3_enableAutoHeal) then {
			lbSetCurSel [2107, 0];
		} else {
			lbSetCurSel [2107, 1];
		};		
	} else {
		lbSetCurSel [2107, 1];
		ctrlEnable [2107, false];
	};
	
	// r3_enableFSNVG
	_lb = lbAdd [2108, "ON"];
	_lb = lbAdd [2108, "OFF"];
	
	if(r3_allowFSNVG) then {
		if(r3_enableFSNVG) then {
			lbSetCurSel [2108, 0];
		} else {
			lbSetCurSel [2108, 1];
		};		
	} else {
		lbSetCurSel [2108, 1];
		ctrlEnable [2108, false];
	};
};
/*
r3_addPsettingsAction = {
	player addAction ["<img image='R34P3R\img\settings32.paa'/> <t color='#ff9b00'>Settings</t>", {call pSettings_open_dialog}, [], -10, false, true, "", "alive player && !visibleMap"];
};

player addEventHandler ["Respawn", { [] call r3_addPsettingsAction }];
[] call r3_addPsettingsAction;
*/



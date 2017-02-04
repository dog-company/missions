/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
if (isDedicated) exitWith {};
waitUntil {!isNull player};

// Noted
call compile preprocessFileLineNumbers "R34P3R\r3_briefing.sqf";

// functions
call compile preprocessFileLineNumbers "R34P3R\r3_settings.sqf";
call compile preprocessFileLineNumbers "R34P3R\fnc\r3_functions.sqf";

// get and set Loadout by: aeroson
//getLoadout = compile preprocessFileLineNumbers 'R34P3R\3rdparty\get_loadout.sqf';
//setLoadout = compile preprocessFileLineNumbers 'R34P3R\3rdparty\set_loadout.sqf';

// Player Settings
call compile preprocessFileLineNumbers "R34P3R\psettings\pSettings.sqf"; 
//[] call pSettings_loadSettings;

if(r3_enableDebugMode) then { diag_log "LOADING CLIENT INIT"; };

// KeyEvents
//waitUntil {!(isNull (findDisplay 46))};
//(findDisplay 46) displaySetEventHandler ["KeyDown", "_this call onKeyPress"];

// Loading Overlay for Clients to wait until server is ready
r3_LoadingOverlay = {

	r3_loadingTxt = "Loading...";
	
	while{isNil "r3_serverFullLoaded"} do {
		1066 cutText[format["Please wait... initialising R34P3R's Framework. ( %1 )", r3_loadingTxt],"BLACK FADED",0];
		sleep 0.05;
	};
	1066 cutFadeOut 1;
};

// Check DayTime
if(isNil "r3_isNight") then {

	if(daytime > r3_nightStart OR (daytime > 0 && daytime < r3_dayStart)) then {
		r3_isNight = true;
	} else {
		r3_isNight = false;
	};
	
	[] spawn {
		while {true} do {
			sleep 5;
			if(daytime > r3_nightStart OR (daytime > 0 && daytime < r3_dayStart)) then {
				r3_isNight = true; 
			} else {
				r3_isNight = false;
			};
		};
	};
};

// Revive script
if(r3_enableReviveScript) then { 
	call compile preprocessFileLineNumbers "R34P3R\revive\r3_init_revive.sqf"; 
};

// Respawn functions
if(r3_enableRespawnSelection) then {
	call compile preprocessFileLineNumbers "R34P3R\respawn\r3_playerRespawn.sqf";
	player addEventHandler ["Respawn", { [] call r3_respawnShowDialog } ];
};

// Inventory open
r3_invOpened = {
	r3_invIsOpen = true;
	
	// Mount animations
	[] spawn {
		if(vehicle player == player) then {
			waitUntil { !(isNull (findDisplay 602)) };
			((findDisplay 602) displayCtrl 621) ctrlAddEventHandler ["mouseButtonDown", { player switchMove "DismountOptic";} ];
			waitUntil { !(isNull (findDisplay 602)) };
			((findDisplay 602) displayCtrl 622) ctrlAddEventHandler ["mouseButtonDown", { player switchMove "DismountSide";} ];
		};
	};
	
	// Restriced uniforms
	/*[] spawn {
		while{r3_invIsOpen} do {
			_uniform = uniform player;
			if!(player isUniformAllowed _uniform) then {
				removeUniform player;
				hint "Sorry but this uniform is not allowed. please choose another one.";
			};
			sleep 1;
		};
	};*/
};

// Inventory close
r3_invClosed = {
	r3_invIsOpen = false;
};

// Inventory Events
player addEventHandler ["inventoryOpened", { [] spawn r3_invOpened } ];
player addEventHandler ["inventoryClosed", { [] spawn r3_invClosed } ];

// Init Vehicle respawn and repair
if(r3_enableVehicleRespawn) then { 
	call compile preprocessFileLineNumbers "R34P3R\veh\r3_fnc_veh_client.sqf";
	
	player addEventHandler ["Respawn", { [] call r3_veh_AddPlayerAction } ];
	[] call r3_veh_AddPlayerAction;
	
	if(isMultiplayer && !isServer) then { 
		call compile preprocessFileLineNumbers "R34P3R\veh\r3_init_veh.sqf";
		[] call r3_load_vehicles; 
	};
};

// FullScreen NVG
if(isNil "r3_nvg_on") then {r3_nvg_on = false};

r3_addNVGaction = {
	player addAction ["<img image='R34P3R\img\fsnvg32.paa'/> <t color='#66ff00'>Switch NV mode</t>", {if(r3_cur_nvMode == 1) then {r3_cur_nvMode = 2} else {r3_cur_nvMode = 1}; [3] call r3_apply_colorCorrection;}, [], -1, false, true, "", "alive player && r3_nvg_on"];
};

if(r3_allowFSNVG) then {
	
	r3_cur_nvMode = 1;
	player addEventHandler ["Respawn", { [] call r3_addNVGaction }];
	[] call r3_addNVGaction;
	
	if(isNil "r3_enableFSNVG") then {r3_enableFSNVG = true};
};

onKeyPress = {
	_key = _this select 1;
	_handled = false;
	
	if(_key in (actionKeys "nightVision")) then {
		if(r3_enableFSNVG) then {
			if(("NVGoggles" in (assignedItems player)) OR ("NVGoggles_OPFOR" in (assignedItems player)) OR ("NVGoggles_INDEP" in (assignedItems player))) then {
				if(r3_nvg_on) then {
					if(r3_enableColorCorrection) then {
						if(r3_isNight) then {
							[2,1] call r3_apply_colorCorrection;
						} else {
							[1,1] call r3_apply_colorCorrection;
						};
					} else {
						[0,1] call r3_apply_colorCorrection;
					};
					_handled = true;				
				} else {
					[3] call r3_apply_colorCorrection;
					_handled = true;
				};
			};
		};
	};
	
	if(_key in (actionKeys "GetOver")) then {
	
		if(isNil {r3_pIsJumping}) then {r3_pIsJumping = false};
		
		if(currentWeapon player == primaryWeapon player && currentWeapon player != "") then {
			if((vehicle player) == player && (speed player) > 11 && stance player == "STAND" && getFatigue player < 0.5 && isTouchingGround player && !r3_pIsJumping) then {
			
				r3_pIsJumping = true;
				
				[] spawn {
					_v = velocity player;
					_veloH = [(_v select 0) +0.6, (_v select 1) +0.6, (_v select 2) +0.1];
					_veloL = [(_v select 0), (_v select 1), (_v select 2) -1];
					_maxHight = (getPosATL player select 2) +1.3;
					
					[[player,"AovrPercMrunSrasWrflDf"],"switchMoveMP"] call BIS_fnc_MP;
					sleep 0.05;
					while {animationState player == "AovrPercMrunSrasWrflDf"} do {
						if((getPosATL player select 2) > _maxHight) then {
							player setVelocity _veloL;
						} else {
							player setVelocity _veloH;
						};
						sleep 0.05;
					};
					
					sleep 1;
					
					r3_pIsJumping = false;
				};
				_handled = true;
			};
		};
	};	
	_handled
};

r3_apply_colorCorrection = {
	_mode = [_this, 0, 0] call BIS_fnc_param; // 0 = OFF, 1 = DAY, 2 = NIGHT, 3 = NVG
	_speed = [_this, 1, 0] call BIS_fnc_param;
	
	switch(_mode) do {
		case 0: {
			r3_nvg_on = false;
			r3_currentDayState = "";
			"colorCorrections" ppEffectEnable false;	
		};
		case 1: {
			r3_nvg_on = false;
			r3_currentDayState = "day";
			// "colorCorrections" ppEffectAdjust [1, 1.05, -0.02, [0.0, 0.0, 0.0, 0.0], [1.2, 1.5, 1.5, 0.85], [0.199, 0.587, 0.114, 0.20]]; - OLD TN-PANEL
			"colorCorrections" ppEffectAdjust [1, 1.15, -0.06, [0.0, 0.0, 0.0, 0.0], [1.1, 1.5, 1.2, 0.9], [0.199, 0.587, 0.114, 0.20]];
			"colorCorrections" ppEffectCommit _speed;
			"colorCorrections" ppEffectEnable true;	
		};
		case 2: {
			r3_nvg_on = false;
			r3_currentDayState = "night";
			"colorCorrections" ppEffectAdjust [1, 0.8, -0.01, [0.0, 0.0, 0.0, 0.0], [1.2, 1.5, 1.5, 0.6], [0.199, 0.587, 0.114, 0.20]];
			"colorCorrections" ppEffectCommit _speed;
			"colorCorrections" ppEffectEnable true;
		};
		case 3: {
			r3_nvg_on = true;
			if(r3_cur_nvMode == 1) then {
				"colorCorrections" ppEffectAdjust [1, 0.8, 0, [1, 1, 1.2, 0.1], [1, 3.8, 1.1, 0.8], [3, 0.5, 1.5, 1]];
			} else {
				"colorCorrections" ppEffectAdjust [1.02, 0.8, 0, [1, 1, 1.2, 0.1], [1, 3.8, 1, 0.5], [2, 1.8, 1.8, 1]];		
			};
			"colorCorrections" ppEffectCommit _speed;
			"colorCorrections" ppEffectEnable true;
		};
	};
};

// ColorCorrection
if(r3_allowColorCorrection OR r3_allowFSNVG) then {

	if(isNil "r3_enableColorCorrection") then {r3_enableColorCorrection = true};
	r3_currentDayState = "";
	
	[] spawn {
		while {true} do {
			if(r3_nvg_on) then {
				if((positionCameraToWorld [0,0,0] distance player) > 5) then {
					if(r3_isNight) then {
						[2,0] call r3_apply_colorCorrection;
					} else {
						[1,0] call r3_apply_colorCorrection;
					};
					waitUntil{sleep 0.5; (positionCameraToWorld [0,0,0] distance player) < 5};
					[3,0] call r3_apply_colorCorrection;
				};
			} else {
				if(r3_allowColorCorrection) then {
					if(r3_enableColorCorrection) then {
						if(r3_isNight) then {
							if(r3_currentDayState == "day" OR r3_currentDayState == "") then { [2,5] call r3_apply_colorCorrection };
						} else {
							if(r3_currentDayState == "night" OR r3_currentDayState == "") then { [1,5] call r3_apply_colorCorrection };
						};
					};
				};
			};
			sleep 1;
		};
	};
};
/*
// Save Loadout for Respawn
if(r3_savePlayerLoadoutForRespawn) then {
	[] spawn {
		while {true} do {
			if(alive player) then {
				respawnLoadout = [player,["ammo"]] call getLoadout;
			};
			sleep 5;  
		};
	};
	player addEventHandler ["Respawn", { [player, respawnLoadout,["ammo"]] spawn setLoadout; } ];
};
*/
// Autoheal
if(r3_allowAutoHeal) then {
	if(isNil "r3_enableAutoHeal") then {r3_enableAutoHeal = true};
	call compile preprocessFileLineNumbers "R34P3R\fnc\r3_autoHeal.sqf";
};

// SlowFatigue
if(r3_allowStaminaScript) then {
	if(isNil "r3_enableStaminaScript") then {r3_enableStaminaScript = true};
	call compile preprocessFileLineNumbers "R34P3R\fnc\r3_stamina.sqf";
};

// Weather client
if(r3_enableWeatherScript) then { 
	call compile preprocessFileLineNumbers "R34P3R\weather\r3_weather_client.sqf";
	[] spawn r3_weatherCycle_client;
};
	
// Earplugs on vehicles
if(r3_enableEarPlugsOnVehicles) then {

	r3_earPlugsInUse = false;
	
	r3_earPlugAction =
	{
		private ["_putEarOn", "_takeEarOff"];
		
		r3_earPlugsInUse = false;
		1 fadeSound 1;
		
		_putEarOn = ["<t color='#ffff33'>Put on ear plugs</t>",{1 fadeSound 0.4; r3_earPlugsInUse = true;},[],-90,false,true,"","player != vehicle player && !r3_earPlugsInUse"];
		_takeEarOff = ["<t color='#ffff33'>Take off ear plugs</t>",{1 fadeSound 1; r3_earPlugsInUse = false;},[],-90,false,true,"","_target == vehicle player && r3_earPlugsInUse"];
		player addAction _putEarOn;
		player addAction _takeEarOff;
	};
	
	[] spawn r3_earPlugAction;
	player addEventHandler ["Respawn",{ [] spawn r3_earPlugAction; }];
};

// Select Leader
if(r3_autoSelectLeader) then {
	[] spawn {

		waitUntil{sleep 5; !isNil {r3_serverFullLoaded}};
		
		if(!isMultiplayer) then {
			if((leader player) != player) then {
				(group player) selectLeader player;
				systemChat "It seems like you playing alone. I will set you as group leader.";
			};
		} else {
			if({isPlayer _x} count playableUnits == 1) then {
				if(player != leader player) then {
					(group player) selectLeader player;
					player addEventHandler ["Respawn", { (group player) selectLeader player; } ];
					systemChat "It seems like you playing alone. I will set you as group leader.";
				};
			};
		};
	};
};

// Stamina Bar
if(r3_allowStaminaBar) then {
	if(isNil "fn_st_stamina_bar_launch") then {
		if(isNil "r3_showStaminaBar") then {r3_showStaminaBar = true};
		call compile preprocessFileLineNumbers "R34P3R\3rdparty\shacktac_stamina.sqf";
	} else {
		r3_allowStaminaBar = false;
	};
};

// Show PlayerNames and Health
if(r3_allowSpecialIcons) then {
	
	if(isNil "r3_showNames") then {r3_showNames = true};
	if(isNil "r3_showTaskIcon") then {r3_showTaskIcon = true};
	
	addMissionEventHandler ["Draw3D", {
		{
			if(_x != player) then {
				if(alive _x) then {
					if((player distance _x) < r3_SpecialIconsMaxDistance) then {
				
						_pPos = [(getPosATL _x select 0), (getPosATL _x select 1), (getPosATL _x select 2) +2.2];
						_pHealth = 100 - round((damage _x) * 100);
						_pDraw = format ["%1 (%2)", name _x, _pHealth];
						
						if(r3_enableReviveScript) then {
							if(_x getVariable ["r3_unitIsDown",0] == 0) then { 
								if(vehicle player == player && r3_showNames) then { drawIcon3D ["",[1,1,1,0.5], _pPos, 0, 0, 0, _pDraw, 1, 0.028, "PuristaMedium"]; };
							} else {
								if(_x getVariable ["r3_unitIsStabi",0] == 1) then {
									drawIcon3D [r3_missionPath + "R34P3R\img\medic64.paa",[1,1,1,1], getPosATL _x, 1, 1, 0, name _x, 1, 0.028, "PuristaMedium"]; 
								} else {
									_unitBleedOut = _x getVariable ["r3_unitbleedOut", 0];
									if(_unitBleedOut != 0) then { 
										_pDraw = format ["%1 (%2)", name _x, _unitBleedOut];
										drawIcon3D [r3_missionPath + "R34P3R\img\bleed64.paa",[1,1,1,1], getPosATL _x, 1, 1, 0, _pDraw, 1, 0.028, "PuristaMedium"];
									} else {
										drawIcon3D [r3_missionPath + "R34P3R\img\bleed64.paa",[1,1,1,1], getPosATL _x, 1, 1, 0, name _x, 1, 0.028, "PuristaMedium"]; 
									};
								};	
							};
						} else {
							if(vehicle player == player && r3_showNames) then { drawIcon3D ["",[1,1,1,0.5], _pPos, 0, 0, 0, _pDraw, 1, 0.028, "PuristaMedium"]; };
						};
					};
				};	
			};
		} forEach units group player;
		
		if(r3_showTaskIcon) then {
			if(!isNull currentTask player) then {
				_tPos = [];
				_tCur = [player] call BIS_fnc_taskCurrent;
				_tPos = [_tCur] call BIS_fnc_taskDestination;
				if!([_tCur] call BIS_fnc_taskCompleted) then {
					switch(count _tPos) do {
						case 2: {
							_tObj = _tPos select 0;
							if(!isNull _tObj) then {
								_tPos = [(getPosATL _tObj select 0), (getPosATL _tObj select 1), (getPosATL _tObj select 2) +1.8];
								drawIcon3D [r3_missionPath + "R34P3R\img\taskdest.paa",[1,1,1,0.7], _tPos, 1, 1, 0]; 					
							};
						};
						case 3: {
							_tPos = [(_tPos select 0),(_tPos select 1),(_tPos select 2) +1.85];
							drawIcon3D [r3_missionPath + "R34P3R\img\taskdest.paa",[1,1,1,0.7], _tPos, 1, 1, 0];
						};				
					};
				};
			};
		};
	}];
};

//Move JIP
if(r3_moveJIPtoLeader) then {
	if(leader player != player) then {
		
		[] spawn {
			waitUntil{sleep 2; !isNil {r3_serverFullLoaded}};
			
			_leader = leader player;
			_moveTime = time + r3_moveJIPafterSec;
			
			if((player distance _leader) > r3_moveJIPdistance) then {
			
				while{time < _moveTime && alive player} do {
					hintSilent format ["Mission already started. You will be moved to your group leader (%1)",(_moveTime - time)];
					sleep 1;
				};
				
				if(alive player) then {
					if((vehicle _leader) != _leader) then {
						if(((vehicle _leader) emptyPositions "cargo") > 0 OR ((vehicle _leader) emptyPositions "gunner") > 0 OR ((vehicle _leader) emptyPositions "driver") > 0) then {
							player moveInAny (vehicle _leader);
						} else {
							_newPos = (getPos _leader) findEmptyPosition [3,20,"B_Soldier_F"];
							if(count _newPos > 0) then { player setPos _newPos; };
						};
					} else {
						_newPos = (getPos _leader) findEmptyPosition [3,20,"B_Soldier_F"];

						if(count _newPos > 0) then {
							player setPos _newPos;
						} else {
							player setPos (getPos _leader);
						};
					};
				};
			};
		};
		
	};
};


r3_initClientDone = true;

if(r3_enableDebugMode) then { diag_log "LOADING CLIENT INIT (DONE)"; };
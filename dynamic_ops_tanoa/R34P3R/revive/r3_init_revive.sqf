/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
if(!isNull player) then {

	call compile preprocessFile "R34P3R\revive\r3_fnc_revive_client.sqf";
	call compile preprocessFile "R34P3R\revive\r3_fnc_revive_server.sqf";

	//////// INIT AI UNITS /////////

	r3_initAiUnits = 
	{
		private ["_unit","_oldUnit"];
		
		_unit = [_this, 0, objNull] call BIS_fnc_param;
		_oldUnit = [_this, 1, objNull] call BIS_fnc_param;
		_fakeplayer = _unit getVariable ["r3_unitFakePlayer", objNull];
		
		if(!isNull _oldUnit) then {
			deleteVehicle _oldUnit; 
			if(r3_enableDebugMode) then { diag_log format ["DELETING OLD AI-UNIT: %1",_oldUnit]; };
		};
		
		if(!isNull _fakeplayer) then {
			deleteVehicle _fakeplayer; 
			if(r3_enableDebugMode) then { diag_log format ["DELETING FAKE AI-UNIT: %1",_fakeplayer]; };
		};
		
		_unit setVariable ["r3_unitIsDown", 0, true];
		_unit setVariable ["r3_unitIsStabi", 0, true];
		_unit setVariable ["r3_unitFakePlayer", objNull, true];
		_unit setVariable ["r3_unitIsCalled", 0, true];
		_unit setVariable ["r3_unitGetRevive", 0, true];
		_unit setVariable ["r3_unitGetDrag", 0, true];	
		_unit setVariable ["r3_unitbleedOut", r3_reviveBleedOutTime, true];
		
		_unit enableAI "ANIM";
		_unit enableAI "MOVE";
		_unit enableAI "TARGET";
		_unit enableAI "AUTOTARGET";
				
		if(r3_enableDebugMode) then { diag_log format ["AI Unit respawned and Initialized: %1", _unit]; };
	};

	{
		if(!isPlayer _x && _x isKindOf "Man") then {
		
			waitUntil{alive _x};
			
			_x removeAllEventHandlers "HandleDamage";
			_x addEventHandler ["HandleDamage", { if(local (_this select 0)) then {_this call r3_unitHandleDamage_AI;} }];
			_x addEventHandler ["Respawn", { if(local (_this select 0)) then {_this call r3_initAiUnits;} }];
			
			// Unit Vars
			_x setVariable ["r3_unitIsDown", 0];
			_x setVariable ["r3_unitIsStabi", 0];
			_x setVariable ["r3_unitFakePlayer", objNull];
			_x setVariable ["r3_unitIsCalled", 0];
			_x setVariable ["r3_unitGetRevive", 0];
			_x setVariable ["r3_unitGetDrag", 0];	
			_x setVariable ["r3_unitbleedOut", r3_reviveBleedOutTime];	
			
			if(r3_enableDebugMode) then { diag_log format ["Revive Init for AI-Unit: %1 DONE, AI is Local = %2", _x, (local _x)]; };
		};
	} forEach units group player;


	///////// INIT PLAYER ///////////

	r3_initPlayer =
	{
		_oldUnit = [_this, 1, objNull] call BIS_fnc_param;
		_fakeplayer = player getVariable ["r3_unitFakePlayer", objNull];
		
		if(!isNull _oldUnit) then {
			deleteVehicle _oldUnit; 
			if(r3_enableDebugMode) then { diag_log format ["DELETING OLD PLAYER-UNIT: %1",_oldUnit]; };
		};
		
		if(!isNull _fakeplayer) then {
			deleteVehicle _fakeplayer; 
			if(r3_enableDebugMode) then { diag_log format ["DELETING FAKE PLAYER-UNIT: %1",_fakeplayer]; };
		};
		
		player removeAllEventHandlers "HandleDamage";
		player addEventHandler ["HandleDamage", { if(local (_this select 0)) then {_this call r3_unitHandleDamage_EH;} }];
		
		// Unit Vars
		player setVariable ["r3_unitIsDown", 0, true];
		player setVariable ["r3_unitIsStabi", 0, true];
		player setVariable ["r3_unitFakePlayer", objNull, true];
		player setVariable ["r3_unitPrivateMedic", objNull, true];
		player setVariable ["r3_unitGetRevive", 0, true];
		player setVariable ["r3_unitGetDrag", 0, true];
		player setVariable ["r3_unitbleedOut", r3_reviveBleedOutTime, true];
			
		player addAction ["<img image='R34P3R\img\medic32.paa'/> <t color='#C90000'>Revive</t>", "[] call r3_handleRevive", [false], 10, true, true, "", "call r3_checkRevive"];
		player addAction ["<img image='R34P3R\img\bleed32.paa'/> <t color='#C90000'>Stabilize</t>", "[] call r3_handleStabi", [false], 9, true, true, "", "call r3_checkStabi"];
		player addAction ["<img image='R34P3R\img\drag32.paa'/> <t color='#C90000'>Drag</t>", "[] call r3_handleDrag", [false], 8, true, true, "", "call r3_checkDrag"];
	};

	// EventHandlers
	addMissionEventHandler ["Ended",{ if(!isNull (findDisplay 33991)) then {closeDialog 33991}; }];
	player addEventHandler ["Respawn", { _this call r3_initPlayer; }];
	[] spawn r3_initPlayer;

};


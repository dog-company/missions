/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(!isNull player) then {

	r3_nearAiMedic = objNull;
	r3_playerIsDragging = 0;

	r3_revCam = objNull;
	r3_revCamInt = 1;
	r3_revCamPos1 = [];
	
	r3_changeRevCamPos =
	{
		_way = [_this, 0, 1] call BIS_fnc_param;

		if(!isNull r3_revCam) then {
			if((count r3_revCamPos1) > 0) then {
				if(_way == 1) then {
					switch(r3_revCamInt) do {
						case 1: {r3_revCamInt = 2};
						case 2: {r3_revCamInt = 3};
						case 3: {r3_revCamInt = 4};
						case 4: {r3_revCamInt = 5};
						case 5: {r3_revCamInt = 1};
					};
				} else {
					switch(r3_revCamInt) do {
						case 1: {r3_revCamInt = 5};
						case 2: {r3_revCamInt = 1};
						case 3: {r3_revCamInt = 2};
						case 4: {r3_revCamInt = 3};
						case 5: {r3_revCamInt = 4};
					};		
				};
				
				r3_revCamPos1 = [(getPosATL player select 0) -2, (getPosATL player select 1) +2, 5];
				r3_revCamPos2 = [(getPosATL player select 0) -1, (getPosATL player select 1) +1, 3];
				r3_revCamPos3 = [(getPosATL player select 0) +1, (getPosATL player select 1) -2, 8];	
				r3_revCamPos4 = [(getPosATL player select 0) +5, (getPosATL player select 1) +3, 1];
				r3_revCamPos5 = [(getPosATL player select 0) -6, (getPosATL player select 1) -3, 2];				
				
				switch(r3_revCamInt) do {
					case 1: {r3_revCam camSetPos r3_revCamPos1};
					case 2: {r3_revCam camSetPos r3_revCamPos2};
					case 3: {r3_revCam camSetPos r3_revCamPos3};
					case 4: {r3_revCam camSetPos r3_revCamPos4};
					case 5: {r3_revCam camSetPos r3_revCamPos5};
				};
				
				r3_revCam camSetTarget player;
				r3_revCam camCommit 2;
			};
		};
	};

	
	r3_unitHandleDamage_EH = 
	{
		private ["_unit", "_killer", "_selection", "_handleDamage", "_killer", "_unitIsDown"];
		
		_unit = param[0];
		_selection = param[1,""];
		_handleDamage = param[2,0];
		_killer = param[3,objNull];
		_unitIsDown = _unit getVariable ["r3_unitIsDown",1];

		if(local _unit) then {
				
			if(alive _unit && _selection == "" && _handleDamage >= 0.9 && _unitIsDown == 0) then {

				_unit setVariable ["r3_unitIsDown", 1, true];
				_unit setVariable ["r3_unitIsStabi", 0, true];
				
				_unit allowDamage false;
				_unit setDamage 0.9;
				_unit setCaptive true;
				
				if(vehicle _unit != _unit) then {moveOut _unit};
				
				//player switchCamera "External";
				
				[] spawn r3_spawnFakeUnit;
				
				if(r3_enableDebugMode) then { diag_log format ["Revive unit is down: %1", _unit]; };
				
				_handleDamage = 0;
			};
		};
		
		if(_handleDamage >= 1) then {_handleDamage = 0.85};
		
		_handleDamage
	};

	r3_unconscious_player =
	{	
		_fakePlayer = _this select 0;
		_bleedOut = time + r3_reviveBleedOutTime;
		
		// Disable Radio
		enableSentences false;
		showCinemaBorder true;

		[] spawn {
			while {alive player && player getVariable ["r3_unitIsDown",0] == 1} do {
				playSound "heardbeat";
				sleep 1.87;
			};
		};
		
		1010 cutText ["", "BLACK OUT", 2];
		sleep 2;
		1010 cutText ["You are bleeding...", "BLACK FADED"];
		
		waitUntil{sleep 1; (velocity _fakePlayer select 2) == 0 OR isTouchingGround _fakePlayer};
		player setPosATL [(getPosATL _fakePlayer select 0),(getPosATL _fakePlayer select 1),(getPosATL _fakePlayer select 2) + 0.1];

		r3_revCamInt = 1;
		r3_revCamPos1 = [(getPosATL player select 0) -2, (getPosATL player select 1) +2, 5];	
		
		r3_revCam = "camera" camCreate r3_revCamPos1; 
		if(r3_isNight) then {camUseNVG true} else {camUseNVG false};
		r3_revCam cameraEffect ["internal", "BACK"]; 
		r3_revCam camSetTarget player;
		r3_revCam camCommit 2;
		
		1010 cutFadeOut 2;
		
		_handle = createDialog "Revive_dialog";
		waitUntil {sleep 0.01; (!(isNull (findDisplay 33991)))};
		_noesckey = (findDisplay 33991) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"]; 
		
		while {alive player && player getVariable ["r3_unitIsDown",0] == 1 && player getVariable "r3_unitIsStabi" == 0 && time < _bleedOut } do {
			_txt = format ["<t size='0.6' font='PuristaLight'>Bleedout in %1 seconds, %2</t>", round (_bleedOut - time), call r3_checkNearUnits];
			[_txt, 0, safeZoneY + safeZoneH -0.15, 2, 0, 0, 9000] spawn BIS_fnc_dynamicText;
			player setVariable ["r3_unitbleedOut",round(_bleedOut - time), true];
			sleep 1;
		};
		
		if(alive player && player getVariable "r3_unitIsStabi" == 1) then {		
			while {alive player && player getVariable ["r3_unitIsDown",0] == 1 } do {
				_txt = format ["<t size='0.6' font='PuristaLight'>You have been stabilized ! %1</t>", call r3_checkNearUnits];
				[_txt, 0, safeZoneY + safeZoneH -0.15, 2, 0, 0, 9000] spawn BIS_fnc_dynamicText;
				sleep 1;
			};
		};
		
		if (time > _bleedOut && player getVariable ["r3_unitIsStabi",0] == 0 && player getVariable ["r3_unitIsDown",0] == 1) then {
			{player removeWeaponGlobal _x} forEach weapons player;
			sleep 0.1;
			player allowDamage true;
			player setCaptive false;
			player setDamage 1; 
		};	
		
		//Close Dialog and enable ESC Button
		(findDisplay 33991) displayRemoveEventHandler ["KeyDown", _noesckey];
		closeDialog 33991;
		
		// Destroy Cam
		r3_revCam cameraEffect ["terminate","back"]; 
		camDestroy r3_revCam;
		cutText ["","PLAIN DOWN"];
		enableSentences true;

		if(alive player) then {
			if(!isNull _fakePlayer) then {deleteVehicle _fakePlayer};
			[[player, false], "hideObjectMP" ] call BIS_fnc_MP;
			player setDamage ( random 0.19);
			player playMoveNow "AmovPpneMstpSrasWrflDnon";
			sleep 3;
			player setCaptive false;
			player allowDamage true;
			player setVariable ["r3_unitbleedOut", r3_reviveBleedOutTime, true];
		};
	};

	r3_createBlood = 
	{
		if(!isNull player) then {
		
			private ["_unit","_fakePlayer","_ran_x","_bodyPos","_source","_mylogic","_blood"];
			
			_unit = _this select 0;
			_fakePlayer = _this select 1;
			
			if(r3_reviveEnableBloodParticle && !isNull _unit && !isNull _fakePlayer) then {
			
				sleep 3;
				
				_ran_x = (0.2 - random 0.35);
				_ran_y = 0 - (random 0.4);
				_bodyPos = [_ran_x,_ran_y,0.25];
				
				_source = "logic" createVehicleLocal (getPos _fakePlayer);
				if (vehicle _fakePlayer == _fakePlayer) then {_source attachTo [_fakePlayer,_bodyPos,"body"]};	
				_blood = "#particlesource" createVehicleLocal (getPos _source);
				_blood setParticleParams [["\a3\Data_f\ParticleEffects\Universal\Universal", 16, 13, 1],"","Billboard",0.6,0.1,[0,0,0.01],[(0.3 - (random 0.6)),(0.3 - (random 0.6)),(0.1 + (random 0.3))],1,0.32,0.2,0.05,[0.055,0.25],[[0.2,0.01,0.01,1],[0.2,0.01,0.01,0]],[0.1],1,0.04,"","",_source];
				_blood setParticleRandom [2, [0, 0, 0], [0.0, 0.0, 0.0], 0, 0.5, [0, 0, 0, 0.1], 0, 0, 10];
				_blood setDropInterval 0.04;
				
				[_blood,_source,_unit] spawn {
				
					private ["_source","_blood","_fakePlayer"];
					
					_blood = _this select 0;
					_source = _this select 1;
					_unit = _this select 2;
					
					waitUntil {sleep 0.5; !alive _unit OR (_unit getVariable ["r3_unitIsDown",0] == 0) OR (_unit getVariable ["r3_unitIsStabi",1] == 1) OR (_unit getVariable ["r3_unitGetDrag",1] == 1)};
					deleteVehicle _blood;
					deleteVehicle _source;
				};
			};
		};
	};

	r3_createMedicSound =
	{
		if(!isNull player) then {
		
			private ["_unit","_rndMedicSound","_rndManDownSound"];
			
			_unit = _this select 0;
				
			if(r3_reviveEnableVoices) then {
			
				_rndMedicSound = floor(random 4);
				switch(_rndMedicSound) do {
					case 0: {_unit say3D "callForMedic_1"; };
					case 1: {_unit say3D "callForMedic_2"; };
					case 2: {_unit say3D "callForMedic_3"; };
					case 3: {_unit say3D "callForMedic_4"; };
				};
				
				{
					if( alive player && player getVariable "r3_unitIsDown" == 0) exitWith {
						_rndManDownSound = floor(random 3);
						switch(_rndManDownSound) do {
							case 0: {player say3D "ManDown_1"; };
							case 1: {player say3D "ManDown_2"; };
							case 2: {player say3D "ManDown_3"; };
						};
					};
				} forEach units group _unit;
			};
		};
	};

	r3_spawnFakeUnit =
	{	
		_newGrp = createGroup (side player);
		
		_fakePlayer = _newGrp createUnit ["b_survivor_F", getMarkerPos r3_reviveTempRespawnMarker, [], 0, "CAN_COLLIDE"];
		_fakePlayer disableCollisionWith player;
		_fakePlayer setFace (face player);
		_fakePlayer forceAddUniform (uniform player);
		removeGoggles _fakePlayer;
		removeHeadgear _fakePlayer;
		if(!isNil {vest player}) then {_fakePlayer addVest (vest player)};
		if(!isNil {headgear player}) then {_fakePlayer addHeadgear (headgear player)};
		if(!isNil {goggles _unit}) then {_fakePlayer addGoggles (goggles _unit)};
		if(!isNil {backpack player}) then {_fakePlayer addBackpackGlobal (backpack player)};
		
		_Items = assignedItems player;
		if(("NVGoggles" in _Items) OR ("NVGoggles_OPFOR" in _Items) OR ("NVGoggles_INDEP" in _Items)) then {
			_fakePlayer linkItem "NVGoggles";
		};
		
		_fakePlayer disableAI "ANIM";
		_fakePlayer disableAI "MOVE";
		_fakePlayer setVariable ["r3_originalUnit", player, true];
		_fakePlayer setDir (getDir player);
		
		switch (stance player) do {
			case "STAND": { [[_fakePlayer, "AmovPercMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "CROUCH": { [[_fakePlayer, "AmovPknlMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "PRONE": { [[_fakePlayer, "AmovPpneMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "UNDEFINED": { [[_fakePlayer, "AmovPknlMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
		};	
	
		[[player, true], "hideObjectMP" ] call BIS_fnc_MP;
		sleep 0.05;
		_fakePlayer setPosATL (getPosATL player);
		_fakePlayer setDamage 1;
		_fakePlayer setVelocity [0,0,-1];
		
		player setVelocity [0,0,-1];
		player setVariable ["r3_unitFakePlayer", _fakePlayer, true];
		[[player, "AinjPpneMstpSnonWrflDnon"], "switchMoveMP"] call BIS_fnc_MP;
		
		sleep 2;
		
		[_fakePlayer] spawn r3_unconscious_player;
		
		[[player,_fakePlayer], "r3_createBlood"] spawn BIS_fnc_MP;
		
		[player] spawn r3_createMedicSound;
	};

	r3_reviveEqiup =
	{
		private ["_healer","_injured","_allItems"];
		
		_healer = _this select 0;
		_injured = _this select 1;
		_allItems = [];
		
		if(local _healer) then {

			_defi_pos = _healer modelToWorld [-0.5,0.2,0];
			_defi = "Land_Defibrillator_F" createVehicle _defi_pos;
			_defi setPos _defi_pos;
			_defi setDir (getDir _healer - 180);
			_allItems = _allItems + [_defi];
			
			sleep (random 3);
			
			_bb_pos = _healer modelToWorld [0.4,(0.2 - (random 0.5)),0];
			_bb = "Land_BloodBag_F" createVehicle _bb_pos;
			_bb setPos _bb_pos;
			_bb setDir (random 359);
			_allItems = _allItems + [_bb];

			sleep (random 3);
			
			if (random 2 >= 1) then {
				_ab_pos = _healer modelToWorld [-0.8,(0.6 - (random 0.4)),0];
				_ab = "Land_Antibiotic_F" createVehicle _ab_pos;
				_ab setPos _ab_pos;
				_ab setDir (random 359);
				_allItems = _allItems + [_ab];
			};
			
			sleep (random 2);

			for "_i" from 1 to (1 + (round random 3)) do {
				_band_pos = _healer modelToWorld [(random 1.3),(0.8 + (random 0.6)),0];
				_band = "Land_Bandage_F" createVehicle _band_pos;
				_band setPos _band_pos;
				_band setDir (random 359);
				sleep (random 0.6);
				_allItems = _allItems + [_band];
			};
			
			[_allItems] spawn {
				private ["_allItems"];
				_allItems = _this select 0;
				
				if(!isNil "r3_reviveCancelt") then {
					if(!r3_reviveCancelt) then { sleep (r3_reviveHealTime + 10) + (random 20); };
				};
				
				{
					deleteVehicle _x;
					sleep random 2;
				}forEach _allItems;
			};
		};
	};

	r3_handleRevive = 
	{
		private ["_target","_originalTarget","_animDelay","_reviveTime"];

		_target = cursorTarget;
		
		if(!isNull _target && r3_playerIsDragging == 0) then {
		
			_originalTarget = _target getVariable ["r3_originalUnit",_target];
			
			if(!isNull(_originalTarget) && alive _originalTarget) then {
				
				_originalTarget setVariable ["r3_unitGetRevive", 1, true];
				
				if(primaryWeapon player != "") then {
					if(currentWeapon player != primaryWeapon player) then {
						player selectWeapon primaryWeapon player;
						sleep 2;
					};
				};
				
				player playActionNow "medicStart";
				_reviveTime = time + r3_reviveHealTime;
				r3_reviveCancelt = false;
				
				[player, _target] spawn r3_reviveEqiup;
				
				while{time < _reviveTime && !r3_reviveCancelt && alive player && player getVariable ["r3_unitIsDown",0] == 0 && alive _originalTarget && _originalTarget getVariable ["r3_unitIsDown",0] == 1} do {
					player playActionNow "medicStart";
					sleep 1;
					if((speed player) > 1 OR (speed player) < -1) exitWith { r3_reviveCancelt = true; };
				};

				if(r3_reviveCancelt) then {
					player playActionNow "Stop";
					cutText ["REVIVE CANCELT !","PLAIN DOWN"];
					_originalTarget setVariable ["r3_unitGetRevive", 0, true];
				};
				
				if(alive player && player getVariable ["r3_unitIsDown",0] == 0 && !r3_reviveCancelt && alive _originalTarget && _originalTarget getVariable ["r3_unitIsDown",0] == 1) then {
					
					player playActionNow "medicStop";
					
					sleep 1;
					_originalTarget setVariable ["r3_unitIsDown", 0, true];
					_originalTarget setVariable ["r3_unitIsStabi", 0, true];
					_originalTarget setVariable ["r3_unitPrivateMedic", objNull, true];
					_originalTarget setVariable ["r3_unitGetRevive", 0, true];
					_originalTarget setVariable ["r3_originalUnit", objNull, true];
					
					if ("FirstAidKit" in (items player)) then {
						player removeItem "FirstAidKit";
					};
					
					if !("FirstAidKit" in (items player) OR "Medikit" in (items player)) then { 
					
						_noMoreMedKits = "<t color='#ff0000' size='1' shadow='1' shadowColor='#000000'>This was your last FirstAidKit ! No more revives possible.</t>";
						hint parseText (_noMoreMedKits);
						
						_rndNoMedLeftSound = floor(random 2);
						switch(_rndNoMedLeftSound) do {
							case 0: { [[player, "outOffFirstaid_1"], "say3DMP"] call BIS_fnc_MP; };
							case 1: { [[player, "outOffFirstaid_2"], "say3DMP"] call BIS_fnc_MP; };
						};		
					};
				};
			};
		};
	};

	r3_handleStabi = 
	{
		private ["_target", "_originalTarget"];
		
		_target = cursorTarget;
		_originalTarget = _target getVariable ["r3_originalUnit",_target];
		
		if (alive _originalTarget && r3_playerIsDragging == 0) then {
		
			if(primaryWeapon player != "") then {
				if(currentWeapon player != primaryWeapon player) then {
					player selectWeapon primaryWeapon player;
					sleep 2;
				};
			};
			
			player playActionNow "medicStart";
			_reviveTime = time + r3_reviveStabiTime;
			r3_stabiCancelt = false;
			
			while{time < _reviveTime && !r3_stabiCancelt && alive player && player getVariable ["r3_unitIsDown",0] == 0 && alive _originalTarget && _originalTarget getVariable ["r3_unitIsDown",0] == 1} do {
				player playActionNow "medicStart";
				sleep 1;
				if((speed player) > 1 OR (speed player) < -1) exitWith { r3_reviveCancelt = true; }; { r3_stabiCancelt = true; };
			};

			if(r3_stabiCancelt) then {
				cutText ["STABILIZATION CANCELT !","PLAIN DOWN"];
				player playAction "medicStop";
			};
			
			if(alive player && player getVariable ["r3_unitIsDown",0] == 0 && !r3_stabiCancelt && alive _originalTarget && _originalTarget getVariable ["r3_unitIsDown",0] == 1) then {
			
				player playAction "medicStop";
				
				_originalTarget setVariable ["r3_unitIsStabi", 1, true];
			};
		};
	};

	r3_handleDrag = 
	{
		_target = cursorTarget;
		_originalTarget = _target getVariable ["r3_originalUnit", objNull];
		
		if(!isNull _originalTarget) then {	
			if(alive _originalTarget && _target isKindOf "Man") then {
				
				if(currentWeapon player != primaryWeapon player) then {
					player selectWeapon primaryWeapon player;
					sleep 2;
				};
				
				r3_playerIsDragging = 1;
			
				_originalTarget setVariable ["r3_unitGetDrag", 1, true];
				_originalTarget setDamage 0;
				
				if(!alive _target) then {
					deleteVehicle _target;
					_originalTarget setVariable ["r3_unitFakePlayer", objNull, true];
					_originalTarget setVariable ["r3_originalUnit", _originalTarget, true];
				};
				
				[[_originalTarget, false], "hideObjectMP"] call BIS_fnc_MP;
				sleep 0.1;
				
				player playMoveNow "AcinPknlMstpSrasWrflDnon";
				_originalTarget attachTo [player, [0, 1.18, 0.08]];
				[[_originalTarget, 180], "setDirMP"] call BIS_fnc_MP;
				
				_releaseId = player addAction ["<img image='R34P3R\img\release32.paa'/> <t color='#C90000'>Release</t>", {r3_playerIsDragging = 0}, [], 10, true, true, "", "r3_playerIsDragging == 1"];

				//hintSilent parseText "<t color='#C90000'>Press 'C' if you can't move.</t>";
				
				[[_originalTarget, false], "enableSimMP"] call BIS_fnc_MP;
				[[_originalTarget, "AinjPpneMstpSnonWrflDb"], "switchMoveMP"] call BIS_fnc_MP;
				
				while {alive player && (player getVariable ["r3_unitIsDown",0] == 0) && alive _originalTarget && r3_playerIsDragging == 1} do {
					sleep 0.2;
				};
				
				[[_originalTarget, true], "enableSimMP"] call BIS_fnc_MP;
				
				if(alive player && (player getVariable ["r3_unitIsDown",0] == 0)) then { 
					player playMove "amovpknlmstpsraswrfldnon";
				};
				
				player removeAction _releaseId;
				r3_playerIsDragging = 0;
				
				detach _originalTarget;
				[[_originalTarget, "AinjPpneMstpSnonWrflDb_release"], "switchMoveMP"] call BIS_fnc_MP;
				_originalTarget setVariable ["r3_unitGetDrag", 0, true];
			};
		};
	};
	
	r3_checkRevive = 
	{
		_return = false;
		_target = cursorTarget;
		
		if(!isNull _target) then {
			if(r3_playerIsDragging == 0) then {
				
				_originalTarget = _target getVariable ["r3_originalUnit", objNull];

				if(!isNull(_originalTarget)) then {
				
					_r3_unitGetRevive = _originalTarget getVariable ["r3_unitGetRevive",0];
					_r3_unitIsDown = _originalTarget getVariable ["r3_unitIsDown",0];
					_r3_unitGetDrag = _originalTarget getVariable ["r3_unitGetDrag",1];
					
					if(alive _originalTarget && _r3_unitGetRevive == 0 && _r3_unitIsDown == 1 && _r3_unitGetDrag == 0) then {
						if((player distance _target) < 2) then {
							if("FirstAidKit" in (items player) OR "Medikit" in (items player)) then {
								_return = true;
							};
						};
					};
				};
			};
		};
		_return		
	};

	r3_checkStabi = 
	{
		_return = false;
		_target = cursorTarget;
		
		if(!isNull _target) then {
			if(r3_playerIsDragging == 0) then {
				
				_originalTarget = _target getVariable ["r3_originalUnit", objNull];

				if(!isNull(_originalTarget)) then {
				
					_r3_unitGetRevive = _originalTarget getVariable ["r3_unitGetRevive", 1];
					_r3_unitIsDown = _originalTarget getVariable ["r3_unitIsDown",0];
					_r3_unitIsStabi = _originalTarget getVariable ["r3_unitIsStabi",0];
					_r3_unitGetDrag = _originalTarget getVariable ["r3_unitGetDrag",1];
				
					if(alive _originalTarget && _r3_unitGetRevive == 0 && _r3_unitIsDown == 1 && _r3_unitIsStabi == 0 && _r3_unitGetDrag == 0) then {
						if((player distance _target) < 2) then {
							_return = true;
						};
					};
				};
			};
		};
		_return
	};

	r3_checkDrag = 
	{
		_return = false;
		_target = cursorTarget;
		
		if(!isNull _target) then {
			if(r3_playerIsDragging == 0) then {
				if(primaryWeapon player != "") then {
				
					_originalTarget = _target getVariable ["r3_originalUnit", objNull];
		
					if(!isNull(_originalTarget)) then {
					
						_r3_unitGetRevive = _originalTarget getVariable ["r3_unitGetRevive", 1];
						_r3_unitIsDown = _originalTarget getVariable ["r3_unitIsDown",0];
						_r3_unitGetDrag = _originalTarget getVariable ["r3_unitGetDrag",1];
						
						if(alive _originalTarget && _r3_unitGetRevive == 0 && _r3_unitIsDown == 1 && _r3_unitGetDrag == 0) then {
							if((player distance _target) < 2) then {
								_return = true;
							};
						};
					};
				};
			};
		};
		_return
	};
	
	r3_checkNearUnits =
	{
		private ["_outputMsg","_distance","_unitName","_nearUnit","_distanceAi","_unitNameAi","_nearUnitAi","_privateMedic","_privateMedicInUse"];

		_outputMsg = "";
		_distance = 250;
		_unitName = "";
		_nearUnit = objNull;

		_distanceAi = 200;
		_unitNameAi = "";
		_nearUnitAi = objNull;	
		
		_privateMedic = player getVariable ["r3_unitPrivateMedic", objNull];
		_privateMedicInUse = false;
		
		if(!isNull(_privateMedic)) then {
			if(alive _privateMedic && _privateMedic getVariable ["r3_unitIsDown",0] == 0) then {
				r3_nearAiMedic = _privateMedic;
				_distance = (player distance _privateMedic);
				_unitName = name _privateMedic;
				_nearUnit = _privateMedic;
				_privateMedicInUse = true;
			} else {
				_privateMedicInUse = false;
			};
		} else {
			_privateMedicInUse = false;
		};
		
		if(!_privateMedicInUse) then {
			{
				if(!isNull _x && _x != player) then {
					if(alive _x && _x getVariable ["r3_unitIsDown",1] == 0 && (vehicle _x) == _x) then {
						if( (_x distance player) < _distance) then {
							if( "FirstAidKit" in (items _x) OR "Medikit" in (items _x) ) then {
								if(isPlayer _x) then {
									_distance = (_x distance player);
									_unitName = name _x;
									_nearUnit = _x;
								} else {
									if(r3_reviveEnableAiRevive && _x getVariable ["r3_unitIsCalled",1] == 0) then {
										if((_x distance player) < _distanceAi) then {
											_distanceAi = (_x distance player);
											_unitNameAi = name _x;
											_nearUnitAi = _x;
										};
									};
								};
							};
						};
					};
				};
			} forEach units group player;
			
			if(!isNull(_nearUnitAi) && _unitNameAi != "" && r3_reviveEnableAiRevive) then {
				_distance = _distanceAi;
				_unitName = _unitNameAi;
				_nearUnit = _nearUnitAi;
				r3_nearAiMedic = _nearUnitAi; 
			};
		};

		if(!isNull(_nearUnit) && _unitName != "") then {
			_outputMsg = format["<br/>Nearby Medic: %1 is %2m away.", _unitName, floor(_distance)];
		} else {
			_outputMsg = "No medic nearby.";
		};
		
		_outputMsg
	};

	r3_playerSuicide = 
	{
		["", 0, safeZoneY + safeZoneH -0.15, 2, 0, 0, 9000] spawn BIS_fnc_dynamicText;
		player setVariable ["r3_unitIsDown", 0, true];
		player setVariable ["r3_unitIsStabi", 0, true];
		player setVariable ["r3_unitGetRevive", 0, true];
		player setVariable ["r3_unitPrivateMedic", objNull, true];
		{player removeWeaponGlobal _x} forEach weapons player;
		sleep 0.1;
		player setCaptive false;
		player allowDamage true;
		player setDamage 1;
		sleep 2;
		{deleteVehicle _x} forEach nearestObjects [player, ["GroundWeaponHolder"], 4];
	};
		
	r3_callForMedic = 
	{
		private ["_txt", "_name"];
		
		if(isNil "r3_MedicAlreadyCalled") then { r3_MedicAlreadyCalled = false };
		
		if(!r3_MedicAlreadyCalled) then {
		
			r3_MedicAlreadyCalled = true;
			
			_rndMedicSound = floor(random 4);
			switch(_rndMedicSound) do {
				case 0: { [[player, "callForMedic_1"], "say3DMP"] call BIS_fnc_MP; };
				case 1: { [[player, "callForMedic_2"], "say3DMP"] call BIS_fnc_MP; };
				case 2: { [[player, "callForMedic_3"], "say3DMP"] call BIS_fnc_MP; };
				case 3: { [[player, "callForMedic_4"], "say3DMP"] call BIS_fnc_MP; };
			};
			
			_txt = parseText format ["<img image='R34P3R\img\medic32.paa'/> <t color='#ff0000' size='1' shadow='1' shadowColor='#000000'> %1 need a medic !</t>",(name player)];
			[_txt,"hintSilent"] call BIS_fnc_MP;
			
			// Call AI-REVIVE HERE
			if(r3_reviveEnableAiRevive && !isNull(r3_nearAiMedic) && isNull(player getVariable ["r3_unitPrivateMedic", objNull])) then {
				if(r3_nearAiMedic getVariable ["r3_unitIsCalled",1] == 0 && r3_nearAiMedic getVariable ["r3_unitIsDown",1] == 0 && alive r3_nearAiMedic) then {
				
					[[player, r3_nearAiMedic], "r3_CallAiRevive", r3_nearAiMedic] call BIS_fnc_MP;
					
					_txt = format ["Medic: %1 is on the way!", name r3_nearAiMedic];
					cutText [_txt,"PLAIN DOWN"];
					
					r3_nearAiMedic = objNull;
				} else {
					_txt = format ["Sorry, %1 is busy!", name r3_nearAiMedic];
					cutText [_txt,"PLAIN DOWN"];
					
					r3_nearAiMedic = objNull;
				};
			};
			
			sleep 10;
			r3_MedicAlreadyCalled = false;
		};
	};
	
};
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(!isNull player) then {

	r3_unitHandleDamage_AI = 
	{
		private ["_unit", "_killer", "_selection", "_handleDamage", "_killer", "_unitIsDown"];
		
		_unit = param[0];
		_selection = param[1,""];
		_handleDamage = param[2,0];
		_killer = param[3,objNull];
		_unitIsDown = _unit getVariable ["r3_unitIsDown",1];

		if(r3_enableDebugMode) then { diag_log format ["HandleDamage for AI-UNIT: %1, Wound: %2, Damage: %3, Source: %4, Owner: %5", _unit, _selection, _handleDamage, _killer, (owner _unit)]; };
		
		if(local _unit && time > 5) then {
				
			if(alive _unit && _selection == "" && _handleDamage >= 0.9 && _unitIsDown == 0) then {

				_unit setVariable ["r3_unitIsDown", 1, true];
				_unit setVariable ["r3_unitIsStabi", 0, true];
				
				_unit allowDamage false;
				_unit setDamage 0.9;
				_unit setCaptive true;
				
				if(vehicle _unit != _unit) then {moveOut _unit};
				
				//player switchCamera "External";
				
				[_unit] spawn r3_spawnFakeUnit_AI;
				
				if(r3_enableDebugMode) then { diag_log format ["Revive AI-UNIT is down: %1", _unit]; };
				
				_handleDamage = 0;
			} else {
				if(alive _unit && damage _unit >= 0.4 && _unitIsDown == 0) then {
					if("FirstAidKit" in (items _unit) OR "Medikit" in (items _unit) ) then {
						[_unit] spawn r3_aiHealingSelf;
					};
				};
			};
		};
		
		if(_handleDamage >= 1) then {_handleDamage = 0.85};
		
		_handleDamage
	};

	r3_aiHealingSelf = 
	{
		_unit = _this select 0;
		_unit setCaptive true;
		_unit disableAi "TARGET";
		_unit disableAi "AUTOTARGET";
		sleep 0.5;
		_unit action ["HealSoldierSelf", _unit];
		sleep 6;
		_unit enableAi "TARGET";
		_unit enableAi "AUTOTARGET";
		sleep 1;
		_unit setCaptive false;
	};
	
	r3_spawnFakeUnit_AI =
	{
		private ["_unit","_fakePlayer", "_unitLoadout", "_newGrp"];
		
		_unit = _this select 0;
		_newGrp = createGroup (side _unit);
		
		_unit disableAi "MOVE";
		_unit disableAi "TARGET";
		_unit disableAi "AUTOTARGET";
		_unit disableAi "ANIM";
		
		_fakePlayer = _newGrp createUnit ["b_survivor_F", getMarkerPos r3_reviveTempRespawnMarker, [], 0, "CAN_COLLIDE"];
		_fakePlayer disableCollisionWith _unit;
		_fakePlayer setFace (face _unit);
		_fakePlayer forceAddUniform (uniform _unit);
		removeGoggles _fakePlayer;
		removeHeadgear _fakePlayer;
		if(!isNil {vest _unit}) then {_fakePlayer addVest (vest _unit)};
		if(!isNil {headgear _unit}) then {_fakePlayer addHeadgear (headgear _unit)};
		if(!isNil {goggles _unit}) then {_fakePlayer addGoggles (goggles _unit)};
		if(!isNil {backpack _unit}) then {_fakePlayer addBackpackGlobal (backpack _unit)};
		
		_Items = assignedItems _unit;
		if(("NVGoggles" in _Items) OR ("NVGoggles_OPFOR" in _Items) OR ("NVGoggles_INDEP" in _Items)) then {
			_fakePlayer linkItem "NVGoggles";
		};
		
		_fakePlayer disableAI "ANIM";
		_fakePlayer disableAI "MOVE";
		_fakePlayer setVariable ["r3_originalUnit", _unit, true];
		_fakePlayer setDir (getDir _unit);
		
		switch (stance _unit) do {
			case "STAND": { [[_fakePlayer, "AmovPercMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "CROUCH": { [[_fakePlayer, "AmovPknlMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "PRONE": { [[_fakePlayer, "AmovPpneMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
			case "UNDEFINED": { [[_fakePlayer, "AmovPknlMstpSrasWrflDnon"], "switchMoveMP"] call BIS_fnc_MP; };
		};
		
		[[_unit, true], "hideObjectMP" ] call BIS_fnc_MP;
		sleep 0.05;
		_fakePlayer setPosATL (getPosATL _unit);
		_fakePlayer setDamage 1;
		_fakePlayer setVelocity [0,0,-1];
		
		_unit setVelocity [0,0,-1];
		_unit setVariable ["r3_unitFakePlayer", _fakePlayer, true];
		[[_unit, "AinjPpneMstpSnonWrflDnon"], "switchMoveMP"] call BIS_fnc_MP;
		
		sleep 0.5;
		
		_unit setPosATL [(getPosATL _fakePlayer select 0),(getPosATL _fakePlayer select 1),(getPosATL _fakePlayer select 2) +0.1] ;
		
		[_unit,_fakePlayer] spawn r3_unconscious_ai;
		
		[[_unit,_fakePlayer], "r3_createBlood"] call BIS_fnc_MP; 
		
		[[_unit], "r3_createMedicSound"] call BIS_fnc_MP; 
	};

	r3_unconscious_ai =
	{
		private ["_unit","_bleedOut","_fakePlayer","_nextAiCall"];
		
		_unit = _this select 0;
		_fakePlayer = _this select 1;
		_bleedOut = time + r3_reviveBleedOutTime;
		_nextAiCall = 0;
		
		_txt = format["%1: Damn, I'm down!",name _unit];
		[[_unit, _txt], "groupChatMP"] call BIS_fnc_MP;
		
		waitUntil{sleep 1; (velocity _fakePlayer select 2) == 0 OR isTouchingGround _fakePlayer};
		
		_unit setPosATL [(getPosATL _fakePlayer select 0),(getPosATL _fakePlayer select 1),(getPosATL _fakePlayer select 2) +0.1] ;
		
		_unit disableConversation true;
		
		while {alive _unit && _unit getVariable ["r3_unitIsDown",0] == 1 && _unit getVariable ["r3_unitIsStabi",0] == 0 && time < (_bleedOut -1) } do {
			_nextAiCall = _nextAiCall +1;
			if(_nextAiCall >= 10 && _unit getVariable ["r3_unitGetRevive",0] == 0 && _unit getVariable ["r3_unitGetDrag",0] == 0) then {
				_nextAiCall = 0;
				if(r3_reviveEnableAiRevive) then { [_unit] spawn r3_aiReviveAi; };
			};
			_unit setVariable ["r3_unitbleedOut",round(_bleedOut - time), true];
			sleep 1; 
		};
		
		if(alive _unit && _unit getVariable ["r3_unitIsStabi",0] == 1) then {		
			while {alive _unit && _unit getVariable ["r3_unitIsDown",0] == 1 } do { 
				_nextAiCall = _nextAiCall +1;
				if(_nextAiCall >= 20 && _unit getVariable ["r3_unitGetRevive",0] == 0 && _unit getVariable ["r3_unitGetDrag",0] == 0) then {
					_nextAiCall = 0;
					if(r3_reviveEnableAiRevive) then { [_unit] spawn r3_aiReviveAi; };
				};
				sleep 1; 
			};
		};
		
		if(time > (_bleedOut -1) && _unit getVariable ["r3_unitIsStabi",0] == 0 && _unit getVariable ["r3_unitIsDown",0] == 1) then {
			{_unit removeWeaponGlobal _x} forEach weapons _unit;
			sleep 0.1;
			_unit allowDamage true;
			_unit setCaptive false;
			_unit setDamage 1;
			sleep 1;
		};
		
		if(alive _unit) then {
			if(!isNull _fakePlayer) then {deleteVehicle _fakePlayer};
			[[_unit, false], "hideObjectMP" ] call BIS_fnc_MP;
			_unit playMove "AmovPpneMstpSrasWrflDnon";
			_unit setDamage (random 0.19);
			_unit enableAI "ANIM";
			_unit enableAI "MOVE";
			_unit enableAI "TARGET";
			_unit enableAI "AUTOTARGET";
			_unit disableConversation false;
			sleep 2;
			_unit setCaptive false;
			_unit allowDamage true;
			_unit setVariable ["r3_unitbleedOut", r3_reviveBleedOutTime, true];
		};
	};

	r3_aiReviveAi = 
	{
		_unit = _this select 0;
		
		{
			if(!isPlayer _x && _x != _unit) then {
				if((vehicle _x) == _x) then {
					if((_x distance _unit) < 150) then {
						if(alive _x && _x getVariable ["r3_unitIsDown",0] == 0) then {
							if(_x getVariable ["r3_unitIsCalled",0] == 0) then {
								if("FirstAidKit" in (items _x) OR "Medikit" in (items _x) ) exitWith {
									[_unit, _x] spawn r3_CallAiRevive;
								};
							};
						};
					};
				};
			};
		} forEach units group _unit;

	};

	r3_reviveEqiupAi =
	{
		private ["_healer","_injured","_allItems"];
		
		_healer = _this select 0;
		_injured = _this select 1;
		_allItems = [];
		
		if (local _healer) then {

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
				
				sleep (r3_reviveHealTime + 10) + floor(random 20);
				
				{
					deleteVehicle _x;
					sleep random 3;
				}forEach _allItems;
			};
		};
	};
	
	r3_medicSwitchBehaviour =
	{
		_aiMedic =  [_this, 0, objNull] call BIS_fnc_param;
		_behaviour =  [_this, 1, "AWARE"] call BIS_fnc_param;
		
		if(!isNull _aiMedic) then {
			_orgGrp = (group _aiMedic);
			_medicGRP = createGroup (side _aiMedic);
			[_aiMedic] joinSilent _medicGRP;
			_aiMedic setBehaviour _behaviour;
			[_aiMedic] joinSilent _orgGrp;
		};		
	};
	
	r3_CallAiRevive =
	{
		private ["_unit","_aiMedic","_moveTimeout","_cancelRevive","_dirVector","_upVector","_reviveTime"];
		
		_unit =  [_this, 0, objNull] call BIS_fnc_param;
		_aiMedic =  [_this, 1, objNull] call BIS_fnc_param;

		if(_aiMedic getVariable ["r3_unitIsCalled",0] == 0) then {
			if(isNull (_unit getVariable ["r3_unitPrivateMedic", objNull])) then {
				if(alive _unit && _unit getVariable ["r3_unitIsDown",0] == 1) then {
					
					_aiMedic setVariable ["r3_unitIsCalled", 1, true];
					_unit setVariable ["r3_unitPrivateMedic", _aiMedic, true];
					
					_aiMedic allowDamage false;
					_aiMedic stop false;
					_aiMedic setCaptive true;
					_aiMedic disableAI "AUTOTARGET";
					_aiMedic disableAI "TARGET";
					
					[_aiMedic,"CARELESS"] call r3_medicSwitchBehaviour;
					
					if(isPlayer _unit) then { 
						_txt = format ["%1: Hold on %2, im on the way !",name _aiMedic, name _unit];
						[[_aiMedic, _txt], "groupChatMP"] call BIS_fnc_MP;
					};
					
					if((_aiMedic distance _unit) > 50) then {
						if((_aiMedic distance _unit) > 100) then {
							_moveTimeout = time + 60;
						} else {
							_moveTimeout = time + 35;
						};
					} else {
						_moveTimeout = time + 16;
					};
					
					_cancelRevive = false;
					
					while{(_aiMedic distance _unit) >= 4 && time < _moveTimeout} do {
						_aiMedic doMove (getPosATL _unit);
						_aiMedic moveTo (getPosATL _unit);
						sleep 2;
						if(!alive _unit OR !alive _aiMedic) exitWith {_cancelRevive = true};
						if(_unit getVariable ["r3_unitIsDown",1] == 0) exitWith {_cancelRevive = true};
						if(_aiMedic getVariable ["r3_unitIsDown",0] == 1) exitWith {_cancelRevive = true};
						if(_unit getVariable ["r3_unitGetDrag",0] == 1) exitWith {_cancelRevive = true};
						if(_unit getVariable ["r3_unitGetRevive",0] == 1) exitWith {_cancelRevive = true};
					};

					if(!_cancelRevive && (_aiMedic distance _unit) <= 5) then {
						_unit setVariable ["r3_unitGetRevive", 1, true];
						
						_dirVector = vectorDir _aiMedic;
						_upVector = vectorUp _aiMedic;
						
						_aiMedic setDir 270;
						
						_fakePlayer = _unit getVariable ["r3_unitFakePlayer",objNull];
						if(!isNull _fakePlayer) then {
							_aiMedic attachTo [_fakePlayer, [0.85, 0.2, 0.01]];
						} else {
							_aiMedic attachTo [_unit, [0.85, 0.2, 0.01]];
						};
						_aiMedic setDir 270;
						
						if(primaryWeapon _aiMedic != "") then {
							if(currentWeapon _aiMedic != primaryWeapon _aiMedic) then {
								_aiMedic selectWeapon primaryWeapon _aiMedic;
								sleep 3;
							};
						};
						
						_aiMedic disableAI "ANIM";
						_aiMedic playActionNow "medicStart";
						_reviveTime = time + r3_reviveHealTime;
						
						[_aiMedic, _unit] spawn r3_reviveEqiupAi;
						
						while{time < _reviveTime && alive _aiMedic && alive _unit && _unit getVariable "r3_unitIsDown" == 1} do {
							sleep 2;
							_aiMedic playActionNow "medicStart";
						};
							
						if(_aiMedic getVariable ["r3_unitIsDown",0] == 0 && alive _aiMedic) then {
							
							_aiMedic playActionNow "medicStop";
							
							sleep 1;
							
							detach _aiMedic;
							_aiMedic setVectorDirAndUp [_dirVector,_upVector];
							sleep 1;
							
							if (!("Medikit" in (items _aiMedic)) ) then { _aiMedic removeItem "FirstAidKit"; };
						
							_unit setVariable ["r3_unitIsDown", 0, true];
							_unit setVariable ["r3_unitIsStabi", 0, true];
							_unit setVariable ["r3_unitGetRevive", 0, true];
							
							if !("FirstAidKit" in (items _aiMedic) OR "Medikit" in (items _aiMedic)) then { 
								_txt = format ["%1: No more kits left !!",name _aiMedic];
								[[_aiMedic, _txt], "groupChatMP"] call BIS_fnc_MP;
							};
						};
					};
					
					_unit setVariable ["r3_unitPrivateMedic", objNull, true];
					
					_orgBehaviour = behaviour (leader _aiMedic);
					[_aiMedic,_orgBehaviour] call r3_medicSwitchBehaviour;
					
					if(_aiMedic getVariable ["r3_unitIsDown",0] == 0 && alive _aiMedic) then {
						_aiMedic stop false;
						_aiMedic enableAI "ANIM";
						_aiMedic enableAI "MOVE";
						_aiMedic enableAI "AUTOTARGET";
						_aiMedic enableAI "TARGET";
						sleep 5;
						_aiMedic setCaptive false;
						_aiMedic allowDamage true;
					};
					
					_aiMedic setVariable ["r3_unitIsCalled", 0, true];
				};
			};
		};	
	};
	
};

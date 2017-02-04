/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

// [this, "animation", hight, direction, [attachX,attachY], removeItems ] execVM "R34P3R\fnc\r3_animate.sqf";
//
// Animations:
// SIT, SIT_GROUND, SIT_TABLE, SIT_HIGH
// LEAN, LEAN_TABLE
// REPAIR_STAND, REPAIR_KNEEL REPAIR_PRONE
// THINK
// INJURED
// SHIELD_SUN
// POINTING
// NAVIGATING
// WALK
// IDLE_STAND
// SLEEP
// HEAL_KNEEL
// PATROL
// HANDSBEHIND
// SURRENDER
//
// hight is optional ! (Set the final hight of the unit. if synchronized with a object you can set the attached hight.)
// direction is optional !
// attach is optional ! unit will attached to synchronized object
// removeItems (BOOL) is optional  (remove vest, headgear, goggles, weapons)

if (isServer) then {

	private ["_unit","_anim","_hight","_d","_p","_pw","_sw","_rnd","_ne","_attachPos","_remItems"];

	_unit = [_this, 0, objNull] call BIS_fnc_param;
	_anim = [_this, 1, ""] call BIS_fnc_param;
	_hight = [_this, 2, 999] call BIS_fnc_param;
	_d = [_this, 3, 999] call BIS_fnc_param;
	_attachPos = [_this, 4, [0,0]] call BIS_fnc_param;
	_remItems = [_this, 5, false] call BIS_fnc_param;

	if(isNull _unit) exitWith { diag_log format ["Animation Failed ! (Unit not found), Unit: %1, Animation: %2",_unit,_anim] };
	if(isNil "_anim") exitWith { diag_log format ["Animation Failed ! (Animation is empty), Unit: %1, Animation: %2",_unit,_anim] };

	if(_hight == 999) then { _hight = 0};
	if(_d == 999) then { _d = getDir _unit};

	detach _unit;
	_unit disableConversation true;
	{_unit disableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];

	if(_remItems) then {
		removeAllWeapons _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeVest _unit;
		removeGoggles _unit;
	};

	_p = getPosATL _unit;
	_pw = primaryWeapon _unit;
	_sw = secondaryWeapon _unit;

	waitUntil{sleep 3; !isNil "switchMoveMP" && !isNil "r3_serverFullLoaded"};

	switch(toUpper(_anim)) do {
		case "SIT": {
			switch(floor(random 10)) do {
				case 0: { [[_unit,"HubSittingChairUA_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 1: { [[_unit,"passenger_apc_generic02"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight +0.6 };
				case 2: { [[_unit,"passenger_apc_generic01"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight +0.6 };
				case 3: { [[_unit,"passenger_apc_narrow_generic02"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight +0.55 };
				case 4: { [[_unit,"passenger_generic01_foldhands"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight +0.55 };
				case 5: { [[_unit,"HubSittingChairA_idle1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 6: { [[_unit,"HubSittingChairA_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 7: { [[_unit,"HubSittingChairB_idle3"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 8: { [[_unit,"HubSittingChairC_idle1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 9: { [[_unit,"HubSittingChairC_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
			}; 
		};
		case "SIT_GROUND": {
			if(_pw == "") then {
				switch(floor(random 2)) do {
					case 0: { [[_unit,"aidlpsitmstpsnonwnondnon_ground00"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 1: { [[_unit,"commander_sdv"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				};
			} else {
				switch(floor(random 7)) do {
					case 0: { [[_unit,"Acts_passenger_flatground_leanright"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 1: { [[_unit,"passenger_flatground_generic01"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 2: { [[_unit,"passenger_flatground_generic02"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 3: { [[_unit,"passenger_flatground_generic03"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 4: { [[_unit,"passenger_flatground_generic04"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 5: { [[_unit,"passenger_flatground_generic05"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 6: { [[_unit,"passenger_flatground_leanright"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				};
			};
		};
		case "SIT_TABLE": {
			[[_unit,"HubSittingAtTableU_idle2"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight -0.5;
		};
		case "SIT_HIGH": {
			switch(floor(random 3)) do {
				case 0: { [[_unit,"HubSittingHighB_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; _d = _d -10; _hight = _hight -0.5 };
				case 1: { [[_unit,"HubSittingHighB_idle1"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight -0.5 };
				case 2: { [[_unit,"HubSittingHighB_idle2"], "switchMoveMP", true, true] call BIS_fnc_MP; _hight = _hight -0.5 };
			}; 
		};
		case "LEAN": {
			[[_unit,"InBaseMoves_Lean1"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "LEAN_TABLE": {
			[[_unit,"InBaseMoves_table1"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "REPAIR_STAND": {
			[[_unit,"InBaseMoves_assemblingVehicleErc"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "REPAIR_KNEEL": {
			[[_unit,"InBaseMoves_repairVehicleKnl"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "REPAIR_PRONE": {
			[[_unit,"InBaseMoves_repairVehiclePne"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "THINK": {
			[[_unit,"HubBriefing_think"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "INJURED": {
			switch(floor(random 3)) do {
				case 0: { [[_unit,"acts_InjuredCoughRifle02"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 1: { [[_unit,"acts_InjuredLookingRifle04"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 2: { [[_unit,"acts_InjuredSpeakingRifle01"], "switchMoveMP", true, true] call BIS_fnc_MP; };
			}; 		
		};
		case "SHIELD_SUN": {
			[[_unit,"Acts_ShieldFromSun_loop"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "POINTING": {
			[[_unit,"acts_PointingLeftUnarmed"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "NAVIGATING": {
			[[_unit,"Acts_ShowingTheRightWay_loop"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "WALK": {
			[[_unit,"HubSpectator_walk"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "IDLE_STAND": {
			if(_pw == "") then {
				switch(floor(random 4)) do {
					case 0: { [[_unit,"HubStandingUA_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 1: { [[_unit,"HubStandingUA_move2"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 2: { [[_unit,"HubStandingUB_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 3: { [[_unit,"HubStandingUC_move1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				};
			} else {
				switch(floor(random 3)) do {
					case 0: { [[_unit,"c4coming2cdf_genericstani1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 1: { [[_unit,"c4coming2cdf_genericstani2"], "switchMoveMP", true, true] call BIS_fnc_MP; };
					case 2: { [[_unit,"c4coming2cdf_genericstani3"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				};		
			}; 
		};
		case "SLEEP": {
			[[_unit,"Acts_LyingWounded_loop"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "HEEL_KNEEL": {
			switch(floor(random 3)) do {
				case 0: { [[_unit,"Acts_TreatingWounded01"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 1: { [[_unit,"Acts_TreatingWounded02"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 2: { [[_unit,"Acts_TreatingWounded05"], "switchMoveMP", true, true] call BIS_fnc_MP; };
			}; 
		};
		case "PATROL": {
			switch(floor(random 2)) do {
				case 0: { [[_unit,"InBaseMoves_patrolling1"], "switchMoveMP", true, true] call BIS_fnc_MP; };
				case 1: { [[_unit,"InBaseMoves_patrolling2"], "switchMoveMP", true, true] call BIS_fnc_MP; };
			}; 
		};
		case "HANDSBEHIND": {
			[[_unit,"inbasemoves_handsbehindback1"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};
		case "SURRENDER": {
			[[_unit,"AmovPercMstpSsurWnonDnon"], "switchMoveMP", true, true] call BIS_fnc_MP;
		};	
		default {
			diag_log format ["Animation Failed ! (Animation not found), Unit: %1, Animation: %2",_unit,_anim];
			_unit disableConversation false;
			{_unit enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
		};
	};

	if(count synchronizedObjects _unit > 0) then {
			private ["_obj"];
			
			_obj = synchronizedObjects _unit select 0;
			_unit attachTo [_obj, [_attachPos select 0, _attachPos select 1, _hight]];
	} else {
		_unit setPosATL [(_p select 0),(_p select 1),_hight];
	};
	_unit setDir _d;
	_unit setDir _d;
	
	_unit addEventHandler ["FiredNear",{
		_caller = _this select 0;
		_shooter = _this select 1;
		_distance = _this select 2;
		_hasSilencer = false;
		
		if(_shooter isKindOf "Man" && vehicle _shooter == _shooter) then {
			_silencer = _shooter weaponAccessories currentMuzzle _shooter select 0;
			_hasSilencer = !isNil "_silencer" && {_silencer != ""};
		};
		
		if(!_hasSilencer) then {
			if(_distance < 40) then {
				_caller removeAllEventHandlers "FiredNear";
				[[_caller,""], "switchMoveMP"] call BIS_fnc_MP;
				{_caller enableAI _x} forEach ["ANIM","AUTOTARGET","FSM","MOVE","TARGET"];
			};
		};
	}];
	
};

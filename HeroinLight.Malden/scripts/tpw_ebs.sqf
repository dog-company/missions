/*
TPW EBS - Engine Based Suppression
Version: 1.24
Authors: tpw,ollem, MrFlay, Das Attorney 
Thanks: -coulum-, fabrizio_t 
Date: 20140910
Requires: CBA A3, tpw_core.sqf
Compatibility: SP

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 	

To use: 
1 - Save this script into your mission directory as eg tpw_ebs.sqf
2 - Call it with 0 = [5,10,0,500,1,1,1,1] execvm "tpw_ebs.sqf"; where 5 = bullet threshold, 10 = delay until suppression functions start (sec), 0 = no debugging, 500 = suppression radius, 1 = player suppression effects, 1 = suppression applied to AI, 1 = AI will seek cover when suppressed, 1 = use suppression shell (0 = bullet centric suppression)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if ((count _this) < 8) exitWith {hint "TPW EBS incorrect/no config, exiting."};
if (isDedicated) exitWith {};
if (!isNil "bcombat") exitWith {};
WaitUntil {!isNull FindDisplay 46};

/////////////
// VARIABLES
/////////////
tpw_ebs_version = "1.24"; // Version string

tpw_ebs_thresh = _this select 0; // unit is suppressed if this many bullets pass by in 5 secs
tpw_ebs_sleep = _this select 1; // how long until suppression functions start
tpw_ebs_debug = _this select 2; // debugging will colour suppressed units (blue = unsuppressed, green = own side, yellow = enemy <5 bullets, red = enemy >5 bullets)
tpw_ebs_radius = _this select 3; // units must be closer to player than this (m) for suppression to work
tpw_ebs_playersup = _this select 4; // suppression effects applied to player
tpw_ebs_aisup = _this select 5; // suppression effects applied to AI
tpw_ebs_findcover = _this select 6; // AI will seek cover if suppressed
tpw_ebs_suptype = _this select 7; // Suppression type (shell or bullet centric)

tpw_ebs_detectradius = 10; // detection radius around each bullet (m)
tpw_ebs_bulletlife = 1; // bullet lifetime (sec)
tpw_ebs_maxdist = 1000; // bullets fired from further than this don't suppress (m)
tpw_ebs_mindist = 10; // bullets fired from less than this don't suppress (m)
tpw_ebs_minspeed = 1500; // bullets must be travelling faster than this to suppress (no pistols)

tpw_ebs_active = true; //Global enable/disable
tpw_ebs_unitarray = []; // Array of suppressible units
tpw_ebs_bulletarray = []; // Array of fired bullets
tpw_ebs_pfeh = false; // Is per frame eventhandler running?

// Stance arrays for each weapon
tpw_ebs_standarray = ["AmovPercMstpSrasWnonDnon","AmovPercMstpSrasWpstDnon","AmovPercMstpSrasWrflDnon","AmovPercMstpSrasWlnrDnon"];
tpw_ebs_croucharray = ["AmovPknlMstpSrasWnonDnon","AmovPknlMstpSrasWpstDnon","AmovPknlMstpSrasWrflDnon","AmovPknlMstpSrasWlnrDnon"];
tpw_ebs_pronearray = ["AmovPpneMstpSrasWnonDnon","AmovPpneMstpSrasWpstDnon","AmovPpneMstpSrasWrflDnon","AmovPpneMstpSrasWlnrDnon"];

// PERIODICALLY APPLY EBS "SHELL" TO ALL UNITS
tpw_ebs_fnc_shell = 
	{
	private ["_unit","_shell"];
	while {true} do
		{
			{
			_unit = _x;
			if (_unit getvariable ["tpw_ebs_shell", 0] == 0 ) then
				{
				_shell = "ebs" createVehicle [0,0,0];
				_shell addeventhandler ["hitpart",{_this call tpw_ebs_fnc_shellsupstate}];
				_shell setvariable ["tpw_ebs_attachedunit",_unit]; 
				_unit setvariable ["tpw_ebs_attachedshell",_shell];
				_shell attachTo [_unit, [0,-1.5,2.5]];
				_unit setvariable ["tpw_ebs_shell", 1];
				_unit addeventhandler ["killed", {deletevehicle ((_this select 0) getvariable "tpw_ebs_attachedshell")}]; // remove shell if killed
				};
			} foreach allunits;
		sleep 10;	
		};	
	};	

// PERIODICALLY APPLY FIRED EVENTHANDLER TO ALL UNITS
tpw_ebs_fnc_apply =
	{
	while {true} do
		{
			{
			if (_x getvariable ["tpw_ebs_eh",0] == 0) then 
				{
				_x addeventhandler ["fired",{_this call tpw_ebs_fnc_fired}];
				_x setvariable ["tpw_ebs_eh",1];
				};
			} foreach allunits;
		sleep 10;	
		};	
	};

// BULLET FIRED
tpw_ebs_fnc_fired =
	{
	private ["_bullet","_shooter","_pos","_lifetime"];
	_shooter = _this select 0;
	_bullet = _this select 6;
	
	// Add bullet to array if it supersonic and close enough to player
	if (
	_shooter distance player < tpw_ebs_maxdist && 
	{speed _bullet > tpw_ebs_minspeed} 
	) then
		{
		_lifetime = diag_ticktime + tpw_ebs_bulletlife; 
		tpw_ebs_bulletarray set [count tpw_ebs_bulletarray,[_bullet,_lifetime,_shooter]];
		
		// Start bullet detection PFEH if it's not already running
		if !(tpw_ebs_pfeh) then 
			{
			tpw_ebs_handle = [tpw_ebs_fnc_detect,0] call cba_fnc_addPerFrameHandler;
			tpw_ebs_pfeh = true;
			};
		};
	};

// DETECT UNITS AROUND BULLETS 
tpw_ebs_fnc_detect =
	{
	private ["_bulletarray","_near","_bullet","_ct","_lifetime"];
	for "_ct" from 0 to (count tpw_ebs_bulletarray - 1) do	
		{
		_bulletarray = tpw_ebs_bulletarray select _ct;
		_bullet = _bulletarray select 0;
		_lifetime = _bulletarray select 1;
		if (alive _bullet && {diag_ticktime < _lifetime}) then 
			{
			_near = (getpos _bullet) nearEntities [["camanbase"],tpw_ebs_detectradius];	
			if (count _near > 0) then 
				{
				[_near,_bulletarray] spawn tpw_ebs_fnc_supstate;
				};
			}
		else
			{
			tpw_ebs_bulletarray set [_ct,-1];
			}	
		}; 
	tpw_ebs_bulletarray = tpw_ebs_bulletarray - [-1];
	};

// DETERMINE SUPPRESSION STATE - BULLET CENTRIC
tpw_ebs_fnc_supstate =
	{
	private ["_unit","_shooter","_shooterside","_allbullets","_enemybullets","_supstate","_near","_bulletarray","_i"];
	_near = _this select 0;
	_bulletarray = _this select 1;
	_shooter = _bulletarray select 2;
	_shooterside = side _shooter;
	for "_i" from 0 to (count _near - 1) do 
		{
		_unit = _near select _i;
		if (_shooter distance _unit > tpw_ebs_mindist) then
			{
			_allbullets = _unit getvariable ["tpw_ebs_allbullets", 0];		
			_enemybullets = _unit getvariable ["tpw_ebs_enemybullets", 0];

			// Increment bullet counters	
			_allbullets  = _allbullets + 1;
			if (side _unit != _shooterside) then 
				{
				_enemybullets  = _enemybullets + 1;
				};
			
			// Initial skill, stance and fatigue
			if (_allbullets == 1 || _allbullets == 2) then
				{
				_unit setvariable ["tpw_ebs_skill",skill _unit];
				_unit setvariable ["tpw_ebs_stance",stance _unit];
				_unit setvariable ["tpw_ebs_fatigue",getfatigue _unit];
				};
			
			// Determine suppression state
			_supstate = 1;	
			if (_enemybullets > 0) then
				{
				_supstate = 2;
				};
			if (_enemybullets > tpw_ebs_thresh) then
				{
				_supstate = 3;
				};
			
			// Update unit's variables
			_unit setvariable ["tpw_ebs_enemy",_shooter];
			_unit setvariable ["tpw_ebs_allbullets",_allbullets]; // all bullets
			_unit setvariable ["tpw_ebs_enemybullets",_enemybullets]; // enemy bullets
			_unit setvariable ["tpw_ebs_supstate",_supstate]; // suppression state
			_unit setvariable ["tpw_ebs_uptime",time + 5 + (random 5)]; // how long until unit is unsuppressed
			_unit setvariable ["tpw_ebs_downtime",time + (random 1)]; // how long until unit reacts to bullet
			};
		};
	};
	
// DETERMINE SUPPRESSION STATE - SHELL
tpw_ebs_fnc_shellsupstate =
	{
	private ["_shell","_shellinfo","_unit","_shooter","_shooterside","_allbullets","_enemybullets","_supstate"];
	_shellinfo = _this select 0;
	_shell =_shellinfo select 0; 
	_unit = _shell getvariable "tpw_ebs_attachedunit";
	_shooter = _shellinfo select 1;
	_shooterside = side _shooter;

	if (_shooter distance _unit > tpw_ebs_mindist) then
		{
		_allbullets = _unit getvariable ["tpw_ebs_allbullets", 0];		
		_enemybullets = _unit getvariable ["tpw_ebs_enemybullets", 0];

		// Increment bullet counters	
		_allbullets  = _allbullets + 1;
		if (side _unit != _shooterside) then 
			{
			_enemybullets  = _enemybullets + 1;
			};
		
		// Initial skill, stance and fatigue
		if (_allbullets == 1 || _allbullets == 2) then
			{
			_unit setvariable ["tpw_ebs_skill",skill _unit];
			_unit setvariable ["tpw_ebs_stance",stance _unit];
			_unit setvariable ["tpw_ebs_fatigue",getfatigue _unit];
			};
		
		// Determine suppression state
		_supstate = 1;	
		if (_enemybullets > 0) then
			{
			_supstate = 2;
			};
		if (_enemybullets > tpw_ebs_thresh) then
			{
			_supstate = 3;
			};
		
		// Update unit's variables
		_unit setvariable ["tpw_ebs_enemy",_shooter];
		_unit setvariable ["tpw_ebs_allbullets",_allbullets]; // all bullets
		_unit setvariable ["tpw_ebs_enemybullets",_enemybullets]; // enemy bullets
		_unit setvariable ["tpw_ebs_supstate",_supstate]; // suppression state
		_unit setvariable ["tpw_ebs_uptime",time + 5 + (random 5)]; // how long until unit is unsuppressed
		_unit setvariable ["tpw_ebs_downtime",time + (random 1)]; // how long until unit reacts to bullet
		};
	};	
	
// FIND COVER
tpw_ebs_fnc_findcover = 
	{
	private ["_unit","_shooter","_cover","_nearcover","_box","_height","_coverpos","_i","_item"];
	_unit = _this select 0;
	_debugball = false;
	_shooter = 	_unit getvariable ["tpw_ebs_enemy",objnull];
	_cover = nearestobjects [position _unit,["house","landvehicle"],100];
	_nearcover = [_cover,[],{_unit distance _x},"ASCEND"] call BIS_fnc_sortBy;
	for "_i" from 0 to (count _nearcover - 1) do 
		{
		_item = _nearcover select _i;
		_box = boundingbox _item;
		_height = ((_box select 1) select 2) - ((_box select 0) select 2);
		if (_height > 1) exitwith 
			{
			_coverpos = getpos _item;
			_unit domove _coverpos;
			};
		};
	sleep 10;	
	_unit setvariable ["tpw_ebs_cover", 0];	
	};	

// MAIN SUPPRESSION PROCESSING LOOP
tpw_ebs_fnc_procsup =
	{
	private ["_unit","_supstate","_stance"];
	while {true} do
		{
		for "_i" from 0 to (count tpw_ebs_unitarray - 1) do
			{
			_unit = tpw_ebs_unitarray select _i;
			_supstate = _unit getvariable ["tpw_ebs_supstate", 0];
			
			// Only bother with suppression functions if... (lazy evaluation)
			if (
			_supstate > _unit getvariable ["tpw_ebs_lastsup",0]  // suppression state has increased
			&& {time >= _unit getvariable ["tpw_ebs_downtime",0]}  // reaction delay time has passed
			&& {_unit getvariable ["tpw_fallstate",0] == 0} // unit is not TPW FALLing
			) then
				{
				_unit setvariable ["tpw_ebs_lastsup",_supstate];
				[_unit] call tpw_core_fnc_weptype;
				_stance = stance _unit;
				
				// Stop unit from fleeing
				_unit allowfleeing 0;
				
				// Stop unit from targetting enemy
				_unit dowatch objnull;
				
				// Suppression specific changes (playmove forces stance change)
				switch _supstate do
					{
					case 1:
						{							
						// Crouch if not prone
						if (_stance != "PRONE") then
							{
							_unit setunitpos "middle";
							_unit playmove (tpw_ebs_croucharray select (_unit getvariable "tpw_core_weptype"));
							};
						};	
					case 2:
						{
						// Crouch if not prone
						if (_stance != "PRONE") then
							{
							_unit setunitpos "middle";
							_unit playmove (tpw_ebs_croucharray select (_unit getvariable "tpw_core_weptype"));
							
							// Reduce skill
							_unit setskill ((_unit getvariable "tpw_ebs_skill") * 0.75);
							};
						
						// Civs hit the deck
						if (side _unit == CIVILIAN) then 
							{
							_unit setunitpos "down";
							_unit playmove (tpw_ebs_pronearray select (_unit getvariable "tpw_core_weptype"));
							_unit setSpeedMode "FULL";							
							};
							
						//Find cover
						if (tpw_ebs_findcover == 1 && {_unit getvariable ["tpw_ebs_cover", 0] == 0}) then
							{
							 _unit setvariable ["tpw_ebs_cover", 1];	
							[_unit] spawn tpw_ebs_fnc_findcover;
							};	
						};

					case 3:
						{
						// Hit the deck if no nearby cover
						if (count (nearestobjects [position _unit,["house","landvehicle"],10]) == 0) then
							{						
							_unit setunitpos "down";
							_unit playmove (tpw_ebs_pronearray select (_unit getvariable "tpw_core_weptype"));
							};
						
						//Find cover
						if (tpw_ebs_findcover == 1 && {_unit getvariable ["tpw_ebs_cover", 0] == 0}) then
							{
							 _unit setvariable ["tpw_ebs_cover", 1];	
							[_unit] spawn tpw_ebs_fnc_findcover;
							};
						
						// Reduce skill
						_unit setskill ((_unit getvariable "tpw_ebs_skill") * 0.5);	
						};	
					};	
				};
				
			// Reset suppression after enough time
			if (time >= (_unit getvariable ["tpw_ebs_uptime", time + 30])) then 			
				{
				_unit setvariable ["tpw_ebs_allbullets",0];
				_unit setvariable ["tpw_ebs_enemybullets",0];
				_unit setvariable ["tpw_ebs_supstate",0];
				_unit setskill (_unit getvariable "tpw_ebs_skill");
				_unit setunitpos "auto";
				_unit setvariable ["tpw_ebs_lastsup",0];	
				_unit setvariable ["tpw_ebs_uptime",time + 30];	
				};
			
			// Debugging			
			if (tpw_ebs_debug == 1) then 
				{
				switch _supstate do
					{
					case 1: 
						{
						[[_unit], "tpw_ebs_fnc_green",false] spawn BIS_fnc_MP;
						};
					case 2: 
						{
						[[_unit], "tpw_ebs_fnc_yellow",false] spawn BIS_fnc_MP;
						};
					case 3: 
						{
						[[_unit], "tpw_ebs_fnc_red",false] spawn BIS_fnc_MP;
						};
					default
						{
						[[_unit], "tpw_ebs_fnc_blue",false] spawn BIS_fnc_MP;
						};
					};
				};				
			};
		
		// Check for live bullets and disable detection PFEH if none
		if (tpw_ebs_pfeh && {count tpw_ebs_bulletarray == 0}) then
			{
			tpw_ebs_pfeh = false;
			[tpw_ebs_handle] call CBA_fnc_removePerFrameHandler;
			};
		sleep 1;
		};
	};

// PLAYER SUPPRESSION	
tpw_ebs_fnc_playersup =
	{
	private ["_supstate","_fatigue"];
	while {true} do
		{
		if (player == vehicle player) then
			{		
			_supstate = player getvariable ["tpw_ebs_supstate",0];

			// Set suppression effects only if suppression state has changed
			if (_supstate > (player getvariable ["tpw_ebs_lastsup",0])) then
				{
				player setvariable ["tpw_ebs_lastsup",_supstate];	
				_fatigue = player getvariable ["tpw_ebs_fatigue",0];
				
				switch _supstate do
					{
					case 1:
						{
						if (_fatigue < 0.2) then
							{
							player setfatigue 0.2;
							};
						};
						
					case 2:
						{
						if (_fatigue < 0.4) then
							{
							player setfatigue 0.4;
							};
						};	
					
					case 3:
						{
						if (_fatigue < 0.6) then
							{
							player setfatigue 0.6;
							};
						};
					};
				};	
			
			// Reset if unsuppressed
			if (time >= (player getvariable ["tpw_ebs_uptime", time + 30])) then 			
				{
				player setvariable ["tpw_ebs_allbullets",0];
				player setvariable ["tpw_ebs_enemybullets",0];
				player setvariable ["tpw_ebs_supstate",0];
				player setvariable ["tpw_ebs_fatigue",0];
				player setvariable ["tpw_ebs_lastsup",0];	
				player setvariable ["tpw_ebs_uptime",time + 30];	
				};
			};
		sleep 1;
		};
	};	

// PERIODICALLY SCAN APPROPRIATE UNITS INTO ARRAY FOR SUPPRESSION	
tpw_ebs_fnc_screen =
	{
	while {true} do
		{
		tpw_ebs_unitarray = [];
			{
			if (
			alive _x && 
			{_x distance vehicle player < tpw_ebs_radius} && 
			{_x == vehicle _x} && 
			{_x != player}
			) then
				{
				// Add to the array of suppressible units 
				tpw_ebs_unitarray set [count tpw_ebs_unitarray,_x];
				};
			} foreach allunits;
		sleep 5;
		};
	};	

// CHANGE UNIFORM COLOURS FOR DEBUGGING
tpw_ebs_fnc_red =
		{
		private ["_unit"];
		_unit = _this select 0;
		_unit setObjectTexture [0,"#(argb,8,8,3)color(1,0,0,1,ca)"];  
		};
		
tpw_ebs_fnc_yellow =
		{
		private ["_unit"];
		_unit = _this select 0;
		_unit setObjectTexture [0,"#(argb,8,8,3)color(1,1,0,1,ca)"];  
		};

tpw_ebs_fnc_green =
		{
		private ["_unit"];
		_unit = _this select 0;
		_unit setObjectTexture [0,"#(argb,8,8,3)color(0,1,0,1,ca)"];  
		};

tpw_ebs_fnc_blue =
		{
		private ["_unit"];
		_unit = _this select 0;
		_unit setObjectTexture [0,"#(argb,8,8,3)color(0,0,1,1,ca)"];  
		};		
	
//////////
// RUN IT
//////////

// DELAY
sleep  tpw_ebs_sleep;

// SUPPRESSION TYPE
if (tpw_ebs_suptype == 1) then 
	{
	0 = [] spawn tpw_ebs_fnc_shell; // shell based
	} else
	{
	0 = [] spawn tpw_ebs_fnc_apply; // bullet centric
	};

// AI SUPPRESSION 
if (tpw_ebs_aisup == 1) then 
	{
	0 = [] spawn tpw_ebs_fnc_screen;
	0 = [] spawn tpw_ebs_fnc_procsup;
	};
	
// PLAYER SUPPRESSION 
if (tpw_ebs_playersup == 1) then
	{
	0 = [] spawn tpw_ebs_fnc_playersup;
	};

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
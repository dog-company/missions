/*
TPW FALL - Units react to bullet hits and jumping from height
Version: 1.57
Author: tpw, Das Attorney, MrFlay
Date: 20170711
Requires: CBA A3, tpw_core.sqf, tpw_bleedout recommended
Compatibility: SP, MP client (maybe)

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_fall.sqf
2 - Call it with 0 = [100,500,10,45,0.2] execvm "tpw_fall.sqf"; where 100 = sensitivity, 500 = radius around player to apply fall effects, 10 = start delay, 45 = maximum time (sec) a unit will be incapacitated by a bullet hit, 0.2 = damage threshold above which ragdolling will occur (0 = no reaction to bullet hits, 0.05 = always ragdoll falls, 1 = always animated falls)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if ((count _this) < 5) exitWith {hint "TPW FALL incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

//READ IN VARIABLES
tpw_fall_version = "1.57"; // Version string
tpw_fall_sens = _this select 0;
tpw_fall_radius = _this select 1;
tpw_fall_delay = _this select 2;
tpw_fall_falltime = _this select 3;
tpw_fall_thresh = _this select 4;

// OTHER VARIABLES	
tpw_fall_int = 0.1; // how often is unit fall status polled (sec). 
tpw_fall_att = 25; // sound attenuation (m)	
tpw_fallunits = []; // Array of units who can fall
tpw_fall_active = true ; //Global enable/disable

// NOISE ARRAYS
tpw_fall_steparray = ["gravel_sprint_1","gravel_sprint_2","gravel_sprint_3","gravel_sprint_4","gravel_sprint_5","gravel_sprint_6","gravel_sprint_7"];// footstep noises for landing
tpw_fall_crawlarray = ["crawl_dirt_1","crawl_dirt_2","crawl_dirt_3","crawl_dirt_4","crawl_dirt_5","crawl_dirt_6","crawl_dirt_7"]; // crawl noises for fall after landing
tpw_fall_crawlarray2 = ["crawl_grass_01","crawl_grass_02","crawl_grass_03","crawl_grass_04","crawl_grass_05","crawl_grass_06","crawl_grass_07"]; // crawl noises for getting back up
tpw_fall_splasharray = ["water_sprint_1","water_sprint_2","water_sprint_3","water_sprint_4","water_sprint_5","water_sprint_6","water_sprint_7","water_sprint_8"]; // splash noises for landing in water
tpw_fall_yellarray = ["p1_moan_01","p1_moan_02","p1_moan_03","p1_moan_04","p1_moan_05","p1_moan_06","p1_moan_07","p1_moan_08"]; // yells/gasps after hard landings

// ANIMATION ARRAYS - ANY GIVEN FALL ANIM HAS A MATCHING GETUP ANIM
tpw_fall_sw_fallarray = ["AmovPercMstpSrasWlnrDnon_AmovPpneMstpSnonWnonDnon"]; // launcher fall animations
tpw_fall_sw_getuparray = [""]; // launcher get up animations
tpw_fall_pw_fallarray = ["AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright","AmovPercMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft"]; // rifle fall animations
tpw_fall_pw_getuparray = ["AadjPpneMstpSrasWrflDright_AmovPercMstpSrasWrflDnon","AadjPpneMstpSrasWrflDleft_AmovPercMstpSrasWrflDnon"]; // rifle get up animations
tpw_fall_hw_fallarray = ["AmovPercMstpSrasWpstDnon_AadjPpneMstpSrasWpstDleft","AmovPercMstpSrasWpstDnon_AadjPpneMstpSrasWpstDright"]; // pistol fall animation
tpw_fall_hw_getuparray = ["AadjPpneMstpSrasWpstDleft_AmovPercMstpSrasWpstDnon","AadjPpneMstpSrasWpstDright_AmovPercMstpSrasWpstDnon"]; // pistol get up animations
tpw_fall_nw_fallarray = ["aparpercmstpsnonwnondnon_amovppnemstpsnonwnondnon"]; // unarmed fall animations
tpw_fall_nw_getuparray = ["AmovPpneMstpSrasWnonDnon_AmovPercMstpSnonWnonDnon"]; //unarmed get up animations
tpw_fall_sprintarray = ["AmovPercMsprSnonWnonDf_AmovPpneMstpSnonWnonDnon"]; // fall from sprinting

tpw_fall_pw_crouchfallarray = ["AmovPknlMstpSrasWrflDnon_AadjPpneMstpSrasWrflDleft","AmovPknlMstpSrasWrflDnon_AadjPpneMstpSrasWrflDright"]; // rifle fall from crouch
tpw_fall_hw_crouchfallarray = ["AmovPknlMstpSrasWpstDnon_AadjPpneMstpSrasWpstDleft","AmovPknlMstpSrasWpstDnon_AadjPpneMstpSrasWpstDright"]; // pistol fall from crouch
tpw_fall_sw_crouchfallarray = ["AmovPknlMstpSnonWnonDnon_AmovPpneMstpSnonWnonDnon"]; // launcher fall from crouch
tpw_fall_nw_crouchfallarray = ["AmovPknlMstpSnonWnonDnon_AmovPpneMstpSnonWnonDnon"]; // unarmed fall from crouch

tpw_fall_nw_crouch = "AmovPercMstpSnonWnonDnon_AmovPknlMstpSnonWnonDnon"; // unarmed crouch animation
tpw_fall_hw_crouch = "AmovPercMstpSrasWpstDnon_AmovPknlMstpSrasWpstDnon"; // pistol crouch animation
tpw_fall_pw_crouch = "AmovPercMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"; // rifle crouch animation
tpw_fall_sw_crouch = "amovpercmstpsraswlnrdnon_amovpknlmstpsraswlnrdnon"; // launcher crouch animation

tpw_fall_nw_uncrouch = "AmovPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon"; // unarmed uncrouch animation
tpw_fall_hw_uncrouch = "AmovPknlMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon"; // pistol uncrouch animation
tpw_fall_pw_uncrouch = "AmovPknlMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon"; // rifle uncrouch animation
tpw_fall_sw_uncrouch = ""; // launcher uncrouch animation

tpw_fall_hitgetuparray = ["AmovPpneMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon","AmovPpneMstpSrasWpstDnon_AmovPercMstpSrasWpstDnon","AmovPpneMstpSrasWrflDnon_AmovPercMstpSrasWrflDnon","AmovPpneMstpSrasWlnrDnon_AmovPercMstpSrasWlnrDnon"]; // animations for getting up after ragdoll

// ARRAYS OF ANIMATION ARRAYS
tpw_fall_fallarrays = [tpw_fall_nw_fallarray,tpw_fall_hw_fallarray,tpw_fall_pw_fallarray,tpw_fall_sw_fallarray];
tpw_fall_crouchfallarrays = [tpw_fall_nw_crouchfallarray,tpw_fall_hw_crouchfallarray,tpw_fall_pw_crouchfallarray,tpw_fall_sw_crouchfallarray];
tpw_fall_fallcountarrays = [1,2,2,1]; // number of anims for each fallarray (and getuparray)
tpw_fall_getuparrays = [tpw_fall_nw_getuparray,tpw_fall_hw_getuparray,tpw_fall_pw_getuparray,tpw_fall_sw_getuparray];
tpw_fall_croucharray = [tpw_fall_nw_crouch,tpw_fall_hw_crouch,tpw_fall_pw_crouch,tpw_fall_sw_crouch];
tpw_fall_uncroucharray = [tpw_fall_nw_uncrouch,tpw_fall_hw_uncrouch,tpw_fall_pw_uncrouch,tpw_fall_sw_uncrouch];

// DELAY
sleep tpw_fall_delay;

// FALL NOISES
tpw_fall_fnc_noise = 
	{
	private ["_unit","_noisearray","_noise","_procnoise"];
	_unit = _this select 0;
	_noisearray = _this select 1;
	_noise = _noisearray select (floor (random (count _noisearray)));	
	_procnoise = format ["A3\sounds_f\characters\crawl\%1.wss",_noise];
	playSound3D [_procnoise,_unit,false,getposasl _unit,1,1,tpw_fall_att];
	};

// YELL
tpw_fall_fnc_yell = 
	{
	private ["_vol","_unit","_yell","_yellsound"];
	_vol = _this select 0;
	_unit = _this select 1;
	_yell = tpw_fall_yellarray select (floor (random (count tpw_fall_yellarray)));
	_yellsound = format ["a3\sounds_f\characters\human-sfx\person1\%1.wss",_yell];
	playSound3D [_yellsound,_unit,false,getposasl _unit,_vol,0.85,tpw_fall_att]; 
	};
	
// FREEFALL NOISE
tpw_fall_fnc_freefall = 
	{
	if ((getpos player) select 2 < 50 ) exitwith {};
	sleep 1;	
	// Play freefall noise		
	playmusic "freefallwind";
	2 fadeMusic 1;
	
	// Wait until slow enough
	waituntil
		{
		sleep 0.5;
		(abs (velocity player select 2) < 5 || !(alive player)) 
		};
	playmusic "chutewind";
	
	// Wait until on ground
	waituntil
		{
		sleep 1;
		((istouchingground player) || !(alive player)) 
		};
	playmusic "";
	2 fadeMusic 0.5;
	};

	
// DISABLE HIT UNIT
tpw_fall_fnc_disable = 
	{
	private ["_unit","_sleep"];
	_unit = _this select 0;
	
	// Dead unit?
	if (!alive _unit) exitwith {};	
	
	// Add fatigue
	_unit setfatigue ((getfatigue _unit) + (damage _unit)); 
	
	// Player
	if (_unit == player) exitwith 
		{
		_unit setvariable ["tpw_fallstate", 0];
		};
	
	// How long to immobilise?
	_sleep = (damage _unit) * tpw_fall_falltime;	
	
	// Keep unit writhing immobile on ground
	private _ct = 0;	
	waituntil
		{
		sleep 1;
		_ct = _ct + 1;
		(animationstate _unit == "unconsciousrevivedefault" || _ct == 10)
		};
	_unit setunconscious false;
	[_unit] call tpw_core_fnc_disable;
	
	// Don't re-enable highly injured unit, let BLEEDOUT take over if active
	if (!(isnil "tpw_bleedout_ithresh") && {damage _unit > tpw_bleedout_ithresh}) exitwith
		{
		_unit setvariable ["tpw_fallstate", 0];
		};
	sleep _sleep;
	
	// Unit can move and get up
	[_unit] call tpw_core_fnc_enable;
	
	// Reset fall status
	_unit setvariable ["tpw_fallstate", 0];
	};

// SETUNCONSCIOUS RAGDOLL FALL - AI
tpw_fall_fnc_sucfall =
	{
	private ["_unit","_sleep"];
	_unit = _this select 0;

	// Drop unit
	_unit setunconscious true;
	_unit setcaptive true;
	_unit setVariable["BIS_revive_disableRevive",true];

	// Disable it
	[_unit] call tpw_fall_fnc_disable;
	
	// Back up again
	if (_unit getvariable ["tpw_core_disabled",0] == 0) then
		{
		_unit setVariable["BIS_revive_disableRevive",false];
		};
	};
	
// PHYSX RAGDOLL FALL (DAS ATTORNEY) - PLAYER	
tpw_fall_fnc_physxfall = 
	{
	private ["_object","_unit","_sp","_ep","_vel","_dam"];
	_unit = _this select 0;
	_dam = damage _unit;
	
	// Spawn invisible Physx object and knock unit down with it
	_object = "FLAY_FireGeom" createVehicleLocal [666,666,666]; // Thanks to MrFlay for the original invisible geometry object
	_object setMass [300,0];
    _vel = velocity _unit; 
	_ep = eyePos _unit;
    _sp = [(_ep select 0)+((_vel select 0) * 0.1),(_ep select 1)+((_vel select 1) * 0.1), _ep select 2]; 
	_unit allowDamage false;
	_object setposasl _sp;
	_object setVelocity [0,0,-10];
	sleep 0.2;
	_unit allowDamage true;
	_unit setdamage _dam;
	deleteVehicle _object;

	// Falling noise 
	[_unit,tpw_fall_crawlarray] call tpw_fall_fnc_noise;
	};		
	

// ANIMATED FALL DOWN / GET UP - AI
tpw_fall_fnc_falldown = 
	{
	private ["_unit","_weptype","_realdist","_fatigue","_move","_crawl","_crawlsound","_fallarray","_fallanim","_getuparray","_getupanim","_crawl2","_crawlsound2","_skill","_sleep","_stance"];
	_unit = _this select 0;
	_stance = stance _unit;
	if (_stance in ["PRONE","UNDEFINED"]) exitwith {_unit setvariable ["tpw_fallstate", 0];};
	[_unit] call tpw_core_fnc_weptype;
	_weptype = _unit getvariable "tpw_core_weptype";
	_realdist = _unit getvariable "tpw_fallstate";

	// Fall to ground animation
	if (_stance == "STAND") then
		{ 
		_fallarray = tpw_fall_fallarrays select _weptype;
		};
	if (_stance == "CROUCH" || asltoagl (eyepos _unit) select 2 < 1.5) then
		{
		_fallarray = tpw_fall_crouchfallarrays select _weptype;
		};	
	_fallcount = tpw_fall_fallcountarrays select _weptype;
	_animselect = floor random _fallcount;
	_fallanim = _fallarray select _animselect;
	
	// Dive to ground if sprinting
	if (speed _unit > 12 && !(_weptype == 2)) then 
		{
		_fallanim = "AmovPercMsprSnonWnonDf_AmovPpneMstpSnonWnonDnon";
		};	
	
	if (speed _unit > 12 && _weptype == 2) then 
		{
		_unit switchmove "AmovPercMsprSlowWrflDf_AmovPpneMstpSrasWrflDnon";
		sleep 0.833;
		_unit switchmove "AmovPercMsprSlowWrflDf_AmovPpneMstpSrasWrflDnon_2";
		} else
		{
		_unit addweapon "hgun_P07_F";
		_unit switchmove _fallanim;
		sleep 2;
		_unit removeweapon "hgun_P07_F";
		};
		
	// Random falling noise
	sleep 1;
	[_unit,tpw_fall_crawlarray] call tpw_fall_fnc_noise;

	// Disable unit on ground if fall was from hit
	if  (_unit getvariable "tpw_fallstate" == 10) then
		{
		sleep random 5;
		};

	// Get back up animation
	_getuparray = tpw_fall_getuparrays select _weptype;
	_getupanim = _getuparray select _animselect;
	_unit playmove _getupanim;
	if (_weptype == 0) then 
		{
		_unit switchmove _getupanim; // unarmed crouch won't uncrouch with playmove
		}
		else
		{
		_unit playmove _getupanim;		
		};
		
	// Random get up noise
	sleep 0.5;
	[_unit,tpw_fall_crawlarray2] call tpw_fall_fnc_noise;
	
	// Add fatigue
	_fatigue = getfatigue _unit;
	_unit setfatigue (_fatigue + (0.1 *_realdist)); 
	
	//Reset fall status	
	_unit setvariable ["tpw_fallstate", 0];		
	};

// ANIMATED PLAYER FALL (NO AUTOMATIC GET UP)
tpw_fall_fnc_playerfall = 
	{
	private ["_stance","_unit","_weptype","_realdist","_fatigue","_move","_crawl","_crawlsound","_fallarray","_fallanim"];
	_unit = player;
	_stance = stance _unit;
	if (_stance in ["PRONE","UNDEFINED"]) exitwith
		{
		_unit setvariable ["tpw_fallstate", 0];	
		};
	[_unit] call tpw_core_fnc_weptype;
	_weptype = _unit getvariable "tpw_core_weptype";
	_realdist = _unit getvariable "tpw_fallstate";
	
	// Fall to ground animation
	if (_stance == "STAND") then
		{
		_fallarray = tpw_fall_fallarrays select _weptype;
		};
	if (_stance == "CROUCH") then
		{
		_fallarray = tpw_fall_crouchfallarrays select _weptype;
		};		
	
	_fallcount = tpw_fall_fallcountarrays select _weptype;
	_animselect = floor random _fallcount;
	_fallanim = _fallarray select _animselect;
	
	if (speed _unit > 12 && !(_weptype == 2)) then 
		{
		_fallanim = "AmovPercMsprSnonWnonDf_AmovPpneMstpSnonWnonDnon";
		};	
	
	_unit switchmove _fallanim;

	// Random falling noise
	sleep 1;
	[_unit,tpw_fall_crawlarray] call tpw_fall_fnc_noise;
	
	// Add fatigue
	_fatigue = getfatigue _unit;
	_unit setfatigue (_fatigue + (0.1 *_realdist)); 
	
	//Reset fall status	
	_unit setvariable ["tpw_fallstate", 0];		
	};	
	
// CROUCH / UNCROUCH - AI & PLAYER
tpw_fall_fnc_crouch = 
	{
	private ["_unit","_realdist","_weptype","_crouchanim","_uncrouchanim","_skill"];
	_unit = _this select 0;
	[_unit] call tpw_core_fnc_weptype;
	_weptype = _unit getvariable "tpw_core_weptype";
	_realdist = _unit getvariable "tpw_fallstate";
	
	// Crouch
	_crouchanim = tpw_fall_croucharray select _weptype;
	_unit playmove _crouchanim;
	
	// Uncrouch
	_uncrouchanim = tpw_fall_uncroucharray select _weptype;	
	if (_weptype == 0) then 
		{
		_unit switchmove _uncrouchanim; // unarmed crouch won't uncrouch with playmove
		}
		else
		{
		_unit playmove _uncrouchanim;		
		};
		
	// Add fatigue
	_fatigue = getfatigue _unit;
	_unit setfatigue (_fatigue + (0.1 *_realdist)); 
	
	//Reset fall status	
	_unit setvariable ["tpw_fallstate", 0];	
	_unit setunitpos "auto";
	};	

// PROCESS FALL - DETERMINE STATUS BASED ON DISTANCE, WEAPON, WEIGHT, FATIGUE ETC	
tpw_fall_fnc_fallproc =
	{
	private ["_unit","_realdist","_posx","_posy","_weptype","_fatigue","_dist","_zstart","_zstop","_vol","_step","_stepsound","_splash","_splashsound","_weight","_margin","_paraflag"];
	_unit = _this select 0;
	_unit setvariable ["tpw_fallstate",0.1]; //will stop a fall being retriggered on unit until the current fall is complete

	// Freefall noise
	if (_unit == player) then 
		{
		[_unit] spawn tpw_fall_fnc_freefall;
		};

	//Calculate vertical distance traveled when unit touches ground again. 
	_zstart = (getposasl _unit) select 2;
	_zstop = 0;
	_paraflag = 0;
	waituntil
		{
		_zstop = (getposasl _unit) select 2;
		if (vehicle _unit iskindof "ParachuteBase") then // has unit deployed chute?
			{
			_paraflag = 1;
			};	
		sleep tpw_fall_int;
		((istouchingground _unit)||(_zstop < 0)); // unit touching ground or below sea (water) level
		};	
	_realdist = abs(_zstart - _zstop);

	if (_paraflag == 1) then 
		{
		_realdist = 1;
		};
		
	//Fatigue will add an extra distance to the fall, so tired units are more likely to fall
	_fatigue = getfatigue _unit;
	_realdist =  _realdist + _fatigue;
	
	//Weight will add extra distance to the fall, so heavier units are more likely to fall
	_weight = load _unit;
	_realdist =  _realdist + _weight;

	// Randomise the distance by +/- 10%	
	_margin = _realdist / 10;
	_realdist = _realdist - _margin + (random (2 * _margin));
	_unit setvariable ["tpw_fallstate",_realdist];	
	
	// Treat all falls past 2m as the same, apply sensitivity
	 _realdist =_realdist * (tpw_fall_sens / 100);
	_dist = floor _realdist;
	if (_dist > 2) then
		{
		_dist = 2;
		};

	// Unit in water? 	
	_posx = (getpos _unit) select 0;
	_posy = (getpos _unit) select 1;
	if (((surfaceiswater [_posx,_posy])) && (_zstart > 0)) then 		
		{
		_dist = 5;
		}; 

	// Footstep sounds for landing
	if !(surfaceiswater [_posx,_posy]) then
		{
		_vol = (_realdist * 0.5); // longer fall = louder volume
		_step = tpw_fall_steparray select (floor (random (count tpw_fall_steparray)));
		_stepsound = format ["A3\sounds_f\characters\footsteps\%1.wss",_step];
		playSound3D [_stepsound,_unit,false,getposasl _unit,_vol,0.7,tpw_fall_att]; // initial thump of feet

		//Yell (eg 2m fall will yell 40% of the time)
		if (random 100 < (_realdist * 20)) then 
			{
			[1,_unit] call tpw_fall_fnc_yell;
			};		
		};
 
	// Play appropriate animations and noises for different heights and weapons
	switch _dist do
		{
		case 1: 
			{
			0 = [_unit] call tpw_fall_fnc_crouch;
			};
		case 2: 
			{
			if (_unit == player) then 
				{
				0 = [_unit] call tpw_fall_fnc_playerfall;
				}
				else
				{
				0 = [_unit] call tpw_fall_fnc_falldown;
				};
			};
		case 5:
			{
			// Random splashing noise
			_vol = _realdist; // higher jump = louder splash
			_splash = tpw_fall_splasharray select (floor (random (count tpw_fall_splasharray))); 
			_splashsound = format ["A3\sounds_f\characters\footsteps\%1.wss",_splash];
			playSound3D [_splashsound,_unit,false,getposasl _unit,_vol,0.3,tpw_fall_att]; 
			};
		};
		
	//Reset fall status	
	_unit setvariable ["tpw_fallstate", 0];			
	};	
	
// PROCESS HIT
tpw_fall_fnc_hitproc = 
	{
	private ["_unit","_yell","_yellsound","_skill","_damage","_falltype","_thresh"];
	_unit = _this select 0;

	// Only bother if live unit is not in vehicle and not already falling
	if (!alive _unit || _unit != vehicle _unit || _unit getvariable "tpw_fallstate" != 0) exitwith {}; 
	
	// Can't shoot medics
	if ((animationstate _unit) in ["ainvpknlmstpslaywrfldnon_medic","ainvppnemstpslaywrfldnon_medic"]) exitwith {};
	
	// Small chance of unit not reacting to hit
	if (random 1 > 0.9) exitwith {};
	
	// Randomise hit threshold
	_thresh = random tpw_fall_thresh;

	// Grab unit damage and set its fallstate so that it can't fall again until this fall is completed.
	_damage = _this select 2;
	_unit setvariable ["tpw_fallstate", 10];

	// Yell if hit
	[3,_unit] call tpw_fall_fnc_yell;


	// Player hit?
	if (_unit == player) then
		{
		if (_damage < _thresh) exitwith
			{
			[] spawn tpw_fall_fnc_playerfall; // animated fall
			}; 
		if (_damage > _thresh) exitwith
			{
			[player] spawn tpw_fall_fnc_physxfall; // physx object fall
			};	
		} else
		{
		// AI
		if (_damage < _thresh) exitwith
			{
			[_unit] spawn tpw_fall_fnc_falldown; // animated fall
			};
		if (_damage > _thresh) exitwith
			{
			[_unit] spawn tpw_fall_fnc_sucfall; // setuncscious ragdoll player fall
			};
		};		
	};
	
////////////
// RUN IT
////////////

// ADD TURNING AND ROLLING SOUNDS
player addeventhandler ["animstatechanged",
{
_anim = _this select 1;
if ( // Prone turning animations
_anim == "AmovPpneMstpSrasWrflDnon_Turnr" ||
_anim == "AmovPpneMstpSrasWrflDnon_Turnl" ||
_anim == "AmovPpneMstpSrasWpstDnon_Turnr" ||
_anim == "AmovPpneMstpSrasWpstDnon_Turnl"
) then 
	{
	_sound = format ["A3\sounds_f\characters\crawl\Dirt_crawl_%1.wss",ceil random 7];
	playSound3D [_sound,player,false,getposasl player,0.5,1,25];
	};
}];

// PERIODICALLY SCAN APPROPRIATE UNITS INTO ARRAY OF "FALLABLE" UNITS
tpw_fall_fnc_scan =
	{
	while {true} do
		{
		tpw_fallunits = allunits select {_x distance player < tpw_fall_radius && {_x == vehicle _x} && {_x getvariable ["tpw_crowd_move",-1] == -1}};
				{
				if (_x getvariable ["tpw_fall_eh",0] == 0 && {tpw_fall_thresh > 0}) then
					{
					_x addeventhandler ["hit",{_this call tpw_fall_fnc_hitproc}]; 				
					_x setvariable ["tpw_fall_eh",1];
					_x setvariable ["tpw_fallstate",0];
					};
					
				// Reset units	
				if (_x getvariable "tpw_fallstate" > 0 && {asltoagl (eyepos _x) select 2 > 0.5}) then
					{
					_x setvariable ["tpw_fallstate",0];
					_x enableai "anim";
					_x enableai "move";
					_x enableai "target";
					_x enableai "autotarget";
					_x enableai "fsm";
					};
				} count tpw_fallunits;
		sleep 11.33;
		};
	};	

// MAIN FALL MONITORING LOOP - DETERMINE IF A UNIT HAS LEFT THE GROUND (IE BEGUN TO FALL)
[] spawn tpw_fall_fnc_scan;
while {true} do
	{
	private ["_i","_unit"];
	for "_i" from 0 to (count tpw_fallunits - 1) do
		{
		_unit = tpw_fallunits select _i;
		//Only bother if footbound unit not already falling
		if (_unit getvariable "tpw_fallstate" == 0) then 
			{
			// Is unit in air from a fall?
			if (!istouchingground _unit && _unit == vehicle _unit) then 
				{
				_unit setfatigue 0;
				[_unit] spawn tpw_fall_fnc_fallproc;
				};
			};
		};
	sleep tpw_fall_int;
	};	
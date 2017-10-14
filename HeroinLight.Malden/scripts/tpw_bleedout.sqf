/*
TPW BLEEDOUT - Units will bleed out if not healed after injury
Author: tpw
Version: 1.32
Date: 20170710
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 	

To use: 
1 - Save this script into your mission directory as eg tpw_bleedout.sqf
2 - Call it with 0 = [5,0.8, 1, 1, 1] execvm "tpw_bleedout.sqf"; where 5 = damage increment, 0.4 = crouch threshold, 0.6 = prone threshold, 0.8 incapacitation threshold, 1 = player heartbeat screeenshake, 1 = AI unit self heal, 1 = Speed and skill are reduced by damage
	
THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this  < 5) exitwith {hint "TPW BLEEDOUT incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

//VARIABLES
tpw_bleedout_version = "1.32"; // Version string
tpw_bleedout_inc = _this select 0 ; // Damage increment. The percentage a bleeding unit's damage will increase by each 10 sec. 1% will take 10+ minutes to bleed out
tpw_bleedout_ithresh = _this select 1; // Damage beyond which a unit will writhe around incapacitated
tpw_bleedout_heartbeat = _this select 2; // Player heartbeat visible as slight screen shake
tpw_bleedout_selfheal = _this select 3; // AI units will automatically try to stop their own bleeding if equipped with First Aid Kits
tpw_bleedout_affect = _this select 4; // AI units speed and skill are affected by damage

// DFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_bleedout_inc = 5 ;
	tpw_bleedout_ithresh = 0.85;
	};

tpw_bleedout_inc = tpw_bleedout_inc / 100; // convert percentage damage to 0-1 value
tpw_bleedout_active = true; // global enable/disable

// Announce FAK usage
tpw_bleedout_fakarray = ["Hold up, applying FAK","Trying to stem bleeding with FAK","Using FAK","Gonna see if I can stem the bleeding","Applying FAK"];

// MOAN
tpw_bleedout_fnc_moan = 
	{
	private ["_unit","_moansound","_vol"];
	sleep random 3;
	_vol = random 1;
	_unit = _this select 0;
	_moansound = format ["a3\sounds_f\characters\human-sfx\person2\P2_breath_damage_high_0%1.wss",ceil random 10 ];
	playSound3D [_moansound,_unit,false,eyepos _unit,_vol,0.85,10]; 
	};

// WRITHING
tpw_bleedout_fnc_writhe = 
	{
	private ["_unit"];
	_unit = _this select 0;

	// Flag it
	_unit setvariable ["tpw_bleedout_writhe",1];
	
	// Make unit lie down on back if not already doing so
	if (animationstate _unit != "acts_InjuredLyingRifle02_180") then
		{
		// Unit passes out 
		_unit setunconscious true;
		_unit setcaptive true;
		private _ct = 0;
		waituntil
			{
			sleep 1;
			_ct = _ct + 1;
			(animationstate _unit == "unconsciousrevivedefault" || _ct == 10)
			};
		};

	// Writhing animation, disable all behaviours
	_unit setunconscious false;
	[_unit] call tpw_core_fnc_disable;
	};	

// STOP WRITHING
tpw_bleedout_fnc_unwrithe = 
	{
	private ["_unit"];
	_unit = _this select 0;		
	
	// Flag it 
	_unit setvariable ["tpw_bleedout_writhe",0];
	
	// Reenable movement, stand up
	[_unit] call tpw_core_fnc_enable;
	};	
	
// HEALED
tpw_bleedout_fnc_healed =
	{
	private ["_unit"];
	_unit = _this select 0;
	
	// Stop bleeding
	_unit setBleedingRemaining 0; 
	_unit setvariable ["tpw_bleedout_damage",damage _unit];
	};
	
// STEM OWN BLEEDING	
tpw_bleedout_fnc_fak = 	
	{
	private ["_unit","_rnd","_d"];
	_unit = _this select 0;
	if (_unit getvariable ["tpw_bleedout_fak",0] == 1) exitwith {};
	
	if ("FirstAidKit" in items _unit ||
	"FirstAidKit" in vestitems _unit ||
	"FirstAidKit" in backpackitems _unit) then
		{
		_unit setvariable ["tpw_bleedout_fak",1];
		_unit groupchat (tpw_bleedout_fakarray select (floor (random (count tpw_bleedout_fakarray))));
		_unit removeitem "FirstAidKit"; // remove first aid kit
		if ((asltoagl eyepos _unit) select 2 > 0.5) then 
			{
			_unit playmove "ainvpknlmstpslaywrfldnon_medic";
			}
		else
			{
			_unit playmove "ainvppnemstpslaywrfldnon_medic";
			};
		_unit setvariable ["tpw_bleedout_fak",0];	
			
		// The worse the injury the less chance a given treatment will stop bleeding
		_rnd = random 1.5;
		_d = damage _unit;
		if ((_rnd * 1.5) > _d) then
			{
			[_unit] spawn tpw_bleedout_fnc_healed; 
			};	
		};
	};
		
// HEART BEAT
if (tpw_bleedout_heartbeat == 1) then
	{
	0 = [] spawn 
		{
		private ["_delay","_int","_hlt","_dm","_ft","_factor","_bpm"];
		_bpm = 60;
		while {alive player} do
			{
			if (time > player getvariable ["tpw_nextbeat",0]) then
				{
				_hlt = round (100 * (1 - damage player));
				_ft = (getfatigue player); // fatigue 
				_dm = (damage player) ^ 2; // damage squared	
				_factor = (1 + (3 * _ft) * (1 + _dm)); // heartrate factor
				if (_factor > 3) then
					{
					_factor = 3;
					};
				_bpm = floor (60 * _factor);
				_delay = 60 / _bpm;
				_int = ((_bpm - 60) / 180) ^ 1.75;
				addcamshake [_int,0.2,20];
				player setvariable ["tpw_nextbeat",(time + _delay)];
				};
			sleep 0.2;
			};	
		};
	};	

// MAIN LOOP
sleep random 2;
while {true} do
	{
	// Any other players with TPW BLEEDOUT active?
	if (ismultiplayer) then
		{
			{
			_unit = _x;
			if ((isplayer _unit) && (_unit != player) && (_unit getvariable "tpw_bleedout" == 1)) exitwith 
				{
				tpw_bleedout_active = false; 
				};
			} foreach playableUnits;
		
		if (tpw_bleedout_active) then
			{
			player setvariable ["tpw_bleedout",1,true];
			} else
			{
			player setvariable ["tpw_bleedout",0,true];
			};
		};
	
	// Eligible units 
	if (tpw_bleedout_active) then
		{
		tpw_bleedout_units = allunits select {_x getvariable ["tpw_crowd_move",-1] == -1}; // no bleedout for crowd civs
		
		private ["_dam","_unit","_speed","_skill","_d","_rnd"];
			{
			_unit = _x;
			
			// Add eventhandler for when unit is healed
			if (_unit getvariable ["tpw_bleedout_healeh",0] == 0) then
				{
				_unit addeventhandler ["handleheal",{[_this select 0] spawn tpw_bleedout_fnc_healed}];
				_unit setvariable ["tpw_bleedout_healeh",1];
				};
				
			// Speed and skill dependent on health	
			if (tpw_bleedout_affect == 1) then
				{
				// Initial speed and skills	
				if (_unit getvariable ["tpw_animspeed",-1] == -1) then
					{
					_unit setvariable ["tpw_animspeed",getanimspeedcoef _unit];
					};
				if (_unit getvariable ["tpw_skill",-1] == -1) then
					{
					_unit setvariable ["tpw_skill",skill _unit];
					};
				_speed = (_unit getvariable "tpw_animspeed") * (1 - (0.2 * damage _unit));	
				_unit setanimspeedcoef _speed; 				
				_skill = (_unit getvariable "tpw_skill") * (1 - damage _unit);
				_unit setskill _skill; 
				};
			
			// If unit is bleeding:
			if (alive _unit && {_unit getvariable ["tpw_bleedout_ignore",0] == 0} && {isbleeding _unit}) then 
				{
				// Increase unit damage and fatigue, keep them bleeding
				_dam = (damage _unit) + (tpw_bleedout_inc * damage _unit);
				if ((_unit getvariable ["tpw_bleedout_nodeath",0] == 1) && (_dam > 0.99)) then
					{
					_dam = damage _unit;
					};
				_unit setdamage _dam;
				_unit setfatigue _dam;
				_unit setvariable ["tpw_bleedout_damage", _dam];
				_unit setBleedingRemaining 60;
				_unit setHitPointDamage ["hitLegs", _dam];	
				};

			// Moan if injured	
			if (_unit != player && {_unit == vehicle _unit} && {damage _unit > tpw_bleedout_ithresh}) then
				{
				[_unit] spawn tpw_bleedout_fnc_moan;
				};
			
			// Self heal
			if (_unit != player && {_unit == vehicle _unit} && {_unit getvariable ["tpw_bleedout_writhe",0] == 0} && {_unit getvariable ["tpw_fallstate",0] == 0} && {_unit getvariable ["tpw_bleedout_fak",0] == 0}) then 
				{
				// Self heal minor bleeding if unit has medkit 
				if (tpw_bleedout_selfheal == 1 && {isbleeding _unit}) then 
					{
					_rnd = random 2.5;
					_d = damage _unit;
					if (_rnd < _d && {_d < tpw_bleedout_ithresh}) then
						{
						[_unit] spawn tpw_bleedout_fnc_fak;
						};
					};
				// Writhe around immobile if too much damage		
				if (damage _unit > tpw_bleedout_ithresh && {_unit getvariable ["tpw_bleedout_writhe",0] == 0}) then 
					{
					[_unit] spawn tpw_bleedout_fnc_writhe; 
					};
				};
				
			// Healthy units stop writhing
			if ((damage _unit < tpw_bleedout_ithresh) && {animationstate _unit == "acts_InjuredLyingRifle02_180"}) then
				{
				[_unit] spawn tpw_bleedout_fnc_unwrithe;
				};
			}	foreach tpw_bleedout_units;
		
		// Stop dead units from writhing
			{
			_unit = _x;
			_unit setunconscious false;
			if (_unit getvariable "tpw_bleedout_writhe" == 1) then 
				{
				_unit switchmove "AinjPpneMstpSnonWrflDnon_rolltofront";
				_unit setvariable ["tpw_bleedout_writhe",0];
				};
			} count alldead;
		};
	sleep 9.87;
	};

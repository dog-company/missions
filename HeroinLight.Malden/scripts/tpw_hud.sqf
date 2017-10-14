/* 
TPW HUD - Realistic Heads Up Display for Tactical Goggles
Author: tpw
Additional code: hypnomatic 
Date: 20170714
Version: 1.65
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client
 
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.   

To use: 
1 - Save this script into your mission directory as eg tpw_hud.sqf
2 - Call it with 0 = 
[
[50,500], // Min/max range of goggles
[1,1,1], // HUD colour
[0,1,1], // Friendly colour
[1,0.5,0], // Enemy units colour
[1,1,1], // Civ colour
[0,1,0], // Squad and marker colour
0.6, // Initial HUD brightness
[1,0.4,0.4,1], // ASL where 1 = active ( 0 = inactive), 0.4 = X position, 0.4 = Y position, 1 = text size
[1,0.5,0.4,1], // AZT 
[1,0.6,0.4,1], // GRD 
[1,0.4,0.5,1], // LMT 
[1,0.6,0.5,1], // TMP 
[1,0.4,0.6,1], // HLT 
[1,0.5,0.6,1], // RNG 
[1,0.6,0.6,1], // VEL 
[1,0.5,0.5,1], // PRX 
[1,1,0.25,0.5], // UNITS where 1 = active ( 0 = inactive), 1 = icon max size, 0.25 = icon min size, 0.5 = text size ( 1 = same size as HUD text)
[0.03,0], //HUD offset [x,y] -1 to 1 
1, // HUD scale. > 1 = larger
1, // Text scale. > 1 = larger
1, // HUD distance degradation. 0 = no degradation
0, // No HUD in 3rd person. 1 = HUD in 3rd person
1, // Add TAC glasses to player's uniform if not present. 0 = don't add
[24,23,30,29,24,23,30,29,22,20], // ICONS [unit,hidden unit,vehicle,hidden vehicle,enemy unit,hidden enemy unit,enemy vehicle,hidden enemy vehicle,marker,predictor]
1.5, // Detection range multiplication factor for vehicles (1.5 = 750m max detection range for vehicles vs 500m for units)  
1, // Audible warning when enemies detected 
["your_goggles","your_goggles2"], //classnames of any 3rd party goggles you want HUD to work with
["your_headgear","your_headgear2"] // classnames of any 3rd party headgear you want HUD to work with
] execvm "tpw_hud.sqf"; 

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
WaitUntil {!isNull FindDisplay 46};
if (count _this < 28) exitwith {hint "TPW HUD incorrect/no config, exiting."};
WaitUntil {!isnil "tpw_core_sunangle"};

//VARIABLES
tpw_hud_version = "1.65";
tpw_hud_range = _this select 0;
tpw_hud_colour = _this select 1; // HUD 
tpw_hud_friendlycolour = _this select 2; // Friendlies
tpw_hud_enemycolour = _this select 3; // Enemies
tpw_hud_civcolour = _this select 4; // Civs 
tpw_hud_squadcolour = _this select 5; // Squad and markers
tpw_hud_alpha = _this select 6; // initial HUD brightness
tpw_hud_asl = _this select 7; // ASL
tpw_hud_azt = _this select 8; // AZT
tpw_hud_grd = _this select 9; // GRD
tpw_hud_lmt = _this select 10; // LMT
tpw_hud_tmp = _this select 11; // TMP
tpw_hud_hlt = _this select 12; // HLT
tpw_hud_rng = _this select 13; // RNG
tpw_hud_vel = _this select 14; // VEL
tpw_hud_prx = _this select 15; // PRX
tpw_hud_unit = _this select 16; // UNITS
tpw_hud_offset = _this select 17; // Offset
tpw_hud_scale = _this select 18; // Scale
tpw_hud_textscale = _this select 19; // Text scale
tpw_hud_degradation = _this select 20; // HUD degradation
tpw_hud_thirdperson = _this select 21; // No HUD in 3rd person view
tpw_hud_addtac = _this select 22; // Add TAC glasses
tpw_hud_icons = _this select 23; // Icon types
tpw_hud_vehiclefactor = _this select 24; // Range factor for vehicles 
tpw_hud_audible = _this select 25; // Audio ticks for nearby units
tpw_hud_extragoggles = _this select 26; // 3rd party goggles
tpw_hud_extraheadgear = _this select 27; // 3rg party headgear

// DEFAULT HUD ELEMENT LAYOUT (SCRIPT VERSION)
tpw_hud_asl_txt = "%1<t size='0.5'><br />ASL</t>";
tpw_hud_atl_txt = "%1<t size='0.5'><br />AGL</t>";
tpw_hud_azt_txt = "%1<t size='0.5'><br />AZT %2</t>";
tpw_hud_grd_txt = "%1<t size='0.5'><br />GRD</t>";
tpw_hud_lmt_txt = "%1%2<t size='0.5'><br />LMT</t>";
tpw_hud_tmp_txt = "%1<t size='0.5'><br />TMP</t>";
tpw_hud_hlt_txt = "%2<t size='0.5'><br />BPM %1</t>";
tpw_hud_rng_txt = "%1<t size='0.5'><br />RNG</t>";
tpw_hud_vel_txt = "%1<t size='0.5'><br />VEL</t>";
tpw_hud_airvel_txt = "%1<t size='0.5'><br />VEL KTS</t>";
tpw_hud_prx_txt = "<t color='%5'>%1</t> <t color='%6'>%2</t> <t color='%7'>%3</t> <t color='%8'>%4</t><t size='0.5'><br />PRX</t>";

// GRAB HUD ELEMENT LAYOUT VALUES FROM CONFIG (IF ADDON VERSION ACTIVE)
if ((getnumber (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_fncactive")) == 1) then
	{ 
	tpw_hud_asl_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_asl_txt");
	tpw_hud_atl_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_atl_txt");
	tpw_hud_azt_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_azt_txt");
	tpw_hud_grd_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_grd_txt");
	tpw_hud_lmt_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_lmt_txt");
	tpw_hud_tmp_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_tmp_txt");
	tpw_hud_hlt_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_hlt_txt");
	tpw_hud_rng_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_rng_txt");
	tpw_hud_vel_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_vel_txt");
	tpw_hud_airvel_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_airvel_txt");
	tpw_hud_prx_txt = gettext (configfile >> "TPW_MODS_Key_Setting" >> "tpw_hud_prx_txt");
	};

// INITIAL VARIABLES	
tpw_hud_eh=false;
tpw_hud_active = true;
tpw_hud_fncactive=true;
tpw_hud_params =[tpw_hud_asl,tpw_hud_azt,tpw_hud_grd,tpw_hud_lmt,tpw_hud_prx,tpw_hud_tmp,tpw_hud_hlt,tpw_hud_rng,tpw_hud_vel];
tpw_hud_offset_x = tpw_hud_offset select 0;
tpw_hud_offset_y = tpw_hud_offset select 1;
tpw_hud_minrange = tpw_hud_range select 0;
tpw_hud_maxrange = tpw_hud_range select 1;
tpw_hud_vehiclerange = tpw_hud_maxrange * tpw_hud_vehiclefactor;
tpw_hud_markers = [];
tpw_hud_gogglewearers = [];
tpw_hud_nearunits = [];
tpw_hud_muzvel = 800;
tpw_hud_feh=false;
tpw_hud_nvflag = false;
tpw_hud_nv = false;
tpw_nv_fac = 0;
tpw_nv_brightness = [5,2,1,0.5,0.25,0.125];
tpw_hud_visible = []; 
tpw_hud_hidden = [];
tpw_hud_unsure = [];
tpw_hud_restingheartrate = floor (55 + (random 10));
tpw_hud_traceflag = 0;
tpw_hud_prevenemies = 0;
tpw_hud_tracer_tracedUnits = [];
tpw_hud_traceactive = 0;
tpw_hud_farunits = [];
tpw_hud_farvehicles = [];
tpw_hud_goggletypes = ["G_Tactical_Black", "G_Tactical_Clear","G_Goggles_VR"] + tpw_hud_extragoggles;
tpw_hud_headgeartypes = ["H_HelmetSpecO_blk","H_HelmetSpecO_ocamo","H_HelmetLeaderO_oucamo","H_HelmetLeaderO_ocamo"] + tpw_hud_extraheadgear;
tpw_hud_tint = tpw_core_sunangle;
tpw_hud_hideciv = false;
tpw_hud_ping = 0;
tpw_hud_units = true;

// ACTIVATE HUD FUNCTIONS
tpw_hud_fnc_activate =
	{
	tpw_hud_shortfunc = []; // functions for the short loop
	tpw_hud_longfunc = []; // functions for the long loop

	if ((tpw_hud_unit select 0) == 1 && tpw_hud_units) then
		{
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_markerscan];
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_unitscan]; 
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_unitprepare];
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_unitshow];
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_gogglecheck]; 
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_mapmarkers];
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_feh]; 			
		if (tpw_hud_degradation == 1) then
			{
			tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_effectiveness];
			};
		if ((tpw_hud_prx select 0) == 1) then
			{
			tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_prx];
			};			
		};	
	if ((tpw_hud_asl select 0) == 1) then
		{
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_asl];
		};
	if ((tpw_hud_azt select 0) == 1) then
		{
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_azt];
		};
	if ((tpw_hud_grd select 0) == 1) then
		{
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_grd];
		};
	if ((tpw_hud_lmt select 0) == 1) then
		{
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_lmt];
		};	
		
	if ((tpw_hud_tmp select 0) == 1) then
		{
		if (!isnil "tpw_fog_active") then
			{
			waituntil {!isnil "tpw_fog_temp"};
			tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_tmp];
			};
		};	
	if ((tpw_hud_hlt select 0) == 1) then
		{
		tpw_hud_longfunc = tpw_hud_longfunc + [tpw_hud_fnc_hlt];
		};	
	if ((tpw_hud_rng select 0) == 1) then
		{
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_rng];
		};	
	if ((tpw_hud_vel select 0) == 1) then
		{
		tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_vel];
		};
	tpw_hud_shortfunc = tpw_hud_shortfunc + [tpw_hud_fnc_nv];	
	};	

// ADD TAC GLASSES
tpw_hud_fnc_addgoggles = 
	{
	if (
	!("G_Tactical_Black" in items player) && 
	!("G_Tactical_Clear" in items player) && 
	!("G_Goggles_VR" in items player) && 
	!("G_Tactical_Black" in vestitems player) && 
	!("G_Tactical_Clear" in vestitems player) && 
	!("G_Goggles_VR" in vestitems player) && 
	!("G_Tactical_Black" in backpackitems player) && 
	!("G_Tactical_Clear" in backpackitems player) && 
	!("G_Goggles_VR" in backpackitems player) && 
	!(player getvariable ["tpw_hud_goggles",0] == 1)) then
		{
		if (vehicle player == player) then
			{
			player additemtouniform "G_Tactical_Clear";
			} else
			{
			player addGoggles "G_Tactical_Clear";
			};
		};
	};	
	
// ASL
tpw_hud_fnc_asl = 
	{
	private ["_asl"];	
	if (vehicle player iskindof "air") then
		{
		_asl = round ((getposatl player) select 2);
		_ctrl_asl ctrlSetStructuredText parseText format [tpw_hud_atl_txt,_asl];
		} else
		{
		_asl = round ((getposasl player) select 2);
		_ctrl_asl ctrlSetStructuredText parseText format [tpw_hud_asl_txt,_asl];
		};
	
	};	
	
// AZIMUTH
tpw_hud_fnc_azt = 
	{
	private ["_azt","_ang","_points","_num","_compass"];
	_azt = (((eyedirection player) select 0) atan2 ((eyedirection player) select 1));
	_ang = _azt;
	if (_azt < 0) then 
		{
		_azt = 360 + _azt;
		};
	_ang = _ang + 11.25; 
	if (_ang < 0) then 
		{
		_ang = 360 + _ang;
		};
	
	_points = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
	_num = floor (_ang / 22.5);
	_compass = _points select _num;		
	_ctrl_azt ctrlSetStructuredText parseText format [tpw_hud_azt_txt,_compass,round _azt];
	};
	
// ADJUST BRIGHTNESS
tpw_hud_fnc_brightness =
	{
	_heh = (findDisplay 46) displayAddEventHandler ["keyDown", {_this call tpw_hud_fnc_keydown; false}];
	tpw_hud_lastchange = time; 
	tpw_hud_fnc_keydown = 
		{
		private["_ctrl","_key"];
		_key = _this select 1;
		_ctrl = _this select 3;
		_alt = _this select 4;
		
		if (player getvariable ["tpw_hud_goggles",0] == 0) exitwith {}; 		
		
		// Toggle display of civilians ctrl-alt-c
		if ((_ctrl) && (_alt) && (_key == 46) && {time > tpw_hud_lastchange} ) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			if (tpw_hud_hideciv) then
				{
				tpw_hud_hideciv = false;
				} else
				{
				tpw_hud_hideciv = true;
				};
			};
		
		// Electrochromic tinting	ctrl-alt-a
		if ((_ctrl) && (_alt) && (_key == 30) && {time > tpw_hud_lastchange} ) exitwith 
			{
			if (tpw_core_sunangle < 0) exitwith {};
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			if (tpw_hud_tint < tpw_core_sunangle + 200) then
				{
				tpw_hud_tint = tpw_hud_tint + 30;
				setaperture tpw_hud_tint;
				} else
				{
				setaperture -1; 
				tpw_hud_tint = tpw_core_sunangle;
				};
			};
		
		// HUD NV	ctrl-alt-n
		if ((_ctrl) && (_alt) && (_key == 49) && {time > tpw_hud_lastchange} ) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			if (tpw_hud_nvflag) then
				{
				[] call tpw_hud_fnc_nvoff; 
				tpw_hud_nvflag = false;
				} else
				{
				tpw_hud_nvflag = true;
				};
			};
			
		// HUD TRACE	ctr-alt-t
		if ((_ctrl) && (_alt) && (_key == 20) && {time > tpw_hud_lastchange} ) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			tpw_hud_traceflag = tpw_hud_traceflag + 1;
			if (tpw_hud_traceflag > 2) then
				{
				tpw_hud_traceflag = 0;
				};
			};
			
		// AUDIO PING	ctr-alt-p
		if ((_ctrl) && (_alt) && (_key == 25) && {time > tpw_hud_lastchange} ) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			if (tpw_hud_ping == 0) then
				{
				tpw_hud_ping = 1;
				player sidechat "Positional audio ping enabled";
				}else
				{
				tpw_hud_ping = 0;
				player sidechat "Positional audio ping disabled";
				};
			};	
			
		// UNIT SCANNING	ctr-alt-u
		if ((_ctrl) && (_alt) && (_key == 22) && {time > tpw_hud_lastchange} ) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			if (tpw_hud_units) then
				{
				tpw_hud_units = false;
				player sidechat "Unit scanning disabled";
				}else
				{
				tpw_hud_units = true;
				player sidechat "Unit scanning enabled";
				};
			if (tpw_hud_eh) then
				{
				["tpw_hud", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
				tpw_hud_eh = false;
				};
			[] call tpw_hud_fnc_activate;
			[] call tpw_hud_fnc_reset;			
			};					
			
		// HUD NV BRIGHTNESS	ctrl-alt-b
		if ((_ctrl) && (_alt) && (_key == 48) && {time > tpw_hud_lastchange} && tpw_hud_nvflag) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			tpw_nv_fac = tpw_nv_fac + 1;
			if (tpw_nv_fac > 5) then
				{
				tpw_nv_fac = 0;
				};
			player action ["nvGogglesOff", player];
			setaperture (tpw_nv_brightness select tpw_nv_fac);
			tpw_hud_nvgrain = ppEffectCreate ["filmgrain", 2050];
			tpw_hud_nvgrain ppEffectEnable true;
			tpw_hud_nvgrain ppEffectAdjust [1,1,1,0.1,0.1,false];
			tpw_hud_nvgrain ppEffectCommit 0;
			tpw_hud_nvblur = ppEffectCreate ["dynamicblur", 450];
			tpw_hud_nvblur ppEffectEnable true;
			tpw_hud_nvblur ppEffectAdjust [0.2];
			tpw_hud_nvblur ppEffectCommit 0;
			tpw_hud_nv=true;	
			};	
		
		// HUD brightness ctrl-alt-h
		if ((_ctrl) && (_alt) &&  (_key == 35) && {time > tpw_hud_lastchange}) exitwith 
			{
			player say "readoutclick";
			tpw_hud_lastchange = time + 0.2;
			tpw_hud_alpha = tpw_hud_alpha + 0.1;
			if (tpw_hud_alpha > 1) then
				{
				tpw_hud_alpha = 0;
				};
			
			// Reset HUD for good measure
			[] call tpw_hud_fnc_reset;		
			};
		};	
	};
	
// SET DISPLAY PARAMETERS FOR EACH HUD CONTROL
tpw_hud_fnc_displayparams =
	{
	private ["_display","_param","_ctrl","_xpos","_ypos","_diff","_size","_squadrgb","_friendlyrgb","_enemyrgb"];
	disableSerialization; 
	_display = uiNamespace getVariable "TPW_HUD_DISPLAY"; 
	for "_i" from 0 to (count tpw_hud_params - 1) do
		{
		_param = tpw_hud_params select _i;
		_ctrl = _display displayctrl (100001 + _i);
		_xpos = (_param select 1);
		_ypos = (_param select 2);

		// Scale
		if (_xpos < 0.5) then
			{
			_diff = 0.5 - _xpos;
			_xpos = 0.5 - (_diff * tpw_hud_scale);
			};
		if (_xpos > 0.5) then		
			{
			_diff = _xpos - 0.5;
			_xpos = 0.5 + (_diff * tpw_hud_scale);
			};
		if (_ypos < 0.5) then
			{
			_diff = 0.5 - _ypos;
			_ypos = 0.5 - (_diff * tpw_hud_scale);
			};
		if (_ypos > 0.5) then		
			{
			_diff = _ypos - 0.5;
			_ypos = 0.5 + (_diff * tpw_hud_scale);
			};			
	
		// Apply offset	
		_xpos = _xpos + tpw_hud_offset_x;
		_ypos = _ypos + tpw_hud_offset_y;
		
		// Resolution correction
		_xpos = _xpos * safezoneW + safezoneX;
		_ypos = _ypos * safezoneW + safezoneX;
		_size = (_param select 3) * tpw_hud_textscale;

		// Update control
		_ctrl ctrlsetposition [_xpos,_ypos];
		_ctrl ctrlsetscale _size;
		_ctrl ctrlcommit 0;
		}; 
	tpw_hud_maxiconsize = tpw_hud_unit select 1;
	tpw_hud_miniconsize = tpw_hud_unit select 2;
	tpw_hud_unittextsize = (0.03 / (getResolution select 5)) *(tpw_hud_unit select 3) * tpw_hud_textscale;
	
	// RGBA to HTML for coloured text
	_squadrgb = tpw_hud_squadcolour + [tpw_hud_alpha];
	tpw_hud_squadhtml = _squadrgb call BIS_fnc_colorRGBAtoHTML;
	_friendlyrgb = tpw_hud_friendlycolour + [tpw_hud_alpha];
	tpw_hud_friendlyhtml = _friendlyrgb call BIS_fnc_colorRGBAtoHTML;
	_enemyrgb = tpw_hud_enemycolour + [tpw_hud_alpha];
	tpw_hud_enemyhtml = _enemyrgb call BIS_fnc_colorRGBAtoHTML;
	_civrgb = tpw_hud_civcolour + [tpw_hud_alpha];
	tpw_hud_civhtml = _civrgb call BIS_fnc_colorRGBAtoHTML;
	};

// EFFECTIVENESS OF HUD REDUCED AT NIGHT, IN RAIN, IN FOG, PRONE UNITS
tpw_hud_fnc_effectiveness =
	{
	private ["_unit","_dist","_dropout","_thresh","_uthresh","_cta","_camo"];
	_thresh = 8;
	
	// Reduced effectiveness at night
	if (tpw_core_sunangle < 0) then 
		{
		_thresh = _thresh / 2;
		};
	
	// REduced effectiveness in rain or fog	
	if (rain > 0.2 || fog > 0.2 ) then 
		{
		_thresh = _thresh / 2;
		};
	
	if (count tpw_hud_nearunits > 0) then
		{
		for "_cta" from 0 to (count tpw_hud_nearunits - 1) do 
			{
			_unit = tpw_hud_nearunits select _cta;
			_dist = _unit distance player;
			if( !isNil "_unit" && {!isnull _unit}) then
				{
				// Reduced effectiveness of detecting prone units
				if (stance _unit == "PRONE") then
					{
					_uthresh = _thresh / 2;
					} else
					{
					_uthresh = _thresh;
					}; 
				if (vehicle _unit != _unit) then
					{
					_uthresh = _thresh * 20;
					};				
					
				// Magic formula to determine likelihood of unit not being detected properly 	
				if (random _uthresh < (_dist / tpw_hud_maxrange) ^ 2) then
					{
					_dropout = time + random (_dist / 100);
					_unit setvariable ["tpw_hud_dropout",_dropout];	// how long till unit is fully visible again
					};
				};	
			};
		};	
	};	

// BULLET SPEED EVENTHANDLER - ONLY ADDED IF NEEDED
tpw_hud_fnc_feh =
	{
	if !(tpw_hud_feh) then
		{
		tpw_hud_fehidx = player addeventhandler ["fired",
			{
			if !((_this select 6) iskindof "grenadehand") then 
				{
				tpw_hud_muzvel = (speed (_this select 6)) / 3.6;
				tpw_hud_feh = false;
				player removeeventhandler ["fired",tpw_hud_fehidx]; //remove this eventhandler after one bullet
				};
			}];	
		tpw_hud_feh = true;	
		};	
	};	
	
// HUD GLITCHES
tpw_hud_fnc_glitch =
	{
	private ["_ctc"];
	if (cameraview == "external" || (player getvariable ["tpw_hud_goggles",0] == 1)) exitwith {};
	private ["_display","_ctrl_asl","_ctrl_azt","_ctrl_grd","_ctrl_lmt","_ctrl_tmp","_ctrl_hlt","_ctrl_rng","_ctrl_vel"];

	// GET DISPLAY AND CONTROLS	
	disableSerialization; 
	_display = uiNamespace getVariable "TPW_HUD_DISPLAY"; 
	_ctrl_asl = _display displayCtrl 100001; 
	_ctrl_azt = _display displayCtrl 100002; 
	_ctrl_grd = _display displayCtrl 100003; 
	_ctrl_lmt = _display displayCtrl 100004; 
	_ctrl_ctr = _display displayCtrl 100005; 
	_ctrl_tmp = _display displayCtrl 100006; 
	_ctrl_hlt = _display displayCtrl 100007; 
	_ctrl_rng = _display displayCtrl 100008;
	_ctrl_vel = _display displayCtrl 100009;
	
	for "_ctc" from 1 to (10 + random 10) do
		{
		//HUD off
			{
			_x ctrlshow false;
			} foreach [_ctrl_asl,_ctrl_azt,_ctrl_grd,_ctrl_lmt,_ctrl_ctr,_ctrl_tmp,_ctrl_hlt,_ctrl_rng,_ctrl_vel];
		if (tpw_hud_eh) then
			{
			["tpw_hud", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			tpw_hud_eh = false;
			};
		sleep random 0.2;
		//HUD on
			{
			_x ctrlshow true;
			_x ctrlsettextcolor (tpw_hud_colour + [random 1]);
			} foreach [_ctrl_asl,_ctrl_azt,_ctrl_grd,_ctrl_lmt,_ctrl_ctr,_ctrl_tmp,_ctrl_hlt,_ctrl_rng,_ctrl_vel];	
		if !(tpw_hud_eh) then
			{	
			[] call tpw_hud_fnc_unitshow;
			};
		sleep random 0.2;	
		};
	};	
	
// GOGGLES/UAV CHECK
tpw_hud_fnc_gogglecheck = 
	{
	private ["_tempgoggles","_ctb"];
	_tempgoggles = [];
	for "_ctb" from 0 to (count (units group player) - 1) do
		{
		_unit = (units group player) select _ctb;
		[_unit] call tpw_hud_fnc_goggles;
		if (_unit getvariable ["tpw_hud_goggles",0] == 1) then
			{
			_tempgoggles set [count _tempgoggles,_unit];
			};
		if (!isnull getconnecteduav _unit) then
			{
			_tempgoggles set [count _tempgoggles,(driver getconnecteduav _unit)];
			};
		};
	tpw_hud_gogglewearers = _tempgoggles;
	};	

// GOGGLE CHECK - CAN UNIT HAVE HUD
tpw_hud_fnc_goggles =
	{
	private ["_unit"];
	_unit = _this select 0;
	if (tpw_hud_active && {(((goggles _unit) in tpw_hud_goggletypes) || ((headgear _unit) in tpw_hud_headgeartypes))} && {cameraview != "external" || tpw_hud_thirdperson == 1} && {(eyepos player) select 2 > 0}) then
		{
		_unit setvariable ["tpw_hud_goggles",1];
		} else
		{
		_unit setvariable ["tpw_hud_goggles",0];
		}
	};
	
// GPS POS
tpw_hud_fnc_grd =
	{
	private ["_grd"];	
	_grd = mapGridPosition (position player);
	_ctrl_grd ctrlsetstructuredtext parsetext format [tpw_hud_grd_txt,_grd];
	};

// HEALTH
tpw_hud_fnc_hlt =
	{
	private ["_hlt","_bpm","_ft","_dm","_factor"];
	if (damage player > 0 || getfatigue player > 0) then
		{
		_hlt = round (100 * (1 - damage player));
		_ft = (getfatigue player); // fatigue 
		_dm = (damage player) ^ 2; // damage squared	
		_factor = (1 + (3 * _ft) * (1 + _dm)); // heartrate factor
		if (_factor > 3) then
			{
			_factor = 3;
			};
		_bpm = floor (tpw_hud_restingheartrate * _factor);
		} else
		{
		_bpm = tpw_hud_restingheartrate;
		_hlt = 100;
		};
	_ctrl_hlt ctrlsetstructuredtext parsetext format [tpw_hud_hlt_txt,_bpm,_hlt];
	};

// SELECT ICONS
tpw_hud_fnc_icon =
	{
	private ["_num"];
	_num = _this select 0;
	switch _num do
		{
		case 0:
			{
			tpw_hud_icon = "\tpw_hud\empty.paa";
			};
		case 1:
			{
			tpw_hud_icon = "\tpw_hud\2px_cross.paa";
			};
		case 2:
			{
			tpw_hud_icon = "\tpw_hud\2px_cross_open.paa";
			};
		case 3:
			{
			tpw_hud_icon = "\tpw_hud\2px_cross_small.paa";
			};
		case 4:
			{
			tpw_hud_icon = "\tpw_hud\2px_diamond.paa";
			};
		case 5:
			{
			tpw_hud_icon = "\tpw_hud\2px_diamond_half.paa";
			};
		case 6:
			{
			tpw_hud_icon = "\tpw_hud\2px_diamond_open.paa";
			};
		case 7:
			{
			tpw_hud_icon = "\tpw_hud\2px_dot.paa";
			};
		case 8:
			{
			tpw_hud_icon = "\tpw_hud\2px_line.paa";
			};
		case 9:
			{
			tpw_hud_icon = "\tpw_hud\2px_line_open.paa";
			};
		case 10:
			{
			tpw_hud_icon = "\tpw_hud\2px_square.paa";
			};			
		case 11:
			{
			tpw_hud_icon = "\tpw_hud\2px_square_half.paa";
			};	
		case 12:
			{
			tpw_hud_icon = "\tpw_hud\2px_square_open.paa";
			};	
		case 13:
			{
			tpw_hud_icon = "\tpw_hud\2px_x.paa";
			};	
		case 14:
			{
			tpw_hud_icon = "\tpw_hud\2px_x_open.paa";
			};	
		case 15:
			{
			tpw_hud_icon = "\tpw_hud\2px_x_small.paa";
			};	
		case 16:
			{
			tpw_hud_icon = "\tpw_hud\3px_circle.paa";
			};
		case 17:
			{
			tpw_hud_icon = "\tpw_hud\3px_circle_half.paa";
			};
		case 18:
			{
			tpw_hud_icon = "\tpw_hud\3px_circle_open.paa";
			};			
		case 19:
			{
			tpw_hud_icon = "\tpw_hud\3px_cross.paa";
			};
		case 20:
			{
			tpw_hud_icon = "\tpw_hud\3px_cross_open.paa";
			};
		case 21:
			{
			tpw_hud_icon = "\tpw_hud\3px_cross_small.paa";
			};
		case 22:
			{
			tpw_hud_icon = "\tpw_hud\3px_diamond.paa";
			};
		case 23:
			{
			tpw_hud_icon = "\tpw_hud\3px_diamond_half.paa";
			};
		case 24:
			{
			tpw_hud_icon = "\tpw_hud\3px_diamond_open.paa";
			};
		case 25:
			{
			tpw_hud_icon = "\tpw_hud\3px_dot.paa";
			};
		case 26:
			{
			tpw_hud_icon = "\tpw_hud\3px_line.paa";
			};
		case 27:
			{
			tpw_hud_icon = "\tpw_hud\3px_line_open.paa";
			};
		case 28:
			{
			tpw_hud_icon = "\tpw_hud\3px_square.paa";
			};			
		case 29:
			{
			tpw_hud_icon = "\tpw_hud\3px_square_half.paa";
			};	
		case 30:
			{
			tpw_hud_icon = "\tpw_hud\3px_square_open.paa";
			};	
		case 31:
			{
			tpw_hud_icon = "\tpw_hud\3px_x.paa";
			};	
		case 32:
			{
			tpw_hud_icon = "\tpw_hud\3px_x_open.paa";
			};	
		case 33:
			{
			tpw_hud_icon = "\tpw_hud\3px_x_small.paa";
			};	
		};
	};
	
// TIME	
tpw_hud_fnc_lmt =
	{
	private ["_h","_m"];	
	_h = date select 3;
	_m = date select 4;
	if (_h < 10) then 
		{
		_h = format ["0%1",_h];
		};
	if (_m < 10) then 
		{
		_m = format ["0%1",_m];
		};			
	_ctrl_lmt ctrlsetstructuredtext parsetext format [tpw_hud_lmt_txt,_h,_m];
	};		
	
// LONG HUD UPDATE LOOP
tpw_hud_fnc_longloop = 
	{
	private ["_display","_ctrl_asl","_ctrl_azt","_ctrl_grd","_ctrl_lmt","_ctrl_tmp","_ctrl_hlt","_ctrl_rng","_ctrl_vel"];
	disableSerialization; 
	_display = uiNamespace getVariable "TPW_HUD_DISPLAY"; 
	_ctrl_asl = _display displayCtrl 100001; 
	_ctrl_azt = _display displayCtrl 100002; 
	_ctrl_grd = _display displayCtrl 100003; 
	_ctrl_lmt = _display displayCtrl 100004; 
	_ctrl_ctr = _display displayCtrl 100005; 
	_ctrl_tmp = _display displayCtrl 100006; 
	_ctrl_hlt = _display displayCtrl 100007; 
	_ctrl_rng = _display displayCtrl 100008;
	_ctrl_vel = _display displayCtrl 100009;
	while {true} do
		{
		if (tpw_hud_fncactive) then 
			{		
			// Update display data
				{
				[] call _x;
				} foreach tpw_hud_longfunc;	
			};
		sleep 2.533;
		};
	};		
	
// CHECK FOR PLAYER ADDED MAP MARKERS
tpw_hud_fnc_mapmarkers = 
	{
	private ["_marker","_markers_temp","_ctd"];
	_markers_temp = [];
		//for "_ctd" from 0 to (count allMapMarkers - 1) do
			{
			//_marker = allmapmarkers select _ctd;
			_marker = _x;
			if ((!isnil "_marker") && {getmarkertype _marker == "hd_objective"} && {["!!",markerText _marker] call bis_fnc_instring}) then
				{
				_markers_temp set [count _markers_temp,_marker];
				};
			} foreach allmapmarkers;	
	tpw_hud_markers = _markers_temp;
	};
		
// GET MARKER INFO FOR DISPLAY	
tpw_hud_fnc_markerscan =
	{
	private ["_pos","_dist","_scale","_text","_marker","_markerarray_temp","_cte"];
	_markerarray_temp = [];
	for "_cte" from 0 to (count tpw_hud_markers - 1) do
		{
		_marker = tpw_hud_markers select _cte;
		if (!isnil "_marker") then
			{
			_pos = getmarkerpos _marker;
			_dist = format ["%1m",round (player distance _pos)];
			_scale = (tpw_hud_maxiconsize) - (round (player distance _pos) / 200);
			_text = [markerText _marker, "!!", ""] call CBA_fnc_replace;
			if (_text != "") then
				{
				_dist = _text + " " + _dist;
				};
			if (_scale < (tpw_hud_miniconsize)) then
				{
				_scale = tpw_hud_miniconsize;
				};
			if (player distance _pos > tpw_hud_minrange) then
				{
				_markerarray_temp set [count _markerarray_temp,[_pos,_dist,_scale]];
				};
			};
		};	
	tpw_hud_markerarray = _markerarray_temp;
	};	
	
// NV 
tpw_hud_fnc_nv =
	{
	// If NV is on, what conditions should switch it off
	if (tpw_hud_nv) then
		{
		if ((tpw_hud_thirdperson == 0 && cameraview == "external") ||
		(player getvariable ["tpw_hud_goggles",0] == 0) ||
		(!tpw_hud_nvflag)) then	
			{
			ppEffectDestroy tpw_hud_nvgrain;
			ppEffectDestroy tpw_hud_nvblur;
			titleCut ["", "BLACK IN", 4];
			setaperture -1;
			tpw_hud_nv=false;
			};	
		} else
		{
		// If NV is off, what conditions should switch it on
		if (!(tpw_hud_thirdperson == 0 && cameraview == "external") &&
	{player getvariable ["tpw_hud_goggles",0] == 1} &&	
	{tpw_hud_nvflag}) then	
			{
			player action ["nvGogglesOff", player];
			//setaperture 0.65;
			setaperture (tpw_nv_brightness select tpw_nv_fac);
			tpw_hud_nvgrain = ppEffectCreate ["filmgrain", 2050];
			tpw_hud_nvgrain ppEffectEnable true;
			tpw_hud_nvgrain ppEffectAdjust [1,1,1,0.1,0.1,false];
			tpw_hud_nvgrain ppEffectCommit 0;
			tpw_hud_nvblur = ppEffectCreate ["dynamicblur", 450];
			tpw_hud_nvblur ppEffectEnable true;
			tpw_hud_nvblur ppEffectAdjust [0.2];
			tpw_hud_nvblur ppEffectCommit 0;
			tpw_hud_nv=true;
			};
		};
	};

// AUDIO PING FOR NEAREST ENEMY	
tpw_hud_fnc_ping =
	{ 
	private ["_allunits","_enemies","_nearenemy","_dir","_pos","_posx","_posy","_tickpos","_dist","_pitch","_vol"];
	while {true} do
		{
		if (tpw_hud_fncactive && {tpw_hud_ping == 1}) then
			{
			_allunits = tpw_hud_visible + tpw_hud_hidden + tpw_hud_unsure;
			if (count allunits > 0) then
				{
				_enemies = _allunits select {(side _x) getFriend (side player) < 0.5};
				if (count _enemies > 0) then
					{
					_nearenemy =  ([_enemies,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy) select  0;
					_dir = [player, _nearenemy] call bis_fnc_dirto;
					_pos = getposasl player;
					_dist = 1;
					_pitch = 0.5;
					_vol = 2 * (1 - (player distance _nearenemy)/ tpw_hud_maxrange);
					if (count (worldToScreen position _nearenemy) > 0) then
						{
						_pitch = 1;
						};
					_posx = (_pos select 0) + (_dist * sin _dir);
					_posy = (_pos select 1) +  (_dist * cos _dir);
					_tickpos = [_posx,_posy,1]; 
					playSound3D ["a3\sounds_f\sfx\beep_target.wss", player, false,_tickpos, _vol, _pitch,0];
					};
				};
			};
		sleep 1.5;
		};	
	};
	
// PROXIMITY ALERT
tpw_hud_fnc_prx = 
	{
	private ["_civ","_friendly","_enemy","_squad","_unitarray","_side","_ctf","_newenemies"];
	_unitarray = [];
	_civ = 0;
	_friendly = 0;
	_enemy = 0;
	_squad = 0;
	_unitarray = tpw_hud_visible + tpw_hud_hidden + tpw_hud_unsure;
	for "_ctf" from 0 to (count _unitarray - 1) do	
		{
		_unit = _unitarray select _ctf;
		if ((side _unit) getFriend (side player) < 0.6) then
			{
			// Enemies 
			_side = "enemy";
			}else
			{
			// Friendlies / civs
			_side = "friendly";
			if (side _unit == CIVILIAN) then
				{
				_side = "civ"
				};
			};
		// Squad 
		if (_unit in units (group player)) then 
			{			
			_side = "squad";
			};
			
		switch _side do
			{
			case "enemy":
				{
				_enemy = _enemy + 1;
				};
			case "friendly":
				{
				_friendly = _friendly + 1;
				};
			case "squad":
				{
				_squad = _squad + 1;
				};
			case "civ":
				{
				_civ = _civ + 1;
				};					
			};
		};
		
		// Audible warning if new enemy appears
		_newenemies = _enemy - tpw_hud_prevenemies;
		if (_newenemies < 0) then
			{
			_newenemies = 0;
			};
		for "_i" from 1 to _newenemies do 
			{
			if (tpw_hud_audible == 1) then 
				{
				player say "readoutclick";
				};
			};
		tpw_hud_prevenemies =  _enemy;		
		
		
	if (_enemy == 0) then 
		{
		_enemy = ".";
		};	
	if (_friendly == 0) then 
		{
		_friendly = ".";
		};	
	if (_squad == 0) then 
		{
		_squad = ".";
		};
	if (_civ == 0) then 
		{
		_civ = ".";
		};		
		
	_ctrl_ctr ctrlsetstructuredtext parsetext format [tpw_hud_prx_txt,_civ,_squad,_friendly,_enemy,tpw_hud_civhtml,tpw_hud_squadhtml,tpw_hud_friendlyhtml,tpw_hud_enemyhtml];	
	};
	
// HUD RESET
tpw_hud_fnc_reset = 
	{
	("TPW_HUD_Layer" call BIS_fnc_rscLayer) cuttext ["","PLAIN",0,false]; 
	("TPW_HUD_Layer" call BIS_fnc_rscLayer) cutRsc ["TPW_HUD_DIALOG","PLAIN",0,false];	
	if (!isnil "tpw_hud_handle1") then
		{
		terminate tpw_hud_handle1;
		};
	if (!isnil "tpw_hud_handle2") then
		{
		terminate tpw_hud_handle2;
		};	
	[] call tpw_hud_fnc_displayparams;
	tpw_hud_handle1 = [] spawn tpw_hud_fnc_shortloop;
	tpw_hud_handle2 = [] spawn tpw_hud_fnc_longloop;	
	if (tpw_hud_addtac == 1) then
		{
		[] call tpw_hud_fnc_addgoggles;
		};
	};
	
// RANGE
tpw_hud_fnc_rng = 
	{
	private ["_objects","_rng"];
	_objects = lineintersectsobjs [(eyepos player),(atltoasl screentoworld [0.5,0.5]),(vehicle player),objnull,false,2];
	_rng = 0;
	if (count _objects > 0) then
		{
		_obj = _objects select 0;
		_rng = round (player distance _obj);
		}else
		{
		_rng = round (player distance (screentoworld [0.5,0.5]));
		};
	if (_rng > 1800 || _rng < 10) then
		{
		_rng = "---";
		};
	_ctrl_rng ctrlsetstructuredtext parsetext format [tpw_hud_rng_txt,_rng];
	};	

// SHORT HUD UPDATE LOOP
tpw_hud_fnc_shortloop =
	{
	private ["_display","_ctrl_asl","_ctrl_azt","_ctrl_grd","_ctrl_lmt","_ctrl_tmp","_ctrl_hlt","_ctrl_rng","_ctrl_vel"];
	
	// GET DISPLAY AND CONTROLS	
	disableSerialization; 
	_display = uiNamespace getVariable "TPW_HUD_DISPLAY"; 
	_ctrl_asl = _display displayCtrl 100001; 
	_ctrl_azt = _display displayCtrl 100002; 
	_ctrl_grd = _display displayCtrl 100003; 
	_ctrl_lmt = _display displayCtrl 100004; 
	_ctrl_ctr = _display displayCtrl 100005; 
	_ctrl_tmp = _display displayCtrl 100006; 
	_ctrl_hlt = _display displayCtrl 100007; 
	_ctrl_rng = _display displayCtrl 100008;
	_ctrl_vel = _display displayCtrl 100009;

	while {true} do
		{
		// Player goggle check
		[player] call tpw_hud_fnc_goggles;
		
		// Only show/update HUD if player wearing tactical goggles and permitted to in external view
		if (player getvariable ["tpw_hud_goggles",0] == 1) then 
			{
			tpw_hud_fncactive = true;
			
			// Disable projectile trace if toggled off
			if  (tpw_hud_traceflag == 0 && tpw_hud_traceactive == 1) then 
				{
				removeMissionEventHandler ["Draw3D",tpw_hud_traceidx];
				tpw_hud_traceactive = 0;
				};
						
			// Show HUD
				{
				_x ctrlshow true;
				_x ctrlsettextcolor (tpw_hud_colour + [tpw_hud_alpha]);
				} foreach [_ctrl_asl,_ctrl_azt,_ctrl_grd,_ctrl_lmt,_ctrl_ctr,_ctrl_tmp,_ctrl_hlt,_ctrl_rng,_ctrl_vel];
			
			// Show projectile trace
			if (tpw_hud_traceflag > 0 && {tpw_hud_traceactive == 0}) then
				{
				[] call tpw_hud_addtracehandler;	
				};

			// Update display data
				{
				[] call _x;
				} foreach tpw_hud_shortfunc;
			} else
			{
			if (tpw_hud_fncactive) then
				{
				tpw_hud_fncactive = false;
				
				// NV off				
				if (tpw_hud_nv) then
					{
					ppEffectDestroy tpw_hud_nvgrain;
					ppEffectDestroy tpw_hud_nvblur;
					titleCut ["", "BLACK IN", 4];
					setaperture -1;
					tpw_hud_nv=false;
					};
				
				// Tint off				
				if (tpw_hud_tint > tpw_core_sunangle) then
					{
					setaperture -1;
					tpw_hud_tint = tpw_core_sunangle;
					};
					
				
				// Hide HUD
					{
					_x ctrlshow false;
					} foreach [_ctrl_asl,_ctrl_azt,_ctrl_grd,_ctrl_lmt,_ctrl_ctr,_ctrl_tmp,_ctrl_hlt,_ctrl_rng,_ctrl_vel];
						
				// Disable unit display - remove PFEH
				if (tpw_hud_eh) then
					{
					["tpw_hud", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
					tpw_hud_eh = false;
					};
					
				// Disable projectile trace EH
				if (tpw_hud_traceactive == 1) then
					{
					removeMissionEventHandler ["Draw3D",tpw_hud_traceidx];
					tpw_hud_traceactive = 0;
					};
				};	
			};
		sleep 0.5333;
		};
	};	

// TEMPERATURE
tpw_hud_fnc_tmp =
	{
	private ["_tmp"];	
	_tmp = round tpw_fog_temp;
	_ctrl_tmp ctrlsetstructuredtext parsetext format [tpw_hud_tmp_txt,_tmp];
	};
	
// SCAN FOR INFANTRY AND OCCUPIED VEHICLES/STATICS, DETERMINE THEIR COLOUR
tpw_hud_fnc_unitscan =
	{
	private ["_sa","_sb","_sc","_sd"];
	private _nearunits = (player nearentities [["camanbase"],tpw_hud_maxrange]) select {!(isobjecthidden _x)} ; // infantry
	private _nearveh = (player nearentities [["landvehicle","air"],tpw_hud_vehiclerange]) select {!(isobjecthidden _x)} ; // air and land vehicles, static weapons

	// Identify stuff 3x further if using optics
	if (cameraView == "gunner") then
		{
		private _farunits = ((player nearentities [["camanbase"],tpw_hud_maxrange * 3]) select {!(isobjecthidden _x)}) - _nearunits; // units spotted further out
		private _farveh = ((player nearentities [["landvehicle","air"],tpw_hud_vehiclerange * 3]) select {!(isobjecthidden _x)}) - _nearveh; // vehicles spotted further out
		
		// Entity must be within 2 deg of the player's direction
		private _min = ([0,0,0] getdir getCameraViewDirection player) - 2;
		private _max = _min + 4;
	
		for "_sa" from 0 to (count _farunits - 1) do 
			{
			private _unit = _farunits select _sa;
			private _ang  = [player,_unit] call bis_fnc_dirto;
			if ((_ang > _min) and (_ang < _max)) then 
				{
				if (_unit getvariable["tpw_hud_fartime",0] < time) then
					{
					tpw_hud_farunits pushback _unit;
					};
				_unit setvariable["tpw_hud_fartime", time + 30]	;		
				};
			};

		for "_sb" from 0 to (count _farveh - 1) do 
			{
			private _veh = _farveh select _sb;
			private _ang  = [player,_veh] call bis_fnc_dirto;
			if ((_ang > _min) and (_ang < _max)) then 
				{
				if (_veh getvariable["tpw_hud_fartime",0] < time) then
					{
					tpw_hud_farvehicles pushback _veh;
					};
				_veh setvariable["tpw_hud_fartime", time + 30]	;		
				};
			};
		};		
		
	// Screen old distant stuff out	
	tpw_hud_farunits = tpw_hud_farunits select {_x getvariable "tpw_hud_fartime" > time};
	tpw_hud_farvehicles = tpw_hud_farvehicles select {_x getvariable "tpw_hud_fartime" > time};
	
	// Combine near and far
	_nearunits = _nearunits + tpw_hud_farunits;
	_nearveh = _nearveh + tpw_hud_farvehicles;
	
	// Only show vehicles if they have live crew	
	for "_sc" from 0 to (count _nearveh - 1) do	
		{
		private _veh = _nearveh select _sc;
			{
			if (alive _x) exitwith {_nearunits pushback _x};
			} foreach crew _veh;
		};
		
	// Screen out close, civs
	_nearunits = _nearunits select {_x distance player > tpw_hud_minrange};	
	
	/* Screen out camouflaged units
	private _camounits = _nearunits select {(_x getunittrait "camouflagecoef") > 1 && {speed _x == 0} && {random 1 < 2 * (_x distance player)/tpw_hud_maxrange}};
	_nearunits = _nearunits - _camounits;
	*/
	
	if (tpw_hud_hideciv) then
		{
		_nearunits = _nearunits select {side _x != CIVILIAN};
		};		
		
	// Assign icon type and colour	
	for "_sd" from 0 to (count _nearunits - 1) do 
		{
		private _unit = _nearunits select _sd;
		private _side = (side _unit) getFriend (side player);
		private ["_icon","_hidicon","_colour"];

		if (vehicle _unit == _unit) then
			{
			if (_side < 0.6) then
				{
				_icon = tpw_hud_enemyuniticon;
				_hidicon = tpw_hud_enemyunithidicon;
				_colour = tpw_hud_enemycolour;
				} else
				{	
				_icon = tpw_hud_uniticon;
				_hidicon = tpw_hud_unithidicon;
				_colour = tpw_hud_friendlycolour;
				if (side _unit == CIVILIAN) then
					{
					_colour = tpw_hud_civcolour;
					};
				};
			} else
			{
			if (_side < 0.6) then
				{
				_icon = tpw_hud_enemyvehicleicon;
				_hidicon = tpw_hud_enemyvehiclehidicon;
				_colour = tpw_hud_enemycolour;
				} else
				{
				_icon = tpw_hud_vehicleicon;
				_hidicon = tpw_hud_vehiclehidicon;
				_colour = tpw_hud_friendlycolour;
				if (side _unit == CIVILIAN) then
					{
					_colour = tpw_hud_civcolour;
					};
				};
			};
		
		// Squad colour
		if (_unit in units (group player)) then 
			{			
			_colour = tpw_hud_squadcolour;
			if (damage _unit > 0.25) then
				{
				_colour = [1,0.25,0.25];
				};
			};
		_unit setvariable ["tpw_hud_visicon", _icon];
		_unit setvariable ["tpw_hud_hidicon", _hidicon];	
		_unit setvariable ["tpw_hud_unitrgb",_colour];
		};
	tpw_hud_nearunits = _nearunits;
	};	
	
// PREPARE UNITS FOR DISPLAY
tpw_hud_fnc_unitprepare =
	{
	private ["_cth","_cti","_height"];

	// Temp arrays for display 
	private _visible_temp = [];
	private _hidden_temp = [];
	private _unsure_temp = [];
	
	// Assign units to visible/hidden/unsure array
	for "_cth" from 0 to (count tpw_hud_nearunits - 1) do
		{
		private _unit = tpw_hud_nearunits select _cth;
		if (!isnil "_unit" && {!isnull _unit}) then 
			{
			private _status = "hidden";	
			// HUD icon scale
			private _scale = tpw_hud_maxiconsize - (round (player distance _unit) / 200);
			if (_scale < tpw_hud_miniconsize) then
				{
				_scale = tpw_hud_miniconsize;
				};
			_unit setvariable ["tpw_hud_scale",_scale];	
						
			// Is unit visible to anyone in squad wearing tac goggles?
			for "_cti" from 0 to (count tpw_hud_gogglewearers - 1) do
				{
				private _squadmem = tpw_hud_gogglewearers select _cti;
				// Squad member has line of sight to unit
				if ([objNull, "VIEW"] checkVisibility [eyePos _unit, eyepos _squadmem] > 0.5) exitwith 
					{
					_status = "visible";
			
					// Simulate reduced HUD effectiveness
					if (tpw_hud_degradation == 1 && {_unit getvariable ["tpw_hud_dropout",0] > time}) then
						{
						_status= "unsure";
						};
						
					// Distant units identified with optics hidden if not using optics
					if (_unit distance player > tpw_hud_maxrange && cameraview != "GUNNER") then
						{
						_status= "hidden";
						}; 
					};
		
				};
			
			// Colour for HUD display
			private _colour = _unit getvariable ["tpw_hud_unitrgb",[0,0,0]];		
			
			switch _status do
				{
				case "visible":
					{
					// Stance
					private _stance = stance _unit;
					switch _stance do
						{
						case "STAND": 
							{
							_height = 1.25;
							};
						case "CROUCH": 
							{
							_height = 0.75;
							};
						case "PRONE": 
							{
							_height = 0.25;
							};
						case "UNDEFINED": 
							{
							_height = 0;
							};
						default 
							{
							_height = 1;
							};	
						};
						
					if (tolower (animationstate _unit) in ["acts_civiltalking_1","acts_civiltalking_2","acts_civillistening_1","acts_civillistening_2","acts_civilidle_1","acts_civilidle_2", "hubbriefing_think","hubbriefing_lookaround1","hubbriefing_lookaround2","hubbriefing_pointleft","hubbriefing_pointright","hubbriefing_scratch","hubbriefing_stretch"]) then 
						{
						_height = 1.25;
						};
					
					_unit setvariable ["tpw_hud_predtime",(0.27 * (player distance _unit) / tpw_hud_muzvel)]; 
					_unit setvariable ["tpw_hud_distance", format ["%1m",round (player distance _unit)]];	
					_unit setvariable ["tpw_hud_height",_height];
					_unit setvariable ["tpw_hud_lasttime",time + 30];
					_unit setvariable ["tpw_hud_unitcolour",(_colour + [tpw_hud_alpha])];
					_visible_temp set [count _visible_temp, _unit]; // move to visible units array				
					};
				case "unsure":
					{
					_unit setvariable ["tpw_hud_unitcolour",(_colour + [tpw_hud_alpha*0.5])];	
					_unsure_temp set [count _unsure_temp, _unit]; // move to unsure units array
					};
				case "hidden":
					{
					if (_unit getvariable "tpw_hud_lasttime" > time) then 
						{
						_unit setvariable ["tpw_hud_unitcolour",(_colour + [tpw_hud_alpha])];	
						_unit setvariable ["tpw_hud_lastseen",format ["%1m %2s",round (player distance (_unit getvariable "tpw_hud_lastpos")),(30 - round ((_unit getvariable "tpw_hud_lasttime") - time))]];
						_hidden_temp set [count _hidden_temp, _unit];	// move to hidden units array
						};
					};				
				};
			};
		};
	tpw_hud_visible = _visible_temp;
	tpw_hud_hidden = _hidden_temp;
	tpw_hud_unsure = _unsure_temp;	
	};

// UNIT DISPLAY FUNCTION
tpw_hud_fnc_units =
	{
	//Show markers
	for "_ctj" from 0 to (count tpw_hud_markerarray - 1) do	
		{
		_marker = tpw_hud_markerarray select _ctj;
		_ipos = _marker select 0;
		_dist = _marker select 1;
		_scale = _marker select 2;
		drawIcon3D [tpw_hud_markericon,(tpw_hud_squadcolour + [tpw_hud_alpha]),_ipos,_scale,_scale,0,_dist,0,tpw_hud_unittextsize, "etelkamonospacepro","left",true]; 
		};
		
	// Show visible units
	for "_ctj" from 0 to (count tpw_hud_visible - 1) do	
		{
		_unit = tpw_hud_visible select _ctj;
		if (!isnil "_unit" && {!isnull _unit}) then 
			{
			_pos = visibleposition _unit;
			_xpos = _pos select 0;
			_ypos = _pos select 1;
			_zpos =(_pos select 2) + (_unit getvariable "tpw_hud_height");
			_unit setvariable ["tpw_hud_lastpos",[_xpos,_ypos,_zpos]];
			_predpos = [[_xpos,_ypos,_zpos], ((speed vehicle _unit) * (_unit getvariable ["tpw_hud_predtime",0])),(getdir _unit)] call BIS_fnc_relPos;

			// Unit icon
			drawIcon3D [(_unit getvariable ["tpw_hud_visicon",""]),(_unit getvariable ["tpw_hud_unitcolour",[0,0,0,0]]), [_xpos,_ypos,_zpos], (_unit getvariable ["tpw_hud_scale",0]), (_unit getvariable ["tpw_hud_scale",0]),0,(_unit getvariable ["tpw_hud_distance",""]),0,tpw_hud_unittextsize , "etelkamonospacepro","left",true]; 
			
			// Predicted position icon
			if (_predpos distance [_xpos,_ypos,_zpos] > 0.3) then
				{
				drawIcon3D [tpw_hud_predictoricon,(_unit getvariable ["tpw_hud_unitcolour",[0,0,0,0]]), _predpos,(_unit getvariable ["tpw_hud_scale",0]),(_unit getvariable ["tpw_hud_scale",0]),0,"",0,0 ,"etelkamonospacepro"];
				};
			};
		};
		
	// Show units hidden less than 30 sec
	for "_ctj" from 0 to (count tpw_hud_hidden - 1) do	
		{			
		_unit = tpw_hud_hidden select _ctj;
		if (!isnil "_unit" && {!isnull _unit}) then 
			{
			drawIcon3D [(_unit getvariable ["tpw_hud_hidicon",""]), (_unit getvariable ["tpw_hud_unitcolour",[0,0,0,0]]),(_unit getvariable ["tpw_hud_lastpos",[0,0,0]]), (_unit getvariable ["tpw_hud_scale",0]), (_unit getvariable ["tpw_hud_scale",0]),0,(_unit getvariable ["tpw_hud_lastseen",""]),0,tpw_hud_unittextsize, "etelkamonospacepro","left",true]; 
			};
		};
		
	// Show units HUD has incomplete data on 
	for "_ctj" from 0 to (count tpw_hud_unsure - 1) do	
		{			
		_unit = tpw_hud_unsure select _ctj;
		if (!isnil "_unit" && {!isnull _unit}) then 
			{
			drawIcon3D [(_unit getvariable ["tpw_hud_visicon",""]),(_unit getvariable ["tpw_hud_unitcolour",[0,0,0,0]]),(_unit getvariable ["tpw_hud_lastpos",[0,0,0]]), (_unit getvariable ["tpw_hud_scale",0]), (_unit getvariable ["tpw_hud_scale",0]),0,(_unit getvariable ["tpw_hud_distance",""]),0,tpw_hud_unittextsize, "etelkamonospacepro","left",true]; 
			};
		};	
	};
	
// SHOW SCANNED UNITS ON HUD
tpw_hud_fnc_unitshow =
	{
	private ["_ctj","_ipos","_pos","_dist","_scale","_xpos","_ypos","_zpos","_marker","_unit","_predpos"];
	if (tpw_hud_eh) exitwith {};
	// Start PFEH
	tpw_hud_eh = true;
	["tpw_hud","oneachframe",{[] call tpw_hud_fnc_units}] call BIS_fnc_addStackedEventHandler;	
	};		
	
// SPEED
tpw_hud_fnc_vel = 
	{
	private ["_vel"];
	_vel = round (speed vehicle player);
	if (vehicle player iskindof "air") then
		{
		_vel = round (_vel * 0.53995);
		_ctrl_vel ctrlsetstructuredtext parsetext format [tpw_hud_airvel_txt,_vel];
		}else
		{
		_ctrl_vel ctrlsetstructuredtext parsetext format [tpw_hud_vel_txt,_vel];
		};
	};	
	
// ADD HIT EVENTHANDLER
player addEventHandler ["Hit",{[] spawn tpw_hud_fnc_glitch}];
	
// TEAM SWITCH
onteamswitch
	{
	[] call tpw_hud_fnc_reset;
	};
 	
// ICONS
_tempicon = [];
	{
	[_x] call tpw_hud_fnc_icon;
	_tempicon set [count _tempicon, tpw_hud_icon]
	} foreach tpw_hud_icons;
tpw_hud_uniticon = _tempicon select 0;
tpw_hud_unithidicon = _tempicon select 1;
tpw_hud_vehicleicon = _tempicon select 2;
tpw_hud_vehiclehidicon = _tempicon select 3;
tpw_hud_enemyuniticon = _tempicon select 4;
tpw_hud_enemyunithidicon = _tempicon select 5;
tpw_hud_enemyvehicleicon = _tempicon select 6;
tpw_hud_enemyvehiclehidicon = _tempicon select 7;
tpw_hud_markericon = _tempicon select 8;
tpw_hud_predictoricon = _tempicon select 9;

/* BULLET TRACING - GRATEFULLY ADAPTED FROM HYPNOMATIC
http://forums.bistudio.com/showthread.php?164294-Quick-and-fun-projectile-path-tracing!
*/
tpw_hud_fnc_traceFire = 
	{
	//Hypnomatic
	private["_this","_unit","_color","_lifetime","_interval","_maxDistance","_maxDuration","_eventHandle"];
	_unit        = [_this, 0, player, [objNull]] call BIS_fnc_param;
	_color       = [_this, 1, [1,0,0,1], [[]], [4]] call BIS_fnc_param;
	_lifetime    = [_this, 2, -1, [0]] call BIS_fnc_param;
	_interval    = [_this, 3, 0, [0]] call BIS_fnc_param;
	_maxDistance = [_this, 4, -1, [0]] call BIS_fnc_param;
	_maxDuration = [_this, 5, -1, [0]] call BIS_fnc_param;
	_unit setVariable ["tpw_hud_tracer_color", _color];
	_unit setVariable ["tpw_hud_tracer_lifetime", _lifetime];
	_unit setVariable ["tpw_hud_tracer_interval", _interval];
	_unit setVariable ["tpw_hud_tracer_maxDistance", _maxDistance];
	_unit setVariable ["tpw_hud_tracer_maxDuration", _maxDuration];
	_unit setVariable ["tpw_hud_tracer_currentIndex", 0];
	_unit setVariable ["tpw_hud_tracer_activeIndexes", []];
	_unit setVariable ["tpw_hud_tracer_initialized", true];
	_eventHandle = _unit addEventHandler ["fired", {
		if (tpw_hud_traceflag == 1) then
			{
			 if ((_this select 2) in ["HandGrenadeMuzzle","GL_3GL_F","M203","EGLM"]) then
				{
				_this select 0 setvariable ["tpw_hud_tracer_lifetime",8];
				_this select 0 setvariable ["tpw_hud_tracer_maxDuration",8];
				[_this, (position(_this select 6)),(velocity (_this select 6)) distance [0,0,0]] spawn tpw_hud_fnc_traceFireEvent;
				};
			};
		if (tpw_hud_traceflag == 2) then
			{
			 if ((_this select 2) in ["HandGrenadeMuzzle","GL_3GL_F","M203","EGLM"]) then
				{
				_this select 0 setvariable ["tpw_hud_tracer_lifetime",8];
				_this select 0 setvariable ["tpw_hud_tracer_maxDuration",8];
				} else
				{
				_this select 0 setvariable ["tpw_hud_tracer_lifetime",3];
				_this select 0 setvariable ["tpw_hud_tracer_maxDuration",3];
				};
			[_this, (position(_this select 6)),(velocity (_this select 6)) distance [0,0,0]] spawn tpw_hud_fnc_traceFireEvent;
			};
	}];
	_unit setVariable ["tpw_hud_tracer_eventHandle", _eventHandle];
	tpw_hud_tracer_tracedUnits set [count tpw_hud_tracer_tracedUnits, _unit];
	};  
 
tpw_hud_fnc_traceFireEvent = 
	{
	//Hypnomatic
	private["_this","_params","_initialPos","_unit","_projectile","_color","_lifetime","_interval","_maxDistance",
			"_maxDuration","_startTime","_skippedFrames","_positions","_projIndex","_activeIndexes","_initialVel"];
	_params        = _this select 0;
	_initialPos    = _this select 1;
	_initialVel    = _this select 2;
	_unit          = _params select 0;
	_projectile    = _params select 6;
	_color         = _unit getVariable "tpw_hud_tracer_color";
	_lifetime      = _unit getVariable "tpw_hud_tracer_lifetime";
	_interval      = _unit getVariable "tpw_hud_tracer_interval";
	_maxDistance   = _unit getVariable "tpw_hud_tracer_maxDistance";
	_maxDuration   = _unit getVariable "tpw_hud_tracer_maxDuration";
	_startTime     = diag_tickTime;
	_skippedFrames = _interval; 
	_positions     = [[_initialPos,_initialVel]];
	_projIndex     = -1;
	_activeIndexes = [];
 	_projIndex     = _unit getVariable "tpw_hud_tracer_currentIndex"; 
	_unit setVariable ["tpw_hud_tracer_currentIndex", _projIndex + 1]; 
	_unit setVariable [format["tpw_hud_tracer_projectile_%1", _projIndex], _positions];
	_activeIndexes = _unit getVariable "tpw_hud_tracer_activeIndexes";
	_activeIndexes set [count _activeIndexes, _projIndex];
	_unit setVariable ["tpw_hud_tracer_activeIndexes", _activeIndexes];
	_activeIndexes = nil; 
	waitUntil 
		{
		if (_interval != 0 && _skippedFrames < _interval) exitWith {_skippedFrames = _skippedFrames + 1; false};
		if (_interval != 0) then {_skippedFrames = 0;};
		if (!alive _projectile) exitWith {true};
		if (_maxDuration != -1 && ((diag_tickTime - _startTime) >= _maxDuration)) exitWith {true}; 
		if (_maxDistance != -1 && ((_initialPos distance _projectile) >= _maxDistance)) exitWith {true};	   
		_positions set [count _positions, [position _projectile, (velocity _projectile) distance [0,0,0]]];
		_unit setVariable [format["tpw_hud_tracer_projectile_%1", _projIndex], _positions];
		};
 
	if (_lifetime != -1) then 
		{
		waitUntil {(diag_tickTime - _startTime) >= _lifetime};
		_activeIndexes = _unit getVariable "tpw_hud_tracer_activeIndexes";
		_activeIndexes = _activeIndexes - [_projIndex];
		_unit setVariable ["tpw_hud_tracer_activeIndexes", _activeIndexes];
		_unit setVariable [format["tpw_hud_tracer_projectile_%1", _projIndex], nil]; 
		};
	};

// ADD  BULLET TRACING FROM SPAWNED UNITS AND REMOVE FROM DESPAWNED AND KILLED UNITS
tpw_hud_fnc_traceloop = 
	{
	private ["_ct","_unit","_side","_col"];
	while {true} do
		{
			{
			// Add trace function to units that don't have it, tracing colour based on side
			if !(_x getvariable ["tpw_hud_tracer_initialized", false]) then
				{
				// Friendlies
				_col = tpw_hud_friendlycolour + [1];
				
				// Squad 
				if (_x in units (group player)) then 
					{			
					_col = tpw_hud_squadcolour + [1];
					};
				
				// Enemies
				if ((side _x) getFriend (side player) < 0.6) then
					{
					_col = tpw_hud_enemycolour + [1];
					};
				
				// Civs
				if (side _x == CIVILIAN) then
					{
					_col = tpw_hud_civcolour + [1];
					};
				
				// Tracing for unit	
				[_x,_col,3,3,nil,3] call tpw_hud_fnc_traceFire;
				};
			} foreach allunits;

			// Remove from trace array if dead or despawned 
			for "_ct" from 0 to (count tpw_hud_tracer_tracedUnits -1) do
				{
				if (isnull (tpw_hud_tracer_tracedUnits select _ct) || !(alive (tpw_hud_tracer_tracedUnits select _ct))) then
					{
					tpw_hud_tracer_tracedUnits set [_ct,-1];
					};
				}; 
		tpw_hud_tracer_tracedUnits = tpw_hud_tracer_tracedUnits - [-1];	
		//hint str tpw_hud_tracer_tracedUnits;	
		sleep 4.89;
		};
	};	

// INITIALISE BULLET TRACING - HYPNOMATIC
tpw_hud_addtracehandler =
	{
	tpw_hud_traceactive = 1;
	tpw_hud_traceidx = addMissionEventHandler ["Draw3D", {
		{
		private["_unit"];
		_unit = _x;
			{
			private["_positions","_color","_muzzleVelocity"];
			_positions = _unit getVariable [format["tpw_hud_tracer_projectile_%1", _x], []];
			_color     = _unit getVariable ["tpw_hud_tracer_color", [1,0,0,1]];
			_muzzleVelocity = _positions select 0 select 1;
			for "_i" from 0 to (count _positions) - 2 do 
				{
				drawLine3D [_positions select _i select 0, _positions select (_i + 1) select 0, _color];
				};
			} forEach ( _unit getVariable["tpw_hud_tracer_activeIndexes", []] );
		} forEach tpw_hud_tracer_tracedUnits;
	}];	
	};
	
// RUN IT
sleep 1;
[] spawn tpw_hud_fnc_ping;
[] spawn tpw_hud_fnc_traceloop;
if (tpw_hud_addtac == 1) then
	{
	[] call tpw_hud_fnc_addgoggles;
	};
[] call tpw_hud_fnc_activate;
[] call tpw_hud_fnc_brightness;
[] call tpw_hud_fnc_reset;
setaperture -1;

// LOOP TO ENSURE SCRIPT DOESN'T TERMINATE. PERIODICALLY RESET HUD. 
while {true} do
	{
	[] call tpw_hud_fnc_reset;	
	sleep 59.87;
	};
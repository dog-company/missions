/*
TPW DUCK - Units will crouch / go prone if suppressed
Version: 1.02
Authors: tpw 
Date: 20170930
Requires: CBA A3, tpw_core.sqf
Compatibility: SP

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 	

To use: 
1 - Save this script into your mission directory as eg tpw_duck.sqf
2 - Call it with 0 = [0.8] execvm "tpw_duck.sqf"; where 0.8 = sensitivity (0 = units never duck, 1 = units always duck if suppressed).

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if ((count _this) < 1) exitWith {hint "TPW DUCK incorrect/no config, exiting."};
if (isDedicated) exitWith {};
WaitUntil {!isNull FindDisplay 46};

/////////////
// VARIABLES
/////////////
tpw_duck_version = "1.02"; // Version string
tpw_duck_sensitivity = _this select 0; // sensitivity (0 = units never duck, 1 = units always duck if suppressed).
tpw_duck_active=true;

// ANIMATION ARRAYS
tpw_duck_croucharray = ["AmovPknlMstpSrasWnonDnon","AmovPknlMstpSrasWpstDnon","AmovPknlMstpSrasWrflDnon","AmovPknlMstpSrasWlnrDnon"];
tpw_duck_pronearray = ["AmovPpneMstpSrasWnonDnon","AmovPpneMstpSrasWpstDnon","AmovPpneMstpSrasWrflDnon","AmovPpneMstpSrasWlnrDnon"];	

// MAIN LOOP
tpw_duck_fnc_mainloop = 
	{
	while {true} do
		{
			if (tpw_duck_active) then
			{
			tpw_duck_units = allunits select {_x getvariable ["tpw_crowd_move",-1] == -1};
			for "_i" from 0 to count tpw_duck_units - 1 do	
				{
				private _unit = tpw_duck_units select _i;
				// Fired EH
				if (_unit getvariable ["tpw_duck",-1] == -1) then
					{
					_unit setvariable ["tpw_duck_time",diag_ticktime];
					_unit setvariable ["tpw_duck",0];
					_unit addeventhandler ["fired",
						{
						if (tpw_duck_check == 0) then {0 = [] spawn tpw_duck_fnc_scan};
						if ((_this select 1) == "Throw") then {0 = [_this select 0] spawn tpw_duck_fnc_grenade};
						}];
					};	
						
				// Reset posture after appropriate time
				if (_unit getvariable "tpw_duck_time" < diag_ticktime) then
					{
					_unit setvariable ["tpw_duck",0];
					_unit setunitpos "AUTO";
					};
				};
			sleep random 10;
			};
		};
	};

// MAIN SUPPRESSION ROUTINE CALLED AFTER ANY WEAPON FIRED 
tpw_duck_fnc_scan = 
	{
	if !(tpw_duck_active) exitwith {};
	tpw_duck_check = 1;	
	
	sleep 0.2; // allow time for bullet to have passed by units 
		
	// Posture / skill changes based on suppression state
	for "_i" from 0 to count tpw_duck_units - 1 do	
		{
		private _unit = tpw_duck_units select _i;
		if (alive _unit && {vehicle _unit == _unit} && {_unit != player} && {getSuppression _unit > 0} && {random 1 < tpw_duck_sensitivity}) then 
			{
			if (asltoagl (eyepos _unit) select 2 > 1.5) then // crouch if standing
				{
				_unit setunitpos "MIDDLE";	
				_unit playmove (tpw_duck_croucharray select (_unit getvariable "tpw_core_weptype"));			
				};
			if (asltoagl (eyepos _unit) select 2 < 1.5) then // prone if crouched
				{
				_unit setunitpos "down";
				_unit playmove (tpw_duck_pronearray select (_unit getvariable "tpw_core_weptype"));
				};

			// How long til unit can get up again
			_unit setvariable ["tpw_duck_time",diag_ticktime + 5 + random 10];
			};
		};
	sleep random 0.5;
	tpw_duck_check = 0;	
	};
	
// UNITS RUN AWAY FROM GRENADES	
tpw_duck_fnc_grenade =
	{
	private _thrower = _this select 0;
	private _grenades = nearestObjects [_thrower,[],5] select {(["grenade",(str (typeof _x))] call BIS_fnc_inString)};
	if (count _grenades == 0) exitwith {};
	private _grenade = _grenades select 0;
	waituntil
		{
		(getposatl _grenade) select 2 < 0.25
		};
	private _people = (_thrower nearobjects ["camanbase",50]) - [player];
		{
		private _unit = _x;
		private _gpos  = getposasl _grenade;
		if (_unit distance _grenade < 25) then
			{
			if !(lineintersects[eyepos _unit,_gpos]) then
				{
				private _dir = [_grenade,_unit] call bis_fnc_dirto;
				private _pos = position _unit;
				private _posx = (_pos select 0) + (20 * sin _dir);
				private _posy = (_pos select 1) +  (20 * cos _dir);
				_unit domove [_posx,_posy];				
				_unit setbehaviour "COMBAT";
				_unit setspeedmode "FULL";
				sleep 0.1;
				};
			};	
		} count _people;
	};	

// RUN IT
sleep 5;	
tpw_duck_check = 0;
tpw_duck_active = true;
[] spawn tpw_duck_fnc_mainloop;	
while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
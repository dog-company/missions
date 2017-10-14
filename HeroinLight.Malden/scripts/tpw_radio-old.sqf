/* 
TPW RADIO - Ambient radio chatter when near/in vehicles
Author: tpw 
Date: 20160517
Version: 1.23
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_radio.sqf
2 - Call it with 0 = [60] execvm "tpw_radio.sqf"; where 60 = maximum time between vehicle radio messages. 0 = no messages

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 1) exitwith {hint "TPW RADIO incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_radio_version = "1.23"; // Version string
tpw_radio_time = _this select 0; // maximum time between radio bursts
tpw_radio_active = true; // Global enable/disabled
tpw_radio_radius = 50; // Distance around player to spawn radios into houses

// DFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_radio_time = 60;
	};

// DON'T PLAY MILITARY RADIO IN CIVILIAN VEHICLES
private ["_cfg"];
tpw_radio_carlist = [];
_cfg = (configFile >> "CfgVehicles");
for "_i" from 0 to ((count _cfg) -1) do 
	{
	if (isClass ((_cfg select _i) ) ) then 
		{
		_cfgName = configName (_cfg select _i);
		if ( (_cfgName isKindOf "car") && {getNumber ((_cfg select _i) >> "scope") == 2} && {getNumber ((_cfg select _i) >> "side") == 3}) then 
			{
			tpw_radio_carlist set [count tpw_radio_carlist,_cfgname];
			};
		};
	};

// CAR SCANNING LOOP
tpw_radio_fnc_carscan = {
	while {true} do
		{
		private ["_sound","_veh","_source","_rnd"];
		
		// Player inside vehicle - play radio using playmusic so it follows vehicle
		if (player != vehicle player) then 
			{
			_veh = vehicle player;
			if (
				!(typeof  _veh in tpw_radio_carlist) &&
				{!(_veh iskindof "StaticWeapon")} &&
				{!(_veh iskindof "ParachuteBase")}
				) then
				{
				if ((["rhs_",str typeof _veh] call BIS_fnc_inString)&& !(["64D",str typeof _veh] call BIS_fnc_inString)&& !(["47F",str typeof _veh] call BIS_fnc_inString)&& !(["60M",str typeof _veh] call BIS_fnc_inString)) then
					{
					_rnd = ceil random 20;
					if (_rnd < 10) then 
						{
						_rnd = format ["0%1",_rnd];
						};
					playsound [format ["rhs_rus_land_rc_%1",_rnd],true];
					} else
					{
					playsound [format ["radio%1", ceil random 30],true];
					};
				}
			} 
			else
			{
			// Player near vehicle - play radio using playsound3d at vehicle position
			_veh = ((position player) nearEntities [["Air", "Landvehicle"], 10]) select 0;
			if (!isnil "_veh") then
				{
				if (
				!(typeof _veh in tpw_radio_carlist) &&
				{!(_veh iskindof "StaticWeapon")} &&
				{!(_veh iskindof "ParachuteBase")}
				) then
					{
					if ((["rhs_",str typeof _veh] call BIS_fnc_inString)&& !(["64D",str typeof _veh] call BIS_fnc_inString)&& !(["47F",str typeof _veh] call BIS_fnc_inString)&& !(["60M",str typeof _veh] call BIS_fnc_inString)) then
						{
						_rnd = ceil random 20;
						if (_rnd < 10) then 
							{
							_rnd = format ["0%1",_rnd];
							};
						_sound = format ["rhsafrf\addons\rhs_s_radio\rc\rus_rc_%1.wss",_rnd];
						} else
						{
						_sound = format ["A3\Sounds_F\sfx\radio\ambient_radio%1.wss",ceil random 30];
						};
					playsound3d [_sound,_veh,false,getposasl _veh,0.5,1,50];
					};
				};
			};
		sleep random tpw_radio_time;
		};
	};	

// RUN IT	
sleep random tpw_radio_time;
[] spawn tpw_radio_fnc_carscan;	

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};	
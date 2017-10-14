/* 
TPW RADIO - Ambient radio chatter when near/in vehicles and on foot
Author: tpw 
Date: 20170617
Version: 1.28
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_radio.sqf
2 - Call it with 0 = [60,1,1] execvm "tpw_radio.sqf"; where 60 = maximum time (sec) between vehicle radio messages (0 = no messages), 1 = radio in/near vehicles (0 = no vehicle radio), 1 = radio on foot (0 = no radio on foot)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (isDedicated) exitWith {};
if (count _this < 3) exitwith {hint "TPW RADIO incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};

// READ IN CONFIGURATION VALUES
tpw_radio_version = "1.28"; // Version string
tpw_radio_time = _this select 0; // maximum time between radio bursts
tpw_radio_car = _this select 1; // radio in vehicles
tpw_radio_foot = _this select 2; // radio on foot
tpw_radio_active = true; // Global enable/disabled

// DEFAULT VALUES IF MP
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
		if (tpw_radio_car > 0 && {tpw_radio_active}) then 
			{
			// Player inside vehicle - play radio using playmusic so it follows vehicle. playsound3d doesn't follow vehicle, and say3d doesn't work inside vehicle 
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
						playsound [format ["radio%1", ceil random 43],true];
						};
					}
				} 
				else
				{
				// Player near vehicle - play radio using playsound3d at vehicle position - will not follow vehicle
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
							_sound = format ["TPW_SOUNDS\sounds\radio%1.ogg",ceil random 43];
							};
						playsound3d [_sound,_veh,false,getposasl _veh,tpw_radio_car,1,50];
						};
					};
				};
			};
		sleep random tpw_radio_time;
		};
	};


// RADIO FOR FOOTBOUND PLAYER
tpw_radio_fnc_foot = 
	{
	while {true} do
		{
		if (tpw_radio_foot > 0 && {vehicle player == player} && {tpw_radio_active})then
			{
			// Play sound using say3d, which will follow the player, but volume cannot be adjusted.
			_sound = format ["player_radio%1",ceil random 43];
			player say3d _sound;
			};
		sleep random tpw_radio_time;
		};
	};
	
	
// ADJUST BRIGHTNESS
tpw_radio_fnc_keypress =
	{
	tpw_radio_lastchange = time; 
	_reh = (findDisplay 46) displayAddEventHandler ["keyDown", {_this call tpw_radio_fnc_toggle; false}];
	};

tpw_radio_fnc_toggle = 
	{
	private["_ctrl","_key"];
	_key = _this select 1;
	_ctrl = _this select 3;
	_alt = _this select 4;

	if ((_ctrl) && (_alt) && (_key == 19) && {time > tpw_radio_lastchange} ) exitwith 
		{
		player say "readoutclick";
		tpw_radio_lastchange = time + 0.2;
		if (tpw_radio_foot == 0) then
			{
			tpw_radio_foot = 1;
			player sidechat "Ambient radio messages enabled";
			} else
			{
			player sidechat "Ambient radio messages disabled";
			tpw_radio_foot = 0;
			};
		};
	};
			

// RUN IT	
sleep random tpw_radio_time;
[] call tpw_radio_fnc_keypress;
[] spawn tpw_radio_fnc_carscan;	
[] spawn tpw_radio_fnc_foot;	

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};	
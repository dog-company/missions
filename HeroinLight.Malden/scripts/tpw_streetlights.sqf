/* 
TPW STREETLIGHTS - Streetlights on A2/OA maps
Author: tpw 
Date: 20141019
Version: 1.05
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works.     

To use: 
1 - Save this script into your mission directory as eg tpw_streetlights.sqf
2 - Call it with 0 = [10,1000,1, 1] execvm "tpw_streetlights.sqf"; where 10 = brightness factor (3-20 depending on map), 1500 = distance around player to scan for lights, 1 = warm white incandescent (2 = yellow white sodium, 3 = blue white fluorescent), 1 = moths around lights (0 = no moths)

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS.
*/

if (worldname in ["Altis","Stratis"]) exitwith {};
if (isDedicated) exitWith {};
//if (isclass (configfile/"CfgPatches"/"AiA_BaseConfig_F")) exitWith {};
if (count _this < 4) exitwith {hint "TPW STREETLIGHTS incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
WaitUntil {!isnil "tpw_core_sunangle"};

// VARIABLES
private ["_colsel","_moths","_lightarray","_lastpos","_colour","_incan","_sodium","_fluoro"];

tpw_streetlights_version = "1.05"; // Version string
tpw_streetlights_factor = _this select 0; 
tpw_streetlights_range = _this select 1; 
_colsel =  _this select 2; 
_moths =  _this select 3; 
tpw_streetlights_active=true;
_lightarray = [];
_lastpos = [0,0,0];

// DFAULT VALUES IF MP
if (isMultiplayer) then 
	{
	tpw_streetlights_factor = 10;
	tpw_streetlights_range = 1000;
	tpw_streetlights_colsel = 0;
	tpw_streetlights_moths = 1;
	};

// SELECT COLOUR
_colour = [];
_incan = [250,150,100];
_sodium = [250,150,80];
_fluoro = [200,200,250];
switch (_colsel) do
	{
	case 0: {_colour=_incan};
	case 1: {_colour=_sodium};	
	case 2: {_colour=_fluoro};	
	};

// SPAWN "LIGHTBULB" 
_fnc_light =
	{
	private ["_lamp","_lightpos","_light","_type","_offset","_intensity"];
	_lamp = _this select 0;
	if !(_lamp in _lightarray) then 
		{
		_lightarray set [count _lightarray,_lamp];
		_type= typeof _lamp;
		switch _type do
			{
			case "Land_lampa_sidl":
				{
				_offset = [-1,1.5,4.2];
				_intensity = 300;
				};
			case "Land_lampa_sidl_2":
				{
				_offset = [-1,1.5,4.2];
				_intensity = 300;
				};
			case "Land_lampa_sidl_3":
				{
				_offset = [-1,1.5,4.2];
				_intensity = 300;
				};			
			case "Land_PowLines_WoodL":
				{
				_offset = [0,0.5,3.8];
				_intensity = 100;
				};
			case "Land_PowLines_ConcL":
				{
				_offset = [-1,0,5];
				_intensity = 200;
				};	
			case "Land_lampa_ind_zebr":
				{
				_offset = [-0.5,0,4];
				_intensity = 50;
				};
			case "Land_lampa_ind":
				{
				_offset = [-0.5,0,4];
				_intensity = 50;
				};	
			case "Land_Lamp_Small_EP1":
				{
				_offset = [0,0,3];
				_intensity = 50;
				};		
			case "Land_Lamp_Street1_EP1":
				{
				_offset = [0,2,6];
				_intensity = 300;
				};	
			case "Land_Lamp_Street2_EP1":
				{
				_offset = [0,2,6];
				_intensity = 300;
				};				
			case "Land_PowLines_Conc2L_EP1":
				{
				_offset = [-0.5,0,5];
				_intensity = 200;
				};		
			case "Land_Lampa_Ind_EP1":
				{
				_offset = [-0.5,0,4];
				_intensity = 50;				
				};					
			default
				{
				_offset = [0,0,5];
				_intensity = 200;	
				};
			};
	
		_intensity = _intensity * tpw_streetlights_factor;	
		_lightpos = getpos _lamp;
		_light = "#lightpoint" createVehiclelocal _lightpos;   
		_light setLightColor _colour; 	
		_light setLightIntensity _intensity;	
		_light setLightAttenuation [1,0,0,500]; 	
		_light lightattachobject [_lamp,_offset];
		_light setLightDayLight false; 
		if (_moths == 1) then 
		{
			_ball = "sign_sphere25cm_F" createvehiclelocal position _lamp;
			_ball attachto [_lamp,_offset];
			_ball hideobject true;
			[position _ball, 2] call BIS_fnc_flies;
			};
		};
	};

// SCAN FOR STREETLIGHTS	
sleep 2;
while {true} do
	{
	if (tpw_streetlights_active) then
		{
		if (position player distance _lastpos > (tpw_streetlights_range/4) && {tpw_core_sunangle < 0}) then
			{
			_lastpos = position player;
				{
				[_x] call _fnc_light;
				} count (position player nearObjects ["StreetLamp",tpw_streetlights_range]);
			};
		};	
	sleep 5.57;
	};
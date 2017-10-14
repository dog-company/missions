/*
TPW HOUSELIGHTS - Ambient house lighting for Arma 3

Author: tpw
Date: 20170618
Version: 1.12
Requires: CBA A3, tpw_core.sqf
Compatibility: SP, MP client

To use: 
1 - Save this script into your mission directory as eg tpw_houselights.sqf
2 - Call it with 0 = [10] execvm "tpw_houselights.sqf"; where 10 = delay until houselighting starts

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this < 1) exitWith {hint "TPW HOUSELIGHTS incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
WaitUntil {!isnil "tpw_core_sunangle"};

// VARIABLES
tpw_houselights_version = "1.12"; // Version string
tpw_houselights_sleep = _this select 0; // Delay until houselights functions start
tpw_houselights_housearray = []; // Array of lightable houses near player
tpw_houselights_radius = 50; // Radius around player to check for houses to spawn lights into
tpw_houselights_active = true; // Global enable/disable	
	
// SPAWN A LIGHT INTO HOUSE AT CEILING LEVEL	
tpw_houselights_fnc_spawnlight =
	{
	private ["_house","_houselight","_x","_y","_z","_startpos","_testpos","_lightpos","_ctr"];
	_house = _this select 0;
	
	//Determine house's ceiling height	
	_x = ((getposasl _house) select 0);
	_y = ((getposasl _house) select 1);
	_z = ((getposasl _house) select 2) + 1;
	_startpos = [_x,_y,_z];
	_ctr = 0;
	waitUntil 
		{
		_z = _z + 0.5;
		_ctr = _ctr + 1;
		_testpos = [_x,_y,_z];
		(lineintersects [_testpos,_startpos] || _ctr == 100)
		};
	
	//Create light object
	if (_ctr < 100) then 
		{
		_z = _z - 0.5;
		_lightpos = asltoatl [_x,_y,_z];
		_houselight = "#lightpoint" createVehiclelocal _lightpos;   
		sleep 0.2;
		_houselight setLightColor [250,200,150]; //slightly yellow
		_houselight setLightAmbient [1,1,0.2]; 
		//_houselight setLightAttenuation [0.3,0,0,500]; 
		_houselight setLightAttenuation [1,4,4,0,1,4]; 
		_houselight setLightIntensity 30;
		_houselight setLightUseFlare true;
		_houselight setLightFlareSize 0.5;
		_houselight setLightFlareMaxDistance tpw_houselights_radius;
		_house setvariable ["tpw_houselights_light",_houselight];
		_house setvariable ["tpw_houselights_lit",1];
		tpw_houselights_housearray set [count tpw_houselights_housearray,_house];
		};
			
	};	
	
// MAIN LOOP - SCAN FOR HOUSES TO LIGHT, REMOVE LIGHTS FROM DISTANT HOUSES
sleep tpw_houselights_sleep;	
private ["_lastpos","_nearhouses","_house","_lithouse","_i"];
_lastpos = [0,0,0];
while {true} do
	{
	if  (tpw_houselights_active && {position player distance _lastpos > tpw_houselights_radius/2} && {tpw_core_sunangle < 0}) then
		{
		_lastpos = position player;
		
		// Scan for habitable houses to spawn lights into
		_nearhouses = [tpw_houselights_radius] call tpw_core_fnc_houses;
		if (count _nearhouses > 0) then
			{
			for "_i" from 0 to (count _nearhouses - 1) do
				{
				_house = _nearhouses select _i;
				// If house has not already been lit then light it
				if (_house getvariable ["tpw_houselights_lit",0] == 0) then 
					{
					[_house] call tpw_houselights_fnc_spawnlight;
					};
				};
			};
		
		// Remove lights from distant houses
		if (count tpw_houselights_housearray > 0) then
			{
			for "_i" from 0 to (count tpw_houselights_housearray - 1) do
				{
				_lithouse = tpw_houselights_housearray select _i;
				if (_lithouse distance player > tpw_houselights_radius) then
					{
					//Remove light from lit house out of range
					deletevehicle (_lithouse getvariable "tpw_houselights_light");
					_lithouse setvariable ["tpw_houselights_lit",0];
					tpw_houselights_housearray set [_i, -1];
					};
				};
			tpw_houselights_housearray = tpw_houselights_housearray - [-1] ;
			};
		};
	sleep 5.13;
	};
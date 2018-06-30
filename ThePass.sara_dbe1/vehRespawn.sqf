/* ---------------------------------------------------------------------------------------------------- 
File: vehRespawn.sqf 
Author: Iceman77
Modified: soulkobk 4:07 PM 13/05/2017 - added load out for specific vehicles.

Description: 
Respawn destroyed and abandoned vehicles (with custom vehicle load outs based on vehicle type, by soulkobk)

Parameter(s): 
_this select 0: vehicle  
_this select 1: abandoned delay in minute(s) - Required 
_this select 2: destroyed delay in minute(s) - Required 

How to use - Vehicle Init Line:  
_nul = [this, 120, 60] execVM "vehRespawn.sqf"; << 2 minute abandoned delay, 1 minute destroyed delay. 
---------------------------------------------------------------------------------------------------- */ 

private "_veh", ;

_veh = _this select 0; 
_abandonDelay = _this select 1; 
_deadDelay = _this select 2; 
_dir = getDir _veh;  
_pos = getPos _veh;  
_vehType = typeOf _veh;  

if (isServer) then
{ 

	_executeLoadout = {
		params ["_veh"];
		clearBackpackCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearWeaponCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		[_veh,[[[["FirstAidKit"],[10]],[["HandGrenade","MiniGrenade","1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeOrange_Grenade_shell","1Rnd_SmokePurple_Grenade_shell","SmokeShell","SmokeShellGreen","SmokeShellOrange","SmokeShellPurple","30Rnd_65x39_caseless_green","10Rnd_762x54_Mag","150Rnd_762x54_Box","Vorona_HE","Vorona_HEAT"],[6,6,6,3,3,3,3,8,8,8,8,40,20,10,10,10]],[["ACE_fieldDressing","ACE_EarPlugs","ACE_epinephrine","ACE_morphine"],[100,50,50,50]],[[],[]]],false]] call bis_fnc_initAmmoBox;	
	};		

	[_veh] call _executeLoadout; // init the load out for the first spawn

	while {true} do { 
		sleep 1; 
		if ((!alive _veh) || (!canMove _veh)) then
		{ 
			_dead = true; 
			for "_i" from 0 to _deadDelay do
			{   
				if (({alive _x} count (crew _veh) > 0) || (canMove _veh)) exitWith {_dead = false;}; 
				sleep 1;   
			}; 
			if (_dead) then
			{ 
				deleteVehicle _veh; 
				sleep 1; 
				_veh = createVehicle [_vehtype, _pos, [], 0, "CAN_COLLIDE"]; 
				[_veh, "Guerilla_03", ["showCamonetHull", 1, "showBags", 1, "showBags2", 1, "showTools", 1, "showSLATHull", 1], true] call bis_fnc_initVehicle;
				_veh setVehicleVarName "ALiVE_SUP_MULTISPAWN_RESPAWNVEHICLE_OPF_F";
				ALiVE_SUP_MULTISPAWN_RESPAWNVEHICLE_OPF_F = _veh;
				publicVariable "ALiVE_SUP_MULTISPAWN_RESPAWNVEHICLE_OPF_F";
				_veh setDir _dir; 
				_veh setPos [_pos select 0, _pos select 1,0];
				[_veh] call _executeLoadout;
			}; 
		}; 
	}; 
};
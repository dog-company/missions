_trigger = _this select 0;

'SmokeShellGreen' createVehicle (getPos player);
'Chemlight_green' createVehicle (getPos player);
[3, 0] remoteExec ['fadeMusic', 0, false];
sleep 3;
[['LeadTrack03_F_EXP',0,1],'bis_fnc_playmusic',true] call BIS_fnc_MP;
[3, 1] remoteExec ['fadeMusic', 0, false];
[(_trigger getVariable 'heli'), [getPos player, (_trigger getVariable 'heliSpawnPos')], (group player)] spawn Zen_OrderExtraction;	
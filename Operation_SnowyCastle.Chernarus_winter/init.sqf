if ((!isServer) && (player != player)) then {waitUntil {player == player};};

setViewDistance 2000;

// Snow Storm

// running script with breath vapors and wind bursts on server side, fog managed by script
//null = [direction_storm,duration_storm,effect_on_objects,ambient_sounds_al,breath_vapors,snow_burst_server_side,snow_burst_client_side,al_fog_snow,snow_indoor,local_fog] execvm "AL_snowstorm\al_snow.sqf";
null = [80,-1,false,40,true,false,true,true,true,true] execvm "AL_snowstorm\al_snow.sqf";

//null = [80,660,false,1,true,false,true,true,true,true] execvm "AL_snowstorm\al_snow.sqf";
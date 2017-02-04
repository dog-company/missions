/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

r3_weatherArray = [];

r3_weatherChange = 
{
	_forceChange = [_this, 0, false] call BIS_fnc_param;
	
	_timeOut = time + 10;
	waitUntil{sleep 0.5; count r3_weatherArray > 0 OR time > _timeOut};
	
	if(count r3_weatherArray > 0) then {
		_r3_overcast = r3_weatherArray select 0;
		_r3_fog = r3_weatherArray select 1;
		_r3_rain = r3_weatherArray select 2;
		_r3_waves = r3_weatherArray select 3;
		_r3_windDir = r3_weatherArray select 4;
		_r3_gusts = r3_weatherArray select 5;

		r3_weatherChangeTime setFog _r3_fog;
		r3_weatherChangeTime setOvercast _r3_overcast;	
		r3_weatherChangeTime setRain _r3_rain;
		r3_weatherChangeTime setWaves _r3_waves;
		r3_weatherChangeTime setWindDir _r3_windDir;
		r3_weatherChangeTime setGusts _r3_gusts;
		
		if(time < 15 OR _forceChange) then {
			0 setFog _r3_fog;
			0 setOvercast _r3_overcast;	
			0 setRain _r3_rain;
			0 setWaves _r3_waves;
			0 setWindDir _r3_windDir;
			0 setGusts _r3_gusts;
			forceWeatherChange;
		};
	};
};

r3_weatherCycle_client = {
	
	waitUntil{sleep 1; !isNil "r3_initClientDone"};
	
	while{true} do {
		[] spawn r3_weatherChange;
		sleep r3_weatherChangeTime;
	};
};
/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

r3_weatherArray = [];

r3_weatherCreate = {

	_r3_overcast = overcast;
	_r3_fog = 0;
	_r3_rain = rain;
	_r3_wind = 0;
	_r3_waves = waves;
	_r3_windDir = 0;
	_r3_gusts = gusts;
	
	switch (toUpper(r3_weatherGlobalSetting)) do { 
		case "RANDOM": {
			
			_diff = r3_weatherOvercast_max - r3_weatherOvercast_min;
			_r3_overcast = (random _diff) + r3_weatherOvercast_min;
			
			if(_r3_overcast > 0.6) then {
				_diff = (r3_weatherRain_max - r3_weatherRain_min) + 0.1;
				_r3_rain = (random _diff) + r3_weatherRain_min;
				
				_diff = r3_weatherWind_max - r3_weatherWind_min;
				_r3_wind = ((random _diff) + r3_weatherWind_min) + 1;
				
				_diff = r3_weatherWaves_max - r3_weatherWaves_min;
				_r3_waves = ((random _diff) + r3_weatherWaves_min) + 0.1;
				
				_r3_gusts = 0.3 + (random 0.3);
				_r3_windDir = floor(random 360);
			} else {
				_r3_rain = r3_weatherRain_min;
				
				_diff = r3_weatherWind_max - r3_weatherWind_min;
				_r3_wind = (random _diff) + r3_weatherWind_min;
				
				_r3_waves = (random r3_weatherWaves_min) + 0.1;
				
				_r3_gusts = (random 0.3);
				_r3_windDir = floor(random 360);
			};
		};
		case "MIN": {
			_r3_overcast = (random r3_weatherOvercast_min) + 0.05;
			_r3_rain = (random r3_weatherRain_min);
			_r3_wind = (random r3_weatherWind_min) + 0.3;
			_r3_waves = (random r3_weatherWaves_min);
			_r3_gusts = (random 0.2);
			_r3_windDir = floor(random 360);
		};
		case "MAX": {
			_r3_overcast = r3_weatherOvercast_max;
			_r3_rain = (random r3_weatherRain_max);
			_r3_wind = (random r3_weatherWind_max) + 1;
			_r3_waves = (random r3_weatherWaves_max) + 0.1;
			_r3_gusts = 0.3 + (random 0.4);
			_r3_windDir = floor(random 360);
		};
	};
	
	r3_weatherArray = [];
	r3_weatherArray pushBack _r3_overcast;
	r3_weatherArray pushBack _r3_fog;
	r3_weatherArray pushBack _r3_rain;
	r3_weatherArray pushBack _r3_waves;
	r3_weatherArray pushBack _r3_windDir;
	r3_weatherArray pushBack _r3_gusts;
	
	publicVariable "r3_weatherArray";
	
	if(isDedicated) then {
		r3_weatherChangeTime setFog _r3_fog;
		r3_weatherChangeTime setOvercast _r3_overcast;	
		r3_weatherChangeTime setRain _r3_rain;
		r3_weatherChangeTime setWaves _r3_waves;
		r3_weatherChangeTime setWindDir _r3_windDir;
		r3_weatherChangeTime setGusts _r3_gusts;
		if(time < 10) then {forceWeatherChange};
	};
	
	setWind [_r3_wind, _r3_wind, true];
};

r3_weatherCycle_server = {

	waitUntil{sleep 1; !isNil "r3_serverFullLoaded"};
	
	while{true} do {
		
		//Overwrite Weather from Parameters
		if(!isNil {r3_weatherParam}) then {r3_weatherGlobalSetting = r3_weatherParam };
		
		[] call r3_weatherCreate;
		sleep r3_weatherChangeTime - 2;
	};
};

















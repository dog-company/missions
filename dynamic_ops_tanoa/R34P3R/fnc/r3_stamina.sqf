/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(r3_enableDebugMode) then { diag_log format ["Stamina Enabled"]; };

[] spawn {

	waitUntil{sleep 2; !isNull player};
	
	private ["_tmp"];
	
	if(isNil {r3_playerIsDragging}) then {r3_playerIsDragging = 0};
	
	while {true} do {
		if(r3_enableStaminaScript) then {
			if(alive player) then {
				if(vehicle player == player) then {
				
					_tmp = getFatigue player;
					_speed = speed player;
					
					switch(true) do {
						case (_speed > 0): {
							if(currentWeapon player == "Binocular") then {
								_tmp = _tmp + 0.012;
							} else {
								_tmp = _tmp - 0.01;
							};
						};
						case (_speed == 0): {
							_tmp = _tmp - 0.013;
						};
						case (_speed < 0): {
							if(r3_playerIsDragging == 1) then {
								_tmp = _tmp + 0.01;
							};
						};
					};

					if(_tmp < 0) then { _tmp = 0 };
					player setFatigue _tmp;
				};
			};
		};
		sleep 1;  
	};

	if(r3_enableDebugMode) then { diag_log format ["Stamina Disabled"]; };
};

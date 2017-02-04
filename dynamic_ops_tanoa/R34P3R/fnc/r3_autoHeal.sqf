/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(r3_enableDebugMode) then { diag_log format ["Autoheal enabled"]; };

[] spawn {

	waitUntil{sleep 2; !isNull player};
	
	private ["_tmp"];

	while {true} do {
		if(r3_enableAutoHeal) then {
			if(alive player) then {
				if(player getVariable ["r3_unitIsDown",0] == 0) then {
					_tmp = getDammage player;
					if(_tmp > 0 && _tmp <= 0.28) then {
						_tmp = _tmp - 0.05;
						if(_tmp < 0) then { _tmp = 0 };
						player setDamage _tmp;
					};
				};
			};
		};
		sleep 30;
	};

	if(r3_enableDebugMode) then { diag_log format ["Autoheal disbaled"]; };
};

/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(!isNull player) then {

	r3_initRespawnDialog =
	{
		_display = _this select 0;
	};

	r3_respawnShowDialog = 
	{
		r3_respawnMaxLifes = r3_respawnMaxLifes -1;
		
		if(r3_respawnMaxLifes > 0) then {
			1099 cutText ["","BLACK IN",2];
			player setPos getMarkerPos r3_tmpRespawnMarker;
			disableSerialization;
			createDialog "Respawn_dialog";
			waitUntil {!isNull (findDisplay 33993)};
			
			{
				_lb = lbAdd [2100,_x];
				if (_x == r3_respawnNames select 0) then {lbSetCurSel [2100,_lb];}
			}forEach r3_respawnNames;
		
			r3_rs_obj = r3_respawnPositions select 0;
			
			if(!isNull r3_rs_obj) then {
				r3_rs_cam = "camera" camCreate [(getPosATL r3_rs_obj select 0) -10, (getPosATL r3_rs_obj select 1) -10, (getPosATL r3_rs_obj select 2) +20]; 
				if(r3_isNight) then {camUseNVG true} else {camUseNVG false};
				r3_rs_cam camSetTarget r3_rs_obj;
				r3_rs_cam cameraEffect ["internal", "BACK"]; 
				r3_rs_cam camCommit 0;
			};
			noesckey = (findDisplay 33993) displayAddEventHandler ["KeyDown", "if ((_this select 1) == 1) then { true }"];
			
			_txt = parseText format ["<t color='#ff0000' shadow='2' size='0.6' font='PuristaMedium'>Lifes available: %1</t>", r3_respawnMaxLifes];
			[_txt, 0, 0.9, 3, 2, 0, 1100] spawn BIS_fnc_dynamicText;
		} else {
			[] spawn r3_rsDeadcam;
		};
	};
	
	r3_rsDeadcam =
	{
		1099 cutText ["","BLACK FADED",0];

		_txt = parseText "<t color='#ff0000' shadow='2' size='0.6' font='PuristaMedium'>No more lifes available...</t>";
		[_txt, 0, 0.9, 4, 1, 0, 1100] spawn BIS_fnc_dynamicText;	
		
		player setPos getMarkerPos r3_tmpRespawnMarker;
		player setVariable ["r3_unitHaveNoLifes", 1, true];
		
		sleep 5;
		
		while{true} do {
		
			r3_rsCamObj = objNull;
			r3_rsAlivePlayers = 0;
			
			{
				if(_x != player) then {
					if(alive _x) then {
						if(isPlayer _x) then {
							if(_x getVariable ["r3_unitHaveNoLifes", 0] == 0) then {
								r3_rsCamObj = _x;
								r3_rsAlivePlayers = r3_rsAlivePlayers +1;
							};
						};
					};
				};
			}forEach units group player;

			if(r3_rsAlivePlayers > 0) then {
				if(!isNull r3_rsCamObj) then {
				
					1099 cutText ["","BLACK IN",1];
					
					r3_rs_cam = "camera" camCreate getPosATL r3_rsCamObj; 
					if(r3_isNight) then { camUseNVG true; };
					r3_rs_cam camSetTarget r3_rsCamObj;
					r3_rs_cam cameraEffect ["internal", "BACK"]; 
					r3_rs_cam camCommit 0;
					r3_rs_cam attachTo [r3_rsCamObj,[0,-2,2]];
					
					_txt = parseText format["<t color='#e2e2e2' shadow='2' size='0.5' font='PuristaMedium'>%1</t>",name r3_rsCamObj];
					[_txt, 0.6, 0.9, 5, 1, 0, 1100] spawn BIS_fnc_dynamicText;	
					
					waitUntil{sleep 5; !alive r3_rsCamObj};
				};	
			} else {
				_txt = parseText "<t color='#ff0000' shadow='2' size='0.6' font='PuristaMedium'>All players in your group are dead !<br/>Please restart Mission.</t>";
				[_txt, 0, 0.9, 5, 1, 0, 1100] spawn BIS_fnc_dynamicText;
			}
		};
	};
	
	r3_rsObjChanged =
	{
		_id = _this select 0;
		r3_rs_obj = r3_respawnPositions select _id;
		
		if(!isNil "r3_rs_cam") then {
			r3_rs_cam camSetPos [(getPosATL r3_rs_obj select 0) -10, (getPosATL r3_rs_obj select 1) -10, (getPosATL r3_rs_obj select 2) +20]; 
			r3_rs_cam camSetTarget r3_rs_obj;
			r3_rs_cam camCommit 0;
		};
	};
	
	r3_respawnCloseDialog = 
	{
		(findDisplay 33993) displayRemoveEventHandler ["KeyDown", noesckey];
		closeDialog 33993;
	};
	
	r3_respawnMoveInVeh = {
		1099 cutText ["","BLACK IN",2];
		player moveInAny r3_rs_obj; 
		
		if(!isNil "r3_rs_cam") then {
			r3_rs_cam cameraEffect ["terminate","back"]; 
			camDestroy r3_rs_cam;
		};
		
		[] call r3_respawnCloseDialog;		
	};
	
	r3_resapwnMoveToPos = {
		_newPos = (getPos r3_rs_obj) findEmptyPosition [1,20,"B_Soldier_F"];
		if(count _newPos > 0) then {
		
			1099 cutText ["","BLACK IN",2];
			player setPos _newPos; 
			
			if(!isNil "r3_rs_cam") then {
				r3_rs_cam cameraEffect ["terminate","back"]; 
				camDestroy r3_rs_cam;
			};
			
			[] call r3_respawnCloseDialog;
		};	
	};
	
	r3_respawnButtonPressed =
	{
		if(!isNil "r3_rs_obj") then {
			if(r3_rs_obj isKindOf "Air" OR r3_rs_obj isKindOf "Car" OR r3_rs_obj isKindOf "Tank") then {
				if(speed r3_rs_obj > 1) then {
					if((r3_rs_obj emptyPositions "cargo") > 0 OR (r3_rs_obj emptyPositions "gunner") > 0 OR (r3_rs_obj emptyPositions "driver") > 0) then {
						[] call r3_respawnMoveInVeh;
					} else {
						[] call r3_resapwnMoveToPos;
					};
				} else {
					[] call r3_resapwnMoveToPos;
				};
			} else {
				[] call r3_resapwnMoveToPos;
			};
		};
	};
};














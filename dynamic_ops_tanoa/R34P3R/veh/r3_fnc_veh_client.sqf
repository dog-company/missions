/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

if(!isNull player) then {

	r3_veh_DriverNotice =
	{
		hintSilent parseText "<img size='1.4' image='R34P3R\img\hint_repair.jpg'/><br/>Your vehicle seems to be damaged, you can fix it by using a ToolKit. Check the vehicle inventory if you don't have one.";
		player setVariable ["r3_vehDriverNotice", 1];
	};
	
	r3_veh_AddPlayerAction =
	{
		if(r3_vehAllowRepair > 0 && count r3_vehObjects > 0) then {
			player addAction ["<img image='R34P3R\img\repair32.paa'/> <t color=""#ff8400"">" + "Repair" + "</t>", "[] call r3_veh_Repair", [false], 10, true, true, "", "call r3_veh_CheckRepair"];
		};
	};
	
	r3_veh_Repair =
	{
		_veh = cursorTarget;
		
		if(!isNull _veh) then {
			_vehIsDamaged =	_veh getVariable ["r3_vehIsDamaged", 0];
			
			if(_vehIsDamaged == 1) then {
				_veh setVariable ["r3_vehGetRepair", 1, true];
				_vehType = typeOf _veh;
		
				player playMove "Acts_carFixingWheel";
		
				sleep 3;
				
				[[player, "veh_repair"], "say3DMP"] call BIS_fnc_MP;
				
				_hitPoints = [];
				configProperties [ configFile >> "CfgVehicles" >> _vehType >> "HitPoints", "_hitPoints pushBack configName _x; true", true ];	
				
				{
					if(alive player) then {
						
						_vehHitDmg = _veh getHitPointDamage _x;
						
						if(_vehHitDmg > 0) then {
							_veh setHitPointDamage [_x, 0];
							sleep 0.6;
						};
					};
				}count _hitPoints;

				if(alive player) then {
					_veh setDamage 0;
					//[[player, "amovpknlmstpsraswrfldnon"], "switchMoveMP"] call BIS_fnc_MP;
					sleep 1;
					_veh setVariable ["r3_vehGetRepair", 0, true];
					_veh setVariable ["r3_vehIsDamaged", 0, true];
				};
			};
		};
	};
	
	r3_veh_CheckRepair =
	{
		_veh = cursorTarget;
		_return = false;
		
		if(!isNull _veh) then {
			if(alive player) then {
				if(vehicle player == player) then {
					if((player distance _veh) < 3.5) then {
					
						_vehIsDamaged =	_veh getVariable ["r3_vehIsDamaged", 0];
						_vehGetRepair =	_veh getVariable ["r3_vehGetRepair", 0];
						
						if(_vehIsDamaged == 1 && _vehGetRepair == 0) then {
							switch(r3_vehAllowRepair) do {
								case 0: { _return = false; };
								case 1: { if("ToolKit" in (items player)) then { _return = true; }; };
								case 2: { _return = true; };
							};
						};
					};
				};
			};
		};
		_return
	};
	
};

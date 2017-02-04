/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
if(isServer) then {

	r3_dogLoop = 
	{
		_dog = [_this, 0, objNull] call BIS_fnc_param;
		_dogLeader = [_this, 1, objNull] call BIS_fnc_param;
		_dogFoundEnemy = false;
		_dogEnemy = objNull;
		
		if(!isNull _dog && !isNull _dogLeader) then {
			while {alive _dog} do {
					
				if (_dog getVariable "dogIsAttacking" == 0) then {
					
					[[_dog,"dogSearch"], "say3DMP"] call BIS_fnc_MP;
					
					{
						if(!isNull _x) then {
							if(!_dogFoundEnemy && _x isKindOf "Man") then {
								if((_dog distance _x) < r3_dogSpotRange) then {
									if([_x] call r3_dogEnemyIsAlive) exitWith {
										_dogFoundEnemy = true;
										_dogEnemy = _x;
									};
								};
							};
						};
						sleep 1;
					}forEach r3_playableUnits;
					
					sleep 2;
					
					if(_dogFoundEnemy && !isNull _dogEnemy) then {

						[[_dog,"dogHowl"], "say3DMP"] call BIS_fnc_MP;
						
						(group _dog) reveal [_dogEnemy, 3];
						[_dog, _dogLeader, _dogEnemy] spawn r3_dogAttack;
						
						_dogEnemy = objNull;
						_dogFoundEnemy = false;
					};
				};
				sleep 15 + floor(random 15);
			};
		};
	};

	r3_dogEnemyIsAlive = 
	{
		_enemyUnit = [_this, 0, objNull] call BIS_fnc_param;
		_return = false; 
		
		if(!isNull _enemyUnit) then {
			if(r3_enableReviveScript) then {
				if(alive _enemyUnit) then {
					if(_enemyUnit getVariable ["r3_unitIsDown",0] == 0) then {
						if(_enemyUnit getVariable ["r3_unitIsCalled",0] == 0) then {
							if(_enemyUnit getVariable ["r3_unitGetDrag",0] == 0) then {
								_return = true;
							};
						};
					};
				};
			} else {
				if(alive _enemyUnit && !captive _enemyUnit) then {
					_return = true;
				};
			};
		};
		_return
	};

	r3_dogAttack = 
	{
		_dog = [_this, 0, objNull] call BIS_fnc_param;
		_dogLeader = [_this, 1, objNull] call BIS_fnc_param;
		_enemyUnit = [_this, 2, objNull] call BIS_fnc_param;
		
		if(!isNull _dog && !isNull _dogLeader && !isNull _enemyUnit) then {
			if(alive _dog && _dog getVariable ["dogIsAttacking",0] == 0) then {
			
				_dog setUnitPos "UP";
				_dog setVariable ["dogIsAttacking", 1];
				
				_dogGrp = createGroup (side _dogLeader);
				[_dog] joinSilent _dogGrp;
				
				[[_dog,"dogBark"], "say3DMP"] call BIS_fnc_MP;
				
				while {alive _dog && (_dog distance _enemyUnit) > 2.2 } do {
				
					_dog doMove getPos _enemyUnit;
					_dog moveTo getPos _enemyUnit;
					
					_vel = velocity _dog;
					_dir = direction _dog;
					_dog setVelocity [(_vel select 0)+(sin _dir*3),(_vel select 1)+(cos _dir*3),(_vel select 2)];
					
					sleep 1;
				};
				
				while {alive _dog && ([_enemyUnit] call r3_dogEnemyIsAlive)} do {
					
					if((_dog distance _enemyUnit) < 2.2) then {
						if(alive _dog && ([_enemyUnit] call r3_dogEnemyIsAlive)) then {
							
							[[_dog,"dogAttack"], "say3DMP"] call BIS_fnc_MP;
							
							_dog setDir ([_dog,_enemyUnit] call BIS_fnc_dirTo);
							sleep 0.1;
							
							_dogDamage = (_enemyUnit getHitPointDamage "HitLegs") + 0.32;
							
							if(_dogDamage >= 1) then {
								_enemyUnit setHitPointDamage ["HitLegs", 0.98];
								
								if(r3_enableReviveScript) then {
									if (isPlayer _enemyUnit) then {
										[[_enemyUnit, "legs", 1, _dog], "r3_unitHandleDamage_EH", _enemyUnit] call BIS_fnc_MP;
									} else {
										[[_enemyUnit, "legs", 1, _dog], "r3_unitHandleDamage_AI", _enemyUnit] call BIS_fnc_MP;
									};
								} else {
									_enemyUnit setDamage 1;
								};
							} else {
								_enemyUnit setHitPointDamage ["HitLegs", _dogDamage];
							};
						};
					} else {
						_dog doMove getPos _enemyUnit;
						_dog moveTo getPos _enemyUnit;
					};
					sleep 1.5;
				};
				
				if(alive _dog) then {
				
					_dog setUnitPos "AUTO";
					_dog setVariable ["dogIsAttacking", 0];

					if(alive _dogLeader) then {
						[_dog] joinSilent (group _dogLeader);
						_dog doMove getPos _dogLeader;
						_dog moveTo getPos _dogLeader;
					} else {
						_uList = _dog nearEntities ["Man", 300];
						{
							if((side _x == side _dog) && alive _x && alive _dog) exitWith { 
								_dog doMove getPos _x;
								_dog moveTo getPos _x;
								[_dog] joinSilent (group _x);
							};
							sleep 0.5;
						}forEach _uList;
					};
				};
			};
		};
	};
	
};
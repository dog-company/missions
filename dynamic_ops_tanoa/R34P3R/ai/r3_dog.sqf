/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////
if(isServer) then {

	// TO SPAWN A DOG USE: [this,true] execVM "R34P3R\ai\r3_dog.sqf";
	// the second parameter select the randomize. Use FALSE to 100% spawn a DOG. else it spawn random.

	_dogLeader = [_this, 0, objNull] call BIS_fnc_param;
	_dogIsRandom = [_this, 1, true] call BIS_fnc_param;
	_spawnDog = true;
	
	if(!isNull _dogLeader) then {
		
		waitUntil{sleep 5; !isNil{r3_serverFullLoaded}};
	
		if(_dogIsRandom) then {
			_rnd = floor(random 2);
			if(_rnd == 0) then { _spawnDog = false };
		};
		
		if(_spawnDog) then {
			_dogGrp = group _dogLeader;
			_dogPos = [(getPosATL _dogLeader select 0) +1, (getPosATL _dogLeader select 1) +1, 0.1];

			_dog = _dogGrp createUnit ["Alsatian_Sandblack_F", _dogPos, [], 0, "CAN_COLLIDE"];
			_dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
			_dog setSpeedMode "FULL";
			_dog disableConversation true;
			_dog disableAI "TARGET";
			_dog disableAI "AUTOTARGET";
			_dog disableAI "FSM";
			_dog disableAI "AIMINGERROR";
			_dog disableAI "SUPPRESSION";
			_dog enableFatigue false;
			_dog allowFleeing 0;
			_dog setVariable ['dogIsAttacking', 0];
			[_dog, _dogLeader] spawn r3_dogLoop;
		};	
	};
};
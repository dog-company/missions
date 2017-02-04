/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

switchMoveMP = compileFinal "_this select 0 switchMove (_this select 1)";
playMoveNowMP = compileFinal "_this select 0 playMoveNow (_this select 1)";
say3DMP = compileFinal "if(player distance (_this select 0) < 80) then {_this select 0 say3D (_this select 1)}";
playSoundMP = compileFinal "if(!isNull player) then {playSound [(_this select 0),true] }";
doMoveMP = compileFinal "if(local (_this select 0)) then {_this select 0 doMove (_this select 1) }";
stopMP = compileFinal "if(local (_this select 0)) then {_this select 0 stop (_this select 1) }";
setDirMP = compileFinal "_this select 0 setDir (_this select 1)";
enableSimMP = compileFinal "_this select 0 enableSimulation (_this select 1)";
setObjectTextureMP = compileFinal "_this select 0 setObjectTexture (_this select 1)";
hintMP = compileFinal "if(!isNull player) then {hintSilent (_this select 0)}";
removeActionMP = compileFinal "_this select 0 removeAction (_this select 1)";
removeAllActionMP = compileFinal "removeAllActions (_this select 0)";

//hideObject
hideObjectMP = {
	_obj = [_this, 0, objNull] call BIS_fnc_param;
	_value = [_this, 1, true] call BIS_fnc_param;
	
	if(!isNull _obj) then {
		if(!isNull player) then {
			_obj hideObject _value;
		};
		if(isDedicated) then {
			_obj hideObjectGlobal _value;
		};
	};
};

//SideChat Multiplayer
r3_CROSSROAD = [west , "Papa_bear"];
r3_AIRBASE = [west , "airbase"];
r3_BASE = [west , "base"];
sideChatMP = compileFinal "_this select 0 sideChat (_this select 1);";
groupChatMP = compileFinal "_this select 0 groupChat (_this select 1);";

r3_endMissionMP = {
	if(isServer) then {
		_endName = [_this, 0, "End1"] call BIS_fnc_param;
		_isVictory = [_this, 1, false] call BIS_fnc_param;
		_fadeTime = [_this, 2, 2] call BIS_fnc_param;
		
		[[_endName,_isVictory,_fadeTime], "BIS_fnc_endMission", true, true, true] call BIS_fnc_MP;
	};
};

// Effects
r3_effect =
{
	_obj = [_this, 0, objNull] call BIS_fnc_param;
	_time =  [_this, 1, 10] call BIS_fnc_param;
	_effect =  [_this, 2, "ObjectDestructionSmoke1_2Smallx"] call BIS_fnc_param; // IEDMineGarbage1, MineDust2, ObjectDestructionSmokeSmallx, BigDestructionFire, FireSparks, ObjectDestructionFire2Smallx, ObjectDestructionSmoke2x 
	
	if(!isNull player && !isNull _obj) then {
		_eff = "#particlesource" createVehicleLocal (getPosATL _obj);
		_eff setParticleClass _effect;
		_eff attachTo [_obj,[0,0,0]];
		sleep _time;
		detach _eff;
		deleteVehicle _eff;
	};
};	

//Hint Message
r3_hint = {
	_txt =	 	[_this, 0, ""] call BIS_fnc_param;
	_img = 		[_this, 1, ""] call BIS_fnc_param;
	_timeOut =	[_this, 2, 7] call BIS_fnc_param;
	_txtSize =  [_this, 3, 1.1] call BIS_fnc_param;
	_imgSize = 	[_this, 4, 11] call BIS_fnc_param;
	_color =	[_this, 5, "#ffffff"] call BIS_fnc_param;
	_silent = 	[_this, 6, true] call BIS_fnc_param;
	
	if(isNil {r3_hintIsOpen}) then { r3_hintIsOpen = false };
	
	if(!isNull player) then {
		if(alive player) then {
			if(!isNil "_txt") then {
				
				_hint = "";
				
				if(_img == "") then {
					_hint = parseText format["<t color='%3' size='%2' shadow='1' align='left'>%1</t>",_txt,_txtSize,_color];
				} else {
					_hint = parseText format["<img image='%4' size='%5' shadow='2'/><br/><br/><t color='%3' size='%2' shadow='1' align='left'>%1</t>",_txt,_txtSize,_color,_img,_imgSize];
				};
				
				if(!isNil '_hint') then {
			
					if(r3_hintIsOpen) then {
						waitUntil{sleep 1; !r3_hintIsOpen OR !alive player};
					};
					
					if(_silent) then {
						hintSilent _hint;
					} else {
						hint _hint;
					};
					
					r3_hintIsOpen = true;
					sleep _timeOut;
					hintSilent "";
					r3_hintIsOpen = false;
				};
			};
		};
	};
};

//SkipTime
r3_skipTime =
{
	_addMin = [_this, 0, 0] call BIS_fnc_param;
	_addDays = [_this, 1, 0] call BIS_fnc_param;
	
	if(_addMin > 0) then {
		_now = date;  //[2014,10,30,2,30]
		_year = _now select 0;
		_month = _now select 1;
		_day = (_now select 2) + _addDays;
		_hour = _now select 3;
		_min  = (_now select 4) + _addMin;
		setDate [_year, _month, _day, _hour, _min];
	};
};

// Vehicle Stuff
r3_break_vehicle = 
{
	_vehicle = _this select 0;
	_newSpeed = _this select 1;
	
	while{speed _vehicle > _newSpeed && canMove _vehicle} do {
		_vel = velocity _vehicle; 
		_dir = direction _vehicle; 
		_vehicle setVelocity [ (_vel select 0) - (sin _dir), (_vel select 1) - (cos _dir), (_vel select 2) ];
		sleep 0.2;
	};
};

r3_acclerate_vehicle = 
{
	_vehicle = _this select 0;
	_newSpeed = _this select 1;
	_timeout = _this select 2;
	
	_timeOut = time + _timeout;
	
	while{speed _vehicle < _newSpeed && time < _timeout && canMove _vehicle} do {
		_vel = velocity _vehicle; 
		_dir = direction _vehicle; 
		_vehicle setVelocity [ (_vel select 0) + (sin _dir), (_vel select 1) + (cos _dir), (_vel select 2) ];
		sleep 0.2;
	};
};

r3_vehicleReady = 
{
    _veh = [_this, 0, objNull] call BIS_fnc_param;
    _ready = true;
    {
        if(!isNull _x) then {
            _ready = _ready && (unitReady _x);
        };
    } forEach [(commander _veh), (gunner _veh), (driver _veh)];
    _ready
};
	
// AI Stuff:
r3_aiMoveAndGetIn = 
{
	_unit = [_this, 0, objNull] call BIS_fnc_param;
	_vehicle = [_this, 1, objNull] call BIS_fnc_param;
	_vehiclePos = [_this, 2, "CARGO"] call BIS_fnc_param;
	
	if(!isNull _unit && !isNull _vehicle) then {
		if(alive _unit && canMove _vehicle) then {
			if(local _unit) then {
				_unit stop false;
				
				switch(toUpper(_vehiclePos)) do {
					case "DRIVER": { _unit assignAsDriver _vehicle; [_unit] orderGetIn true; };
					case "COMMANDER": { _unit assignAsCommander _vehicle; [_unit] orderGetIn true; };
					case "GUNNER": { _unit assignAsGunner _vehicle; [_unit] orderGetIn true; };
					case "CARGO": { _unit assignAsCargo _vehicle; [_unit] orderGetIn true; };
					case "PILOT": { _unit assignAsDriver _vehicle; [_unit] orderGetIn true; };
					case "TURRET": { _unit assignAsTurret [_vehicle,[0,0]]; [_unit] orderGetIn true;};
					default { _unit assignAsCargo _vehicle; [_unit] orderGetIn true; };
				};

			};
		};
	};
};
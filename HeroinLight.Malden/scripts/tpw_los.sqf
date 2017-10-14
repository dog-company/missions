/*
TPW LOS - Units react rapidly to enemies they have line of sight to.
Version: 1.13
Author: tpw
Date: 20140910
Original Line of sight stuff: SaOk 
Azimuth stuff: CarlGustaffa
Additional code: Ollem
Requires: CBA A3, tpw_core.sqf
Compatibility: SP
	
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as eg tpw_los.sqf
2 - Call it with 0 = [0,100,25,2] execvm "tpw_los.sqf"; where 0 = debugging, 100 = maximum distance (m), 25 = minimum distance, 2 = delay before LOS functions start
	

THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if ((count _this) < 4) exitWith {hint "TPW LOS incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
WaitUntil {!isnil "tpw_core_sunangle"};


// VARIABLES
tpw_los_version = "1.13"; // Version string
tpw_los_debug = _this select 0; // Debugging. Units with los to a visible enemy will have a blue ball over their heads. 0 = no debugging, 1 = debugging.
tpw_los_maxdist = _this select 1; // Maximum distance (m). LOS stuff only works for units closer than this.
tpw_los_mindist = _this select 2; // Minimum distance (m). Enemies are considered "visible" no matter what, if less than this distance.
tpw_los_sleep = _this select 3; // Delay before LOS functions start. 
tpw_los_active = true; // Global enable/disable

//COLOURED BALL
tpw_los_fnc_colourball = 
	{
	private ["_ball"];
	_ball = _this select 0;
	_ball setObjectTexture [0,"#(argb,8,8,3)color(0.2,0.2,0.9,0.5,ca)"];
	};		
	
//HIDE BALL
tpw_los_fnc_hideball = 
	{
	private ["_ball"];
	_ball = _this select 0;
	_ball hideobject true;
	};

//UNHIDE BALL
tpw_los_fnc_showball = 
	{
	private ["_ball"];
	_ball = _this select 0;
	_ball hideobject false;
	};	

// RAPIDLY TURN TO ENEMY
tpw_los_fnc_turn =
	{
	private ["_unit","_near","_i","_stance","_delta","_inc","_div"];
	_unit = _this select 0;
	_near = _this select 1;
	_delta = _this select 2;
	_stance = stance _unit;

	switch _stance do
		{
		case "prone": 
			{
			_div = 6;
			};
		case "crouch": 
			{
			_div = 4;
			};
		case "stand": 
			{
			_div = 2;
			};
		default 
			{
			_div = 2;
			};	
		};
	
	// Turn increment (smaller for lower stances ie slower)
	_inc = (_delta / _div) * 0.1; 
	_unit setvariable ["tpw_los_turning", 1]; 
	
	for "_i" from 1 to 10 do 
		{
		sleep 0.01;
		_unit setdir ((direction _unit) + _inc);
		};

		_unit setvariable ["tpw_los_turning", 0]; 	
	};

//MAIN FUNCTION
tpw_los_fnc_mainloop =  
	{
	private ["_x","_nexttime","_unit","_near","_nearunits","_a","_b","_dirto","_eyed","_eyepb","_eyepa","_eyedv","_ang","_tint","_lint","_vm","_dist","_esp","_usp","_camo","_formula","_ball","_upos","_stance","_delta","_unitdir","_mod","_fsmtime"]; 	
	    {
		// ONLY RUN FOR UNINJURED COMBATANT AI
		if ((side _x != civilian) && {(canstand _x) && (_x != player)} && {behaviour _x != "SAFE"} && {behaviour _x != "CARELESS"}) then 
			{	 
			_unit = _x; 
			_nexttime = _unit getvariable ["tpw_los_nexttime", -1]; 
			_fsmtime = _unit getvariable ["tpw_los_fsmtime", -1]; 
			_turning = _unit getvariable ["tpw_los_turning", 0]; 
	
			//SET UP INITIAL UNIT PARAMETERS
			if(_nexttime == -1) then 
				{
				//ENEMY SIDE
				switch (side _unit) do 
				{
				case east: 
					{
					_unit setvariable ["tpw_los_enemyside",west];
					};
				case west: 
					{
					_unit setvariable ["tpw_los_enemyside",east];
					};
				case resistance: 
					{
					_unit setvariable ["tpw_los_enemyside",east];
					};
				};
				
				//DEBUG BLUE BALLS
				if (tpw_los_debug == 1) then 
					{
					_ball = "sign_sphere25cm_F" createvehicle getpos _unit;
					if (isMultiplayer) then 
						{
						_ball setObjectTexture [0,"#(argb,8,8,3)color(0.2,0.2,0.9,0.5,ca)"];
						}
					else
						{
						[[_ball], "tpw_los_fnc_colourball",false] spawn BIS_fnc_MP;
						};
					_ball attachto [_unit,[0,0,2.3]]; 
					_unit setvariable ["tpw_los_losball",_ball];
					_unit addeventhandler ["killed","_this call tpw_los_fnc_deadclean"];
					};
				_unit setvariable ["tpw_los_nexttime", diag_ticktime + random 1];
				};
			
			//ALLOW INDEPENDENT MOVEMENT AND TARGETTING 
			if (diag_ticktime >= _fsmtime) then  
				{	 
				//DISABLE FSM
				_unit enableai "AUTOTARGET";
				_unit enableai "MOVE";
				};
	
			//IF ENOUGH TIME HAS PASSED SINCE LAST LOS CHECK	
			if(diag_ticktime >= _nexttime) then  
				{	 
				//HIDE DEBUG BALLS
				if (tpw_los_debug == 1) then 
					{
					_ball = _unit getvariable "tpw_los_losball"; 
					if (isMultiplayer) then 
						{
						[[_ball], "tpw_los_fnc_hideball",false] spawn BIS_fnc_MP;
						}
					else
						{
						_ball hideobject true;
						};
					};		
				_unit setvariable ["tpw_los_nexttime", diag_ticktime + random 1]; 
		
				//FIND NEAR MEN AND CARS
				_nearunits = (getpos _unit) nearentities [["camanbase","car_f"],tpw_los_maxdist]; 
				for "_i" from 0 to (count _nearunits - 1) do
					{ 
					_near = _nearunits select _i; 
					tpw_los_cansee = 0; 
					
					//IF ENEMY
					if (side _near == _unit getvariable "tpw_los_enemyside") then  
						//DOES UNIT HAVE LINE OF SIGHT
						{ 
						_a = _unit;  
						_b = _near;  
						_eyedv = eyedirection _a;  
						_eyed = ((_eyedv select 0) atan2 (_eyedv select 1));   
						_dirto = ([_b, _a] call bis_fnc_dirto);  
						_ang = abs (_dirto - _eyed); 
						_eyepa = eyepos _a; 
						_eyepb = eyepos _b; 
						_tint = terrainintersectasl [_eyepa, _eyepb]; 
						_lint = lineintersects [_eyepa, _eyepb]; 
						if (((_ang > 120) && (_ang < 240)) && {!(_lint) && !(_tint)}) then
							{
							//OTHER FACTORS AFFECTING VISIBILITY OF ENEMY
							_vm = (currentvisionmode _unit); 
							if (_vm == 1) then 
								{
								_vm = -1
								} 
								else 
								{
								_vm = 1
								}; 

							_dist = (_unit distance _near); 
							_esp = abs (speed _near);
							_usp = abs (speed _unit);
							_camo = getnumber (configfile >> "cfgvehicles" >> (typeof _near) >> "camouflage");
							
							//GET ENEMY'S CURRENT STANCE
							_stance= stance _b;
							switch _stance do
								{
								case "STAND": 
									{
									_upos = 1.00;
									};
								case "CROUCH":
									{
									_upos = 0.75;
									};
								case "PRONE":
									{
									_upos = 0.25;
									};	
								default 
									{
									_upos = 1.00;
									};
								};
								
							//MAGIC VISIBILITY FORMULA
							_formula = (_vm * (tpw_core_sunangle) * _upos) + (_esp * 6) - (_usp * 2) - _dist + random 40;
							
							//ANYONE LESS THAN 25m IS FAIR GAME
							if (_dist < tpw_los_mindist) then 
								{
								_formula = 200
								};
							
							//IGNORE CAMO ENEMY	
							if (_camo > 0.5) then 
								{
								tpw_los_cansee = _formula
								};
							};
						}; 
					if (tpw_los_cansee > 0) exitwith  
						//IF VISIBLE ENEMY
						{ 
						//DISALLOW INDEPENDENT MOVEMENT AND TARGETTING FOR NEXT 5 SEC
						_unit disableai "AUTOTARGET";
						_unit disableai "MOVE";
						_unit setvariable ["tpw_los_fsmtime", diag_ticktime + 5]; 
						
						//HOW MANY DEGREES MUST UNIT TURN TO FACE ENEMY
						_dirto = ([_a, _b] call bis_fnc_dirto);  
						_unitdir = direction _unit;
						_delta = (_dirto - _unitdir);
						if (_delta <= -180) then 
							{
							_delta = 360 + _delta;
							};
						
						// ONLY RAPID TURN AND FIRE IF NOT ALREADY TURNING, AND IF MORE THAN 15 DEGREES FROM ENEMY
						_unit lookat _near; 
						if ((_turning == 0) && ((abs _delta) > 15)) then 
							{
							[_unit,_near,(floor _delta)] spawn tpw_los_fnc_turn;
							};	
						if ((combatMode _x) != "BLUE") then
							{			
							_unit lookat _near;
							_unit dotarget _near;
							_unit dofire _near;	
							};
						
						//SHOW DEBUG BALLS
						if (tpw_los_debug == 1) then 
							{
							if (isMultiplayer) then 
								{
								[[_ball], "tpw_los_fnc_showball",false] spawn BIS_fnc_MP;
								}
							else
								{
								_ball hideobject false;
								};
							}; 
						};
					}; 
				};
			}; 
		} foreach allunits;
	};

//CLEAN UP DEBUG BALLS FROM DEAD UNITS
tpw_los_fnc_deadclean = 
	{
	_unit = _this select 0;
	_ball = _unit getvariable "tpw_los_losball";
	detach _ball; 
	deleteVehicle _ball;  
	};

//RUN IT
sleep tpw_los_sleep;  
[tpw_los_fnc_mainloop,0.5] call cba_fnc_addperframehandler;

while {true} do
	{
	// dummy loop so script doesn't terminate
	sleep 10;
	};
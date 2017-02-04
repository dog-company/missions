_unit = _this select 0;
_backpack = backpack _unit;

diag_log format ["DRO: paraBackpack called for unit %1", _unit];

_unit allowDamage false; 
_unit switchMove "HaloFreeFall_non";
_unit disableAI "ANIM";

_backpackClass = "";
_backpackItems = [];
if (count _backpack > 0) then {
	_backpackClass = _backpack call BIS_fnc_basicBackpack;	
	_backpackItems = backPackItems _unit;
	
	removeBackpackGlobal _unit;
	_unit addBackpackGlobal "B_Parachute";
	diag_log format ["Unit %1 received a parachute", _unit];
} else {
	_unit addBackpackGlobal "B_Parachute";
	diag_log format ["Unit %1 received a parachute", _unit];
};
/*
if (isPlayer _unit) then {
	[_unit, ['Eject', (objectParent _unit)]] remoteExec ['action', _unit, false];			
	unassignvehicle _unit;
} else {
	_unit action ['Eject', (objectParent _unit)];
};
*/
if (count _backpackClass > 0) then {
	
	waitUntil {isNull (objectParent _unit)};		
	
	_backpackDummy = _backpackClass createVehicle position _unit;
	_backpackHolder = objectParent _backpackDummy;
	_backpackHolder attachTo [_unit, [-0.1, 0, -0.7], "Pelvis"];
	_backpackHolder setVectorDirAndUp [[0, -1, 0],[0, 0, -1]];
	
	waitUntil {!isNull (objectParent _unit)};
	
	deleteVehicle _backpackDummy;
	deleteVehicle _backpackHolder;
		
	_backpackDummy = _backpackClass createVehicle position _unit;
	_backpackHolder = objectParent _backpackDummy;
	_backpackHolder attachTo [vehicle _unit, [-0.1, 0.7, 0]];
	_backpackHolder setVectorDirAndUp [[0, 0, -1],[0, 1, 0]];
	
	_unit allowDamage true; 	
	_unit enableAI "ANIM";
	
	waitUntil {(isNull (objectParent _unit))};
	
	deleteVehicle _backpackDummy;
	deleteVehicle _backpackHolder;
	
	removeBackpack _unit;
	_unit addBackpackGlobal _backpackClass;	
	{_unit addItemToBackpack _x} forEach _backpackItems;
		
	
} else {
	
	waitUntil {animationState _unit == "para_pilot"};
	
	_unit allowDamage true; 	
	_unit enableAI "ANIM";
	
};



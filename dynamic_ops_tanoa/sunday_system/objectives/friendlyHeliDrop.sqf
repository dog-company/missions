_dropPos = _this select 0;
_lastTask = _this select 1;
_heliTransports = _this select 2;

//_spawnDist = 3000;
//_spawnPos = [_dropPos, _spawnDist, (random 360)] call BIS_fnc_relPos;
_spawnPos = [_dropPos,3000,5000,0,1,100,0] call BIS_fnc_findSafePos;

_heliClass = [_heliTransports, false] call Zen_ArrayGetRandom;
_heli = createVehicle [_heliClass, _spawnPos, [], 0, "FLY"];
createVehicleCrew _heli;
_heli setCaptive true;

_maxUnits = ((configFile >> "CfgVehicles" >> _heliClass >> "transportSoldier") call BIS_fnc_GetCfgData);
_reinfGroup = [_spawnPos, playersSide, pInfGroups, [4,_maxUnits], "Infantry"] call sun_spawnCfgGroup;						
[_reinfGroup, _heli] spawn Zen_MoveInVehicle;

0 = [_heli, [_dropPos, _spawnPos], _reinfGroup, "normal", 40, "land", true] spawn Zen_OrderInsertion;

_markerName = format["dropMkr%1", floor(random 10000)];
_markerDrop = createMarker [_markerName, _dropPos];
_markerDrop setMarkerShape "ICON";
_markerDrop setMarkerType  "o_air";
_markerDrop setMarkerAlpha 0;

// Create task
//_thisTask = format ["task%1", floor(random 100000)];
//[group groupLeader, _thisTask, ["Cover insertion of friendly units", "Wait and Cover", _markerName], _dropPos, "CREATED", 1, true, "defend", false] call BIS_fnc_taskCreate;
//sleep 1;
[_lastTask, 'SUCCEEDED', true] spawn BIS_fnc_taskSetState;	

sleep 2;

// Create triggers
_trgAllOut = createTrigger ["EmptyDetector", _dropPos, true];
_trgAllOut setTriggerArea [200, 200, 0, false];
_trgAllOut setTriggerActivation ["ANY", "PRESENT", false];
_trgAllOut setTriggerStatements [
	"
		(({alive _x || _x in (thisTrigger getVariable 'heli')} count(units(thisTrigger getVariable 'reinfGroup'))) == 0)
	",
	"						
		[(thisTrigger getVariable 'reinfGroup'), (getPos (leader (thisTrigger getVariable 'reinfGroup'))), 200] call bis_fnc_taskPatrol;
	", 
	""];
_trgAllOut setVariable ["reinfGroup", _reinfGroup];
_trgAllOut setVariable ["heli", _heli];
//_trgAllOut setVariable ["thisTask", _thisTask];

// Damage trigger
/*
trgDamaged = createTrigger ["EmptyDetector", _center, true];
trgDamaged setTriggerArea [0, 0, 0, false];
trgDamaged setTriggerActivation ["ANY", "PRESENT", false];
trgDamaged setTriggerStatements [
	"
		(!canMove (thisTrigger getVariable 'heli'))
	",
	"
		[(thisTrigger getVariable 'thisTask'), 'CANCELED', true] spawn BIS_fnc_taskSetState;			
	",
	""];
trgDamaged setTriggerTimeout [3, 5, 8, false];
trgDamaged setVariable ["heli", _heli];
trgDamaged setVariable ["thisTask", _thisTask];
*/
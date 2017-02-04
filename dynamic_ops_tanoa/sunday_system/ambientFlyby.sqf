_center = _this select 0;
_vehTypes = _this select 1;

_numFlyBys = [2,8] call BIS_fnc_randomInt;

for "_i" from 0 to _numFlyBys do {
	
	sleep ([120, 480] call BIS_fnc_randomInt);

	_vehType = [_vehTypes, false] call Zen_ArrayGetRandom;

	_startPosTemp = [_center, 100, 150, 0, 1, 60, 0] call BIS_fnc_findSafePos;
	_startDir = [_center, _startPosTemp] call BIS_fnc_dirTo;
	_startDist = 3000;
	_startPos = [_center, _startDist, _startDir] call BIS_fnc_relPos;

	_endDir = [_startPos, _center] call BIS_fnc_dirTo;
	_endDist = 3000;
	_endPos = [_center, _endDist, _endDir] call BIS_fnc_relPos;

	[_startPos, _endPos, 200, "FULL", _vehType, enemySide] call BIS_fnc_ambientFlyby;

};
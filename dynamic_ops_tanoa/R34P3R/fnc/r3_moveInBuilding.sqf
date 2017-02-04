/////////////////////////////////////////////////
/////////////////////////////////////////////////
/////			 							/////
////           R 3 4 P 3 R 's               /////
////       C O O P - S C R I P S            /////
/////			 							/////
/////////////////////////////////////////////////
/////////////////////////////////////////////////

// [UNIT, HOUSEPOS] execVM "R34P3R\fnc\r3_moveInBuilding.sqf";

if(isServer) then {

	_unit = _this select 0;
	_bpos = _this select 1;
	_build = nearestBuilding _unit;
	 
	if((_build buildingPos _bpos) distance [0,0,0] > 0 ) then {
		_unit setPos (_build buildingPos _bpos);
		_unit setUnitPos "UP";
	};
};
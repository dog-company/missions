_delay = _this select 0;

_groupArray = enemySemiAlertableGroups + enemyAlertableGroups;

{
	
	 while {(count (waypoints _x)) > 0} do {
		deleteWaypoint ((waypoints _x) select 0);
	 };
	[_x, getPos groupLeader] call BIS_fnc_taskAttack;
	
	sleep _delay;
	
} forEach _groupArray;

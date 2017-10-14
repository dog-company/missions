private _wp, _distance, _nearestLocations;

systemChat format ["Unit: %1", leader drug_runners];

_nearestLocations = nearestLocations [leader drug_runners, ["NameCity", "NameVillage", "NameLocal"], 3000];
systemChat format ["Nearest Locations: %1", _nearestLocations];

{ 
    _distance = (position leader drug_runners) distance _x;
    if (_distance > 200) then {
        systemChat format ["Location: %1", _x];
        _wp = drug_runners addWaypoint [(selectRandom ((locationPosition _x) nearRoads 200)), 1];
        _wp setWaypointTimeout [30, 60, 90];
    };
} forEach _nearestLocations;

if (_wp) then {
    _wp setWaypointScript "scripts\wander.sqf";
};
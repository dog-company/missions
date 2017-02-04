_size = worldSize;
_worldCenter = (_size/2);
_locList = nearestLocations [[_worldCenter, _worldCenter], ["NameLocal","NameVillage","NameCity","NameCityCapital"], _size];

locMarkerArray = [];
selectedLocMarker = "";

{	
	//_mkrName = format ["%1", getPos _x];
	_mkrName = format ["locMkr%1", _forEachIndex];
	_thisMkr = createMarker [_mkrName, getPos _x];
	_thisMkr setMarkerShape "ICON";			
	_thisMkr setMarkerType "Select";
	_thisMkr setMarkerColor "ColorPink";
	_thisMkr setMarkerAlpha 1;
	locMarkerArray pushBack _mkrName;
} forEach _locList;
// 0: location name
// 1: location type
// 2: location type text
// 3: location marker
// 4: player start location
// 5: resupply marker
// 6: civilians present

_locName = _this select 0;
_locType = _this select 1;
_locText = _this select 2;
_locMarker = _this select 3;
_markerCamp = _this select 4;
_resupplyMarker = _this select 5;
_missionName = _this select 6;
_enemyFactionName = ((configFile >> "CfgFactionClasses" >> enemyFaction >> "displayName") call BIS_fnc_GetCfgData);

switch (_locType) do {
	case "NameLocal": {_locText = "local"};
	case "NameVillage": {_locText = "village"};
	case "NameCity": {_locText = "city"};
	case "NameCityCapital": {_locText = "capital"};
};

// Mission name diary entry
_missionText = "";
if (count _missionName > 0) then {
	//_missionName = [_missionName, 15] call BIS_fnc_trimString;
	_missionText = format ["<font size='20' face='PuristaBold'>%1</font>",_missionName];	
};

// Insertion diary entry
_textLocation = "";
if (count _markerCamp > 0) then {
	_markerText = markerText _markerCamp;
	if (getMarkerType _markerCamp == "loc_Bunker") then {
		if (_locType == "NameLocal") then {
			_textLocation = format ["From <marker name=%4>%5</marker> fireteam Alpha will perform a patrol into %1 at <marker name=%3>this location.</marker> Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp,_markerText];
		} else {	
			_textLocation = format ["From <marker name=%4>%5</marker> fireteam Alpha will perform a patrol into the %2 of <marker name=%3>%1.</marker> Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp,_markerText];
		};
	} else {	
		if (getMarkerType _markerCamp == "mil_start") then {
			if (_locType == "NameLocal") then {
				_textLocation = format ["Fireteam Alpha will insert via boat starting from the marked <marker name=%4>drop point</marker>. From there they will perform a patrol into %1 at <marker name=%3>this location</marker>. Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp];
			} else {	
				_textLocation = format ["Fireteam Alpha will insert via boat starting from the marked <marker name=%4>drop point</marker>. From there they will perform a patrol into the %2 of <marker name=%3>%1</marker>. Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp];
			};
		} else {
			if (_locType == "NameLocal") then {
				_textLocation = format ["Fireteam Alpha will insert via helo at the marked <marker name=%4>drop point</marker>. From there they will perform a patrol into %1 at <marker name=%3>this location</marker>. Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp];
			} else {	
				_textLocation = format ["Fireteam Alpha will insert via helo at the marked <marker name=%4>drop point</marker>. From there they will perform a patrol into the %2 of <marker name=%3>%1</marker>. Check task list for objectives.", _locName, _locText, _locMarker,_markerCamp];
			};
		};
	};	
};

// Enemy makeup diary entry
_textEnemies = "";
_numEnemies = 0;
{
	if (side _x == enemySide) then {
		_numEnemies = _numEnemies + 1;
	};
} forEach allUnits;

_textAOType = "";
_placeText = "";
_nearestLocName = "";
if (_locType == "NameLocal") then {	
	_nearbyLocations = nearestLocations [(getMarkerPos _locMarker), ["NameVillage","NameCity","NameCityCapital"], 1000];
	if (count _nearbyLocations > 0) then {
		_nearestLocName = text (_nearbyLocations select 0);
		_placeText = format ["the %1 area near %2", _locName, _nearestLocName];
	} else {
		_placeText = format ["the %1 area", _locName];
	};
} else {
	_placeText = format ["the %2 of %1", _locName, _locText];
};
switch (AO_Type) do {
	case "DEFAULT": {		
		_textAOType = format ["%1 forces hold %2. ", _enemyFactionName, _placeText];
	};
	case "NOMAD": {
		_textAOType = format ["%1 have troops encamped around %2. ", _enemyFactionName, _placeText];
	};
	case "BARRIER": {
		_textAOType = format ["%1 have fortified positions around %2 and are patrolling their defended borders. ", _enemyFactionName, _placeText];
	};
	case "PEACEKEEPERS": {
		_textAOType = format ["%1 forces occupy %2 supposedly in a peacekeeping capacity. They are working on strengthening ties with the local civilian population. ", _enemyFactionName, _placeText];
	};
};

if (_numEnemies < 40) then {
	_textEnemies = format ["Reports estimate that their current presence is weak. However, ", _numEnemies];
};
if (_numEnemies >= 40 && _numEnemies < 60) then {
	_textEnemies = format ["Reports estimate that their current presence is moderate. However, ", _numEnemies];
};
if (_numEnemies >= 60) then {
	_textEnemies = format ["Reports estimate that their current presence is strong; expect heavy resistance. However, ", _numEnemies];
};

// Civilians present diary entry
_textCivs = "";
if (!isNil "civTrue") then {	
	if (civTrue) then {
		_textCivs = "civilians are present in the area of operations. Check your targets and exercise extreme caution before using ordnance.";
	} else {
		_textCivs = "the area of operations is clear of civilians. You are cleared to use any tools at your disposal to complete objectives.";
	};	
};

_textResupply = format ["A <marker name=%1>resupply point</marker> has been prepared by a guerilla element. It contains a basic selection of arms for you to use in the field including explosives to deal with any objectives that may require them.", _resupplyMarker];

_textCancel = "If at any time you find yourself unable to complete an objective you have the option to cancel that task under its task listing.";

_briefingString = format["%1<br /><br />%2<br /><br />%7%6%3<br /><br />%4<br /><br />%5", _missionText, _textLocation, _textCivs, _textResupply, _textCancel, _textEnemies, _textAOType];
[player, ["Diary", ["Briefing", _briefingString]]] remoteExec ["createDiaryRecord", 0, true];

[[], "sun_playRadioRandom", true] call BIS_fnc_MP;
[[[playersSide, "HQ"], "Check your briefing notes for updated info."], "sideChat", true] call BIS_fnc_MP;

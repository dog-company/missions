_heli = _this select 0;
hint 'activated';
_spawnPos = [((getPos _heli select 0)), ((getPos _heli select 1)), ((getPos _heli select 2)-20)];

//[_heli, "B_supplyCrate_F"] call BIS_fnc_supplydrop;

_arsenal = createVehicle ["B_supplyCrate_F", _spawnPos, [], 0, "NONE"];
clearWeaponCargoGlobal _arsenal;
clearMagazineCargoGlobal _arsenal;
clearItemCargoGlobal _arsenal;

_arsenal addMagazineCargoGlobal ["SatchelCharge_Remote_Mag", 2];
_arsenal addMagazineCargoGlobal ["DemoCharge_Remote_Mag", 4];
_arsenal addItemCargoGlobal ["Medikit", 1];
_arsenal addItemCargoGlobal ["FirstAidKit", 10];

{
	//_magazines = magazines _x;
	_magazines = magazinesAmmoFull _x;
	
	{
		_arsenal addMagazineCargoGlobal [(_x select 0), 2];
	} forEach _magazines;	
} forEach units group player;

waitUntil {(((position _arsenal) select 2) < 100)};

_para = createVehicle ["B_Parachute_02_F", _spawnPos, [], 0, ""];
_arsenal attachTo [_para,[0,0,0]];

waitUntil {((((position _arsenal) select 2) < 0.6) || (isNil "_para"))};

detach _arsenal;
_arsenal setVelocity [0,0,-5];
sleep 0.3;
_arsenal setPos [(position _arsenal) select 0, (position _arsenal) select 1, 1];
_arsenal setVelocity [0,0,0];  

markerArsenal = createMarker ["arsenalMkr2", getPos _arsenal];
markerArsenal setMarkerShape "ICON";
markerArsenal setMarkerColor markerColorPlayers;
markerArsenal setMarkerType "mil_flag";
markerArsenal setMarkerText "Arsenal";

[_arsenal, ["Arsenal", "['Open', true] call BIS_fnc_arsenal", nil, 6]] remoteExec ["addAction", 0];




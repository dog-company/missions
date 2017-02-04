if (!isNull (_this select 0)) then {
	_unit = _this select 0;
	closeDialog 1;

	_oldUnit = player;
	if (player != _unit) then {
		selectPlayer _unit;
	};

	_dir = 0;
	switch (_unit) do {
		case u1: {_dir = unitDirs select 0};
		case u2: {_dir = unitDirs select 1};
		case u3: {_dir = unitDirs select 2};
		case u4: {_dir = unitDirs select 3};
		case u5: {_dir = unitDirs select 4};
		case u6: {_dir = unitDirs select 5};
		case u7: {_dir = unitDirs select 6};
		case u8: {_dir = unitDirs select 7};
	};
	_unit setDir _dir;

	// Open arsenal
	["Open", true] call BIS_fnc_arsenal;

	waitUntil {isNull ( uiNamespace getVariable [ "BIS_fnc_arsenal_cam", objNull ] )};

	if (player != _oldUnit) then {
		selectPlayer _oldUnit;
	};
	player switchCamera "GROUP";
	_unit setVariable ["unitChoice", "CUSTOM", true];
	publicVariable "unitChoice";


	_handle = CreateDialog "DRO_lobbyDialog";
	[] execVM "sunday_system\dialogs\populateLobby.sqf";
};

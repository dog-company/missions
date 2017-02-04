_spacer = 0.03;
_startY = 0.365;

// AI delete buttons
_ctrlX = 0.2575;
_ctrlY = (_startY + 0.011);
{
	((findDisplay 626262) displayCtrl _x) ctrlSetPosition [(_ctrlX * safezoneW + safezoneX), (_ctrlY * safezoneH + safezoneY)];
	((findDisplay 626262) displayCtrl _x) ctrlCommit 0;
	_ctrlX = _ctrlX;
	_ctrlY = _ctrlY + _spacer;
} forEach [1501, 1502, 1503, 1504, 1505, 1506, 1507, 1508];

// Unit titles
_ctrlX = 0.28;
_ctrlY = _startY;
{
	((findDisplay 626262) displayCtrl _x) ctrlSetPosition [(_ctrlX * safezoneW + safezoneX), (_ctrlY * safezoneH + safezoneY)];
	((findDisplay 626262) displayCtrl _x) ctrlCommit 0;
	_ctrlX = _ctrlX;
	_ctrlY = _ctrlY + _spacer;
} forEach [1200, 1202, 1204, 1206, 1208, 1210, 1212, 1214];

// Loadout comboboxes
_ctrlX = 0.375;
_ctrlY = (_startY + 0.013);
{
	((findDisplay 626262) displayCtrl _x) ctrlSetPosition [(_ctrlX * safezoneW + safezoneX), (_ctrlY * safezoneH + safezoneY)];
	((findDisplay 626262) displayCtrl _x) ctrlCommit 0;
	_ctrlX = _ctrlX;
	_ctrlY = _ctrlY + _spacer;
} forEach [1201, 1203, 1205, 1207, 1209, 1211, 1213, 1215];

// VA buttons
_ctrlX = 0.485;
_ctrlY = (_startY + 0.01);
{
	((findDisplay 626262) displayCtrl _x) ctrlSetPosition [(_ctrlX * safezoneW + safezoneX), (_ctrlY * safezoneH + safezoneY)];
	((findDisplay 626262) displayCtrl _x) ctrlCommit 0;
	_ctrlX = _ctrlX;
	_ctrlY = _ctrlY + _spacer;
} forEach [1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308];

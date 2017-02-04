cutText ["Extracting faction data", "BLACK FADED"];

_playersIndex = lbCurSel 2100;
_enemyIndex = lbCurSel 2101;
_civIndex = lbCurSel 2102;
_playersFaction = lbData [2100, _playersIndex];
_enemyFaction = lbData [2101, _enemyIndex];
_civFaction = lbData [2102, _civIndex];

_playersSideNum = ((configFile >> "CfgFactionClasses" >> _playersFaction >> "side") call BIS_fnc_GetCfgData);
_enemySideNum = ((configFile >> "CfgFactionClasses" >> _enemyFaction >> "side") call BIS_fnc_GetCfgData);

if (_playersIndex == -1 || _enemyIndex == -1) then {
	hint "Both the player and enemy side must have a faction selected.";
} else {
	if (_playersSideNum == _enemySideNum) then {
		hint "Player and enemy factions are the same side. Please choose factions with differing sides.";
	} else {				
		playersFaction = lbData [2100, _playersIndex];
		publicVariable "playersFaction";
		enemyFaction = lbData [2101, _enemyIndex];		
		civFaction = lbData [2102, _civIndex];		
		
		missionNameSpace setVariable ["factionsChosen", 1];
		publicVariable "factionsChosen";
		
		hintSilent  "";
		closeDialog 1;
	};
};
//hint format ["%1, %2", playersFaction, enemyFaction];


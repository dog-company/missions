_playersIndex = lbCurSel 2100;
_u1ClassIndex = lbCurSel 1201;
_u2ClassIndex = lbCurSel 1203;
_u3ClassIndex = lbCurSel 1205;
_u4ClassIndex = lbCurSel 1207;
_enemyIndex = lbCurSel 2101;
_civIndex = lbCurSel 2102;

_timeIndex = lbCurSel 2103;
_insertIndex = lbCurSel 2104;
_skillIndex = lbCurSel 2105;
_objIndex = lbCurSel 2106;
_aoIndex = lbCurSel 2107;
_reviveIndex = lbCurSel 2108;

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
		if (count (lbData [1207, _u4ClassIndex]) > 0) then {
			timeOfDay = _timeIndex;
			insertType = _insertIndex;
			aiSkill = _skillIndex;
			numObjectives = _objIndex;
			aoOptionSelect = _aoIndex;
			missionNameSpace setVariable ["reviveOptionSelect", _reviveIndex];
			publicVariable "reviveOptionSelect";
			
			playersFaction = lbData [2100, _playersIndex];
			u1Class = lbData [1201, _u1ClassIndex];
			u2Class = lbData [1203, _u2ClassIndex];
			u3Class = lbData [1205, _u3ClassIndex];
			u4Class = lbData [1207, _u4ClassIndex];		
			
			enemyFaction = lbData [2101, _enemyIndex];		
			civFaction = lbData [2102, _civIndex];		
			
			missionNameSpace setVariable ["factionsChosen", 1];
			publicVariable "factionsChosen";
			
			hintSilent  "";
			closeDialog 1;
		} else {
			hint "Please wait for player side unit selections to finish loading.";
		};
	};
};
//hint format ["%1, %2", playersFaction, enemyFaction];


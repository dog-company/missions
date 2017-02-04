//disableUserInput false;
[] execVM "sunday_system\dialogs\positionLobbyControls.sqf";

{
	_thisUnit = _x;
	if ((player == _thisUnit) OR ((player == u1) && (!isPlayer _thisUnit))) then {
		// Populate unit classes
		
		_thisLB = (_thisUnit getVariable "unitLoadoutIDC");
		lbClear _thisLB;
		{		
			_index = lbAdd [_thisLB, (_x select 1)];
			lbSetData [_thisLB, _index, (_x select 0)];
		} forEach unitList;	
			
		if (typeName (_thisUnit getVariable "unitChoice") == "STRING") then {		
			if ((_thisUnit getVariable "unitChoice") == "CUSTOM") then {
				_index = lbAdd [_thisLB, "Custom Loadout"];
				lbSetData [_thisLB, _index, "CUSTOM"];
				lbSetCurSel [_thisLB, _index];
			} else {		
				for "_i" from 1 to (lbSize _thisLB) do {
					_className = lbData [_thisLB, (_i - 1)];
					if ((_thisUnit getVariable "unitChoice") == _className) then {
						lbSetCurSel [_thisLB, (_i - 1)];
						diag_log "selected using switchLoadout value";
					};
				};
			};		
		};
	} else {		
		ctrlDelete ((findDisplay 626262) displayCtrl (_thisUnit getVariable "unitLoadoutIDC"));
	};
	
	// Disable delete button for players
	if (isPlayer _thisUnit) then {
		ctrlEnable [(_thisUnit getVariable "unitDeleteIDC"), false];
	};
	
} forEach (units group player);

lbAdd [6009, "Random"];
lbAdd [6009, "Ground"];
lbAdd [6009, "Air"];
//lbAdd [6009, "HALO"];
if (player == u1) then {
	lbSetCurSel [6009, insertType];
};

// Insert vehicle options
_index = lbAdd [6013, "Random"];
lbSetData [6013, _index, ""];
{
	_index = lbAdd [6013, ((configfile >> "CfgVehicles" >> _x >> "displayName") call BIS_fnc_getCfgData)];
	lbSetData [6013, _index, _x];
} forEach pCarClasses;

if (player == u1) then {
	lbSetCurSel [6013, (startVehicle select 0)];
};

// Support options
lbAdd [6010, "Random"];
lbAdd [6010, "Custom"];
if (player == u1) then {
	lbSetCurSel [6010, randomSupports];
};


// If player is not u1 then disable all other controls
if (player != u1) then {
	{
		if (_x != player) then {			
			ctrlEnable [(_x getVariable "unitArsenalIDC"), false];			
			ctrlEnable [(_x getVariable "unitDeleteIDC"), false];
		}
	} forEach (units group player);
	ctrlEnable [6004, false];
	ctrlEnable [6005, false];
	ctrlEnable [6009, false];
	ctrlEnable [6010, false];
	ctrlEnable [6011, false];
	ctrlEnable [6013, false];
	ctrlEnable [6050, false];
};

// Remove controls for AI no longer in group
{
	if (isObjectHidden _x) then {		
		ctrlEnable [(_x getVariable "unitLoadoutIDC"), false];
		ctrlEnable [(_x getVariable "unitArsenalIDC"), false];		
		ctrlEnable [(_x getVariable "unitDeleteIDC"), true];
		((findDisplay 626262) displayCtrl (_x getVariable "unitDeleteIDC")) ctrlSetChecked true;		
	};	
} forEach (units group player);

// Change name texts
{
	if (isPlayer _x) then {		
		((findDisplay 626262) displayCtrl ((_x getVariable "unitLoadoutIDC")-1)) ctrlSetText (format ["%1:", (name _x)]);
	} else {
		((findDisplay 626262) displayCtrl ((_x getVariable "unitLoadoutIDC")-1)) ctrlSetText (format ["%1 (AI):", (name _x)]);
	};	
} forEach (units group player);




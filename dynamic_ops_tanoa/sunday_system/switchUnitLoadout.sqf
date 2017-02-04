// Apply player unit loadouts and identities

_thisUnit = _this select 0;
_return = _this select 1;

if ((player == _thisUnit) OR (!isPlayer _thisUnit)) then {
	
	_infCopy = nil;
	
	if (typeName (_return select 0) == "CONTROL") then {
		_infCopy = (_return select 0) lbData (_return select 1);
	} else {
		_infCopy = (_return select 0);
	};
	
	_thisUnit setVariable ['unitChoice', _infCopy, true];


	if (_infCopy == "CUSTOM") then {

	} else {
		
		if (typeName (_return select 0) == "CONTROL") then {
			_lbSize = (lbSize (_return select 0));
			for "_i" from 1 to _lbSize do {
				if (((_return select 0) lbData _i) == "CUSTOM") then {
					(_return select 0) lbDelete _i;
					(_return select 0) lbSetCurSel (_return select 1);
				};
			};	
		};
		_dummy = _infCopy createVehicle [0,0,0];
		
		waitUntil {!isNull _dummy};	

		// Remove loadout
		_thisUnit removeWeaponGlobal (primaryWeapon _thisUnit);
		_thisUnit removeWeaponGlobal (secondaryWeapon _thisUnit);
		_thisUnit removeWeaponGlobal (handgunWeapon _thisUnit);
		removeUniform _thisUnit;
		removeVest _thisUnit;
		removeHeadgear _thisUnit;
		removeGoggles _thisUnit;
		removeBackpack _thisUnit;
		_nvgs = hmd _thisUnit;
		_thisUnit unassignItem _nvgs;
		_thisUnit removeItem _nvgs;	
		
		// Wearables
		_thisUnit forceAddUniform (uniform _dummy);	
		_uniformItems = uniformItems _dummy;
		{_thisUnit addItemToUniform _x} forEach _uniformItems;
		
		_vest = vest _dummy;
		if (!isNil '_vest') then {
			_thisUnit addVest _vest;
			_vestItems = vestItems _dummy;
			{_thisUnit addItemToVest _x} forEach _vestItems;
		};
		
		_backpack = (configfile >> "CfgVehicles" >> _infCopy >> "backpack") call BIS_fnc_getCfgData;
		//_backpack = backpack _dummy;
		if (count _backpack > 0) then {
			_thisUnit addBackpackGlobal _backpack;
			_backpackItems = backPackItems _dummy;
			{_thisUnit addItemToBackpack _x} forEach _backpackItems;
		};
		
		_headgear = headgear _dummy;
		if (!isNil '_headgear') then {
			_thisUnit addHeadgear _headgear;
		};
		
		_goggles = goggles _dummy;
		if (!isNil '_goggles') then {
			_thisUnit addGoggles _goggles;
		};
		
		_primaryWeapon = primaryWeapon _dummy;
		if (!isNil '_primaryWeapon') then {
			_thisUnit addWeaponGlobal _primaryWeapon;
		};
		
		_secondaryWeapon = secondaryWeapon _dummy;
		if (!isNil '_secondaryWeapon') then {
			_thisUnit addWeaponGlobal _secondaryWeapon;
		};
		
		_handgunWeapon = handgunWeapon _dummy;
		if (!isNil '_handgunWeapon') then {
			_thisUnit addWeaponGlobal _handgunWeapon;
		};
		
		_helmetSubItems = (configfile >> "CfgWeapons" >> _headgear >> "subItems") call BIS_fnc_getCfgData;
		if (isNil "_helmetSubItems") then {		
			_nvgs = hmd _dummy;
			if (count _nvgs > 0) then {
				_thisUnit linkItem _nvgs;
			} else {
				_thisUnit linkItem "NVGoggles";
			};
		};
		
		_binocs = binocular _dummy;
		if (!isNil "_binocs") then {
			_thisUnit addWeaponGlobal _binocs;	
		};
		
		{
			_thisUnit linkItem _x;
		} forEach (assignedItems _dummy);
		
		_thisUnit linkItem "ItemMap";
		
		_thisUnit setUnitTrait ["Medic", true];
		_thisUnit setUnitTrait ["engineer", true];
		_thisUnit setUnitTrait ["explosiveSpecialist", true];
		_thisUnit setUnitTrait ["UAVHacker", true];
		
		deleteVehicle _dummy;

		
	};
};
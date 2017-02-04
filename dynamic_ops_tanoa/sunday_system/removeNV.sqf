

{
	if (side _x != side player) then {
		_unit = _x;
		
		_nvgs = hmd _unit;			
		_unit unassignItem _nvgs;
		_unit removeItem _nvgs;			
		_unit removePrimaryWeaponItem "acc_pointer_IR";   
		_unit addPrimaryWeaponItem "acc_flashlight";
		_unit enableGunLights "forceon";		
	};
} foreach allunits;

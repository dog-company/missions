private "_this";
_this = _this select 0;
 
if ((side _this == independent) and (!isPlayer _this)) then {
  _this addPrimaryWeaponItem 'rhs_acc_2dpZenit';
  _this enableGunLights "forceOn";
};
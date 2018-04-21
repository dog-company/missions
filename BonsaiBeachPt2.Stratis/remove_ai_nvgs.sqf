private "_this";
_this = _this select 0;
 
if ((side _this == west) and (!isPlayer _this)) then {
   _this unassignItem "NVGogglesB_grn_F";
   _this unassignItem "NVGogglesB_blk_F";
   _this unassignItem "NVGogglesB_gry_F";
   _this removeItem "NVGogglesB_grn_F";
   _this removeItem "NVGogglesB_blk_F";
   _this removeItem "NVGogglesB_gry_F";
   _this addPrimaryWeaponItem "acc_flashlight";
   vehicle _this disableTIEquipment true;
   vehicle _this disableNVGEquipment true;
};
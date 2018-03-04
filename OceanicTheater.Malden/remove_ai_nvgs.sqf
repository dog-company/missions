private "_this";
_this = _this select 0;
 
if ((side _this == east) and (!isPlayer _this)) then {
   _this unassignItem "NVGoggles_OPFOR";
   _this removeItem "NVGoggles_OPFOR";
};
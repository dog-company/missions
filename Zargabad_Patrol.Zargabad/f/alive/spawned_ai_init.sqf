private "_this";
_this = _this select 0;

if (!isPlayer _this) then {
  sleep 3;
  [_this] execVM "f\setAISkill\f_setAISkill.sqf";
};

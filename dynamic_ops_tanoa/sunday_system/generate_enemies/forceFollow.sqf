_group = _this select 0;
_targetGroup = _this select 1;
_distance = _this select 2;

while { ( { (alive _x) } count (units _group) > 0) } do
{
       if (vehicle leader _group distance (leader _targetGroup) > _distance) then
       {
              {_x doMove (getPos (leader _targetGroup)) } forEach units _group;
       };

       sleep 5;
};
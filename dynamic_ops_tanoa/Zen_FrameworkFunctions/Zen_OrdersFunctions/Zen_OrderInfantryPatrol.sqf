// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderInfantryPatrol", _this] call Zen_StackAdd;
private ["_grpsArray", "_movecenters", "_maxx", "_mpos", "_man", "_speedMode", "_limitAnglesSet", "_target", "_behaviorMode", "_chaseEnemy", "_waterPosition", "_divers", "_joinWeak", "_joined", "_center", "_index", "_positionFilterArgs"];

if !([_this, [["VOID"], ["ARRAY", "OBJECT", "GROUP", "STRING"], ["ARRAY"], ["ARRAY", "SCALAR"], ["STRING"], ["STRING"], ["BOOL"], ["BOOL"], ["BOOL"]], [[], ["ARRAY", "OBJECT", "GROUP", "STRING", "SCALAR"], ["STRING", "ARRAY", "SCALAR"], ["SCALAR", "ARRAY"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_grpsArray = [(_this select 0)] call Zen_ConvertToGroupArray;
_movecenters = _this select 1;

if !((typeName _movecenters == "ARRAY") && {typeName (_movecenters select 0) != "SCALAR"}) then {
    if (count _this > 2) then {
        _positionFilterArgs = [_this select 2];
    } else {
        if (typeName _movecenters == "STRING") then {
            _positionFilterArgs = [[]];
            if ((markerShape _movecenters) == "ICON") then {
                _positionFilterArgs = [[50, 200]];
            };
        } else {
            _positionFilterArgs = [[50, 200]];
        };
    };

    _movecenters = [_movecenters];
    ZEN_STD_Parse_GetArgumentDefault(_limitAnglesSet, 3, 0)
    _limitAnglesSet = [_limitAnglesSet];
} else {
    _positionFilterArgs = _this select 2;
    _limitAnglesSet = _this select 3;
};

{
    if ((typeName _x == "STRING") && {((markerShape _x) == "ICON")}) then {
        _movecenters set [_forEachIndex, [_x] call Zen_ConvertToPosition];
    };
} forEach _movecenters;

ZEN_STD_Parse_GetArgumentDefault(_speedMode, 4, "limited")
ZEN_STD_Parse_GetArgumentDefault(_behaviorMode, 5, "aware")
ZEN_STD_Parse_GetArgumentDefault(_chaseEnemy, 6, true)
ZEN_STD_Parse_GetArgumentDefault(_joinWeak, 7, false)
ZEN_STD_Parse_GetArgumentDefault(_divers, 8, false)

_waterPosition = 1;
if (_divers) then {
    _waterPosition = 2;
};

_grpsArray = [_grpsArray] call Zen_ArrayRemoveDead;
{
    private "_group";
    _group = _x;
    _man = leader _group;
    _mpos = [0,0,0];

    #define CALC_POS \
    _index = ZEN_STD_Array_RandIndex(_movecenters); \
    _center = _movecenters select _index; \
    if (typeName _center == "STRING") then { \
        _mpos = [_center, 0, (_positionFilterArgs select _index), _waterPosition, [1,50], _limitAnglesSet select _index] call Zen_FindGroundPosition; \
    } else { \
        if (([_man, _center] call Zen_Find2dDistance) < ((_positionFilterArgs select _index) select 0)) then { \
            _mpos = [_center, _positionFilterArgs select _index, [], _waterPosition, [1,50], _limitAnglesSet select _index] call Zen_FindGroundPosition; \
        } else { \
            while {true} do { \
                _mpos = [_center, _positionFilterArgs select _index, [], _waterPosition, [1,50], _limitAnglesSet select _index] call Zen_FindGroundPosition; \
                if !([_man, [_man, _mpos] call Zen_Find2dDistance, ([_man, _mpos] call Zen_FindDirection), _center, [((_positionFilterArgs select _index) select 0), ((_positionFilterArgs select _index) select 0)], 0, "ellipse"] call Zen_IsRayInPoly) exitWith {}; \
            }; \
        }; \
    };

    CALC_POS
    _group = group _man;

    if !(isPlayer _man) then {
        if (_divers) then {
            _mpos set [2, -10];
            {
                _x swimInDepth -10;
            } forEach (units _group);
        };

        _group setCurrentWaypoint (_group addWaypoint [_mpos, -1]);
        _group setCombatMode "Red";
        _group setSpeedMode _speedMode;
        if (side _group == civilian) then {
            _group setBehaviour "careless";
        } else {
            _group setBehaviour _behaviorMode;
        };
    };
} forEach _grpsArray;

while {(count _grpsArray != 0)} do {
    {
        private "_group";
        _group = _x;
        if (!(isNull _group) && {(({alive _x} count (units _group)) > 0)}) then {
            _joined = false;

            if (_joinWeak && {(({alive _x} count (units _group)) < 3)}) then {
                _nearGroup = [_grpsArray - [_group], compile format["_this distanceSqr %1", getPosATL leader _group]] call Zen_ArrayFindExtremum;

                if (([_group, _nearGroup] call Zen_Find2dDistance) < 100) then {
                    _joined = true;
                    (units _group) join _nearGroup;
                };
            };

            if !(_joined) then {
                _man = leader _group;
                if ((unitReady _man) && {(alive _man)}) then {
                    _mpos = [0,0,0];
                    CALC_POS

                    if !(isPlayer _man) then {
                        if (_divers) then {
                            _mpos set [2, -10];
                            {
                                _x swimInDepth -10;
                            } forEach (units _group);
                        };

                        _group setCurrentWaypoint (_group addWaypoint [_mpos, -1]);
                        _group setBehaviour _behaviorMode;
                        _group setCombatMode "Red";
                        _group setSpeedMode _speedMode;
                    };
                } else {
                    if (_chaseEnemy) then {
                        if (side _group == civilian) then {
                            {
                                civilian setFriend [_x, 0];
                            } forEach [west, east, resistance];
                            _target = _man findNearestEnemy _man;
                            {
                                civilian setFriend [_x, 1];
                            } forEach [west, east, resistance];
                        } else {
                            _target = _man findNearestEnemy _man;
                        };
                        if (!(isNull _target) && {((([_man, _target] call Zen_Find2dDistance) < 750) && (_target isKindOf "Man"))}) then {
                            _mpos = [_target, (random (150 / ((_man knowsAbout _target) + 0.1))), (random 360)] call Zen_ExtendPosition;

                            if !(isPlayer _man) then {
                                if (_divers) then {
                                    _mpos set [2, -10];
                                    {
                                        _x swimInDepth -10;
                                    } forEach (units _group);
                                };

                                _group setCurrentWaypoint (_group addWaypoint [_mpos, -1]);
                                _group setCombatMode "Red";
                                _group setSpeedMode _speedMode;
                                if (side _group == civilian) then {
                                    _group setBehaviour "careless";
                                };
                            };
                        };
                    };
                };
            };
        };
    } forEach _grpsArray;
    sleep 10;
    _grpsArray = [_grpsArray] call Zen_ArrayRemoveDead;
};

call Zen_StackRemove;
if (true) exitWith {};

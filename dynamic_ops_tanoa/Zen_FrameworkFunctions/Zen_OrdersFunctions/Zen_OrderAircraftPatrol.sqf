// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderAircraftPatrol", _this] call Zen_StackAdd;
private ["_vehicleArray", "_movecenters", "_blackList", "_speedMode", "_heliHeight", "_mpos", "_heliDirToLand", "_mposCorrected", "_vehDist", "_limitAnglesSet", "_cleanupDead", "_crewGroupArray", "_crew", "_center", "_index", "_behavior", "_positionFilterArgs"];

if !([_this, [["VOID"], ["ARRAY", "OBJECT", "GROUP", "STRING"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["STRING"], ["STRING"], ["SCALAR"], ["BOOL"]], [[], ["ARRAY", "OBJECT", "GROUP", "STRING", "SCALAR"], ["STRING", "ARRAY", "SCALAR"], ["SCALAR", "ARRAY"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicleArray = [(_this select 0)] call Zen_ConvertToObjectArray;
_movecenters = _this select 1;

ZEN_STD_Parse_GetArgumentDefault(_speedMode, 4, "limited")
ZEN_STD_Parse_GetArgumentDefault(_behavior, 5, "aware")
ZEN_STD_Parse_GetArgumentDefault(_heliHeight, 6, 75)
ZEN_STD_Parse_GetArgumentDefault(_cleanupDead, 7, false)

if !((typeName _movecenters == "ARRAY") && {typeName (_movecenters select 0) != "SCALAR"}) then {
    if (count _this > 2) then {
        _positionFilterArgs = [_this select 2];
    } else {
        if (typeName _movecenters == "STRING") then {
            _positionFilterArgs = [[]];
            if ((markerShape _movecenters) == "ICON") then {
                _positionFilterArgs = [500];
            };
        } else {
            _positionFilterArgs = [500];
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

_vehicleArray = [([_vehicleArray] call Zen_ConvertToObjectArray)] call Zen_ArrayRemoveDead;
_crewGroupArray = [];

{
    private "_veh";
    _veh = _x;
    _mpos = [0,0,0];
    _crewGroupArray pushBack (group driver _veh);

    #define CALC_POS \
    _index = ZEN_STD_Array_RandIndex(_movecenters); \
    _center = _movecenters select _index; \
    if (typeName _center == "STRING") then { \
        _mpos = [_center, 0,_positionFilterArgs select _index, 0, 0, _limitAnglesSet select _index] call Zen_FindGroundPosition; \
    } else { \
        _mpos = [_center, [0, _positionFilterArgs select _index], [], 0, 0, _limitAnglesSet select _index] call Zen_FindGroundPosition; \
    };

    CALC_POS

    _heliDirToLand = [_veh,_mpos] call Zen_FindDirection;
    _mposCorrected = [_mpos, 100, _heliDirToLand, "trig"] call Zen_ExtendPosition;

    (group driver _veh) setCurrentWaypoint ((group driver _veh) addWaypoint [_mposCorrected, -1]);
    _veh flyInHeight _heliHeight;
    _veh setBehaviour _behavior;
    _veh setCombatMode "Red";
    _veh setSpeedMode _speedMode;
} forEach _vehicleArray;

while {(count _vehicleArray != 0)} do {
    {
        if (isNull _x) then {
            _vehicleArray set [_forEachIndex, 0];
            _crewGroupArray set [_forEachIndex, 0];
        } else {
            private "_veh";
            _veh = _x;
            if (!(alive _veh) || (({alive _x} count crew _veh) == 0)) then {
                _vehicleArray set [_forEachIndex, 0];
                _crew = _crewGroupArray select _forEachIndex;
                _crewGroupArray set [_forEachIndex, 0];
                if (_cleanupDead) then {
                    0 = [_veh, _crew] spawn {
                        sleep 60;
                        deleteVehicle (_this select 0);
                        {
                            deleteVehicle _x;
                        } forEach units (_this select 1);
                    };
                };
            } else {
                if ([_veh] call Zen_IsReady) then {
                    _mpos = [0,0,0];
                    CALC_POS

                    _mposCorrected = [_veh, _mpos, 100] call Zen_ExtendRay;
                    (group driver _veh) setCurrentWaypoint ((group driver _veh) addWaypoint [_mposCorrected, -1]);
                    _veh flyInHeight _heliHeight;
                    _veh setBehaviour _behavior;
                    _veh setCombatMode "Red";
                    _veh setSpeedMode _speedMode;
                };
            };
        };
    } forEach _vehicleArray;
    0 = [_vehicleArray, 0] call Zen_ArrayRemoveValue;
    0 = [_crewGroupArray, 0] call Zen_ArrayRemoveValue;
    sleep 10;
};

call Zen_StackRemove;
if (true) exitWith {};

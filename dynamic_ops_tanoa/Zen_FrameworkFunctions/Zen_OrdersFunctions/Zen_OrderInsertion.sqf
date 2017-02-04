// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderInsertion", _this] call Zen_StackAdd;
private ["_vehicle", "_posArray", "_units", "_speed", "_heliZ", "_insertionType", "_cleanup", "_moveFunction", "_vehMass", "_cargoSeats", "_flyOverPos", "_isCrash", "_dirToDrop", "_dirHeli", "_landScript", "_args"];

if !([_this, [["OBJECT"], ["VOID"], ["VOID"], ["STRING"], ["SCALAR"], ["STRING"], ["BOOL"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicle = _this select 0;
_posArray = _this select 1;
_units = [(_this select 2)] call Zen_ConvertToObjectArray;

ZEN_STD_Parse_GetArgumentDefault(_speed, 3, "normal")
ZEN_STD_Parse_GetArgumentDefault(_heliZ, 4, 40)
ZEN_STD_Parse_GetArgumentDefault(_insertionType, 5, "land")
ZEN_STD_Parse_GetArgumentDefault(_cleanup, 6, false)

_insertionType = toLower _insertionType;

if ((_insertionType == "parachute") && {!(_vehicle isKindOf "AIR")}) exitWith {
    ZEN_FMW_Code_ErrorExitVoid("Zen_OrderInsertion", "Given vehicle to parachute from cannot fly")
};

if (typeName _posArray == "ARRAY") then {
    if ((typeName (_posArray select 0)) == "SCAlAR") then {
        _posArray = [_posArray];
    };
} else {
    _posArray = [_posArray];
};

{
    _posArray set [_forEachIndex, ([_x] call Zen_ConvertToPosition)];
} forEach _posArray;

if (_vehicle isKindOf "AIR") then {
    _moveFunction = "Zen_OrderHelicopterLand";
} else {
    _moveFunction = "Zen_OrderVehicleMove";
};

_cargoSeats = ZEN_STD_OBJ_CountCargoSeats(_vehicle) + (count ([_vehicle, "cargoFFV"] call Zen_GetTurretPaths));
{
    if (_insertionType == "parachute") then {
        _flyOverPos = [_vehicle, _x, 1000] call Zen_ExtendRay;
        0 = [_vehicle, _flyOverPos, "full", (_heliZ max 400)] spawn Zen_OrderVehicleMove;

        _isCrash = false;
        waitUntil {
            sleep 1;
            if (!(alive _vehicle) || !(alive driver _vehicle) || !(canMove _vehicle)) then {
                _isCrash = true;
            };

            _dirToDrop = [_vehicle, _x] call Zen_FindDirection;
            _dirHeli = [(getDir _vehicle)] call Zen_FindTrigAngle;

            ((!([_dirToDrop, [(_dirHeli - 80), (_dirHeli + 80)]] call Zen_IsAngleInSector) && (([_vehicle, _x] call Zen_Find2dDistance) < 400)) || _isCrash)
        };

        if (_isCrash) exitWith {};
    } else {
        _landScript = [_vehicle, _x, _speed, _heliZ, (_insertionType == "fastrope"), _cleanup] spawn (missionNamespace getVariable _moveFunction);

        waitUntil {
            sleep 1;
            scriptDone _landScript;
        };
    };

    if (_forEachIndex == ((count _posArray) - 1) && ((count _posArray) > 1)) exitWith {};

    switch (_insertionType) do {
        case "land": {
            if (_vehicle isKindOf "AIR") then {
                if (surfaceIsWater getPosATL _vehicle) then {
                    _vehicle flyInHeight 4;

                    {
                        _args = ["unassignVehicle", [_x]];
                        ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                        _args = ["action", [_x, ["getOut", _vehicle]]];
                        ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                        _x enableAI "move";
                        sleep 1;
                    } forEach _units;
                } else {
                    _vehicle flyInHeight 0;
                };
            };

            {
                _args = ["orderGetIn", [[_x], false]];
                ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                _args = ["unassignVehicle", [_x]];
                ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                _args = ["leaveVehicle", [_x, _vehicle]];
                ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                _x enableAI "move";
            } forEach _units;
        };
        case "fastrope": {
            0 = [_vehicle, _units] spawn Zen_OrderFastRope;
        };
        case "parachute": {
            ZEN_STD_OBJ_AnimateDoors(_vehicle, 1)
            sleep 1;
            {
                removeBackpackGlobal _x;
                _x addBackpackGlobal "b_parachute";

                _args = ["unassignVehicle", [_x]];
                ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)

                if (isPlayer _x) then {
                    _args = ["action", [_x, ["eject", _vehicle]]];
                    ZEN_FMW_MP_REClient("Zen_ExecuteCommand", _args, call, _x)
                } else {
                    _x setPosATL ((getPosATL _vehicle) vectorAdd [0,0,-5]);
                };

                waitUntil {
                    ((vehicle _x) == _x)
                };
                sleep 1;
            } forEach _units;
        };
    };

    _insertionType = "land";
    waitUntil {
        sleep 2;
        ((([_units, _vehicle]) call Zen_AreNotInVehicle) || ((_vehicle emptyPositions "cargo") == _cargoSeats) || !(alive _vehicle))
    };

    _vehicle flyInHeight 40;
} forEach _posArray;

{
    _x enableAI "move";
} forEach (crew _vehicle);

if (_cleanup) then {
    ZEN_STD_OBJ_DeleteVehCrew(_vehicle)
};

call Zen_StackRemove;
if (true) exitWith {};

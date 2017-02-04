// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_OrderExtraction", _this] call Zen_StackAdd;
private ["_vehicle", "_posArray", "_units", "_speed", "_heliZ", "_landScript", "_moveFunction", "_vehMass"];

if !([_this, [["OBJECT"], ["ARRAY"], ["VOID"], ["STRING"], ["SCALAR"]], [], 3] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_vehicle = _this select 0;
_posArray = _this select 1;
_units = [(_this select 2)] call Zen_ConvertToObjectArray;

_speed = "normal";
_heliZ = 40;

if (count _this > 3) then {
    _speed = _this select 3;
};

if (count _this > 4) then {
    _heliZ = _this select 4;
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

{
    _landScript = [_vehicle, _x, _speed, _heliZ] spawn (missionNamespace getVariable _moveFunction);

    waitUntil {
        sleep 2;
        scriptDone _landScript;
    };

    if (_forEachIndex == ((count _posArray) - 1) && ((count _posArray) > 1)) exitWith {};

    if (_vehicle isKindOf "AIR") then {
        _vehicle flyInHeight 0;
    };

    {
        _x assignAsCargo _vehicle;
        _x enableAI "move";
    } forEach _units;
    _units orderGetIn true;

    waitUntil {
        sleep 2;
        ((([_units, _vehicle]) call Zen_AreInVehicle) || ((_vehicle emptyPositions "cargo") == 0) || !(alive _vehicle))
    };

    _vehicle flyInHeight 40;
} forEach _posArray;

{
    _x enableAI "move";
} forEach (crew _vehicle);

call Zen_StackRemove;
if (true) exitWith {};

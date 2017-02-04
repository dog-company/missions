// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnVehicle", _this] call Zen_StackAdd;
private ["_pos", "_class", "_vehicle", "_height", "_special", "_dir", "_collide", "_velocity"];

if !([_this, [["VOID"], ["STRING"], ["SCALAR"], ["SCALAR"], ["BOOL"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (objNull)
};

_pos = [(_this select 0)] call Zen_ConvertToPosition;
_class = _this select 1;

_height = 0;
_dir = 0;
_collide = false;
_velocity = [0, 0, 0];

if (count _this > 2) then {
    _height = _this select 2;
};

if (count _this > 3) then {
    _dir = _this select 3;
};

if (count _this > 4) then {
    _collide = _this select 4;
};

if (_class isKindOf "Man") exitWith {
    0 = ["Zen_SpawnVehicle", "Soldier classname given, cannot spawn humans", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (objNull)
};

if ((!(isClass (configFile >> "CfgVehicles" >> _class))) && (!(isClass (configFile >> "CfgAmmo" >> _class))) && (!(isClass (configFile >> "CfgMagazines" >> _class)))) exitWith {
    0 = ["Zen_SpawnVehicle", "Invalid classname given", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
    (objNull)
};

_special = "NONE";
if (_height > 2) then {
    if (count _this < 5) then {
        _collide = true;
    };

    if (_class isKindOf "AIR") then {
        _special = "FLY";
        if (_class isKindOf "Plane") then {
            _velocity = [100, 90 - _dir, 10];
        };
    };
};

_pos set [2, 0];
_vehicle = createVehicle [_class, _pos, [], 0, _special];

if (surfaceIsWater (getPosATL _vehicle)) then {
    if (_vehicle isKindOf "SHIP") then {
        if (_collide) then {
            0 = [_vehicle, _pos, -(getTerrainHeightASL (getPosATL _vehicle)) + _height, _velocity, _dir] call Zen_TransformObject;
        } else {
            0 = [_vehicle, _vehicle, _height, _velocity, _dir] call Zen_TransformObject;
        };
    } else {
        if (_vehicle isKindOf "AIR") then {
            if (_collide) then {
                0 = [_vehicle, _pos, -(getTerrainHeightASL (getPosATL _vehicle)) + _height, _velocity, _dir] call Zen_TransformObject;
            } else {
                if (_special == "FLY") then {
                    0 = [_vehicle, _vehicle, -(getTerrainHeightASL (getPosATL _vehicle)) + _height - 60, _velocity, _dir] call Zen_TransformObject;
                } else {
                    0 = [_vehicle, _vehicle, -(getTerrainHeightASL (getPosATL _vehicle)) + _height, _velocity, _dir] call Zen_TransformObject;
                };
            };
        } else {
            if (_collide) then {
                0 = [_vehicle, _pos, -(getTerrainHeightASL (getPosATL _vehicle)) + _height, _velocity, _dir] call Zen_TransformObject;
            } else {
                0 = [_vehicle, _vehicle, -(getTerrainHeightASL (getPosATL _vehicle)) + _height, _velocity, _dir] call Zen_TransformObject;
            };
        };
    };
} else {
    if (_collide) then {
        0 = [_vehicle, _pos, _height, _velocity, _dir, (_height < 2)] call Zen_TransformObject;
    } else {
        0 = [_vehicle, _vehicle, _height, _velocity, _dir, (_height < 2)] call Zen_TransformObject;
    };
};

call Zen_StackRemove;
(_vehicle)

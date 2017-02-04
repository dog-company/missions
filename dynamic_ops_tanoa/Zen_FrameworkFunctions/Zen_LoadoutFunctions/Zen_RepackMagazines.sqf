// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define MAG_REPACK_ANIM "AinvPknlMstpSlayWrflDnon_medic"

if (isDedicated || !hasInterface) exitWith {};
_Zen_stack_Trace = ["Zen_RepackMagazines", _this] call Zen_StackAdd;
private ["_unit", "_magDetailsUnit", "_magTypes", "_magTypeAmmoCaps", "_magAmmoCounts", "_i", "_magType", "_magRepackAnim", "_totalFullMags", "_oddMagOutRoundCount", "_totalAmmo", "_ammoPerMag", "_fullCount", "_curCount", "_partials"];

if !([_this, [["OBJECT"], ["OBJECT"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_unit = _this select 1;

if (count (magazines _unit) == 0) exitWith {
    hint "You have no magazines";
    call Zen_StackRemove;
};

_magTypes = [];
_magTypeAmmoCaps = [];
_magAmmoCounts = [];
_partials = 0;

_magDetailsUnit = magazinesAmmoFull _unit;

{
    if (_x select 2) then {
        _magDetailsUnit set [_forEachIndex, -1];
    };
} forEach _magDetailsUnit;

_magDetailsUnit = _magDetailsUnit - [-1];

{
    if !((_x select 0) in _magTypes) then {
        if (((_x select 3) == -1) && {((getNumber(configFile >> "CfgMagazines" >> (_x select 0) >> "count")) > 4)}) then {
            _magTypes pushBack (_x select 0);
            _magAmmoCounts pushBack 0;
        };
    };
} forEach _magDetailsUnit;

if (count _magTypes == 0) exitWith {
    hint "You have no magazines that can be repacked";
    call Zen_StackRemove;
};

{
    _magTypeAmmoCaps pushBack (getNumber (configFile >> "CfgMagazines" >> _x >> "count"));
} forEach _magTypes;

for "_i" from 0 to ((count _magTypes) - 1) do {
    _fullCount = _magTypeAmmoCaps select _i;
    {
        if ((_magTypes select _i) == (_x select 0)) then {
            _curCount = _x select 1;
            if (_curCount < _fullCount) then {
                _partials = _partials + 1;
            };
            _magAmmoCounts set [_i, ((_magAmmoCounts select _i) + _curCount)];
        };
    } forEach _magDetailsUnit;
};

if (_partials == 0) exitWith {
    hint "You have no partial magazines to repack";
    call Zen_StackRemove;
};

for "_i" from 1 to _partials do {
    _unit playMoveNow MAG_REPACK_ANIM;
    sleep 2;
    waitUntil {
        sleep 0.25;
        animationState _unit != MAG_REPACK_ANIM;
    };
};

for "_i" from 0 to ((count _magTypes) - 1) do {
    _magType = _magTypes select _i;
    _totalAmmo = _magAmmoCounts select _i;
    _ammoPerMag = _magTypeAmmoCaps select _i;

    _unit removeMagazines _magType;
    _totalFullMags = floor (_totalAmmo / _ammoPerMag);
    _oddMagOutRoundCount = (_totalAmmo % _ammoPerMag);

    if (_totalFullMags != 0) then {
    _unit addMagazines [_magType,_totalFullMags];
    };

    if (_oddMagOutRoundCount != 0) then {
        _unit addMagazine [_magType,_oddMagOutRoundCount];
    };
};

hint "All Magazines Repacked";

call Zen_StackRemove;
if (true) exitWith {};

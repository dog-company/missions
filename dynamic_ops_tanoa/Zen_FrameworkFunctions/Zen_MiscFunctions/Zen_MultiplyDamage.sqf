// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_MultiplyDamage", _this] call Zen_StackAdd;
private ["_units", "_removeHDEvents", "_sendPacket"];

if !([_this, [["VOID"], ["BOOL"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;
_removeHDEvents = false;

if (count _this > 1) then {
    _removeHDEvents = _this select 1;
} else {
    _this set [1, _removeHDEvents];
};

ZEN_STD_Parse_GetSetArgumentDefault(_sendPacket, 2, true, false)

{
    if (alive _x) then {
        if (_removeHDEvents) then {
            _x removeAllEventHandlers "HandleDamage";
        };
        _x addEventHandler ["HandleDamage", {
            (if (alive (_this select 0)) then {
                _damage = 0;
                if (((_this select 4) != "") && ((vehicle (_this select 0)) == (_this select 0)) && {(getText (configFile >> "CfgAmmo" >> (_this select 4) >> "simulation")) == "shotBullet"}) then {
                    _hit = (getNumber (configFile >> "CfgAmmo" >> (_this select 4) >> "hit"));
                    _multiplier = (_hit + Zen_Damage_Increase) / _hit;
                    _damage = ((_this select 2) * (abs _multiplier));
                } else {
                    _damage = (_this select 2);
                };
                (_this select 0) setFatigue ((getFatigue (_this select 0)) + (_damage / 2));
                (_damage)
            } else {
                (_this select 0) removeAllEventHandlers "HandleDamage";
                (0)
            })
        }];
    };
} forEach _units;

if (isMultiplayer && {_sendPacket}) then {
    publicVariable "Zen_Damage_Increase";
    Zen_MP_Closure_Packet = ["Zen_MultiplyDamage", (_this)];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

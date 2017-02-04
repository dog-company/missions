// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetAISkill", _this] call Zen_StackAdd;
private ["_setSkillUnits", "_skill", "_sendPacket", "_unit", "_skillTypes", "_skillValue"];

if !([_this, [["VOID"], ["SCALAR", "STRING", "ARRAY"], ["BOOL"]], [[], ["SCALAR", "ARRAY"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_setSkillUnits = [([(_this select 0)] call Zen_ConvertToObjectArray)] call Zen_ArrayRemoveDead;
_skill = _this select 1;

_sendPacket = true;
if (count _this > 2) then {
    _sendPacket = _this select 2;
};

if (typeName _skill == "STRING") exitWith {
    switch (toLower _skill) do {
        case "militia": {
                0 = [_setSkillUnits, [[0.05, 0.07], [0.01, 0.02], [0.1, 0.15], 1, [0, 0.2], [0.2, 0.4], [0.5, 0.6], [0.1, 0.2], [0.5, 0.6], [0.1, 0.2]]] call Zen_SetAISkill;
        };
        case "infantry": {
                0 = [_setSkillUnits, [[0.09, 0.11], [0.03, 0.04], [0.15, 0.2], 1, [0.4, 0.5], [0.5, 0.7], [0.7, 0.8], [0.6, 0.8], [0.7, 0.8], [0.3, 0.4]]] call Zen_SetAISkill;
        };
        case "sniper": {
                0 = [_setSkillUnits, [0.5, [0.5, 0.6], [0.1, 0.2], 1, [0.8, 0.9], [0.8, 1], 0.9, [0.8, 0.1], 1, 1]] call Zen_SetAISkill;
        };
        case "sof": {
                0 = [_setSkillUnits, [[0.16, 0.18], [0.1, 0.12], [0.25, 0.3], 1, 1, 1, 1, 1, [0.8, 0.9], [0.5, 0.6]]] call Zen_SetAISkill;
        };
        case "officer": {
                0 = [_setSkillUnits, [[0.1, 0.12], [0.03, 0.04], [0.1, 0.2], 1, 1, [0.5, 0.7], [0.7, 0.8], [0.4, 0.6], [0.7, 0.8], [0.4, 0.5]]] call Zen_SetAISkill;
        };
        case "crew": {
                0 = [_setSkillUnits, [[0.075, 0.1], [0.03, 0.04], [0.1, 0.2], 1, [0.5, 0.7], [0.2, 0.4], [0.7, 0.8], [0.4, 0.6], [0.5, 0.6], [0.3, 0.4]]] call Zen_SetAISkill;
        };
        default {
            0 = ["Zen_SetAISkill", "Invalid skill preset given", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };
    };
    call Zen_StackRemove;
};

_skillTypes = ["aimingAccuracy", "aimingShake", "aimingSpeed", "commanding", "courage", "endurance", "general", "reloadSpeed", "spotDistance", "spotTime"];

{
    _unit = _x;
    if (typeName _skill == "ARRAY") then {
        if (count _skill < 10) then {
            _givenCount = count _skill;
            _lastValue = _skill select (count _skill - 1);

            for "_i" from _givenCount to 9 do {
                _skill set [_i, _lastValue];
            };
        };
        {
            if (typeName _x == "ARRAY") then {
                _skillValue = [_x select 0, _x select 1] call Zen_FindInRange;
            } else {
                _skillValue = _x;
            };

            if (_forEachIndex > 1) then {
                if (_unit == (leader group _unit)) then {
                    _unit setSkill [(_skillTypes select _forEachIndex), (_skillValue + 0.1) min 1.0];
                } else {
                    _unit setSkill [(_skillTypes select _forEachIndex), _skillValue];
                };
            } else {
                if (sunOrMoon == 0) then {
                    _unit setSkill [(_skillTypes select _forEachIndex), _skillValue / 2];
                } else {
                    _unit setSkill [(_skillTypes select _forEachIndex), _skillValue];
                };
            };
        } forEach _skill;
    } else {
        {
            if (_forEachIndex > 1) then {
                if (_unit == (leader group _unit)) then {
                    _unit setSkill [_x, (_skill + 0.1) min 1.0];
                } else {
                    _unit setSkill [_x, _skill];
                };
            } else {
                if (sunOrMoon == 0) then {
                    _unit setSkill [_x, _skill / 2];
                } else {
                    _unit setSkill [_x, _skill];
                };
            };
        } forEach _skillTypes;
    };
} forEach _setSkillUnits;

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_SetAISkill", (_this + [false])];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

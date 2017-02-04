// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetSide", _this] call Zen_StackAdd;
private ["_unitClass", "_side"];

if !([_this, [["OBJECT", "STRING"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (sideLogic)
};

_unitClass = _this select 0;

if (typeName _unitClass == "OBJECT") then {
    _unitClass = typeOf _unitClass;
};

switch (getNumber (configFile >> "CfgVehicles" >> _unitClass >> "side")) do {
    case 0: {_side = East;};
    case 1: {_side = West;};
    case 2: {_side = Resistance;};
    case 3: {_side = Civilian;};
    default {_side = sideLogic;};
};

call Zen_StackRemove;
(_side)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ConfigGetLocations", _this] call Zen_StackAdd;
private ["_locMarkers", "_locTypes", "_locConfig", "_locClass", "_locType", "_locMk", "_i"];

if !([_this, [["STRING", "ARRAY"]], [["STRING"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_locTypes = _this select 0;

_locMarkers = [];
_locConfig = configFile >> "CfgWorlds" >> worldName >> "Names";

if (count (missionNamespace getVariable [(format ["Zen_ConfigGetLocations_%1", _locTypes]), []]) != 0) exitWith {
    call Zen_StackRemove;
    (missionNamespace getVariable (format ["Zen_ConfigGetLocations_%1", _locTypes]))
};

for "_i" from 0 to (count _locConfig - 1) do {
    _locClass = _locConfig select _i;
    _locType = getText (_locClass >> "type");

    if ([_locType, _locTypes] call Zen_ValueIsInArray) then {
        _locMk = [(getArray (_locClass >> "position")), "", "colorBlack", [(getNumber (_locClass >> "radiusB")), (getNumber (_locClass >> "radiusA"))], "ellipse", 0, 0] call Zen_SpawnMarker;
        _locMarkers pushBack _locMk;
    };
};

missionNamespace setVariable [(format ["Zen_ConfigGetLocations_%1", _locTypes]), _locMarkers];

call Zen_StackRemove;
(_locMarkers)

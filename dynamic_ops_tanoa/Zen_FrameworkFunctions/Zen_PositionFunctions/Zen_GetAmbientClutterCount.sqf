// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetAmbientClutterCount", _this] call Zen_StackAdd;
private ["_center", "_radius", "_treeCount", "_rockCount", "_shrubCount"];

if !([_this, [["VOID"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

_center = [(_this select 0)] call Zen_ConvertToPosition;
_radius = _this select 1;

// _treeCount = 0;
// _rockCount = 0;
// _shrubCount = 0;

// {
    // if (["t_", (str _x)] call Zen_StringIsInString) then {
        // _treeCount = _treeCount + 1;
    // };

    // if (["stone", (str _x)] call Zen_StringIsInString) then {
        // _rockCount = _rockCount + 1;
    // };

    // if (["b_", (str _x)] call Zen_StringIsInString) then {
        // _shrubCount = _shrubCount + 1;
    // };
// } forEach (nearestObjects [_center, [], _radius]);

_treeCount = count (nearestTerrainObjects[_center, ["Tree", "Small Tree"], _radius]);
_rockCount = count (nearestTerrainObjects[_center, ["Rocks", "Rock"], _radius]);
_shrubCount = count (nearestTerrainObjects[_center, ["Bush"], _radius]);

call Zen_StackRemove;
([_treeCount, _rockCount, _shrubCount])

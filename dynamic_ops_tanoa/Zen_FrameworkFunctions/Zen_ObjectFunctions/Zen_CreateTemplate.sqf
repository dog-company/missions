// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_CreateTemplate", _this] call Zen_StackAdd;
private ["_pos", "_radius", "_objRaw", "_objResult", "_center", "_templateData", "_filterWithMarker", "_marker", "_damage", "_loadoutData", "_loadout", "_veh", "_anims"];

if (count _this == 1) then {
    if !([_this, [["STRING"]], [], 1] call Zen_CheckArguments) exitWith {
        call Zen_StackRemove;
        ("")
    };

    _marker = _this select 0;

    _pos = getMarkerPos _marker;
    _radius = [markerSize _marker, {_this}] call Zen_ArrayFindExtremum;
    _filterWithMarker = true;
} else {
    if !([_this, [["VOID"], ["SCALAR"]], [], 2] call Zen_CheckArguments) exitWith {
        call Zen_StackRemove;
        ("")
    };

    _pos = [(_this select 0)] call Zen_ConvertToPosition;
    _radius = _this select 1;

    _filterWithMarker = false;
};

_objRaw = [];
_objResult = [];
_templateData = [];

// if (_pos nearObjectsReady _radius) then {
    _objRaw = _pos nearObjects ["All", _radius];
// } else {
    // ZEN_FMW_Code_ErrorExitValue("Zen_CreateTemplate", "", ([]))
// };

if (_filterWithMarker) then {
    private ["_objRawFilter"];
    _objRawFilter = [];
    {
        if ([_x, _marker] call Zen_IsPointInPoly) then {
            _objRawFilter pushBack _x;
        };
    } forEach _objRaw;
    _objRaw = _objRawFilter;
};

{
    if ((getNumber (configFile >> "cfgVehicles" >> typeOf _x >> "Scope")) == 2) then {
        if !((_x isKindOf "Man") || {(_x isKindOf "EmptyDetector")}) then {
            _objResult pushBack _x;
        };
    };
} forEach (_objRaw - (nearestTerrainObjects [_pos, [], _radius]));

_center = [_objResult] call Zen_FindCenterPosition;
_center set [2, 0];
{
    if (_x isKindOf "static" ||_x isKindOf "building" || _x isKindOf "thing") then {
        _templateData pushBack (["Zen_Template_Object_Type_Simple", typeOf _x, (getPosATL _x) vectorDiff _center, getDir _x, [vectorDir _x, vectorUp _x], getDammage _x, simulationEnabled _x]);
    } else {
        if (_x isKindOf "WeaponHolder") then {
            _loadoutData = [_x] call Zen_GetUnitLoadout;
            _loadout = [_loadoutData] call Zen_CreateLoadout;
            _templateData pushBack (["Zen_Template_Object_Type_WeaponHolder", typeOf _x, (getPosATL _x) vectorDiff _center, getDir _x, [vectorDir _x, vectorUp _x], getDammage _x, simulationEnabled _x, _loadout]);
        } else {
            _damage = getDammage _x;
            if (count (getAllHitPointsDamage _x) > 0) then {
                _damage = (getAllHitPointsDamage _x) select 2;
            };

            _loadoutData = [_x] call Zen_GetUnitLoadout;
            _loadout = [_loadoutData] call Zen_CreateLoadout;

            _veh = _x;
            _anims = [];
            {
                _anims pushBack (_veh animationPhase _x);
            } forEach animationNames _x;

            _templateData pushBack (["Zen_Template_Object_Type_Vehicle", typeOf _x, (getPosATL _x) vectorDiff _center, getDir _x, [vectorDir _x, vectorUp _x], _damage, simulationEnabled _x, _loadout, fuel _x, _anims]);
        };
    };
} forEach _objResult;

_nameString = format ["Zen_template_%1",([10] call Zen_StringGenerateRandom)];
Zen_Template_Array_Global pushBack [_nameString, _templateData, []];
publicVariable "Zen_Template_Array_Global";

call Zen_StackRemove;
(_nameString)

/**
["template_name"
    [
        ["object type simple", "object classname", vector difference from center, vector direction, vector up, damage]
        ["object type vehicle", "object classname", vector difference from center, vector direction, vector up, damage selections, fuel, "loadout", animation phases]
        ...
    ]
]
//*/
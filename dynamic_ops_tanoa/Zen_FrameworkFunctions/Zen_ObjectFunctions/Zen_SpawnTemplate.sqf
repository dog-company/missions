// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"
#include "..\Zen_FrameworkLibrary.sqf"

_Zen_stack_Trace = ["Zen_SpawnTemplate", _this] call Zen_StackAdd;
private ["_pos", "_template", "_objects", "_obj", "_templateData", "_data", "_indexes"];

if !([_this, [["VOID"], ["STRING"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_pos = [(_this select 0)] call Zen_ConvertToPosition;
_template = _this select 1;

_indexes = [Zen_Template_Array_Global, _template, 0] call Zen_ArrayGetNestedIndex;
if (count _indexes < 1) exitWith {
    ZEN_FMW_Code_ErrorExitValue("Zen_SpawnTemplate", "Invalid template name", "")
};

_templateData = (Zen_Template_Array_Global select (_indexes select 0)) select 1;
_enableSim = [];

_objects = [];
{
    _obj = createVehicle [(_x select 1), [0, 0, 100], [], 0, "NONE"];
    _objects pushBack _obj;
    _enableSim pushBack (_x select 6);

    _obj setDir (_x select 3);
    ZEN_STD_Code_SleepFrames(3)
    _obj setVectorDirAndUp (_x select 4);

    if ((_x select 0) == "Zen_Template_Object_Type_Simple") then {
        _obj setDamage (_x select 5);
        _obj allowDamage false;
    } else {
        if ((_x select 0) == "Zen_Template_Object_Type_WeaponHolder") then {
            _obj setDamage (_x select 5);
            _obj allowDamage false;
            0 = [_obj, (_x select 7)] call Zen_GiveLoadoutCustom;
        } else {
            {
                _obj setHitIndex [_forEachIndex, _x];
            } forEach (_x select 5);
            _obj allowDamage false;

            _obj setFuel (_x select 8);
            0 = [_obj, (_x select 7)] call Zen_GiveLoadoutCustom;
            
            _data = _x;
            {
                _obj animate [_x, (_data select 9) select _forEachIndex];
            } forEach animationNames _obj;
        };
    };

    _obj setVelocity [0,0,0];
    if (((_x select 2) select 2) > 0) then {
        _obj setPosATL (((_x select 2) vectorAdd _pos) vectorAdd [0., 0., 0.02]);
    } else {
        _obj setPosATL ((_x select 2) vectorAdd _pos);
    };
    _obj enableSimulationGlobal false;
} forEach _templateData;

{
    _x allowDamage true;
} forEach _objects;

{
    _x setVectorUp (surfaceNormal (getPosATL _x));
    if (_enableSim select _forEachIndex) then {
        _x enableSimulationGlobal true;
    };
} forEach _objects;

_nameString = format ["Zen_template_spawned_%1",([10] call Zen_StringGenerateRandom)];
_templateDataSpawned = (Zen_Template_Array_Global select (_indexes select 0)) select 2;
_templateDataSpawned pushBack [_nameString, _objects];

call Zen_StackRemove;
(_nameString)

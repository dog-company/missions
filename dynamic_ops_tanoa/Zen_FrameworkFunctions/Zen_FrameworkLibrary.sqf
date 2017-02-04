// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define ZEN_FMW_Array_RemoveIndexes(A, I) \
    _Zen_IndexesToRemoveSorted = [I, {(-1 * _this)}, "hash"] call Zen_ArraySort; \
    { \
        0 = [A, _x] call Zen_ArrayRemoveIndex; \
    } forEach _Zen_IndexesToRemoveSorted;

#define ZEN_FMW_CFG_VehicleWeapons(V) \
    _Zen_WeaponsArray = []; \
    0 = [_Zen_WeaponsArray, getArray (V >> "weapons")] call Zen_ArrayAppendNested; \
    { \
        0 = [_Zen_WeaponsArray, getArray (V >> "weapons")] call Zen_ArrayAppendNested; \
    } forEach ("true" configClasses (V >> "turrets")); \
    { \
        _Zen_WeaponsArray = [_Zen_WeaponsArray, ZEN_FMW_ZAF_String(V)] call Zen_ArrayFilterCondition; \
    } forEach ["smoke", "horn", "laser", "flare", "throw", "put"];

#define ZEN_FMW_Code_ErrorExitVoid(F, D) \
    0 = [F, D, _this] call Zen_PrintError; \
    call Zen_StackPrint; \
    call Zen_StackRemove;

#define ZEN_FMW_Code_ErrorExitValue(F, D, V) \
    0 = [F, D, _this] call Zen_PrintError; \
    call Zen_StackPrint; \
    call Zen_StackRemove; \
    V

#define ZEN_FMW_Code_Error(F, D) \
    0 = [F, D, _this] call Zen_PrintError; \
    call Zen_StackPrint;

#define ZEN_FMW_Code_GiveLoadoutsOrdered(U, L, S) \
    { \
        0 = [_x, S, (L select (_forEachIndex % (count L)))] call Zen_GiveLoadout; \
    } forEach ([U] call Zen_ConvertToObjectArray);

#define ZEN_FMW_Code_Insertion(U, V, S, E) \
    _Zen_Vehicle = [S, V, (if (V isKindOf "Air") then {40} else {0})] call Zen_SpawnVehicle; \
    0 = [_Zen_Vehicle] call Zen_SpawnVehicleCrew; \
    0 = [U, _Zen_Vehicle] call Zen_MoveInVehicle; \
    0 = [_Zen_Vehicle, [E, S], U] spawn Zen_OrderInsertion;

#define ZEN_FMW_Code_InsertionPatrol(G, T, S, M) \
    _Zen_Vehicle = [S, T] call Zen_SpawnVehicle; \
    0 = [_Zen_Vehicle] call Zen_SpawnVehicleCrew; \
    0 = [G, _Zen_Vehicle] call Zen_MoveInVehicle; \
    if (_Zen_Vehicle isKindOf "Air") then { \
        0 = [_Zen_Vehicle, [([M] call Zen_FindGroundPosition), S], G, "normal", 40, "fastrope", true] spawn Zen_OrderInsertion; \
    } else { \
        0 = [_Zen_Vehicle, [([M] call Zen_FindGroundPosition), S], G] spawn Zen_OrderInsertion; \
    }; \
    0 = [G, M] spawn { \
        waitUntil { \
            sleep 5; \
            ([_this select 0] call Zen_AreNotInVehicle) \
        }; \
        0 = [_this select 0, _this select 1] spawn Zen_OrderInfantryPatrol; \
    };

#define ZEN_FMW_Code_SpawnMarker(M, N, S) \
    _Zen_GrpsArray = []; \
    for "_Z" from 1 to N do { \
        _Zen_Pos = [ M ] call Zen_FindGroundPosition; \
        _Zen_Group = [_Zen_Pos, S, "infantry", [4,6]] call Zen_SpawnInfantry; \
        _Zen_GrpsArray pushBack _Zen_Group; \
    }; \
    0 = [_Zen_GrpsArray, S, ZEN_FMW_Loadout_StdInfantryPreset, false] call Zen_GiveLoadout; \
    0 = [_Zen_GrpsArray, M] spawn Zen_OrderInfantryPatrol;

#define ZEN_FMW_Code_SpawnPoint(C, D, N, S) \
    _Zen_GrpsArray = []; \
    for "_Z" from 1 to N do { \
        _Zen_Pos = [C, [0, D]] call Zen_FindGroundPosition; \
        _Zen_Group = [_Zen_Pos, S, "infantry", [4,6]] call Zen_SpawnInfantry; \
        _Zen_GrpsArray pushBack _Zen_Group; \
    }; \
    0 = [_Zen_GrpsArray, S, ZEN_FMW_Loadout_StdInfantryPreset, false] call Zen_GiveLoadout; \
    0 = [_Zen_GrpsArray, C, [0, D]] spawn Zen_OrderInfantryPatrol;

#define ZEN_FMW_Code_SpawnPointBehind(START, END, MIND, MAXD, N, S) \
    _Zen_DirToSpawn = [START, END] call Zen_FindDirection; \
    _Zen_GrpsArray = []; \
    for "_i" from 1 to N do { \
        _Zen_SpawnPos = [END, [MIND, MAXD], 0, 1, 0, [_Zen_DirToSpawn - 90, _Zen_DirToSpawn + 90, "trig"]] call Zen_FindGroundPosition; \
        _Zen_Group = [_Zen_SpawnPos, S, "infantry", [4, 6]] call Zen_SpawnInfantry; \
        _Zen_GrpsArray pushBack _Zen_Group; \
    }; \
    0 = [_Zen_GrpsArray, S, ZEN_FMW_Loadout_StdInfantryPreset, false] call Zen_GiveLoadout; \
    0 = [_Zen_GrpsArray, END, [1, MAXD]] spawn Zen_OrderInfantryPatrol; \
    _Zen_DirToSpawn = nil;

#define ZEN_FMW_Code_WaitDistanceGreater(A, B, D) \
    waitUntil { \
        sleep 2; \
        (([A, B] call Zen_Find2dDistance) > D) \
    };

#define ZEN_FMW_Code_WaitDistanceLess(A, B, D) \
    waitUntil { \
        sleep 2; \
        (([A, B] call Zen_Find2dDistance) < D) \
    };

#define ZEN_FMW_MP_REAll(F, A, I) \
    A I (missionNamespace getVariable F); \
    if (isMultiplayer) then { \
        Zen_MP_Closure_Packet = [F, A]; \
        publicVariable "Zen_MP_Closure_Packet"; \
    };

#define ZEN_FMW_MP_REClient(F, A, I, O) \
    if (local (O)) then { \
        A I (missionNamespace getVariable F); \
    } else { \
        if (isMultiplayer) then { \
            Zen_MP_Closure_Packet = [F, A]; \
            (owner O) publicVariableClient "Zen_MP_Closure_Packet"; \
        }; \
    };

#define ZEN_FMW_MP_RENonDedicated(F, A, I) \
    if (isMultiplayer) then { \
        Zen_MP_Closure_Packet = [F, A]; \
        publicVariable "Zen_MP_Closure_Packet"; \
    }; \
    if !(isDedicated) then { \
        A I (missionNamespace getVariable F); \
    };

#define ZEN_FMW_MP_REServerOnly(F, A, I) \
    if (isServer) then { \
        A I (missionNamespace getVariable F); \
    } else { \
        if (isMultiplayer) then { \
            Zen_MP_Closure_Packet = [F, A]; \
            publicVariableServer "Zen_MP_Closure_Packet"; \
        }; \
    };

#define ZEN_FMW_Math_DistLess2D(A, B, D) (([A, B] call Zen_Find2dDistance) < D)
#define ZEN_FMW_Math_DistGreater3D(A, B, D) ((([A] call Zen_ConvertToPosition) distance ([B] call Zen_ConvertToPosition)) > D)
#define ZEN_FMW_Math_DistGreater2D(A, B, D) (([A, B] call Zen_Find2dDistance) > D)
#define ZEN_FMW_Math_DistLess3D(A, B, D) ((([A] call Zen_ConvertToPosition) distance ([B] call Zen_ConvertToPosition)) < D)
#define ZEN_FMW_Math_RandomPoint(C, R) ([C, random R, random 360] call Zen_ExtendPosition)
#define ZEN_FMW_Math_RandomPointMin(C, S, E) ([C, S + random abs (E - S), random 360] call Zen_ExtendPosition)

#define ZEN_FMW_Math_TerrainParallelCart(P, I) \
    _Zen_3dGradPolar = [1, [P] call Zen_FindTerrainGradient, 90 - ([P] call Zen_FindTerrainSlope)]; \
    I = ZEN_STD_Math_VectPolarCart(_Zen_3dGradPolar);

#define ZEN_FMW_Math_TerrainGradientCart(P, I) \
    _Zen_2dGradCyl = [tan ([P] call Zen_FindTerrainSlope), [P] call Zen_FindTerrainGradient, 0]; \
    I = ZEN_STD_Math_VectCylCart(_Zen_2dGradCyl);

#define ZEN_FMW_OBJ_DeleteDead(D) \
    { \
        _Zen_DeadUnit = _x; \
        _Zen_Delete = true; \
        { \
            if (isPlayer _x) then { \
                if ((_x distanceSqr _Zen_DeadUnit) < D*D) then { \
                    _Zen_Delete = false; \
                }; \
            }; \
        } forEach allUnits; \
        if (_Zen_Delete) then { \
            deleteVehicle _x; \
        }; \
    } forEach allDead;

#define ZEN_FMW_ZAS_ArrayLength {if (count (_this select 0) < count (_this select 1)) exitWith {-1}; (if (count (_this select 0) == count (_this select 1)) then {0} else {1})}
#define ZEN_FMW_ZAS_AlphaNumeric ({_2a = toArray (_this select 1); _c = 0; {if (_x < (_2a select _forEachIndex)) exitWith {_c = -1}; if (_x > (_2a select _forEachIndex)) exitWith {_c = 1};} forEach (toArray (_this select 0)); (_c)})
#define ZEN_FMW_ZAS_DistFarNear(C) (compile format ["if ((_this select 0) distance %1 > (_this select 1) distance %1) exitWith {-1}; (if ((_this select 0) distance %1 == (_this select 1) distance %1) then {0} else {1})", C])
#define ZEN_FMW_ZAS_DistNearFar(C) (compile format ["if ((_this select 0) distance %1 < (_this select 1) distance %1) exitWith {-1}; (if ((_this select 0) distance %1 == (_this select 1) distance %1) then {0} else {1})", C])
#define ZEN_FMW_ZAS_IntInArray(I) (compile format["if (((_this select 0) select %1) < ((_this select 1) select %1)) exitWith {-1}; (if (((_this select 0) select %1) == ((_this select 1) select %1)) then {0} else {1})", I])
#define ZEN_FMW_ZAS_StringLength {if (count toArray (_this select 0) < count toArray (_this select 1)) exitWith {-1}; (if (count toArray (_this select 0) == count toArray (_this select 1)) then {0} else {1})}

#define ZEN_FMW_ZAF_NotString(S) (compile format ["(if (typeName _this == 'STRING') then {!(['%1', _this] call Zen_StringIsInString)} else {false})", S])
#define ZEN_FMW_ZAF_String(S) (compile format ["(if (typeName _this == 'STRING') then {(['%1', _this] call Zen_StringIsInString)} else {false})", S])
#define ZEN_FMW_ZAF_Type(T) (compile format ["((toLower typeName _this) == '%1')", (toLower T)])

#define ZEN_FMW_ZFGP_Beach 1, [3,50], 0, 0, 0, [2,30], [1,10], 0, [1,10,10]
#define ZEN_FMW_ZFGP_DeepSea 2, 0, 0, 0, 0, 0, 0, 0, [1, -50]
#define ZEN_FMW_ZFGP_Flat 1, 0, 0, 0, 0, 0, [1,10]
#define ZEN_FMW_ZFGP_Forest 1, [3,100], 0, [1,0,20], 0, [1,50], 0, [2,[4, -1, -1], 20]
#define ZEN_FMW_ZFGP_Hill 1, 0, 0, 0, 0, [1,25], [2,20], 0, [2,25,10]
#define ZEN_FMW_ZFGP_LandingZone 1, [1,100], 0, [1,0,20], 0, [1,25], [1,20], [1,[0, 1, -1], 20]
#define ZEN_FMW_ZFGP_NotForest 1, 0, 0, 0, 0, 0, 0, [1,[1, -1, -1], 20]
#define ZEN_FMW_ZFGP_Urban 1, [2, 0], 0, [2,1,25], 0, [1,100], 0, [1,[1,-1,-1], 20]

#define ZEN_FMW_Loadout_DefaultPreset (["Rifleman", "AT Rifleman", "Assistant AA", "Assistant AT", "Assistant AR", "Team Leader", "Squad Leader", "Grenadier", "Auto Rifleman", "Marksman", "Medic", "AA Specialist", "AT Specialist", "Sapper", "Miner", "EOD Specialist"])
#define ZEN_FMW_Loadout_StdInfantryPreset (["Rifleman", "Rifleman", "Rifleman", "AT Rifleman", "Assistant AR", "Team Leader", "Squad Leader", "Grenadier", "Grenadier", "Auto Rifleman", "Auto Rifleman", "Marksman", "Medic"])

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define ZEN_STD_Array_LastElement(A) (A select (count A - 1))
#define ZEN_STD_Array_RandIndex(A) (floor random count A)
#define ZEN_STD_Array_RandElement(A) (A select (floor random count A))
#define ZEN_STD_Array_UnorderedRemove(A, I) \
    A set [I, A select (count A - 1)]; \
    A resize (count A - 1);

#define ZEN_STD_Code_WaitScript(S) \
    waitUntil { \
        sleep 1; \
        (scriptDone S) \
    };

#define ZEN_STD_Code_SleepFrames(F) sleep (F / diag_fps);

#define ZEN_STD_Code_SwapVars(X, Y) \
    _Zen_tempVar = X; \
    X = Y; \
    Y = _Zen_tempVar; \
    _Zen_tempVar = nil;

#define ZEN_STD_Math_RandNegativePositive() (if (random 1 > 0.5) then {1} else {-1})

#define ZEN_STD_Math_MarkerArea(M) \
    (if (toLower markerShape M == "ellipse") then { \
        (((markerSize M) select 0) * ((markerSize M) select 1) * pi) \
    } else { \
        (((markerSize M) select 0) * ((markerSize M) select 1) * 4) \
    })

#define ZEN_STD_Math_VectCartCyl(V) ([(vectorMagnitude [(V select 0), (V select 1), 0]), (V select 1) atan2 (V select 0), (V select 2)])
#define ZEN_STD_Math_VectCartPolar(V) ([(vectorMagnitude V), (V select 1) atan2 (V select 0), acos ((V select 2) / (vectorMagnitude V))])

#define ZEN_STD_Math_VectCylCart(V) ([(V select 0) * cos (V select 1), (V select 0) * sin (V select 1), (V select 2)])
#define ZEN_STD_Math_VectCylPolar(V) ([(vectorMagnitude [(V select 0), 0, (V select 2)]), (V select 1), (V select 0) atan2 (V select 2)])

#define ZEN_STD_Math_VectPolarCart(V) ([(V select 0) * cos (V select 1) * sin (V select 2), (V select 0) * sin (V select 1) * sin (V select 2), (V select 0) * cos (V select 2)])
#define ZEN_STD_Math_VectPolarCyl(V) ([(V select 0) * sin (V select 2), (V select 1), (V select 0) * cos (V select 2)])

#define ZEN_STD_Math_VectRotateX(P, A) ([(P select 0), (P select 1) * cos A + (P select 2) * sin A, - (P select 1) * sin A + (P select 2) * cos A])
#define ZEN_STD_Math_VectRotateY(P, A) ([(P select 0) * cos A - (P select 2) * sin A, (P select 1), (P select 0) * sin A + (P select 2) * cos A])
#define ZEN_STD_Math_VectRotateZ(P, A) ([(P select 0) * cos A + (P select 1) * sin A, - (P select 0) * sin A + (P select 1) * cos A, (P select 2)])

#define ZEN_STD_Math_VectTransform(P, X, Y, Z) ([(P select 0) + X, (P select 1) + Y, (P select 2) + Z])

#define ZEN_STD_OBJ_ATLPositionZ(O) ((getPosATL O) select 2)
#define ZEN_STD_OBJ_ASLPositionZ(O) ((getPosASL O) select 2)
#define ZEN_STD_OBJ_BBX(O) abs ((((boundingBoxReal O) select 0) select 0) - (((boundingBoxReal O) select 1) select 0))
#define ZEN_STD_OBJ_BBY(O) abs ((((boundingBoxReal O) select 0) select 1) - (((boundingBoxReal O) select 1) select 1))
#define ZEN_STD_OBJ_BBZ(O) abs ((((boundingBoxReal O) select 0) select 2) - (((boundingBoxReal O) select 1) select 2))

#define ZEN_STD_OBJ_AnimateDoors(V, C) \
    { \
        V animateDoor [(configName _x), C]; \
    } forEach ("((toLower (getText (_x >> 'source'))) == 'door')" configClasses (configFile >> "CfgVehicles" >> (typeOf V) >> "AnimationSources"));

#define ZEN_STD_OBJ_CountBuildingPos(V, B) \
    V = 0; \
    for "_i" from 0 to 100 do { \
        if ((B buildingPos V) isEqualTo [0,0,0]) exitWith {}; \
        V = V + 1; \
    }; \
    V = V - 1;

#define ZEN_STD_OBJ_CountCargoSeats(V) (getNumber (configFile >> "CfgVehicles" >> (typeOf V) >> "transportSoldier"))
#define ZEN_STD_OBJ_DeleteVehCrew(V) \
    { \
        deleteVehicle _x; \
    } forEach (crew V + [V]);

#define ZEN_STD_OBJ_MakePOW(O) \
    O setCaptive true; \
    O disableAI "move"; \
    O setUnitPos "UP"; \
    removeAllWeapons O; \
    removeBackpack O; \
    removeGoggles O; \
    removeHeadgear O;

#define ZEN_STD_OBJ_OrderGetOut(U, V) \
    U orderGetIn false; \
    { \
        unassignVehicle _x; \
        _x leaveVehicle V; \
    } forEach U;

#define ZEN_STD_OBJ_OrderGetIn(U, V) \
    { \
         _x assignAsCargo V; \
    } forEach U; \
    U orderGetIn true;

#define ZEN_STD_OBJ_OrientAircraft(O, P, S) \
    _Zen_vDirToLZ = ((getPosATL O) vectorFromTo P); \
    _Zen_dirToLZ = ZEN_STD_Math_VectCartCyl(_Zen_vDirToLZ) select 1; \
    sleep (5 / diag_fps); \
    O setDir (90 - _Zen_dirToLZ); \
    O setVelocity [S * cos _Zen_dirToLZ, S * sin _Zen_dirToLZ, 0];

#define ZEN_STD_OBJ_ParachuteInsertion(O, P, H) \
    _Zen_dir = random 360; \
    { \
        _x setPosATL (P vectorAdd [50 * _forEachIndex * cos _Zen_dir, 50 * _forEachIndex * sin _Zen_dir, H]); \
        removeBackpackGlobal _x; \
        _x addBackpackGlobal "b_parachute"; \
    } forEach O;

#define ZEN_STD_OBJ_TransformATL(O, X, Y, Z) O setPosATL [((getPosATL O) select 0) + X, ((getPosATL O) select 1) + Y, ((getPosATL O) select 2) + Z];

#define ZEN_STD_Parse_GetArgumentDefault(V, I, D) \
    if (count _this > I) then { \
        V = _this select I; \
    } else { \
        V = D; \
    };

#define ZEN_STD_Parse_GetSetArgumentDefault(V, I, D, R) \
    if (count _this > I) then { \
        V = _this select I; \
    } else { \
        V = D; \
    }; \
    _this set [I, R];

#define ZEN_STD_Parse_GetSetArgumentOptional(V, I, D, R) \
    if (count _this > I) then { \
        V = _this select I; \
    } else { \
        V = D; \
        _this set [I, R]; \
    };

#define ZEN_STD_Parse_GetArgument(V, I) \
    if (count _this > I) then { \
        V = _this select I; \
    };

#define ZEN_STD_Parse_ToArray(X) \
    if (typeName X != "ARRAY") then { \
        X = [X]; \
    };

#define ZEN_STD_Parse_ToString(X) \
    if (typeName X != "STRING") then { \
        X = str X; \
    };

#define ZEN_STD_Parse_ToStringLower(X) \
    if (typeName X != "STRING") then { \
        X = toLower str X; \
    };

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_FindGroundPosition", _this] call Zen_StackAdd;
private ["_worldSizeXY", "_deleteArea", "_worldMiddle", "_area", "_pos", "_vars"];

if !([_this, [["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

// /**
_worldSizeXY = [];
switch (toLower worldName) do {
    // Arma 3 worlds
    case "altis": { // Altis
        _worldSizeXY = [30720,30720];
    };
    case "bornholm": { // Bornholm,Denmark
        _worldSizeXY = [20480,20480];
    };
    case "everon2014": { // Everon 2014
        _worldSizeXY = [12800,12800];
    };
    case "anim_helvantis_v2": { // Helvantis
        _worldSizeXY = [10240,10240];
    };
    case "imrali":  { // Imrali Island
        _worldSizeXY = [10240,10240];
    };
    case "iso_st_agnes": { // St.Agnes
        _worldSizeXY = [4096,4096];
    };
    case "koplic": { // FSF Koplic
        _worldSizeXY = [7680,7680];
    };
    case "pja306": { // FSF Kalu Khan
        _worldSizeXY = [20480,20480];
    };
    case "pja307": { // FSF Daryah
        _worldSizeXY = [20480,20480];
    };
    case "saru": { // Sarugao
        _worldSizeXY = [12800,12800];
    };
    case "sfp_wamako": { // Wamako
        _worldSizeXY = [25600,25600];
    };
    case "sfp_sturko": { // Sturko
        _worldSizeXY = [10240,10240];
    };
    case "smd_sahrani_a3": { // SMD Sahrani
        _worldSizeXY = [20480,20480];
    };
    case "stratis": { // Stratis
        _worldSizeXY = [8192,8192];
    };
    case "xcam_prototype": { // Xcam PROTOTYPE
        _worldSizeXY = [10240,10240];
    };
    // AiA TP worlds
    case "bootcamp_acr": { // Bukovina
        _worldSizeXY = [3840,3840];
    };
    case "chernarus": { // Chernarus
        _worldSizeXY = [15360,15360];
    };
    case "chernarus_summer": { // Chernarus Summer
        _worldSizeXY = [15360,15360];
    };
    case "intro": { // Rahmadi
        _worldSizeXY = [5120,5120];
    };
    case "mountains_acr": { // Takistan Mountains
        _worldSizeXY = [6400,6400];
    };
    case "porto": { // Porto
        _worldSizeXY = [5120,5120];
    };
    case "sara": { // Sahrani
        _worldSizeXY = [20480,20480];
    };
    case "saralite": { // Southern Sahrani
        _worldSizeXY = [10240,10240];
    };
    case "sara_dbe1": { // United Sahrani
        _worldSizeXY = [20480,20480];
    };
    case "shapur_baf": { // Shapur
        _worldSizeXY = [2048,2048];
    };
    case "takistan": { // Takistan
        _worldSizeXY = [12800,12800];
    };
    case "utes": { // Utes
        _worldSizeXY = [5120,5120];
    };
    case "woodland_acr": { // Bystrica
        _worldSizeXY = [7680,7680];
    };
    case "zargabad": { // Zargabad
        _worldSizeXY = [8192,8192];
    };
    // Arma 2 worlds
    case "bmfayshkhabur": { // Fayshkhabur v1.2
        _worldSizeXY = [20480,20480];
    };
    case "caribou": { // Caribou Frontier
        _worldSizeXY = [8190,8190];
    };
    case "celle": { // Celle
        _worldSizeXY = [10240,10240];
    };
    case "clafghan": { // CLA Clafghan
        _worldSizeXY = [20480,20480];
    };
    case "cmr_cicada": { // Cicada
        _worldSizeXY = [10240,10240];
    };
    case "cmr_ovaron": { // Ovaron
        _worldSizeXY = [10240,10240];
    };
    case "fata": { // PR Fata
        _worldSizeXY = [10240,10240];
    };
    case "fdf_isle1_a": { // Podagorsk
        _worldSizeXY = [20480,20480];
    };
    case "hellskitchen": { // Summer Sangin 5x5 km
        _worldSizeXY = [5120,5120];
    };
    case "hellskitchens": { // Winter Sangin 5x5 km
        _worldSizeXY = [5120,5120];
    };
    case "isoladicapraia": { // Capraia
        _worldSizeXY = [10240,10240];
    };
    case "japahto": { // Japahto Islands
        _worldSizeXY = [5120,5120];
    };
    case "kulima": { // Kulima v2.2
        _worldSizeXY = [5120,5120];
    };
    case "mak_pj7": { // FSF_Varkgard
        _worldSizeXY = [20480,20480];
    };
    case "mcn_aliabad": { // Aliabad Region
        _worldSizeXY = [5120,5120];
    };
    case "panthera3": { // Island Panthera v3.1
        _worldSizeXY = [10240,10240];
    };
    case "spritzisland": { // Spritz Island 1.1
        _worldSizeXY = [10240,10240];
    };
    case "thirsk": { // Thirsk
        _worldSizeXY = [5120,5120];
    };
    case "thirskw": { // Thirsk Winter
        _worldSizeXY = [5120,5120];
    };
    case "torabora": { // ToraBora
        _worldSizeXY = [10240,10240];
    };
    case "tropica": { // Tropica
        _worldSizeXY = [20480,20480];
    };
};
//*/

if (count _worldSizeXY == 0) then {
    _worldSizeXY = [worldSize, worldSize];
};

_deleteArea = false;
if (typeName (_this select 0) == "SCALAR") then {
    if (count _worldSizeXY > 0) then {
        _worldMiddle = [(_worldSizeXY select 0) / 2, (_worldSizeXY select 1) / 2];
        _area = [_worldMiddle, "", "colorBlack", _worldMiddle, "rectangle", 0, 0] call Zen_SpawnMarker;
        _pos = _worldMiddle;
        _deleteArea = true;
        _this set [0, _area];
    } else {
        0 = ["Zen_FindGroundPosition", "Unable to generate world marker.", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
} else {
    _area = _this select 0;
    _pos = [_area] call Zen_ConvertToPosition;
};

if (typeName _area == "STRING") then {
    if !([_area, allMapMarkers] call Zen_ValueIsInArray) then {
        0 = ["Zen_FindGroundPosition", "The given marker does not exist", _this] call Zen_PrintError;
        call Zen_StackPrint;
    } else {
        if ((markerShape _area) == "ICON") then {
            _this set [0, ([_area] call Zen_ConvertToPosition)];
            _vars = _this call Zen_GetArguments;

            if (count _vars > 0) then {
                _pos = _vars call Zen_CalculatePositionObject;
            };
        } else {
            _vars = _this call Zen_GetArguments;

            if (count _vars > 0) then {
                _pos = _vars call Zen_CalculatePositionMarker;
            };
        };
    };
} else {
    _vars = _this call Zen_GetArguments;

    if (count _vars > 0) then {
        _pos = _vars call Zen_CalculatePositionObject;
    };
};

if (count _worldSizeXY > 0) then {
    if ((((_pos select 0) < 0) || ((_pos select 1) < 0)) || {(((_pos select 0) > (_worldSizeXY select 0)) || ((_pos select 1) > (_worldSizeXY select 1)))}) then {
        0 = ["Zen_FindGroundPosition", "Returned position is off the map", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
} else {
    if (((_pos select 0) < 0) || ((_pos select 1) < 0)) then {
        0 = ["Zen_FindGroundPosition", "Returned position is off the map", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

if (_deleteArea) then {
    deleteMarker _area;
};

call Zen_StackRemove;
(_pos)

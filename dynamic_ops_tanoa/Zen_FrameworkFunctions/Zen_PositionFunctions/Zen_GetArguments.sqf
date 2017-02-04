// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_GetArguments", _this] call Zen_StackAdd;
private ["_water", "_road", "_roadID", "_roadDist", "_area", "_min", "_max", "_Vars", "_maxAngle", "_minAngle", "_angles", "_objSwitch", "_objLimit", "_objDist", "_objects", "_Trig", "_minMax", "_pointAvoid", "_pointAvoidSwitch", "_pointAvoidArray", "_pointAvoidDist", "_nearWater", "_nearWaterSwitch", "_nearWaterDist", "_terrainSlopeSwitch", "_terrainSlopeAngle", "_terrainSlopeRadius", "_terrainSlope", "_ambientClutterSwitch", "_ambientClutterCount", "_ambientClutterRadius", "_ambientClutter", "_height", "_heightSwitch", "_heightNumber", "_heightRadius", "_numbers", "_allBlacklist", "_allWhitelist", "_oneWhitelist"];

if !([_this, [["VOID"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["ARRAY", "SCALAR"], ["SCALAR"]], [[], ["SCALAR"], ["STRING", "ARRAY"], [], ["SCALAR"], ["SCALAR", "STRING"], ["SCALAR"], ["SCALAR", "ARRAY", "OBJECT", "GROUP", "STRING"], ["SCALAR"], ["SCALAR"], ["SCALAR", "ARRAY"], ["SCALAR"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_area = _this select 0;

_min = random 1;
_max = 200;
_allBlacklist = [];
_allWhitelist = [];
_oneWhitelist = [];
_water = 1;
_roadID = 0;
_roadDist = 0;
_minAngle = 0;
_maxAngle = 360;
_objSwitch = 0;
_objLimit = 0;
_objDist = 0;
_pointAvoidSwitch = 0;
_pointAvoidArray = 0;
_pointAvoidDist = 0;
_nearWaterSwitch = 0;
_nearWaterDist = 0;
_terrainSlopeSwitch = 0;
_terrainSlopeAngle = 0;
_terrainSlopeRadius = -1;
_ambientClutterSwitch = 0;
_ambientClutterCount = 0;
_ambientClutterRadius = 0;
_heightSwitch = 0;
_heightNumber = 0;
_heightRadius = 0;
_maxFailures = 0;

if (count _this > 1) then {
    _MNDist = _this select 1;
    if (typeName _MNDist == "ARRAY") then {
        _min = _MNDist select 0;
        _max = _MNDist select 1;
        if (_min == 0) then {_min = random 1;};
        if (_min < 0) then {_min = abs _min;};
        if (_max == 0) then {_max = 1;};
        if (_max < 0) then {_max = abs _max;};
        if (_min > _max) then {
            _minTemp = _min;
            _min = _max;
            _max = _minTemp;
        };
        if (_min == _max) then {_max = _max + random 1;};
    } else {
        _min = _MNDist;
        if (_min < 0) then {_min = abs _min;};
    };
};

if (count _this > 2) then {
    if (((typeName (_this select 2)) == "ARRAY") && {count (_this select 2) > 0}) then {
        if ((typeName ((_this select 2) select 0)) == "ARRAY") then {
            _allBlacklist = (_this select 2) select 0;
            if ((count (_this select 2)) > 1) then {
                _allWhitelist = (_this select 2) select 1;
            };

            if ((count (_this select 2)) > 2) then {
                _oneWhitelist = (_this select 2) select 2;
            };
        } else {
            _allBlacklist = _this select 2;
        };
    };
};

if (count _this > 3) then {
    _water = _this select 3;
};

if (count _this > 4) then {
    _road = _this select 4;
    if (typeName _road == "ARRAY") then {
        _roadID = _road select 0;
        _roadDist = _road select 1;
    };
    if (_roadID == 2) then {_roadDist = 100;};
};

if (count _this > 5) then {
    _angles = _this select 5;
    if (typeName _angles == "ARRAY") then {
        if (count _angles > 2) then {
            if (toLower (_angles select 2) == "compass") then {
                _minAngle = [(_angles select 0)] call Zen_FindTrigAngle;
                _maxAngle = [(_angles select 1)] call Zen_FindTrigAngle;
            } else {
                _minAngle = _angles select 0;
                _maxAngle = _angles select 1;
            };
        } else {
            _minAngle = [(_angles select 0)] call Zen_FindTrigAngle;
            _maxAngle = [(_angles select 1)] call Zen_FindTrigAngle;
        };
    };
};

if (count _this > 6) then {
    _objects = _this select 6;
    if (typeName _objects == "ARRAY") then {
        _objSwitch = _objects select 0;
        _objLimit = _objects select 1;
        _objDist = _objects select 2;
    };
};

if (count _this > 7) then {
    _pointAvoid = _this select 7;
    if (typeName _pointAvoid == "ARRAY") then {
        _pointAvoidSwitch = _pointAvoid select 0;
        _pointAvoidArray = _pointAvoid select 1;
        _pointAvoidDist = _pointAvoid select 2;
    };

    if (typeName _pointAvoidArray != "ARRAY") then {
        _pointAvoidArray = [_pointAvoidArray];
    };
};

if (count _this > 8) then {
    _nearWater = _this select 8;
    if (typeName _nearWater == "ARRAY") then {
        _nearWaterSwitch = _nearWater select 0;
        _nearWaterDist = _nearWater select 1;
    };
};

if (count _this > 9) then {
    _terrainSlope = _this select 9;
    if (typeName _terrainSlope == "ARRAY") then {
        _terrainSlopeSwitch = _terrainSlope select 0;
        _terrainSlopeAngle = _terrainSlope select 1;
        if (count _terrainSlope > 2) then {
            _terrainSlopeRadius = _terrainSlope select 2;
        };
    };
};

if (count _this > 10) then {
    _ambientClutter = _this select 10;
    if (typeName _ambientClutter == "ARRAY") then {
        _ambientClutterSwitch = _ambientClutter select 0;
        _ambientClutterCount = _ambientClutter select 1;
        _ambientClutterRadius = _ambientClutter select 2;
    };
};

if (count _this > 11) then {
    _height = _this select 11;
    if (typeName _height == "ARRAY") then {
        _heightSwitch = _height select 0;
        _heightNumber = _height select 1;
        _heightRadius = _height select 2;
    };
};

if (count _this > 12) then {
    _maxFailures = _this select 12;
};

call Zen_StackRemove;
(if (typeName _area == "STRING") then {
    ([_area, _min, 0, _allBlacklist, _allWhitelist, _oneWhitelist, _water, _roadID, _roadDist, _minAngle, _maxAngle,_objSwitch,_objLimit,_objDist,_pointAvoidSwitch,_pointAvoidArray,_pointAvoidDist,_nearWaterSwitch,_nearWaterDist, _terrainSlopeSwitch, _terrainSlopeAngle, _terrainSlopeRadius, _ambientClutterSwitch, _ambientClutterCount, _ambientClutterRadius, _heightSwitch, _heightNumber, _heightRadius, _maxFailures])
} else {
    ([([_area] call Zen_ConvertToPosition), _min, _max, _allBlacklist, _allWhitelist, _oneWhitelist, _water, _roadID, _roadDist, _minAngle, _maxAngle,_objSwitch,_objLimit,_objDist,_pointAvoidSwitch,_pointAvoidArray,_pointAvoidDist,_nearWaterSwitch,_nearWaterDist, _terrainSlopeSwitch, _terrainSlopeAngle, _terrainSlopeRadius, _ambientClutterSwitch, _ambientClutterCount, _ambientClutterRadius, _heightSwitch, _heightNumber, _heightRadius, _maxFailures])
})

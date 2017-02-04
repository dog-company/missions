// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_IsAngleInSector", _this] call Zen_StackAdd;
private ["_angle", "_sectorAngles", "_minSector", "_isInSector", "_tempAngleMax", "_maxSector"];

if !([_this, [["SCALAR"], ["ARRAY"]], [[], ["SCALAR"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    (false)
};

_angle = _this select 0;
_sectorAngles = _this select 1;

_minSector = _sectorAngles select 0;
_maxSector = _sectorAngles select 1;

_isInSector = false;

if (_minSector > _maxSector) then {
    _tempAngleMax = _maxSector;
    _maxSector = _minSector;
    _minSector = _tempAngleMax;
};

if ((_angle < 0) && (_maxSector >= 0) && (_minSector >= 0)) then {
    _angle = _angle + 360;
};

if ((_angle > 0) && (_maxSector <= 0) && (_minSector <= 0)) then {
    _angle = _angle - 360;
};

if ((_angle > _maxSector) && (_maxSector >= 0) && (_minSector <= 0) && ((abs _minSector) > (abs _maxSector))) then {
    _angle = _angle - 360;
};

if ((_angle < _minSector) && (_maxSector >= 0) && (_minSector <= 0) && ((abs _minSector) < (abs _maxSector))) then {
    _angle = _angle + 360;
};

if (_minSector == _maxSector) then {
    if (_angle == _maxSector) then {
        _isInSector = true;
    };
} else {
    if ((_angle >= _minSector) && (_angle <= _maxSector)) then {
        _isInSector = true;
    };
};

if (((abs _minSector) + (abs _maxSector)) == 360) then {
    _isInSector = true;
};

call Zen_StackRemove;
(_isInSector)

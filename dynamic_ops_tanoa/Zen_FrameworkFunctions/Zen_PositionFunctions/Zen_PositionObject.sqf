// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

private ["_centerXY", "_radiusMin", "_radiusMax", "_minAngle", "_maxAngle", "_phi", "_distance"];

_centerXY = _this select 0;
_radiusMin = _this select 1;
_radiusMax = _this select 2;
_minAngle = _this select 3;
_maxAngle = _this select 4;

_phi = _minAngle + random (_maxAngle - _minAngle);
_distance = _radiusMin + ((sqrt random 1) * (_radiusMax - _radiusMin));
// _distance = _radiusMin + ((random 1)^(1/(sqrt 2)) * (_radiusMax - _radiusMin));

([(_centerXY select 0) + (cos _phi) * _distance, (_centerXY select 1) + (sin _phi) * _distance, 0])

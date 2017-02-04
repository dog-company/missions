private ["_heli", "_targetPos"];

_heli = _this select 0;
_targetPos = _this select 1;
_time = 0;

_dist = _heli distance _targetPos;
_startPos = getPosASL  _heli;
//linearConversion [0,1,0.55,0,_dist]; //55



while {true} do {
	_heli engineOn true;
    _time = _time + 0.000036;
    _arr = [_startPos, _targetPos, [0,0,0], [0,0,0], vectorDir _heli, vectorDir _heli, vectorUp _heli, vectorUp _heli, _time];
    _heli setVelocityTransformation _arr;
 
};

deleteVehicle _heli;
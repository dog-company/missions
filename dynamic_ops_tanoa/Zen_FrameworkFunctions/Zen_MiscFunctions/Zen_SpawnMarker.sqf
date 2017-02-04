// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SpawnMarker", _this] call Zen_StackAdd;
private ["_name", "_pos", "_type", "_txt", "_size", "_color", "_alpha", "_dir"];

if !([_this, [["VOID"], ["STRING"], ["STRING"], ["ARRAY"], ["STRING"], ["SCALAR"], ["SCALAR"]], [[], [], [], ["SCALAR"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ("")
};

_pos = [(_this select 0)] call Zen_ConvertToPosition;

_name = "";
_txt = "";
_color = "colorBlack";
_size = [1,1];
_type = "mil_dot";
_dir = 0;
_alpha = 1;

if (count _this > 1) then {
    _txt = _this select 1;
};

if (count _this > 2) then {
    _color = _this select 2;
    if (_color == "") then {_color = "colorBlack";};
};

if (count _this > 3) then {
    _size = _this select 3;
};

if (count _this > 4) then {
    _type = _this select 4;
    if (_type == "") then {_type = "mil_Dot";};
};

if (count _this > 5) then {
    _dir = _this select 5;
};

if (count _this > 6) then {
    _alpha = _this select 6;
};

if (count _this > 7) then {
    _name = _this select 7;
}; 

if (_name == "") then {
    _name = format["Zen_mk_%1", ([10] call Zen_StringGenerateRandom)];
};

createMarker [_name,_pos];
_name setMarkerAlpha _alpha;
_name setMarkerPos _pos;

if (_type == "ELLIPSE" || _type == "RECTANGLE") then {
    _name setMarkerShape _type;
} else {
    _name setMarkerType _type;
};

_name setMarkerText _txt;
_name setMarkerColor _color;
_name setMarkerSize _size;
_name setMarkerDir _dir;

call Zen_StackRemove;
(_name)

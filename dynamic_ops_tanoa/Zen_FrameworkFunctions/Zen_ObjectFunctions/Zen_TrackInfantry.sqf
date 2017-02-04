// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TrackInfantry", _this] call Zen_StackAdd;
private ["_textType", "_groups", "_color","_txt","_units", "_unitMarkers", "_marker", "_thread", "_hideFromUnits", "_unit"];

if !([_this, [["VOID"], ["STRING"], ["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_units = [(_this select 0)] call Zen_ConvertToObjectArray;

_textType = "name";
_hideFromUnits = 0;

if (count _this > 1) then {
    _textType = _this select 1;
};

if (count _this > 2) then {
    _hideFromUnits = _this select 2;
};

_unitMarkers = [];

{
    _unit = _x;

    switch (toLower _textType) do {
        case "object": {
            _txt = str _unit;
        };
        case "group": {
            _txt = str (group _unit);
        };
        case "name": {
            _txt = "";
            if (isPlayer _unit && alive _unit) then {
                _txt = name _unit;
            };
        };
        case "number": {
            _txt = str _forEachIndex;
        };
        default {
            _txt = "";
        };
    };

    _color = [_unit] call Zen_GetSideColor;
    _marker = [_unit, _txt, _color, [.4,.65] ,"mil_triangle", (getDir _unit), 1] call Zen_SpawnMarker;

    _unitMarkers pushBack _marker;
} forEach _units;

if (isMultiplayer) then {
    0 = [_unitMarkers, 0, _hideFromUnits] call Zen_ShowHideMarkers;
};

_thread = [_units, _unitMarkers, _textType] spawn {

    _Zen_stack_Trace = ["Zen_TrackInfantry", _this] call Zen_StackAdd;
    private ["_units", "_unit", "_unitMarkers", "_textType", "_marker"];

    _units = _this select 0;
    _unitMarkers = _this select 1;
    _textType = _this select 2;

    while {((count _units) != 0)} do {
        {
            _marker = _x;
            _unit = _units select _forEachIndex;
            if !(alive _unit) then {

                _marker setMarkerPos getPosATL _unit;
                _marker setMarkerDir getDir _unit;
                _marker setMarkerType "mil_destroy";
                _marker setMarkerDir 45;
                _marker setMarkerSize [0.5,0.5];
                _marker setMarkerText "";

                _unitMarkers set [_forEachIndex, 0];
                _units set [_forEachIndex, 0];
            } else {
                switch (toLower _textType) do {
                    case "object": {
                        _marker setMarkerText (str _unit);
                    };
                    case "group": {
                        _marker setMarkerText (str (group _unit));
                    };
                    case "name": {
                        if (isPlayer _unit && alive _unit) then {
                            _marker setMarkerText (name _unit);
                        } else {
                            if (!isPlayer _unit) then {
                                _marker setMarkerText "";
                            };
                        };
                    };
                    case "number": {
                        _marker setMarkerText str _forEachIndex;
                    };
                };

                _marker setMarkerPos getPosATL _unit;
                _marker setMarkerDir getDir _unit;
            };
        } forEach _unitMarkers;

        0 = [_units, 0] call Zen_ArrayRemoveValue;
        0 = [_unitMarkers, 0] call Zen_ArrayRemoveValue;
        sleep 10;
    };
    call Zen_StackRemove;
    if (true) exitWith {};
};

call Zen_StackRemove;
([_unitMarkers, _thread])

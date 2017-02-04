// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_TrackVehicles", _this] call Zen_StackAdd;
private ["_vehicles", "_textType", "_hideFromUnits", "_unitMarkers", "_vehicle", "_txt", "_markerShape", "_color", "_marker", "_thread"];

if !([_this, [["ARRAY", "OBJECT"], ["STRING"], ["VOID"]], [["OBJECT", "ARRAY"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_vehicles = [(_this select 0)] call Zen_ConvertToObjectArray;

_textType = "none";
_hideFromUnits = 0;

if (count _this > 1) then {
    _textType = _this select 1;
};

if (count _this > 2) then {
    _hideFromUnits = _this select 2;
};

_unitMarkers = [];

{
    _vehicle = _x;

    switch (true) do {
        case (_vehicle isKindOf "CAR"): {
            _markerShape = "mech_inf";
        };
        case (_vehicle isKindOf "TANK"): {
            _markerShape = "armor";
        };
        case (_vehicle isKindOf "HELICOPTER"): {
            _markerShape = "air";
        };
        case (_vehicle isKindOf "PLANE"): {
            _markerShape = "plane";
        };
        case (_vehicle isKindOf "SHIP"): {
            _markerShape = "naval";
        };
        case (_vehicle isKindOf "STATICMORTAR"): {
            _markerShape = "mortar";
        };
        case (_vehicle isKindOf "UAV"): {
            _markerShape = "uav";
        };
        default {
            _markerShape = "unknown";
        };
    };

    switch ([_vehicle] call Zen_GetSide) do {
        case west: {
            _markerShape = "b_" + _markerShape;
        };
        case east: {
            _markerShape = "o_" + _markerShape;
        };
        case resistance: {
            _markerShape = "n_" + _markerShape;
        };
        case civilian: {
            _markerShape = "c_unknown";
        };
        default {
            _markerShape = "c_unknown";
            0 = ["Zen_TrackVehicles", "Object is of invalid side", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };
    };

    switch (toLower _textType) do {
        case "object": {
            _txt = str _vehicle;
        };
        case "group": {
            if (({alive _x} count crew _vehicle) > 0) then {
                _txt = (str group (crew _vehicle select 0));
            } else {
                _txt = "";
            };
        };
        case "name": {
            _txt = "";
            if (isPlayer (commander _x) && {alive (commander _x)}) then {
                _txt = name (commander _x);
            } else {
                if (isPlayer (gunner _x) && {alive (gunner _x)}) then {
                    _txt = name (gunner _x);
                } else {
                    if (isPlayer (driver _x) && {alive (driver _x)}) then {
                        _txt = name (driver _x);
                    };
                };
            };
        };
        case "number": {
            _txt = str (_forEachIndex + 1);
        };
        default {
            _txt = "";
        };
    };

    _marker = [(getPosATL _vehicle), format ["%1", _txt], "colorBlack", [0.9, 0.9], _markerShape, 0, 1] call Zen_SpawnMarker;
    _unitMarkers pushBack _marker;
} forEach _vehicles;

if (isMultiplayer) then {
    0 = [_unitMarkers, 0, _hideFromUnits] call Zen_ShowHideMarkers;
};

_thread = [_vehicles, _unitMarkers, _textType] spawn {
    _Zen_stack_Trace = ["Zen_TrackVehicles", _this] call Zen_StackAdd;
    private ["_vehicles", "_unitMarkers", "_textType", "_vehicle", "_marker"];

    _vehicles = _this select 0;
    _unitMarkers = _this select 1;
    _textType = _this select 2;

    while {((count _vehicles) != 0)} do {
        {
            _vehicle = _x;
            _marker = _unitMarkers select _forEachIndex;
            if !(alive _vehicle) then {
                deleteMarker _marker;

                _vehicles set [_forEachIndex, 0];
                _unitMarkers set [_forEachIndex, 0];
            } else {
                switch (toLower _textType) do {
                    case "object": {
                        _marker setMarkerText (str _vehicle);
                    };
                    case "group": {
                        if (({alive _x} count crew _vehicle) > 0) then {
                            _marker setMarkerText (str group (crew _vehicle select 0));
                        } else {
                            _marker setMarkerText "";
                        };
                    };
                    case "name": {
                        if (alive (commander _vehicle) && {isPlayer (commander _vehicle)}) then {
                            _marker setMarkerText name (commander _vehicle);
                        } else {
                            if (alive (gunner _vehicle) && {isPlayer (gunner _vehicle)}) then {
                                _marker setMarkerText name (gunner _vehicle);
                            } else {
                                if (alive (driver _vehicle) && {isPlayer (driver _vehicle)}) then {
                                    _marker setMarkerText name (driver _vehicle);
                                } else {
                                    _marker setMarkerText "";
                                };
                            };
                        };
                    };
                    // case "number": {};
                };

                if (({alive _x} count crew _vehicle) == 0) then {
                    _marker setMarkerColor "ColorBlack";
                } else {
                    _marker setMarkerColor ([(([(crew _vehicle)] call Zen_ArrayRemoveDead) select 0)] call Zen_GetSideColor);
                };

                _marker setMarkerPos getPosATL _vehicle;
            };
        } forEach _vehicles;

        0 = [_vehicles, 0] call Zen_ArrayRemoveValue;
        0 = [_unitMarkers, 0] call Zen_ArrayRemoveValue;
        sleep 10;
    };
    call Zen_StackRemove;
    if (true) exitWith {};
};

call Zen_StackRemove;
[_unitMarkers, _thread]

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ShowHideMarkers", _this] call Zen_StackAdd;
private ["_markerArray", "_unitsShowArray", "_unitsHideArray", "_vars"];

if !([_this, [["ARRAY", "STRING"], ["VOID"], ["VOID"]], [["STRING"]], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_markerArray = _this select 0;

if (typeName _markerArray == "STRING") then {
    _markerArray = [_markerArray];
};

_unitsShowArray = 0;
_unitsHideArray = 0;

if (count _this > 1) then {
    _unitsShowArray = _this select 1;
};

if (count _this > 2) then {
    _unitsHideArray = _this select 2;
};

_sendPacket = true;
if (count _this > 3) then {
    _sendPacket = _this select 3;
};

if (!isDedicated && hasInterface) then {
    if (typeName _unitsShowArray != "SCALAR") then {
        _unitsShowArray = [_unitsShowArray] call Zen_ConvertToObjectArray;
        if (player in _unitsShowArray) then {
            {
                _x setMarkerAlphaLocal 1;
            } forEach _markerArray;
        };
    };

    if (typeName _unitsHideArray != "SCALAR") then {
        _unitsHideArray = [_unitsHideArray] call Zen_ConvertToObjectArray;
        if (player in _unitsHideArray) then {
            {
                _x setMarkerAlphaLocal 0;
            } forEach _markerArray;
        };
    };
};

if (isMultiplayer && {(_sendPacket)}) then {
    switch (count _this) do {
        case 2: {
            _vars = _this + [0, false];
        };
        case 3: {
            _vars = _this + [false];
        };
        default {
            _vars = _this;
        };
    };

    Zen_MP_Closure_Packet = ["Zen_ShowHideMarkers", _vars];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

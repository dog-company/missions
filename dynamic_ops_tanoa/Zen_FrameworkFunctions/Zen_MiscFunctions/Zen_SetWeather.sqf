// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_SetWeather", _this] call Zen_StackAdd;
private ["_dateArray", "_sendPacket", "_defaultArrayDate", "_defaultArrayWeather", "_currentValue", "_futureValue", "_futureTime"];

if !([_this, [["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"], ["ARRAY"]], [["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"], ["STRING", "SCALAR", "BOOL"]], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_defaultArrayDate = ["defaultdate", (random 59.99), random 24, (random 32.99), (random 11.99), 2035];
_sendPacket = true;

{
    if ((_x select 0) == "defaultdate") then {
        _defaultArrayDate = _x;
    } else {
        if ((_x select 0) == "packet") then {
            _sendPacket = _x select 1;
        } else {
            if (toLower (_x select 0) == "overcast") then {
                _defaultArrayWeather = ["", 0, 0, 600];
                {
                    _defaultArrayWeather set [_forEachIndex, _x];
                } forEach _x;
                _currentValue = _defaultArrayWeather select 1;
                _futureValue = _defaultArrayWeather select 2;
                _futureTime = _defaultArrayWeather select 3;

                if (_currentValue != -1) then {
                    0 setOvercast _currentValue;
                    skipTime 2;
                    sleep 0.1;
                    skipTime -2;
                    sleep 0.1;
                    simulWeatherSync;
                };

                if (count _x > 2) then {
                    _futureTime setOvercast _futureValue;
                };
            };
        };
    };
} forEach _this;

{
    if ((toLower (_x select 0)) == "date") then {
        _dateArray =+ _defaultArrayDate;
        {
            _dateArray set [_forEachIndex, _x];
        } forEach _x;

        reverse _dateArray;
        _dateArray resize 5;
        setDate _dateArray;
    } else {
        _defaultArrayWeather = ["", 0, 0, 600];
        {
            _defaultArrayWeather set [_forEachIndex, _x];
        } forEach _x;

        _currentValue = _defaultArrayWeather select 1;
        _futureValue = _defaultArrayWeather select 2;
        _futureTime = _defaultArrayWeather select 3;
        switch (toLower (_x select 0)) do {
            case "fog": {
                if (_currentValue != -1) then {
                    0 setFog [_currentValue, 0.004 + random .005, 3 + random 4];
                };

                if (count _x > 2) then {
                    _futureTime setFog [_futureValue, 0.01 + random .1, 1 + random 25];
                };
            };
            case "rain": {
                if (_currentValue != -1) then {
                    0 setRain _currentValue;
                };

                if (count _x > 2) then {
                    _futureTime setRain _futureValue;
                };
            };
            case "wind": {
                setWind [_currentValue, _futureValue];
            };
            case "gusts": {
                if (_currentValue != -1) then {
                    0 setGusts _currentValue;
                };

                if (count _x > 2) then {
                    _futureTime setGusts _futureValue;
                };
            };
            case "waves": {
                if (_currentValue != -1) then {
                    0 setWaves _currentValue;
                };

                if (count _x > 2) then {
                    _futureTime setGusts _futureValue;
                };
            };
            case "overcast": {};
            case "defaultdate": {};
            case "packet": {};
            default {
                0 = ["Zen_SetWeather", "Invalid weather type given", _this] call Zen_PrintError;
                call Zen_StackPrint;
            };
        };
    };
} forEach _this;

if (isMultiplayer && {_sendPacket}) then {
    Zen_MP_Closure_Packet = ["Zen_SetWeather", (_this + [["packet", false]] + [_defaultArrayDate])];
    publicVariable "Zen_MP_Closure_Packet";
};

call Zen_StackRemove;
if (true) exitWith {};

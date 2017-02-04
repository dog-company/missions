// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ConvertToPosition", _this] call Zen_StackAdd;
private ["_dataToConvert", "_returnPosition"];

if !([_this, [["VOID"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([0,0,0])
};

_dataToConvert = _this select 0;
_returnPosition = [0,0,0];

switch (typeName _dataToConvert) do {
    case "OBJECT": {
        _returnPosition = getPosATL _dataToConvert;
    };
    case "STRING": {
        if ([_dataToConvert, allMapMarkers] call Zen_ValueIsInArray) then {
            _returnPosition = getMarkerPos _dataToConvert;
        } else {
            0 = ["Zen_ConvertToPosition", "Given marker does not exist", _this] call Zen_PrintError;
            call Zen_StackPrint;
        };
    };
    case "GROUP": {
        _returnPosition = getPosATL (leader _dataToConvert);
    };
    case "ARRAY": {
        switch (count _dataToConvert) do {
            case 2: {
                _returnPosition = [(_dataToConvert select 0), (_dataToConvert select 1), 0];
            };
            case 3: {
                _returnPosition =+ _dataToConvert;
            };
            default {
                0 = ["Zen_ConvertToPosition", "Given array is not in [x,y] or [x,y,z] format", _this] call Zen_PrintError;
                call Zen_StackPrint;
            };
        };

        {
            if (typeName _x != "SCALAR") exitWith {
                _returnPosition = [0,0,0];
                0 = ["Zen_ConvertToPosition", "Given array does not contain valid x,y,z numerical coordinates", _this] call Zen_PrintError;
                call Zen_StackPrint;
            };
        } forEach _returnPosition;
    };
    default {
        _returnPosition = _dataToConvert;
        0 = ["Zen_ConvertToPosition", "Given value does not represent a position in space", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

call Zen_StackRemove;
(_returnPosition)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_ArrayGetRandom", _this] call Zen_StackAdd;
private ["_array", "_returnElement", "_remove", "_randomIndex"];

if !([_this, [["VOID"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_array = _this select 0;
ZEN_STD_Parse_GetArgumentDefault(_remove, 1, false)

if (typeName _array == "ARRAY") then {
    if (count _array == 0) then {
        _returnElement = [];
    } else {
        _randomIndex = ZEN_STD_Array_RandIndex(_array);
        _returnElement = _array select _randomIndex;

        if (_remove) then {
            _array deleteAt _randomIndex;
        };
    };
} else {
    _returnElement = _array;
};

call Zen_StackRemove;
(_returnElement)

// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define PICK_ANIM(POSE, EMPTY, RIFLE, HAND) case POSE: { \
            switch (true) do { \
                case ((currentWeapon _giver) == (primaryWeapon _giver)): { \
                    _giveAnim = RIFLE; \
                }; \
                case ((currentWeapon _giver) == (handgunWeapon _giver)): { \
                    _giveAnim = HAND; \
                }; \
                default { \
                    _giveAnim = EMPTY; \
                }; \
            }; \
        };

if (isDedicated || !hasInterface) exitWith {};
_Zen_stack_Trace = ["Zen_GiveMagazine", _this] call Zen_StackAdd;
private ["_giver", "_receiver", "_receiverAcceptedMags", "_magName", "_giverMags", "_giveAnim", "_weapon"];

if !([_this, [["OBJECT"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_giver = _this select 0;

_receiver = objNull;
_giveAnim = "";

{
    if ((_giver != _x) && ((side _x) == (side _giver)) && ([_giver, _x, 120] call Zen_IsFacing)) exitWith {
        _receiver = _x;
    };
} forEach ((getPosATL _giver) nearEntities ["Man", 3]);

if (isNull _receiver) exitWith { // this should never be true, handled by addAction condition
    0 = ["Zen_GiveMagazine", "Action presented for invalid target (dev error)", _this] call Zen_PrintError;
    call Zen_StackPrint;
    call Zen_StackRemove;
};

_weapon = currentWeapon _receiver;
if (_weapon isEqualTo "") then {
    _weapon = primaryWeapon _receiver;
};

_receiverAcceptedMags = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
_giverMags = magazines _giver;

if (count _giverMags == 0) exitWith {
    hint "You have no magazines";
    call Zen_StackRemove;
};

_giverMags = [_giverMags] call Zen_ArrayRemoveDuplicates;

if ([_giverMags, _receiverAcceptedMags] call Zen_ValuesAreNotInArray) exitWith {
    hint format ["You have no magazines that match %1's current weapon", (name _receiver)];
    call Zen_StackRemove;
};

{
    if (_x in _giverMags) exitWith {
        _magName = getText (configFile >> "CfgMagazines" >> _x >> "displayName");
        if (_receiver canAddItemToUniform _x || _receiver canAddItemToVest _x || _receiver canAddItemToBackpack _x) then {

            switch (stance _giver) do {
                PICK_ANIM("STAND", "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon", "AinvPercMstpSrasWrflDnon_Putdown_AmovPercMstpSrasWrflDnon", "AinvPercMstpSrasWpstDnon_Putdown_AmovPercMstpSrasWpstDnon")
                PICK_ANIM("CROUCH", "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon", "AinvPknlMstpSrasWrflDnon_Putdown_AmovPknlMstpSrasWrflDnon", "AinvPknlMstpSrasWpstDnon_Putdown_AmovPknlMstpSrasWpstDnon")
                PICK_ANIM("PRONE", "AinvPpneMstpSnonWnonDnon_Putdown_AmovPpneMstpSnonWnonDnon", "AinvPpneMstpSrasWrflDnon_Putdown_AmovPpneMstpSrasWrflDnon", "AinvPpneMstpSrasWpstDnon_Putdown_AmovPpneMstpSrasWpstDnon")
            };

            _giver playMoveNow _giveAnim;
            _giver removeMagazineGlobal _x;
            _receiver addMagazineGlobal _x;
            hint format ["You have given %1 a %2 magazine", (name _receiver), _magName];

            if (isMultiplayer) then {
                Zen_MP_Closure_Packet = ["Zen_GiveMagazine_ReceiverHint_MP", [_receiver, _giver, _magName]];
                (owner _receiver) publicVariableClient "Zen_MP_Closure_Packet";
            };
        } else {
            hint format ["%1 does not have room in his inventory for a %2 magazine", (name _receiver), _magName];
        };
    };
} forEach _receiverAcceptedMags;

call Zen_StackRemove;
if (true) exitWith {};

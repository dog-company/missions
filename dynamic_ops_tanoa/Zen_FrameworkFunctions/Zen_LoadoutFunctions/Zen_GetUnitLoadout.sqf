// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#define ADD_LOADED_MAG(CMD) \
    _weaponMag = CMD _unit; \
    if (count _weaponMag > 0) then { \
        _magsCargo pushBack [_weaponMag select 0, 1]; \
    };

#define COMPILE_EQUIPMENT(A, C) \
    A = []; \
    _uniques = []; \
    _uniqueCounts = []; \
    { \
        _item = _x; \
        if !(_x in _uniques) then { \
            _uniques pushBack _x; \
            _uniqueCounts pushBack ({_x == _item} count (C _unit)); \
        }; \
    } forEach ((C _unit) - [""]); \
    { \
        if ((_uniqueCounts select _forEachIndex) > 0) then { \
            A pushBack [_x, (_uniqueCounts select _forEachIndex)]; \
        }; \
    } forEach _uniques;

_Zen_stack_Trace = ["Zen_GetUnitLoadout", _this] call Zen_StackAdd;
private ["_weaponMag", "_magsCargo", "_uniques", "_uniqueCounts", "_item", "_unit", "_loadoutData", "_rawWeapons", "_weapons", "_rawBackpacks", "_backpacks", "_rawMags", "_magazines", "_rawItems", "_dummyUnit", "_items", "_assignedItems"];

if !([_this, [["OBJECT"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([])
};

_unit = _this select 0;

if (_unit isKindOf "Man") then {

    COMPILE_EQUIPMENT(_magsCargo, magazines)
    COMPILE_EQUIPMENT(_itemsCargo, items)

    ADD_LOADED_MAG(primaryWeaponMagazine)
    ADD_LOADED_MAG(secondaryWeaponMagazine)
    ADD_LOADED_MAG(handgunMagazine)

    {
        if (["Laserdesignator", _x] call Zen_StringIsInString) exitWith {
            _magsCargo pushBack ["LaserBatteries", 1];
        };
    } forEach (weapons _unit);

    _loadoutData = [
        (if (uniform _unit != "") then {["uniform", uniform _unit]} else {0}),
        (if (vest _unit != "") then {["vest", vest _unit]} else {0}),
        (if (backpack _unit != "") then {["backpack", backpack _unit]} else {0}),
        (if (headgear _unit != "") then {["headgear", headgear _unit]} else {0}),
        (if (goggles _unit != "") then {["goggles", goggles _unit]} else {0}),
        (if (count assignedItems _unit > 0) then {["assignedItems", (assignedItems _unit) - ["Binocular", "Rangefinder", "Laserdesignator"]]} else {0}),
        (if (count weapons _unit > 0) then {["weapons", weapons _unit]} else {0}),
        (if (count _magsCargo > 0) then {["magazines", _magsCargo]} else {0}),
        (if (count items _unit > 0) then {["items", _itemsCargo]} else {0}),
        (if ({_x != ""} count primaryWeaponItems _unit > 0) then {["primaryAttachments", (primaryWeaponItems _unit) - [""]]} else {0}),
        (if ({_x != ""} count secondaryWeaponItems _unit > 0) then {["secondaryAttachments", (secondaryWeaponItems _unit) - [""]]} else {0}),
        (if ({_x != ""} count handgunItems _unit > 0) then {["handgunAttachments", (handgunItems _unit) - [""]]} else {0})
    ];
} else {
    _rawWeapons = getWeaponCargo _unit;
    _weapons = [];
    {
        for "_i" from 1 to ((_rawWeapons select 1) select _forEachIndex) do {
            _weapons pushBack _x;
        };
    } forEach (_rawWeapons select 0);

    _rawBackpacks = getBackpackCargo _unit;
    _backpacks = [];
    {
        for "_i" from 1 to ((_rawBackpacks select 1) select _forEachIndex) do {
            _backpacks pushBack _x;
        };
    } forEach (_rawBackpacks select 0);

    _rawMags = getMagazineCargo _unit;
    _magazines = [];
    {
        _magazines pushBack [_x, ((_rawMags select 1) select _forEachIndex)];
    } forEach (_rawMags select 0);

    _rawItems = getItemCargo _unit;
    _dummyUnit = leader ([[-10, 0, 0], "b_soldier_f"] call Zen_SpawnGroup);

    #define FIND_ITEM(R, A, C, V) \
        R _dummyUnit; \
        { \
            _dummyUnit A _x; \
            if (C _dummyUnit == _x) exitWith { \
                V = _x; \
                (_rawItems select 1) set [_forEachIndex, ((_rawItems select 1) select _forEachIndex) - 1]; \
            }; \
        } forEach (_rawItems select 0);

    _uniform = "";
    _vest = "";
    _headgear = "";
    _goggles = "";
    FIND_ITEM(removeUniform, forceAddUniform, uniform, _uniform)
    FIND_ITEM(removeVest, addVest, vest, _vest)
    FIND_ITEM(removeHeadgear, addHeadgear, headgear, _headgear)
    FIND_ITEM(removeGoggles, addGoggles, goggles, _goggles)

    deleteVehicle _dummyUnit;
    _assignedItems = [];
    {
        if (toUpper _x in ["ITEMMAP","ITEMCOMPASS","ITEMWATCH","ITEMRADIO","ITEMGPS","NVGOGGLES_OPFOR", "NVGOGGLES", "NVGOGGLES_INDEP", "B_UAVterminal", "I_UAVterminal", "O_UAVterminal"]) then {
            _assignedItems pushBack _x;
            (_rawItems select 1) set [_forEachIndex, ((_rawItems select 1) select _forEachIndex) - 1];
        };
    } forEach (_rawItems select 0);

    _items = [];
    {
        if (((_rawItems select 1) select _forEachIndex) > 0) then {
            _items pushBack [_x, ((_rawItems select 1) select _forEachIndex)];
        };
    } forEach (_rawItems select 0);

    _loadoutData = [
        (if (_uniform != "") then {["uniform", _uniform]} else {(0)}),
        (if (_vest != "") then {["vest", _vest]} else {(0)}),
        (if (_headgear != "") then {["headgear", _headgear]} else {(0)}),
        (if (_goggles != "") then {["goggles", _goggles]} else {(0)}),
        ["backpack", _backpacks],
        ["assignedItems", _assignedItems],
        ["weapons", _weapons],
        ["magazines", _magazines],
        // ["primaryAttachments", ],
        // ["secondaryAttachments", ],
        // ["handgunAttachments", ],
        ["items", _items]
    ];
};

0 = [_loadoutData, 0] call Zen_ArrayRemoveValue;
call Zen_StackRemove;
(_loadoutData)

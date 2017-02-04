// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "..\Zen_FrameworkLibrary.sqf"

Zen_Fire_Support_Round_Local = objNull;
Zen_Fire_Support_Target_Pos_Local = [];
Zen_Fire_Support_Array_Global = [];
Zen_Fire_Support_Action_Array_Global = [];
Zen_Fire_Support_Action_Array_Local = [];
Zen_Fire_Support_Action_Dialog_Data = ["", "", ""];

Zen_AddFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_AddFireSupportAction.sqf";
Zen_AddSupportActionCustom = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_AddSupportActionCustom.sqf";
Zen_CreateFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_CreateFireSupport.sqf";
Zen_GetFireSupportActionData = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GetFireSupportActionData.sqf";
Zen_GetFireSupportData = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GetFireSupportData.sqf";
Zen_GetUnitFireSupportActions = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GetUnitFireSupportActions.sqf";
Zen_GuideRound = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_GuideRound.sqf";
Zen_InvokeFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_InvokeFireSupport.sqf";
Zen_InvokeFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_InvokeFireSupportAction.sqf";
Zen_RemoveFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_RemoveFireSupport.sqf";
Zen_RemoveFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_RemoveFireSupportAction.sqf";
Zen_UpdateFireSupport = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_UpdateFireSupport.sqf";
Zen_UpdateFireSupportAction = compileFinal preprocessFileLineNumbers "Zen_FrameworkFunctions\Zen_FireSupportSystem\Zen_UpdateFireSupportAction.sqf";

Zen_AddFireSupportAction_AddLocal_MP = {
    if (isDedicated || !hasInterface) exitWith {};
    private ["_nameString"];

    _nameString = _this select 0;

    Zen_Fire_Support_Action_Array_Local pushBack [_nameString, scriptNull, scriptNull];
    if (true) exitWith {};
};

Zen_AddFireSupportAction_ShowDialog_MP = {
    private ["_listData", "_listTitles", "_textArray"];

    _listData = [];
    _listTitles = [];
    _textArray = [];

    {
        if (player in (_x select 1)) then {
            _listData pushBack (_x select 0);
            _textArray pushBack (_x select 8);

            _indexes = [Zen_Fire_Support_Action_Array_Local, (_x select 0), 0] call Zen_ArrayGetNestedIndex;
            _localData = Zen_Fire_Support_Action_Array_Local select (_indexes select 0);

            if !(isNull (_localData select 1)) then {
                _listTitles pushBack ((_x select 2) + " -- Inbound");
            } else {
                _listTitles pushBack (_x select 2);
            };
        };
    } forEach Zen_Fire_Support_Action_Array_Global;

    0 = [(Zen_Fire_Support_Action_Dialog_Data select 1), ["List", _listTitles], ["ListData", _listData]] call Zen_UpdateControl;
    0 = [(Zen_Fire_Support_Action_Dialog_Data select 2), ["Text", (_textArray select 0)]] call Zen_UpdateControl;
    0 = [(Zen_Fire_Support_Action_Dialog_Data select 0)] spawn Zen_InvokeDialog;
    if (true) exitWith {};
};

Zen_AddFireSupportAction_DialogOK_MP = {
    // player commandChat str _this;
    _nameString = _this select 0;

    _indexes = [Zen_Fire_Support_Action_Array_Global, _nameString, 0] call Zen_ArrayGetNestedIndex;
    if (count _indexes > 0) then {
        _data = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);

        _isCustom = _data select 9;
        if (_isCustom) then {
            if ((_data select 6) == (_data select 7)) exitWith {
                player groupChat "This support has been used the maximum number of times.";
            };

            call Zen_CloseDialog;
            openMap true;
            hintSilent "Hold Left-click on the desired fire support target.";
            Zen_Fire_Support_Target_Pos_Local = [];
            _EHID = "Zen_Fire_Support_Map_EH" + ([10] call Zen_StringGenerateRandom);
            0 = [_EHID, "onMapSingleClick", {Zen_Fire_Support_Target_Pos_Local = _pos;}] call BIS_fnc_AddStackedEventHandler;

            waitUntil {
                ((count Zen_Fire_Support_Target_Pos_Local) > 0)
            };

            _pos =+ Zen_Fire_Support_Target_Pos_Local;
            0 = [_EHID, "onMapSingleClick"] call BIS_fnc_RemoveStackedEventHandler;
            hintSilent "";

            _args = [[_pos, "", objNull, ""], player, _nameString, true, (_data select 10)];
            // ZEN_FMW_MP_REServerOnly("Zen_InvokeFireSupportAction_Fire_MP", _args, spawn)
            0 = _args call Zen_InvokeFireSupportAction_Fire_MP;

            _args = [player, _pos, -1];
            ZEN_FMW_MP_REAll("Zen_InvokeFireSupportAction_SideChat_MP", _args, spawn)

            _marker = [_pos, "Support Target", "colorRed", [0.6, 0.6], "mil_destroy", 45, 0] call Zen_SpawnMarker;
            0 = [_marker, player] call Zen_ShowHideMarkers;

            0 = _marker spawn {
                sleep 60;
                deleteMarker _this;
            };

            _args = [_nameString, player];
            ZEN_FMW_MP_REServerOnly("Zen_InvokeFireSupportAction_CheckCount_Server_MP", _args, call)
        } else {
            if (player in (_data select 1)) then {
                0 = [_nameString] spawn Zen_InvokeFireSupportAction;
            };
        };
    } else {
        player groupChat "That support is invalid.";
    };

    call Zen_CloseDialog;
    if (true) exitWith {};
};

Zen_AddFireSupportAction_DialogCancel_MP = {
    // player commandChat str _this;
    _nameString = _this select 0;

    _indexes = [Zen_Fire_Support_Action_Array_Local, _nameString, 0] call Zen_ArrayGetNestedIndex;
    _dataLocal = Zen_Fire_Support_Action_Array_Local select (_indexes select 0);

    terminate (_dataLocal select 1);
    terminate (_dataLocal select 2);

    _indexes = [Zen_Fire_Support_Action_Array_Global, (_this select 0), 0] call Zen_ArrayGetNestedIndex;
    _dataGlobal = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);

    _maxCount = _dataGlobal select 6;
    _count = (_dataGlobal select 7) - 1;
    _dataGlobal set [7, _count];
    publicVariable "Zen_Fire_Support_Action_Array_Global";

    sleep 0.2;
    call Zen_AddFireSupportAction_DialogRefresh_MP;
    if (true) exitWith {};
};

Zen_AddFireSupportAction_DialogRefresh_MP = {
    private ["_listData", "_listTitles", "_textArray"];

    _listData = [];
    _listTitles = [];
    _textArray = [];

    {
        if (player in (_x select 1)) then {
            _listData pushBack (_x select 0);
            _textArray pushBack (_x select 8);

            _indexes = [Zen_Fire_Support_Action_Array_Local, (_x select 0), 0] call Zen_ArrayGetNestedIndex;
            _localData = Zen_Fire_Support_Action_Array_Local select (_indexes select 0);

            if !(isNull (_localData select 1)) then {
                _listTitles pushBack ((_x select 2) + " -- Inbound");
            } else {
                _listTitles pushBack (_x select 2);
            };
        };
    } forEach Zen_Fire_Support_Action_Array_Global;

    0 = [(Zen_Fire_Support_Action_Dialog_Data select 1), ["List", _listTitles], ["ListData", _listData]] call Zen_UpdateControl;
    0 = [(Zen_Fire_Support_Action_Dialog_Data select 2), ["Text", (if (count _textArray > 0) then {(_textArray select 0)} else {("")})]]call Zen_UpdateControl;
    call Zen_RefreshDialog;
    if (true) exitWith {};
};

Zen_AddFireSupportAction_DialogListSel_MP = {
    // player commandChat str _this;

    _indexes = [Zen_Fire_Support_Action_Array_Global, (_this select 0), 0] call Zen_ArrayGetNestedIndex;
    _data = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);

    0 = [(Zen_Fire_Support_Action_Dialog_Data select 2), ["Text", (_data select 8)]]call Zen_UpdateControl;
    call Zen_RefreshDialog;
    if (true) exitWith {};
};

Zen_InvokeFireSupportAction_CheckCount_Server_MP = {
    if !(isServer) exitWith {};
    private ["_nameString", "_indexes", "_data", "_player"];
    _nameString = _this select 0;
    _player = _this select 1;

    _indexes = [Zen_Fire_Support_Action_Array_Global, (_this select 0), 0] call Zen_ArrayGetNestedIndex;
    _data = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);

    _maxCount = _data select 6;
    _count = (_data select 7) + 1;
    _data set [7, _count];

    _args = [_nameString, _count, _maxCount, (_data select 3), (_data select 9)];
    ZEN_FMW_MP_REClient("Zen_InvokeFireSupportAction_Remove_MP", _args, call, _player)
    publicVariable "Zen_Fire_Support_Action_Array_Global";
    if (true) exitWith {};
};

Zen_InvokeFireSupportAction_Remove_MP = {
    private ["_nameString", "_count", "_maxCount", "_h_remove", "_indexes", "_data", "_isCustom", "_templateName"];
    _nameString = _this select 0;
    _count = _this select 1;
    _maxCount = _this select 2;
    _templateName = _this select 3;
    _isCustom = _this select 4;

    _h_remove = [_nameString, _count, _maxCount, _templateName, _isCustom] spawn {
        _nameString = _this select 0;
        _count = _this select 1;
        _maxCount = _this select 2;
        _templateName = _this select 3;
        _isCustom = _this select 4;

        if (_isCustom) then {
            sleep 11;
        } else {
            _templateData = [_templateName] call Zen_GetFireSupportData;
            sleep (2*((_templateData select 5) select 0));
        };

        if ((_count >= _maxCount) && {_maxCount != -1}) then {
            0 = [_nameString] call Zen_RemoveFireSupportAction;
        };
    };

    _indexes = [Zen_Fire_Support_Action_Array_Local, _nameString, 0] call Zen_ArrayGetNestedIndex;
    _data = Zen_Fire_Support_Action_Array_Local select (_indexes select 0);
    _data set [2, _h_remove];
    if (true) exitWith {};
};

Zen_InvokeFireSupportAction_Fire_MP = {
    private ["_h_support"];
    _pos = (_this select 0) select 0;
    _supportTemplate = (_this select 0) select 1;
    _guideObj = (_this select 0) select 2;
    _nameString = _this select 2;
    _isCustom = _this select 3;
    _customArgs = _this select 4;

    _h_support = scriptNull;
    if (_isCustom) then {
        _indexes = [Zen_Fire_Support_Action_Array_Global, _nameString, 0] call Zen_ArrayGetNestedIndex;
        _data = Zen_Fire_Support_Action_Array_Global select (_indexes select 0);
        _function = _data select 3;

        _h_support = [_nameString, _pos, player, _customArgs] spawn (missionNamespace getVariable _function);
    } else {
        _h_support = (_this select 0) spawn Zen_InvokeFireSupport;
    };

    // _threadID = "Zen_FireSupportAction_ID_" + ([5] call Zen_StringGenerateRandom);
    // missionNamespace setVariable [_threadID, _h_support];

    _indexes = [Zen_Fire_Support_Action_Array_Local, _nameString, 0] call Zen_ArrayGetNestedIndex;
    _data = Zen_Fire_Support_Action_Array_Local select (_indexes select 0);
    _data set [1, _h_support];

    // _callingUnit = _this select 1;
    // _args = [_threadID, _guideObj, _supportTemplate];
    // ZEN_FMW_MP_REClient("Zen_InvokeFireSupportAction_AddCancelAction_MP", _args, spawn, _callingUnit)
    if (true) exitWith {};
};

Zen_InvokeFireSupportAction_SideChat_MP = {
    if (isDedicated || !hasInterface) exitWith {};
    private ["_unit", "_side", "_group", "_pos", "_sentTime"];

    _unit = _this select 0;
    _pos = _this select 1;
    _sentTime = _this select 2;

    _side = side _unit;

    if (side player != _side) exitWith {};

    _group = toArray str group _unit;
    _group = toString ([_group, 2] call Zen_ArrayGetIndexedSlice);

    _unit sideChat format ["HQ, %1, Request support at grid %2, over.", _group, (mapGridPosition _pos)];
    sleep 7;
    if (_sentTime < 0) then {
        [_side, "base"] sideChat format ["%1, HQ, Support inbound, out.", _group];
    } else {
        [_side, "base"] sideChat format ["%1, HQ, Support inbound in %2 seconds, out.", _group, _sentTime];
    };

    if (true) exitWith {};
};

if (true) exitWith {};

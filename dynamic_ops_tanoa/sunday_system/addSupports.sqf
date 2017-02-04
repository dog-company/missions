_airStartPos = _this select 0;

// Define supports
centerSide = createCenter sideLogic;
_logicGroupRequester = createGroup centerSide;
requester = _logicGroupRequester createUnit ["SupportRequester",getpos player, [], 0, "FORM"];
//Setup requestor limit values
{
	[requester, _x, 0] call BIS_fnc_limitSupport;
} forEach [
	"Artillery",
	"CAS_Heli",
	"CAS_Bombing",
	"UAV",
	"Drop",
	"Transport"
];

// Check whether supports are random or custom
_dropChance = random 100;
_artyChance = random 100;
_casChance = random 100;
if (randomSupports == 1) then {
	if ((customSupports select 0) == 0) then {
		_dropChance = 0;
	} else {
		diag_log "DRO: Custom support selected: Supply drop";
		_dropChance = 100;
	};
	if ((customSupports select 1) == 0) then {
		_artyChance = 0;
	} else {
		diag_log "DRO: Custom support selected: Artillery";
		_artyChance = 100;
	};
	if ((customSupports select 2) == 0) then {
		_casChance = 0;
	} else {
		diag_log "DRO: Custom support selected: CAS";
		_casChance = 100;
	};
};

// Supply drop
if (_dropChance > 60) then {
	providerDrop = nil;
	if (count pHeliClasses > 0) then {
		_logicGroupDrop = createGroup centerSide;
		diag_log requester;
		diag_log _logicGroupDrop;
		_suppPos = [getPos trgAOC,3000,4000,0,1,1,0] call BIS_fnc_findSafePos;	
		diag_log _suppPos;		
		providerDrop = _logicGroupDrop createUnit ["SupportProvider_Virtual_Drop", _suppPos, [], 0, "FORM"];
		diag_log providerDrop;				
		//Setup provider values
		{
			providerDrop setVariable [(_x select 0),(_x select 1)];
		} forEach [
			["BIS_SUPP_crateInit",
				"
					clearWeaponCargoGlobal _this;
					clearMagazineCargoGlobal _this;
					clearItemCargoGlobal _this;
					_this addMagazineCargoGlobal ['SatchelCharge_Remote_Mag', 2];
					_this addMagazineCargoGlobal ['DemoCharge_Remote_Mag', 4];
					_this addItemCargoGlobal ['Medikit', 1];
					_this addItemCargoGlobal ['FirstAidKit', 10];
					{
						_magazines = magazinesAmmoFull _x;
						{
							_this addMagazineCargoGlobal [(_x select 0), 2];
						} forEach _magazines;
					} forEach units group player; 
				"],		
			["BIS_SUPP_vehicles",[(selectRandom pHeliClasses)]],		
			["BIS_SUPP_vehicleinit",""],	
			["BIS_SUPP_filter","FACTION"]		
		];
		
		[requester, "Drop", 1] call BIS_fnc_limitSupport;
	
		{	
			[_x, requester, providerDrop] call BIS_fnc_addSupportLink;
		} forEach (units group player);		
	};
};

// Artillery
if (_artyChance > 60) then {
	providerArty = nil;
	_artyList = pMortarClasses + pArtyClasses;
	diag_log _artyList;
	if (count _artyList > 0) then {
		_artyClass = (selectRandom _artyList);
		_logicGroupArty = createGroup centerSide;
		_mkrPos = getMarkerPos "campMkr";
		_artyLocation = _mkrPos findEmptyPosition [10, 50, _artyClass];
		if (count _artyLocation == 0) then {
			_newPos = [_mkrPos, 0, 2000, 5, 0, 0.2, 0, [trgAOC], [[0,0,0],[0,0,0]]] call BIS_fnc_findSafePos;
			if (!(_newPos isEqualTo [0,0,0])) then {
				_artyLocation = _newPos findEmptyPosition [10, 50, _artyClass];
			};
		};
		if (count _artyLocation > 0) then {
			
			providerArty = _logicGroupArty createUnit ["SupportProvider_Artillery", _artyLocation, [], 0, "FORM"];
			_artyVeh = [_artyLocation, _artyClass, 0, ([_mkrPos, trgAOC] call BIS_fnc_dirTo), true] call Zen_SpawnVehicle;
			createVehicleCrew _artyVeh;
	
			[requester, "Artillery", -1] call BIS_fnc_limitSupport;
			providerArty synchronizeObjectsAdd [_artyVeh];
			{	
				[_x, requester, providerArty] call BIS_fnc_addSupportLink;
			} forEach (units group player);					
		};
	};
};

// CAS
if (_casChance > 60) then {
	if (count pHeliClasses > 0 || count pPlaneClasses > 0) then {
		_casClasses = pHeliClasses + pPlaneClasses;
		_availableCASClasses = [];
		_availableCASClassesHeli = [];
		_availableCASClassesBomb = [];
		{
			_availableSupportTypes = (configfile >> "CfgVehicles" >> _x >> "availableForSupportTypes") call BIS_fnc_GetCfgData;	
			if ("CAS_Bombing" in _availableSupportTypes) then {
				_availableCASClassesBomb pushBack _x;
				_availableCASClasses pushBack _x;
			};
			if ("CAS_Heli" in _availableSupportTypes) then {
				_availableCASClassesHeli pushBack _x;
				_availableCASClasses pushBack _x;
			};
		} forEach _casClasses;
		
		if (count _availableCASClasses > 0) then {
		
			// Choose a random CAS type based on vehicles available
			_casType = "";
			_limitType = "";
			if ((count _availableCASClassesHeli > 0) && (count _availableCASClassesBomb > 0)) then {			
				_casTypeChance = [0,1] call BIS_fnc_randomInt;
				if (_casTypeChance == 0) then {
					_casType = "SupportProvider_Virtual_CAS_Heli";
					_availableCASClasses = _availableCASClassesHeli;
					_limitType = "CAS_Heli";
				} else {
					_casType = "SupportProvider_Virtual_CAS_Bombing";
					_availableCASClasses = _availableCASClassesBomb;
					_limitType = "CAS_Bombing";
				};
			} else {
				if (count _availableCASClassesHeli > 0) then {
					_casType = "SupportProvider_Virtual_CAS_Heli";
					_availableCASClasses = _availableCASClassesHeli;
					_limitType = "CAS_Heli";
				} else {
					_casType = "SupportProvider_Virtual_CAS_Bombing";
					_availableCASClasses = _availableCASClassesBomb;
					_limitType = "CAS_Bombing";
				};
			};
			
			_logicGroupCAS = createGroup centerSide;
			diag_log requester;
			diag_log _logicGroupCAS;
			_suppPos = [getPos trgAOC,3000,4000,0,1,1,0] call BIS_fnc_findSafePos;	
			diag_log _suppPos;		
			providerCAS = _logicGroupCAS createUnit [_casType, _suppPos, [], 0, "FORM"];
			diag_log providerCAS;				
			//Setup provider values
			{
				providerCAS setVariable [(_x select 0),(_x select 1)];
			} forEach [						
				["BIS_SUPP_vehicles",[(selectRandom _availableCASClasses)]],		
				["BIS_SUPP_vehicleinit",""],	
				["BIS_SUPP_filter","FACTION"]		
			];
			
			[requester, _limitType, 1] call BIS_fnc_limitSupport;
		
			{	
				[_x, requester, providerCAS] call BIS_fnc_addSupportLink;
			} forEach (units group player);		
		};		
	};
};


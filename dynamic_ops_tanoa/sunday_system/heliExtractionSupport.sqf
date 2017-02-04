_heliTransports = _this select 0;
diag_log format ["_heliTransports = %1", _heliTransports];
	
if (count _heliTransports > 0) then {
	diag_log format ["provider pos = %1",getPos trgAOC];
	diag_log format ["requester = %1", requester];
	_providerPos = [getPos trgAOC,3000,4000,0,1,1,0] call BIS_fnc_findSafePos;
	_logicGroup = createGroup centerSide;
	providerTransport = _logicGroup createUnit ["SupportProvider_Virtual_Transport", _providerPos, [], 0, "FORM"];
	diag_log format ["providerTransport = %1", providerTransport];
	//Setup provider values	
	{
		providerTransport setVariable [(_x select 0),(_x select 1)];
	} forEach [				
		["BIS_SUPP_vehicles",[(selectRandom _heliTransports)]],		
		["BIS_SUPP_vehicleinit","diag_log _this; _this setCaptive true"],	
		["BIS_SUPP_filter","FACTION"]		
	];	
	
	[requester, "Transport", 1] call BIS_fnc_limitSupport;
	
	[player, requester, providerTransport] call BIS_fnc_addSupportLink;
};
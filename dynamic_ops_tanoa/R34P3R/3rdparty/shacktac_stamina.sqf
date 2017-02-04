//
// ShackTac Stamina Bar 
// http://dslyecxi.com/shacktac_wp/shacktac-mods/shacktac-stamina-bar/
//

fn_st_stamina_bar_launch = {

	if (isNil "st_stamina_bar_visualizer_enabled") then {st_stamina_bar_visualizer_enabled = true;};
	
	waitUntil {!isNull player};
	waitUntil {player == player};
	
	sleep 2;
	
	disableSerialization; 
	
	57705 cutRsc ["st_stamina_bar_visualizer", "PLAIN"];
	
	_loadBar = (st_stamina_bar_visualizer select 0) displayCtrl 2201;
	_loadBarBackground = (st_stamina_bar_visualizer select 0) displayCtrl 2200;
	
	_loadBar ctrlSetFade 1;
	_loadBarBackground ctrlSetFade 1;
	
	_fatigueBarBackground = (st_stamina_bar_visualizer select 0) displayCtrl 2202;
	_fatigueBar = (st_stamina_bar_visualizer select 0) displayCtrl 2203;

	waitUntil {	
		if((alive player) && {(!visibleMap)} && {(vehicle player == player OR ((player != driver vehicle player) && (player != gunner vehicle player) && (player != commander vehicle player)))} && {(positionCameraToWorld [0,0,0] distance player) < 5}) then {
			if((ctrlFade ((st_stamina_bar_visualizer select 0) displayCtrl 2202)) > 0) then {
				{
					((st_stamina_bar_visualizer select 0) displayCtrl _x) ctrlSetFade 0;
					((st_stamina_bar_visualizer select 0) displayCtrl _x) ctrlCommit 0;
				} forEach [2202,2203]; //,2200,2201];
			};

			_barMaxWidth = .17; 
			_barMaxHeight = 0.0042; 
			_uiSize = getResolution select 5;
			
			_posX = 0.823 * safezoneW + safezoneX;
			_posY = (0.095 - _barMaxHeight) * safezoneH + safezoneY;
			
			if(_uiSize > 0.55) then {
				_posX = 0.780 * safezoneW + safezoneX;
				_posY = (0.115 - _barMaxHeight) * safezoneH + safezoneY;
			} else {
				_posX = 0.823 * safezoneW + safezoneX;
				_posY = (0.095 - _barMaxHeight) * safezoneH + safezoneY;			
			};
			
			_fatigueWidth = linearConversion [0,1,getFatigue player,0,_barMaxWidth,true];
			
			_fatigueBarBackground ctrlSetBackgroundColor [0,0,0,0.3 min 0.8 * ((getFatigue player) + 0.1)];
			_fatigueBarBackground ctrlSetPosition [_posX, _posY, _barMaxWidth * safezoneW, _barMaxHeight * safezoneH];
			_fatigueBarBackground ctrlCommit 0;
		
			_staminaGreen = linearConversion [0,1,getFatigue player,.6,0,true]; 
			_staminaAlpha = linearConversion [0,1,getFatigue player,.5,1,true];
			_color = [getFatigue player,_staminaGreen,0,_staminaAlpha]; 

			_fatigueBar ctrlSetBackgroundColor _color;
			_fatigueBar ctrlSetPosition [_posX, _posY, _fatigueWidth * safezoneW,_barMaxHeight * safezoneH];
			_fatigueBar ctrlCommit 0;
		} else {
			if((ctrlFade ((st_stamina_bar_visualizer select 0) displayCtrl 2202)) == 0) then {
				{
					((st_stamina_bar_visualizer select 0) displayCtrl _x) ctrlSetFade 1;
					((st_stamina_bar_visualizer select 0) displayCtrl _x) ctrlCommit 0;
				} forEach [2202,2203]; //,2200,2201];
			};
		};
		
		!st_stamina_bar_visualizer_enabled OR !r3_showStaminaBar
	};
	
	57705 cutText ["", "PLAIN"];
};

[] spawn fn_st_stamina_bar_launch;

addMissionEventHandler ["loaded",{[] spawn fn_st_stamina_bar_launch}]; // Compatibility for SP/reload
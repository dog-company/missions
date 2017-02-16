
//	@file Version: v1.0
//	@mission name: .ogg video & UAV intro
//	@file Author: [WD]Elvis
//	@file edit: 03.13.2013
//	@file Description: Refined introduction execution line for the video - UAV mission introduction
//	@usage: Reference description.ext
	 
 

		[] spawn {
			scriptName "initMission.hpp: mission start";
			["rsc\ARMA_3.ogv", false] spawn BIS_fnc_titlecard;	
			waitUntil {!(isNil "BIS_fnc_titlecard_finished")};
			[[2879.289,5618.516,0],"Alpha and Bravo have been engaged by hostile forces, provide backup"] spawn BIS_fnc_establishingShot;	
			//OR , The above is a bit more user friendly and easier to control.
			//[getPos orbit1,"Alpha and Bravo have been engaged by hostile forces, provide backup",300,200,180,0,[]] spawn BIS_fnc_establishingShot;   
		};
	


                                 
                                                  
                                                  
                                                     
        

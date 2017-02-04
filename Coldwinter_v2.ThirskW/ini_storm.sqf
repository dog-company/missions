// by ALIAS
// SNOW STORM SCRIPT DEMO- For vanilla terrains
// Tutorial: https://www.youtube.com/user/aliascartoons

/*
================================================================================================================================
>>>>> SNOW STORM Parameters =======================
================================================================================================================================

null = [direction_storm,duration_storm,effect_on_objects,ambient_sounds_al] execvm "AL_snowstorm\al_snow.sqf";

direction_storm		- integer, from 0 to 360, direction towards the wind blows expressed in compass degrees
duration_storm		- integer, life time of the SNOW STORM expressed in seconds
effect_on_objects	- boolean, if is true occasionally a random object will be thrown in the air
ambient_sounds_al	- seconds/number, a random number will be generated based on your input value and used to set the frequency for played ambient sounds
					- also determines interval at which snow gusts are generated
					- i recommend a value of 120 or higher
*/

>>>>>>>>>> EXAMPLE

null = [80,240,false,40] execvm "AL_snowstorm\al_snow.sqf";
// off: 0 = [0.95] execVM "lights.sqf";
// on: 0 = [0] execVM "lights.sqf";

_types = ["Lamps_Base_F", "PowerLines_base_F", "Land_PowerPoleWooden_F", "Land_LampHarbour_F", "Land_LampShabby_F", "Land_PowerPoleWooden_L_F", "Land_PowerPoleWooden_small_F", "Land_LampDecor_F", "Land_LampHalogen_F", "Land_LampSolar_F", "Land_LampStreet_small_F", "Land_LampStreet_F", "Land_LampAirport_F", "Land_PowerPoleWooden_L_F"];
_onoff = _this select 0;

for [{_i=0},{_i < (count _types)},{_i=_i+1}] do
{
   // powercoverage is a marker I placed.
_lamps = getMarkerPos "LIGHTSOURCE" nearObjects [_types select _i, 500];
sleep 0.1;
{_x setDamage _onoff; sleep 0.1} forEach _lamps;
};

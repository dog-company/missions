 // off: 0 = [0.95] execVM "lights.sqf";
// on: 0 = [0] execVM "lights.sqf";

_types = ["Lamps_Base_F", "PowerLines_base_F","Land_PowerPoleWooden_L_F"];
_onoff = _this select 0;

for [{_i=0},{_i < (count _types)},{_i=_i+1}] do
{
    // powercoverage is a marker I placed.
_lamps = getMarkerPos "LIGHTSOURCE" nearObjects [_types select _i, 500];
sleep 1;
{_x setDamage _onoff} forEach _lamps;
};

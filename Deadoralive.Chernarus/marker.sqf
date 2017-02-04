private ["_markerPos", "_inner_marker", "_helper_marker"];

trackingPrecision = 150; //marker precision (radius)

gpsSleepTimeMin = 120;
gpsSleepTimeMax = 240;

_markerPos = (getPos _this);

_inner_marker = createMarker ["agentmarker", _markerPos];
_inner_marker setMarkerType "mil_unknown";
_inner_marker setMarkerColor "ColorRed";
_inner_marker setMarkerShape "ELLIPSE";
_inner_marker setMarkerSize [trackingPrecision, trackingPrecision];
_inner_marker setMarkerBrush "DIAGGRID";

_helper_marker = createMarker ["agentmarker2", _markerPos];
_helper_marker setMarkerType "mil_unknown";
_helper_marker setMarkerColor "ColorRed";
_helper_marker setMarkerShape "ELLIPSE";
_helper_marker setMarkerSize [500, 500];
_helper_marker setMarkerBrush "Border";

gps_sleep_time = {
    gpsSleepTimeMin + floor(random(gpsSleepTimeMax - gpsSleepTimeMin))
};

randomize_coord = {    
    _this + random(trackingPrecision * 2) - trackingPrecision
};

randomize_pos =
{
    private ["_randomizedPos", "_trueX", "_trueY"];
    
    _trueX = _this select 0;
    _trueY = _this select 1;
    
    _randomizedPos = [
        _trueX call randomize_coord,
        _trueY call randomize_coord,
        _this select 2
    ];
	
	_randomizedPos
};

while {alive _this} do {
    _markerPos = (getPos _this) call randomize_pos;
    _inner_marker setMarkerPos _markerPos;
    _helper_marker setMarkerPos _markerPos;
    
    sleep (call gps_sleep_time);
};

_inner_marker setMarkerColor "ColorBlack";
_inner_marker setMarkerPos (getPos _this);
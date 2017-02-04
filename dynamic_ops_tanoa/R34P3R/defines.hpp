// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_GROUP_BOX       96
#define ST_GROUP_BOX2      112
#define ST_ROUNDED_CORNER  ST_GROUP_BOX + ST_CENTER
#define ST_ROUNDED_CORNER2 ST_GROUP_BOX2 + ST_CENTER

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4


////////////////
//Base Classes//
////////////////


class RscText
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_LEFT;
    linespacing = 0;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    shadow = 1;
    font = "PuristaMedium";
    SizeEx = 0.02300;
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0;
    w = 0;
};

class RscCombo 
{
	style = 16;
	type = 4;
	x = 0;
	y = 0;
	w = 0.12;
	h = 0.035;
	shadow = 0;
	colorSelect[] = {0.98,0.65,0,1};
	colorText[] = {0.85,0.47,0,1};
	colorBackground[] = {0.12,0.12,0.12,1};
	colorSelectBackground[] = {0.24,0.24,0.24,0.6};
	colorScrollBar[] = {1,0,0,1};
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa";
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa";
	wholeHeight = 0.45;
	color[] = {1,1,1,1};
	colorActive[] = {1,0,0,1};
	colorDisabled[] = {1,1,1,0.25};
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
	class ComboScrollBar
	{
		color[] = {1,1,1,0.6};
		colorActive[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,0.3};
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
	};
	soundSelect[] = { "", 0, 1 };
	soundExpand[] = { "", 0, 1 };
	soundCollapse[] = { "", 0, 1 };
	maxHistoryDelay = 0;
};

class RscPicture
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_PICTURE;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    font = "PuristaLight";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
};

class RscBlackBack
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_BACKGROUND;
    colorBackground[] = {0,0,0,0.7};
    colorText[] = {0,0,0,0.9};
    font = "PuristaLight";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
    x = 0;
    y = 0;
    w = 0.2;
    h = 0.15;
};

class BombButton
{
    access = 0;
    type = CT_BUTTON;
    text = "";
	colorText[] = {0.2,0.98,0,1};
	colorBackground[] = {0,0.01,0.12,0.6};
	colorActive[] = {0,0.01,0.04,0.6};
    colorDisabled[] = {0,0.01,0.12,0.6};
    colorBackgroundDisabled[] = {0,0.0,0};
    colorBackgroundActive[] = {0,0.01,0.04,0.6};
    colorFocused[] = {0,0.01,0.04,0.7};
    colorShadow[] = {0,0,0,0.4};
    colorBorder[] = {0.2,0.98,0,0.8};
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.08,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.08,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.07,1};
    style = 2;
    x = 0;
    y = 0;
    w = 0.04;
    h = 0.04;
    shadow = 0;
    font = "PuristaMedium";
    sizeEx = 0.03;
    offsetX = 0.000;
    offsetY = 0.000;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
};

class KeyPadButton
{
    access = 0;
    type = CT_BUTTON;
    text = "";
	colorText[] = {0,0,0,1};
	colorBackground[] = {0,0,0,0};
	colorActive[] = {0,0,0,0.1};
    colorDisabled[] = {0,0,0,0};
    colorBackgroundDisabled[] = {0,0.0,0};
    colorBackgroundActive[] = {0,0,0,0};
    colorFocused[] = {0,0,0,0.1};
    colorShadow[] = {0,0,0,0};
    colorBorder[] = {0,0,0,0.1};
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.08,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.08,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.07,1};
    style = 2;
    x = 0;
    y = 0;
    w = 0.05;
    h = 0.05;
    shadow = 0;
    font = "PuristaBold";
    sizeEx = 0.04;
    offsetX = 0.000;
    offsetY = 0.000;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
};

class RscButton
{ 
    access = 0;
    type = CT_BUTTON;
	style = 2;
    text = "";
	
	colorText[] = {0.92,0.42,0,1};
	colorActive[] = {0.99,0.6,0,1};
    colorDisabled[] = {0.17,0.17,0.17,1};
	colorBackground[] = {0.15,0.15,0.15,1};
    colorBackgroundDisabled[] = {0,0,0,1};
    colorBackgroundActive[] = {0,0.07,0.1,1};
    colorFocused[] = {0.07,0.07,0.07,1};
    colorShadow[] = {0,0,0,1};
    colorBorder[] = {0.68,0.84,0.97,1};
	
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.08,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.08,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.07,1};
    
    x = 0;
    y = 0;
    w = 0.055589;
    h = 0.039216;
    shadow = 1;
    font = "PuristaMedium";
    sizeEx = 0.035;
    offsetX = 0.003;
    offsetY = 0.003;
    offsetPressedX = 0.002;
    offsetPressedY = 0.002;
    borderSize = 0;
};

class RscShortcutButton
{
	type = 16;
	style = ST_CENTER;
	
	class HitZone {
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	};
	class ShortcutPos {
		left = 0;
		top = 0;
		w = 0;
		h = 0;
	};
	class TextPos {
		left = 0;
		top = 0;
		right = 0;
		bottom = 0;
	};
	borderSize = 0;
	animTextureNormal = "R34P3R\img\bt_n.jpg";
	animTextureDisabled = "R34P3R\img\bt_d.jpg";
	animTextureOver = "R34P3R\img\bt_h.jpg";
	animTextureFocused = "R34P3R\img\bt_n.jpg";
	animTexturePressed = "R34P3R\img\bt_p.jpg";
	animTextureDefault = "R34P3R\img\bt_n.jpg";
	period = 0;
	periodFocus = 0;
	periodOver = 0;
	shortcuts[] = {};
	textureNoShortcut = "R34P3R\img\bt_n.jpg";
	color[] = {0,0,0,1};
	color2[] = {0,0,0,1};
	colorDisabled[] = {0,0,0,0.3};
	colorFocused[] = {0,0,0,1};
	colorBackground[] = {1,1,1,1};
	colorBackground2[] = {1,1,1,1};
	colorBackgroundFocused[] = {1,1,1,1};

    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.5,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.5,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.5,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.5,1};
	
	text = "";
	size = 0.032;
	shadow = 0;
	font = "puristaMedium";
	
	class Attributes {
		font = "puristaMedium";
		align = "center";
		shadow = 0;
		shadowColor = "#ffffff";
	};
};

class RscFrame
{
    type = CT_STATIC;
    idc = -1;
    style = ST_FRAME;
    shadow = 2;
    colorBackground[] = {1,1,1,1};
    colorText[] = {1,1,1,0.9};
    font = "PuristaLight";
    sizeEx = 0.032;
    text = "";
};

class IGUIBack
{
	type = 0;
	idc = -1;
	style = 128;
	text = "";
	colorText[] = {0,0,0,0};
	font = "PuristaMedium";
	sizeEx = 0;
	shadow = 0;
	x = 0.1;
	y = 0.1;
	w = 0.1;
	h = 0.1;
	colorbackground[] = {0,0,0,0};
};

class Box
{
    type = CT_STATIC;
    idc = -1;
    style = ST_CENTER;
    shadow = 2;
    colorBackground[] = { 0.2,0.9,0.5, 0.9};
    colorText[] = {1,1,1,0.9};
    font = "PuristaLight";
    sizeEx = 0.03;
    text = "";
};

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



class sundayHeading : RscText
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_CENTER;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    shadow = 0;
    font = "EtelkaNarrowMediumPro";
    SizeEx = 0.05;
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0;
    w = 0;
   
};

class sundayText : RscText
{
    access = 0;
    idc = -1;
    type = CT_STATIC;
    style = ST_LEFT;
    linespacing = 1;
    colorBackground[] = {0,0,0,0};
    colorText[] = {1,1,1,1};
    text = "";
    shadow = 0;
    font = "RobotoCondensed";
    SizeEx = 0.03;
    fixedWidth = 0;
    x = 0;
    y = 0;
    h = 0;
    w = 0;
   
};

class DROCombo {
	idc = -1;
	access = 0;
	type = CT_COMBO;
	style = ST_LEFT;
	w = 0.1 * safezoneW;
	h = 0.025 * safezoneH;
	sizeEx = 0.033;
	rowHeight = 0.03;
	wholeHeight = 4 * 0.10;
	
	colorSelect[] = {0,0,0,1};
	colorText[] = {1,1,1,1};
	colorDisabled[] = {1,1,1,0.5}; // Disabled text color
	colorBackground[] = {0.1,0.1,0.1,1};
	colorSelectBackground[] = {0.20,0.40,0.65,1}; // Selected item fill color
	colorScrollbar[] = {1,1,1,1};
	font = "RobotoCondensed";
	
	soundSelect[] = {"",0.1,1};
	soundExpand[] = {"",0.1,1};
	soundCollapse[] = {"",0.1,1};
	maxHistoryDelay = 1.0;
	shadow = 0;
	
	arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_ca.paa"; // Expand arrow
	arrowFull = "\A3\ui_f\data\GUI\RscCommon\rsccombo\arrow_combo_active_ca.paa"; // Collapse arrow
	
	class ComboScrollBar
	{
		width = 0.05; // width of ComboScrollBar
		height = 0; // height of ComboScrollBar
		scrollSpeed = 0.01; // scrollSpeed of ComboScrollBar

		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa"; // Arrow
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa"; // Arrow when clicked on
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa"; // Slider background (stretched vertically)
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa"; // Dragging element (stretched vertically)

		color[] = {1,1,1,1}; // Scrollbar color
	};
	
};


class DROToolBoxMenu {
    idc = -1;
    type = CT_TOOLBOX;
    style = ST_CENTER;
	
	w = 0.10 * safezoneW;
	h = 0.025 * safezoneH;
    
	font = "RobotoCondensed";
	
	colorBackground[] = {0.1, 0.1, 0.1, 1};
    colorText[] = {1, 1, 1, 1};
    color[] = {0, 1, 0, 1};
    colorTextSelect[] = {0, 0, 0, 1};
    colorSelect[] = {1, 1, 1, 1};
	colorSelectedBg[] = {0.20,0.40,0.65,1};
    colorTextDisable[] = {0.4, 0.4, 0.4, 1};
    colorDisable[] = {0.4, 0.4, 0.4, 1};
 
	sizeEx = 0.025;	
    
    rows = 1;
    columns = 1;
    strings[] = {};
	
	
		
};

class DROCheckBoxRemove {
    idc = -1;
    type = CT_CHECKBOXES;
    style = ST_CENTER;
    
    x = 0.1;
    y = 0.18;
	w = 0.028 * safezoneW;
	h = 0.026 * safezoneH;
    
	font = "RobotoCondensed";
	
	colorBackground[] = {0.2, 0.2, 0.2, 1};
    colorText[] = {0.8, 0, 0, 1};
    color[] = {0, 1, 0, 1};
    colorTextSelect[] = {0.1, 0.8, 0, 1};
    colorSelect[] = {0, 0, 0, 1};
	colorSelectedBg[] = {0.1, 0.1, 0.1, 1};
    colorTextDisable[] = {0.4, 0.4, 0.4, 1};
    colorDisable[] = {0.4, 0.4, 0.4, 1};
 
	sizeEx = 0.025;	
    
    rows = 1;
    columns = 1;
    strings[] = {"X"};
		
};

class DROCheckBoxSupports {
    idc = -1;
    type = CT_CHECKBOXES;
    style = ST_CENTER;
    
    x = 0.1;
    y = 0.18;
	w = 0.1 * safezoneW;
	h = 0.09 * safezoneH;
    
	font = "RobotoCondensed";
	
	colorBackground[] = {0.17,0.17,0.17,1};
    colorText[] = {1, 1, 1, 1};
    color[] = {0, 1, 0, 1};
    colorTextSelect[] = {0.20,0.40,0.65,1};
    colorSelect[] = {1, 1, 1, 1};
	colorSelectedBg[] = {0.17,0.17,0.17,1};
    colorTextDisable[] = {0.4, 0.4, 0.4, 1};
    colorDisable[] = {0.4, 0.4, 0.4, 1};
 
	sizeEx = 0.025;	
    
    rows = 3;
    columns = 1;
    strings[] = {"Supply drop", "Artillery", "CAS"};		
};


class DROBigButton {
	access = 0;
    type = CT_BUTTON;
	style = 2;
    text = "";
	
	colorText[] = {1,1,1,1};
	colorActive[] = {1,1,1,1};
    colorDisabled[] = {0.17,0.17,0.17,1};
	colorBackground[] = {0.17,0.17,0.17,1};
    colorBackgroundDisabled[] = {0,0,0,1};
    colorBackgroundActive[] = {0.20,0.40,0.65,1};
    colorFocused[] = {0.07,0.07,0.07,1};
    colorShadow[] = {0,0,0,1};
    colorBorder[] = {0,0,0,1};
	
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.08,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.08,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.07,1};
    
	onMouseEnter = "(_this select 0) ctrlsettextcolor [0,0,0,1];";
	onMouseExit = "(_this select 0) ctrlsettextcolor [1,1,1,1];";
	
    x = 0;
    y = 0;
    w = 0.055589;
    h = 0.039216;
    shadow = 0;
    font = "RobotoCondensed";
    sizeEx = 0.04;
    offsetX = 0.00;
    offsetY = 0.00;
    offsetPressedX = 0.00;
    offsetPressedY = 0.00;
    borderSize = 0;
		
};

class DROBasicButton {
	access = 0;
    type = CT_BUTTON;
	style = 2;
    text = "";
	
	colorBackground[] = {0.17,0.17,0.17,1};
	//colorActive[] = {0,0,0,1};
	colorBackgroundActive[] = {0.20,0.40,0.65,1};
	colorBackgroundDisabled[] = {0.17,0.17,0.17,1};
	colorBorder[] = {0,0,0,1};
	colorDisabled[] = {1,1,1,0.25};
	colorFocused[] = {0,0,0,1};
	colorShadow[] = {0,0,0,0};
	colorText[] = {1,1,1,1};
	
	//onKillFocus = "(_this select 0) ctrlsettextcolor [1,1,1,1];";
	onMouseEnter = "(_this select 0) ctrlsettextcolor [0,0,0,1];";
	onMouseExit = "(_this select 0) ctrlsettextcolor [1,1,1,1];";
	//onSetFocus = "(_this select 0) ctrlsettextcolor [0,0,0,1];";
	
    soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.08,1};
    soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.08,0};
    soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1};
    soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.07,1};
    
    x = 0;
    y = 0;
    w = 0.055589;
    h = 0.039216;
    shadow = 0;
    font = "RobotoCondensed";
	sizeEx = "(((((safezoneW / safezoneH) min 2) / 2) / 25) * 1)";
    offsetX = 0.00;
    offsetY = 0.00;
    offsetPressedX = 0.00;
    offsetPressedY = 0.00;
    borderSize = 0;
		
};




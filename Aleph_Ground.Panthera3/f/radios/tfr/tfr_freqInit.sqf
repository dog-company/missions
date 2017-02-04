// F3 - Set Group Radio Frequency
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// DECLARE VARIABLES

private["_unit", "_typeOfUnit", "_freqs", "_freqs_offset", "_side_group_name", "_group_name", "_hasSW", "_hasLR", "_SWChannel", "_SWAddChannel", "_LRChannel", "_LRAddChannel"];

systemChat "Radio Freq Assignment Started";

_unit = player;

// group name, primary sw radio, alternate sw radio, primary lr radio, alternate lr radio
_freqs = ["CO", 100.1, 100, 31, 32,
"DC", 100.2, 100, 31, 32,
"ASL", 101, 100, 31, 32,
"A1", 101.1, 101, 31, 32,
"A2", 101.2, 101, 31, 32,
"A3", 101.3, 101, 31, 32,
"BSL",102, 100, 31, 32,
"B1", 102.1, 102, 31, 32,
"B2", 102.2, 102, 31, 32,
"B3", 102.3, 102, 31, 32,
"CSL", 103, 100, 31, 32,
"C1", 103.1, 103, 31, 32,
"C2", 103.2, 103, 31, 32,
"C3", 103.3, 103, 31, 32,
"MMG1", 104, 100, 31, 32,
"HMG1", 105, 100, 31, 32,
"MAT1", 106, 100, 31, 32,
"HAT1", 107, 100, 31, 32,
"MTR1", 108, 100, 31, 32,
"MSAM1", 109, 100, 31, 32,
"HSAM1", 110, 100, 31, 32,
"ST1", 111, 100, 31, 32,
"DT1", 112, 100, 31, 32,
"ENG1", 113, 100, 31, 32,
"IFV1", 114.1, 114, 31, 32,
"IFV2", 114.2, 114, 31, 32,
"IFV3", 114.3, 114, 31, 32,
"IFV4", 114.4, 114, 31, 32,
"IFV5", 114.5, 114, 31, 32,
"IFV6", 114.6, 114, 31, 32,
"IFV7", 114.7, 114, 31, 32,
"IFV8", 114.8, 114, 31, 32,
"TNK1", 114.9, 114, 31, 32,
"TH1", 115.1, 115, 31, 32,
"TH2", 115.2, 115, 31, 32,
"TH3", 115.3, 115, 31, 32,
"TH4", 115.4, 115, 31, 32,
"TH5", 115.5, 115, 31, 32,
"TH6", 115.6, 115, 31, 32,
"TH7", 115.7, 115, 31, 32,
"TH8", 115.8, 115, 31, 32,
"AH1", 115.9, 115, 31, 32];

sleep 3;

// ====================================================================================

// CARRY OUT CLEANUP PROCEDURE, FREQUENCY SETUP AND RADIO HANDOUT
// Clear the unit's inventory of any added radios, just in case the defaults change
// or a mistake is made with loadouts. Then, set the frequency network up according
// to the settings in tfr_settings.sqf and assign radios depending on unit loadout.

// Check player is alive
if(alive _unit) then {

  systemChat "You look alive.";

  // Wait for gear assignation to take place

  waitUntil{(_unit getVariable ["f_var_assignGear_done", false])};

  _side_group_name = group player;

  _group_name = ([format["%1", _side_group_name], " "] call CBA_fnc_split) select 2;

  systemChat format["You look like a member of %1.", _group_name];
  systemChat "I've given you your gear.";

  waitUntil{(call TFAR_fnc_activeSwRadio) call TFAR_fnc_isRadio;};

  _hasSW = call TFAR_fnc_haveSWRadio;

  _freqs_offset = _freqs find _group_name;

  if (_hasSW) then {
    systemChat "You have a SW Radio.";

    _SWChannel = format["%1", _freqs select (_freqs_offset + 1)];
    _SWAddChannel = format["%1", _freqs select (_freqs_offset + 2)];

    [(call TFAR_fnc_activeSwRadio), 0] call TFAR_fnc_setSwChannel;
    systemChat "I've set SW primary channel to CH:1.";
    [(call TFAR_fnc_activeSwRadio), 1, _SWChannel] call TFAR_fnc_SetChannelFrequency;
    systemChat format["I've set SW primary freq to %1.", _SWChannel];
    [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_setAdditionalSwChannel;
    systemChat "I've set SW alt channel to CH:2.";
    [(call TFAR_fnc_activeSwRadio), 2, _SWAddChannel] call TFAR_fnc_SetChannelFrequency;
    systemChat format["I've set SW alt freq to %1.", _SWAddChannel];
    call TFAR_fnc_sendFrequencyInfo;
    systemChat "Saved SW data.";
  };

  _hasLR = call TFAR_fnc_haveLRRadio;

  if (_hasLR) then {
      systemChat "You have a LR Radio.";

      _LRChannel = format["%1", _freqs select (_freqs_offset + 3)];

      _LRAddChannel = format["%1", _freqs select (_freqs_offset + 4)];

      [(call TFAR_fnc_activeLrRadio), 0] call TFAR_fnc_setLrChannel;
      systemChat "I've set LR primary channel to CH:1.";
      [(call TFAR_fnc_activeLrRadio), 1, _LRChannel] call TFAR_fnc_SetChannelFrequency;
      systemChat format["I've set LR primary freq to %1.", _LRChannel];
      [(call TFAR_fnc_activeLrRadio), 1] call TFAR_fnc_setAdditionalLrChannel;
      systemChat "I've set LR alt channel to CH:2.";
      [(call TFAR_fnc_activeLrRadio), 2, _LRAddChannel] call TFAR_fnc_SetChannelFrequency;
      systemChat format["I've set LR alt freq to %1.", _LRAddChannel];
      call TFAR_fnc_sendFrequencyInfo;
    };



};

// ====================================================================================

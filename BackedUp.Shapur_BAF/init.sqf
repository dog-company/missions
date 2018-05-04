// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// FACTION: NATO

// ====================================================================================

// TASKS
// The code below creates tasks. Two (commented-out) sample tasks are included.
// Note: tasks should be entered into this file in reverse order.

// _task2 = player createSimpleTask ["OBJ_2"];
// _task2 setSimpleTaskDescription ["IN DEPTH OBJECTIVE DESCRIPTION", "SHORT OBJECTIVE DESCRIPTION", "WAYPOINT TEXT"];
// _task2 setSimpleTaskDestination WAYPOINTLOCATION;
// _task2 setTaskState "Created";

// _task1 = player createSimpleTask ["OBJ_1"];
// _task1 setSimpleTaskDescription ["IN DEPTH OBJECTIVE DESCRIPTION", "SHORT OBJECTIVE DESCRIPTION", "WAYPOINT TEXT"];
// _task1 setSimpleTaskDestination WAYPOINTLOCATION;
// _task1 setTaskState "Created";

// ====================================================================================

// NOTES: CREDITS
// The code below creates the administration sub-section of notes.

_cre = player createDiaryRecord ["diary", ["Credits","
<br/>
Mission made by Giggaflop
<br/><br/>
Made with F3 (http://www.ferstaberinde.com/f3/en/)
"]];

// ====================================================================================

// NOTES: ADMINISTRATION
// The code below creates the administration sub-section of notes.

_adm = player createDiaryRecord ["diary", ["Administration","
<br/>
<font size='18'>Respawn</font>
<br/>
Respawn is enabled, however it is limited to a maximum of 30 for the entire set of players. I advise that you look at how many units you're bringing and divide 30 by that to see how many times you can each respawn.
<br/>

<br/>
<font size='18'>Medical</font>
<br/>
A dedicated CLS unit is preferred but not essential. The medical building will afford the needed medical training on all units (because magic). It is advised that units having lost blood move back to the medical building to receive a transfusion with a buddy.
<br/>

<br/>
<font size='18'>Meta Stuff</font>
<br/>
The extraction sequence is not timed and must be triggered by accessing the radio and making radio call Alpha. As this will end the mission it is only to be done by the current SL/TL. This can be done by pressing the following groups of keys (Shift+0) (Shift+0) (1)
"]];

// ====================================================================================

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
We are to spread our forces across the three fronts of battle. Golf, Tango, and Zulu. Each of these fronts are to be overwatched by at least one person at any time to avoid sneak attacks. As attacks come in, forces may need to be moved and split between them to repel the attackers. We have placed red marker flags to denote the end of each front to improve situational awareness. We are to hold until an approching UH-80 can extract the remaining forces.
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
Fire support is provided within the base by a Pvt Williams with M252 Mortar. He has been tasked to harrass the enemy, however we do not expect him to be particuarly accurate due to lack of training. He is however the most qualified currently in the base.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Mission is to entrench and defend the base from enemy attack for as long as possible.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Recent civilian casualties in Shapur in the midst of US peacekeeping efforts are causing a scandal at home. The local security and military forces are mobilising to violently eject US troops by force from bases across the country.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
We are expecting waves of Light Infantry, accompanied by russian trucks, APCs, and possible tanks.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
The garrison at the base consists of roughly 30 US Marines, with access to 1x mortar, 3x HMMV, and 2x M113 APC's
"]];

// ====================================================================================
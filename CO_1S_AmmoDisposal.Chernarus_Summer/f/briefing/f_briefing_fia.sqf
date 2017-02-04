
// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// FACTION: FIA

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
Made by Giggaflop for Dog Company
<br/><br/>
Made with F3 (http://www.ferstaberinde.com/f3/en/)
"]];


// ====================================================================================

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
Use recon groups to locate and form a plan of attack, non-obvious attack vectors give higher likelyhood of success.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Infantry may take advantage of all assets provided in the starting area.
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
Using GL's from an aerial transport may prove effective in this terrain.
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
Use the provided explosives to detonate the cache remotely. Don't blow the cache until the village has been totally cleared.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Find and destroy the Russian sympathiser stockpile(s)
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Russian sympathisers are stockpiling weapons and equipment in the small coastal village of Kamyshovo.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces expected to be Light Infantry. Recommend in-field reconnaissance before assaulting.<br>
A patrol in the area has pinpointed a number of positions and the location of the supply vehicle.
"]];

// ====================================================================================

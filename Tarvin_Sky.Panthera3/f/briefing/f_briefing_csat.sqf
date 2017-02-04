// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// FACTION: CSAT

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
Use the fire support to supply smoke rounds to cover your movement up to each town and then move through, sweeping all floors
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Movement to the objective will take place via the trucks provided, upon reaching the AO, dismount and clear each town on foot.
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
CO, DC, SL and FTL are able to call in smoke rounds on positions of their choosing.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Mission is to move through friendly positions to the northern front line, where we will be making a sweep effort to clear the towns marked with OP 1 through OP 4
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Having carved out a significant chunk of Panthera for the Russian Federation, the focus falls to the northern outposts that stop us having an uncontested western front.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces consist of entrenched USMC regulars. No vehicles are expected due to the tight terrain
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
An artillery section is on standby for Fire support missions
"]];

// ====================================================================================

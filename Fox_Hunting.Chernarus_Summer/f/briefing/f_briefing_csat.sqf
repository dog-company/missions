
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
Made For Dog Company By Giggaflop
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
Sweep and mark the roads/buildings as you clear.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Move as a mounted column, and dismount before each built up area. Do not remount until the area is cleared.
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
You are to engage and destroy any units you encounter
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
We are to sweep the area inside the red boundary, this includes the large city of Chernogorsk and Zelenogorsk.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Our control of Chernarus is failing, we believe that there are western forces hiding like foxes in our civilian hen houses
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy Forces likely consist of USMC Light Para Infantry and Special Forces
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
All MSV Forces are sweeping and clearing the affected areas, looking for enemy camps and sypathisers
"]];

// ====================================================================================


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
Made for Dog Company by Giggaflop
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
Use the confusion created by the fixing force to move through the low ground out of sight of the fixed emplacements.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Friendly forces are to move via the reverse slope to the south west of Mount Ironside.
<br/>
Forces are to split on the reverse slope and the assault element will close in via the low ground nearer the coast to get close and knock out the static weapons.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Clear the base and surrounding area, capture the HVT, await the friendly IFV extraction forces.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
During increased tensions between CSAT and NATO forces due to the Energy Crisis, one man appears to have developed a method of solving the problem, making the side who holds him very powerful.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Up to a squad of NATO regulars are holding position at Mount Ironside, awaiting a extraction via armoured convoy. We can expect Mount Ironside to be heavy with static emplacements.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
We have a supporting portion of the platoon acting as a fixing force which will remain in the trees on the reverse slope for as long as possible.
<br/>

<br/>
We also have a IFV section waiting for the all clear to enter the base and extract the HVT
"]];

// ====================================================================================

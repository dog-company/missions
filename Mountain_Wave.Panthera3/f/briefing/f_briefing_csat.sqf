
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
Use aerial reconnaissance to spot EI and focus infantry fire prior to making contact.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
A safe river crossing has been marked on your map.
<br/>
Use the BP's as guidelines on likely assault positions.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Assault and clear the towns around the bridge and remove the threat of AT infantry from our armour's path.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
US Forces are holding a vital bridge across the river, stopping our armored advance towards the Boriana Airfield.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces consist of light infantry supported by AT assets, dug into buildings and minor fortifications surrounding the bridge
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
A section of BMP-3's are stuck at Trnovo, awaiting the all clear from our forces before moving up toward the airfield
"]];

// ====================================================================================


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
Clear all buildings and the area surrounding each position before continuing to the next
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
All forces will move via the battle positions marked on map. Once all objectives are complete, you are to move to the extract point where transport has been provided to return to the airfield.
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
Fire support is provided in the form of Mortar gunners under CO discretion
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
Avoid civilian casualties where possible
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Clear the area leading up to and surrounding the castle tower to enable forward observer's eyes on the town of Taff Grove
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
After taking the Boriana Airfield we have established ourselves a route for resupply of initial ground forces. We now move to push the fronteers of Russian territory.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces are expected to consist of 2 USMC Light Infantry squads spread over a number of positions.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
No friendly forces will be operating in the AO
"]];

// ====================================================================================

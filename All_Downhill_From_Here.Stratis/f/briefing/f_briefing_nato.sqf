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
Made by Giggaflop for Dog Company
<br/><br/>
Made with F3 (http://www.ferstaberinde.com/f3/en/)
"]];



// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Primary objective is to assist and capture Air Station Mike and destroy the Russian Radar facility. Secondary objectives will be assigned during the operation.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Following our recent capture of a Russian spy, we have intelligence that Russian forces plan to assault Camp Tempest from Air station Mike
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces consist of mass light infantry, with limited motorised support and a single IFV
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
Friendly forces consist of multiple squads of light infantry, supported by MRAPs. We also have two MG outposts covering the valley road to Camp Tempest
"]];

// ====================================================================================

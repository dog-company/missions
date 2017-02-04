
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

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
All forces move via Chinook to the <marker name = 'f_insert'>Insertion Point</marker>. Then proceed across the island via the objective markers. Extract via the <marker name = 'f_extract'>Extract Point</marker>.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Disrupt communications with Chernarus. Destroy the grounded Air Support at Utes Airbase.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
In preparation for an upcoming assault on Chernarus, we need to capture the airfield of Utes.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy consists of light infantry with limited air support.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
The USS Khe Sanh is providing 1x Chinook and 1x Comanche.
"]];

// ====================================================================================

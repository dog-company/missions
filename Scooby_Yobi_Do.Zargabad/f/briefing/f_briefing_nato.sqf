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
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
Commander intends for all intel that references the US to be removed from the area. We will be given 1 hour from boots on ground to complete our mission before an exfiltration chopper arrives.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
We suspect that Raoul's forces will place mines on the approaches to The Villa so we will insert via the helipad. We will then take defensive positions and cover the intelligence team as they search for any relevant intel.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Forces loyal to the Russian claim to Zargabad are moving to assault The Villa of Raoul Azerjad. They cannot be allowed to find any intel left behind by Raoul's forces.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces will consist of lightly armed russian style infantry. We are also aware of 1x Russian fighter jet in the airspace surrounding Zargabad.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
Friendly forces consists of 1x Gunship helo and 1x Transport helo. The gunship will only provide support if your perimeter is breached.
"]];

// ====================================================================================

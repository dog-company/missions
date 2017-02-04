
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

// NOTES: ADMINISTRATION
// The code below creates the administration sub-section of notes.

_adm = player createDiaryRecord ["diary", ["Administration","
<br/>
<font size='18'>VEHICLES</font>
<br/>
Each squad begins pre-mounted in a truck. CO, DC and attachments begin pre-mounted in their own trucks.
"]];

// ====================================================================================

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
Use smoke and HE to suppress the enemy in preparation for your assault
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
All infantry move by truck to the hills south of the camp, dismount and hold there until the enemy outpost has been suppressed by artillery, then assault the enemy positions directly (on foot).
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
All leaders can request artillery support.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Our mission is to liberate the town of and capture the airfield.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Following on from the annex of the north west of Panthera, capture of the northern airfield will strengthen our supply lines into Panthera
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy forces consist of light mounted infantry with dismounted supporting infantry
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
Friendly forces will move and attack east of our assault, affording us cover from a rear advance of US Forces.
"]];

// ====================================================================================

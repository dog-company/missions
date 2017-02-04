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
<br/>

<br/>
<font size='18'>SMOKE ROUNDS</font>
<br/>
All SLs and FTLs have been issued with extra smoke rounds for their UGLs.
"]];

// ====================================================================================

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
Positions can be assaulted in ANY desired order. It is suggested that <marker name = 'op_4'>OP 4</marker> and <marker name = 'op_5'>OP 5</marker> is assaulted last.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Movement is to take place via provided trucks to the AO
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
Call Fire Support onto positions before an assault to reduce enemy resistance. Fire support has limited round available for use.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Capture the Bridgehead at Modrej
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Following on from the capture of valuable forward observation positions, we are to push forward with our capture of US held territory
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
At least a full strength squad of light infantry have been observed moving down the road from Baca to reinforce positions.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
We have communications with the Forward Observers posted at Bajo Fuerta. They will relay Fire Support calls from units equipped with Range Finders
"]];

// ====================================================================================

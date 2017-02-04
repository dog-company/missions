
// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// FACTION: FIA

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
We are operating on a return fire basis. Ensure you check your targets, Takistani law allows open carry of firearms and forbids use by civilians except in self defence.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Move off road on approach to built up areas to avoid enfilading fires down the column. Keep your movement within sight lines of the road and scan for IED's to report to EOD.
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
If weapon caches are discovered they are to be confiscated/destroyed as able.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
We are to make our way along the MSR to Jilaver, Then we are to make our way to Chaman along the ASR, and then we are to move to Feruz Abad for debriefing.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
A recent failed drone strike in the region of Takistan has increased tensions in the area west of  Feruz Abad. We are embarking on a recon of the road between Feruz Abad and Chaman.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy are expected to be lightly armed Takistan locals. We expect them to have constructed barricades to halt an approach via the road.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
Friendly forces at Feruz Abad consist of mostly light guard infantry with up to 2 mechanised support vehicles. Road blocks are in place around Feruz Abad due to increased risk of suicide attacks.
"]];

// ====================================================================================

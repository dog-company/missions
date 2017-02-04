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

// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.

_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
Commander intends to move through the canyons slowly when not under contact to allow time to spot upcoming enemies and possible IED's
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
Try to remain mobile using the vic's. Move and fire at the same time. If you encounter heavy resistance that you can't push through, spread out and dismount passengers.
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
We are aware of IED's being used across Khalu Klan. Fire team leaders are able to disarm IED's using the defuse kits provided in the ambulance, alternatively they can be detonated using the vic's mounted guns. The ambulance also contains additional medical supplies for the medic.
"]];

// ====================================================================================

// NOTES: MISSION
// The code below creates the mission sub-section of notes.

_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
Our mission is to move through the canyons of Khalu Khan and render assistance to the injured transport pilot.
"]];

// ====================================================================================

// NOTES: SITUATION
// The code below creates the situation sub-section of notes.

_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
A transport chopper passing over Khalu Klan has taken accurate .50cal fire and been forced into an emergency landing. The co-pilot is KIA. The pilot is wounded and in need of medical attention to stabilise his condition enough so he can continue the journey.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Enemy consists of embedded Takistan Army light infantry. We expect to encounter foot patrols and the villages to be occupied.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
Friendly forces in the area consist of the survivors of the downed transport chopper. They are in place guarding the chopper and the injured pilot. We have been informed that the chopper is mechanically sound and will be using that for extraction.
"]];

// ====================================================================================
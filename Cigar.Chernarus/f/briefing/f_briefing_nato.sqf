 
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
4ner
<br/><br/>
Made with F3 (http://www.ferstaberinde.com/f3/en/)
"]];
 
// ====================================================================================
 
// NOTES: ADMINISTRATION
// The code below creates the administration sub-section of notes.
 
_adm = player createDiaryRecord ["diary", ["Administration","
<br/>
N/A
"]];
 
// ====================================================================================
 
// NOTES: EXECUTION
// The code below creates the execution sub-section of notes.
 
_exe = player createDiaryRecord ["diary", ["Execution","
<br/>
<font size='18'>COMMANDER'S INTENT</font>
<br/>
You are to first move towards the Food industry and then towards the Supermarket once these two key areas are liberated, you are to assault the outpost and secure the supplies that were stolen by the terrorists.
<br/><br/>
<font size='18'>MOVEMENT PLAN</font>
<br/>
N/A
<br/><br/>
<font size='18'>FIRE SUPPORT PLAN</font>
<br/>
N/A
<br/><br/>
<font size='18'>SPECIAL TASKS</font>
<br/>
N/A
"]];
 
// ====================================================================================
 
// NOTES: MISSION
// The code below creates the mission sub-section of notes.
 
_mis = player createDiaryRecord ["diary", ["Mission","
<br/>
You are to break up the siege of the vital areas, flush out the terrorist groups out of the town, and make sure that any supplies aren't extracted from the town. We also believe that there is a weapon cache within the Terrorist outpost, if you stumble across it, you are to destroy it.
"]];
 
// ====================================================================================
 
// NOTES: SITUATION
// The code below creates the situation sub-section of notes.
 
_sit = player createDiaryRecord ["diary", ["Situation","
<br/>
Following a massive operation of the Chernarus Special Forces on the local terrorist groups, it caused the terroist groups to retreat into the mountains as they were flushed away from the urban areas, this caused the huge lack of food, weponery and other assets of the terrorist groups.
<br/>
 
<br/>
Therefore, the terrorist groups managed to regroup and to assault the town of Zelenogorks, they've taken the vital points and are trying to extract the supplies from the town. Special Forces unit was dispatched from the nearest base.
<br/><br/>
<font size='18'>ENEMY FORCES</font>
<br/>
Multiple squads of light infantry, utilising assault rifles stretched over the area of Zelenogorks.
<br/><br/>
<font size='18'>FRIENDLY FORCES</font>
<br/>
N/A
"]];
 
// ====================================================================================
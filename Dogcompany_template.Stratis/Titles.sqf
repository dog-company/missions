waitUntil{!(isNil "BIS_fnc_init")};
sleep 1;
_text = "<t size='1'>" + "Mission by 4ner" + "<br />" + "<t size='1.5'>" + "DOG COMPANY" + "</t>" + "<br />" + "<t size='1.5'>" + "- MISISON NAME-" + "</t>" + "<br />" + "<img size='4' image='images\DCLOGO-Recovered.paa'/>" + "<br />" + "<t size='1'>" + "www.dog-company.getforum.net" + "</t>" + "<br />" + "<t size='0.5'>" + "Dog Company" + "</t>";
_1 =[_text,0.01,0.01,10,-1,0,90]spawn bis_fnc_dynamicText;
waituntil {scriptdone _1};
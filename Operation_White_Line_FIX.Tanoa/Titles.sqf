waitUntil{!(isNil "BIS_fnc_init")};
sleep 1;
_text = "<t size='1'>" + "Mission by Gamer" + "<br />" + "<t size='1.5'>" + "DOG COMPANY" + "</t>" + "<br />" + "<t size='1.5'>" + "- OPERATION WHITELINE-" + "</t>" + "<br />" + "<img size='4' image='images\dc.png'/>" + "<br />" + "<t size='1'>" + "www.dog-company.getforum.net" + "</t>" + "<br />" + "<t size='0.5'>" + "Dog Company" + "</t>";
_1 =[_text,0.01,0.01,10,-1,0,90]spawn bis_fnc_dynamicText;
waituntil {scriptdone _1};
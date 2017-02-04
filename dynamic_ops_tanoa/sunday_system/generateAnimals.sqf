_center = _this select 0;

_bestPlacesMeadow = selectBestPlaces [_center, (aoSize/2), "meadow - houses", 30, 30];
_animalClasses = ["Goat_random_F", "Sheep_random_F", "Hen_random_F", "Cock_random_F"];

{
	_numAnimals = [1, 3] call BIS_fnc_randomInt;
	_thisClass = selectRandom _animalClasses;
	_spawnPos = _x select 0;
	
	for "_i" from 1 to _numAnimals do {
		_animalGroup = createGroup civilian;		
		_thisAnimal = _animalGroup createUnit [_thisClass, _spawnPos, [], 0, "NONE"];		
		_dir = random 360;
		_thisAnimal setFormDir _dir;
		_thisAnimal setDir _dir;
	};
	
} forEach _bestPlacesMeadow;
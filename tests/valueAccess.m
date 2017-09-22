function [failCount,testOutput] = valueAccess

tudat.load();


% Create input files for tests

cat.type = 'cat';
cat.name = 'Skai';
cat.age = 8;
cat.mass = 2.6;
cat.offspring = {'Dee','Cout','Plaat'};
cat.offspringMasses = [1.7, 1.8, 1.3];
cat.mother.birthplace.city.name = 'Valencia';
cat.mother.birthplace.city.temperatureRange = [0, 40];
cat.mother.birthplace.continent.name = 'Europe';
cat.mother.birthplace.continent.temperatureRange = [-15, 45];

dog.type = 'dog';
dog.name = 'Bumper';
dog.age = 11;
dog.mass = 19.5;
dog.hobbies = {'eat','sleep'};
dog.food = containers.Map({7,12,15,19},{'feed','meat','feed','feed'});
dog.orientation = [1 0 0; 0 2 1; 0 3 -1];
dog.enemies = {cat};

test.createInput(dog,fullfile(mfilename,'object'));


% Run tests

[failCount,testOutput] = test.runUnitTest(mfilename);


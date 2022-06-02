/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals where Name like '%mon';

SELECT * FROM animals WHERE date_of_birth between '2016/01/01' and '2019/01/01';

SELECT * FROM animals WHERE neutered=true AND escape_attempts<3;

SELECT date_of_birth FROM animals where name='Agumon' OR name='Pikachu';

SELECT name, escape_attempts FROM animals where weight_kg>10.5;

SELECT * FROM animals where neutered=true;

SELECT * FROM animals where name NOT LIKE '%Gabumon';

SELECT * from animals where weight_kg between 10.4 and 17.3;


/* Update */

-- Inside a transaction update the animals table by setting the species column 
-- to unspecified. Verify that change was made. Then roll back the change and verify that
--  species columns went back to the state before transaction.
ALTER TABLE animals
RENAME COLUMN species TO unspecified;
SELECT * FROM animals;

ALTER TABLE animals
RENAME COLUMN  unspecified TO species;
SELECT * FROM animals;

-- Update the animals table by setting the species column 
-- to digimon for all animals that have a name ending in mon.

UPDATE animals
SET species='digimon'
WHERE Name like '%mon';
SELECT * FROM animals;

-- Update the animals table by setting the species column to 
-- pokemon for all animals that don't have species already set.

UPDATE animals
SET species='pokemon'
WHERE species IS NULL;
SELECT * FROM animals;

/*delete all records in the animals 
table, then roll back the transaction.*/

BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;
COMMIT;


-- Delete all animals born after Jan 1st, 2022.
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
COMMIT;

-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
BEGIN;
SAVEPOINT delete_1_based_on_date;
-- Update all animals' weight to be their weight multiplied by -1.
UPDATE animals
SET weight_kg=weight_kg *- 1;
-- Rollback to the savepoint
ROLLBACK TO delete_1_based_on_date;
SET weight_kg=weight_kg *- 1;
-- Update all animals' weights that are negative to be their weight multiplied by -1.
SET weight_kg=weight_kg *- 1 WHERE weight_kg<0;
COMMIT;


-- How many animals are there? 
SELECT COUNT(*) FROM animals;  

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts=0; 
-- What is the average weight of animals?

   SELECT AVG (weight_kg) FROM animals;   
-- Who escapes the most, neutered or not neutered animals?

SELECT MAX (escape_attempts) FROM animals WHERE  neutered=true;
-- What is the minimum and maximum weight of each type of animal?
SELECT MAX (weight_kg) ,  Min (weight_kg)  FROM animals; 

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT AVG(escape_attempts) FROM animals WHERE  date_of_birth BETWEEN '01-01-1990' AND '01-01-2000';

-- Modify your inserted animals so it includes the species_id value:
    -- If the name ends in "mon" it will be Digimon
UPDATE animals SET species_id = 2 WHERE name LIKE '%mon';
    -- All other animals are Pokemon
UPDATE animals SET species_id = 1 WHERE species_id IS NULL;

-- Modify your inserted animals to include owner information (owner_id)
UPDATE animals SET owner_id = 1 WHERE name = 'Agumon';
UPDATE animals SET owner_id = 2 WHERE name = 'Gabumon' OR name='Pikachu';
UPDATE animals SET owner_id = 3 WHERE name = 'Devimon' OR name='Plantmon';
UPDATE animals SET owner_id = 4 WHERE name = 'Charmander' OR name='Squirtle' OR name='Blossom';
UPDATE animals SET owner_id = 5 WHERE name = 'Angemon' OR name=' Blossom';

-- What animals belong to Melody Pond?
SELECT * FROM owners 
JOIN animals ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Melod Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM species 
JOIN animals ON animals.species_id = species.id
WHERE species.name ='Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT * FROM owners 
LEFT JOIN animals ON animals.owner_id = owners.id; 
-- How many animals are there per species?
SELECT COUNT(*) FROM species
JOIN animals ON animals.species_id = species.id WHERE species.name='Pokemon'
JOIN animals ON animals.species_id = species.id WHERE species.name='Digmon';
-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM owners 
JOIN animals ON animals.owner_id = owners.id
JOIN species ON species.id = animals.species_id
WHERE species.name ='Digmon' AND owners.full_name='Jenefer Orwell';
-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM owners 
JOIN animals ON animals.owner_id = owners.id 
WHERE owners.full_name = 'Dean Winchester' AND escape_attempts = 0;
-- Who owns the most animals?
SELECT owners.id,full_name, COUNT(*) FROM animals 
JOIN owners ON animals.owner_id = owners.id  
GROUP BY owners.id, owners.full_name 
ORDER BY count DESC LIMIT 1;  
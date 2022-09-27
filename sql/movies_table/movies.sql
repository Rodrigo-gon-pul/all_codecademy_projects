CREATE TABLE films (
  name TEXT,
  release_year INTEGER
);
INSERT INTO films (name, release_year)
VALUES ('The Matrix', 1999);

INSERT INTO films (name, release_year)
VALUES ('Blade Runner', 1982);

INSERT INTO films (name, release_year)
VALUES ('Apocalypse Now', 1979);

SELECT * FROM films WHERE release_year = 1999;

ALTER TABLE films ADD COLUMN runtime INTEGER;
ALTER TABLE films ADD COLUMN category TEXT;
ALTER TABLE films ADD COLUMN rating REAL;
ALTER TABLE films ADD COLUMN box_office BIGINT;

UPDATE films
SET runtime = 150,
    category = 'sci-fi',
    rating = 8.7,
    box_office = 465300000   
WHERE name = 'The Matrix';

UPDATE films
SET runtime = 117,
    category = 'sci-fi',
    rating = 8.1,
    box_office = 41600000   
WHERE name = 'Blade Runner';

UPDATE films
SET runtime = 147,
    category = 'war',
    rating = 8.5,
    box_office = 120000000  
WHERE name = 'Apocalypse Now';

ALTER TABLE films
ADD CONSTRAINT unique_name UNIQUE (name);
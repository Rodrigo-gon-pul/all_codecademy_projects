/*Alter 'code' column so that each value inserted into this field is unique and not empty*/
ALTER TABLE parts 
ALTER COLUMN code SET NOT NULL;

ALTER TABLE parts ADD UNIQUE(code);

UPDATE parts
SET description = 'None Available'
WHERE description = NULL;

/*Add a constraint on 'parts' that ensures that all values in 'description' are filled and non-empty*/
ALTER TABLE parts
ALTER COLUMN description SET NOT NULL;

/*Add a constraint on 'reoder_options' that ensures that all values in 'price_usd' and 'quantity' are filled and non-empty*/
ALTER TABLE reorder_options
ALTER COLUMN price_usd SET NOT NULL,
ALTER COLUMN quantity SET NOT NULL;

/*Check both fields are positive*/
ALTER TABLE reorder_options
ADD CHECK (price_usd > 0 AND  quantity > 0);

/*Add a constraint to 'reorder_options' that limits price per unit to within 0.02 USD and 25.00 USD*/
ALTER TABLE reorder_options
ADD CHECK (price_usd/quantity > 0.02 AND price_usd/quantity < 25);

/*Add a constraint to ensure that we don’t have pricing information on 'parts' that aren’t already tracked in our DB schema*/
ALTER TABLE parts
ADD PRIMARY KEY (id);

ALTER TABLE reorder_options
ADD FOREIGN KEY (part_id) REFERENCES parts (id);

/*Add a constraint that ensures that each value in 'qty' is greater than 0*/
ALTER TABLE locations 
ADD CHECK (qty > 0); 

/*Ensure that 'locations' records only one row for each combination of 'location' and 'part'*/
ALTER TABLE locations
ADD UNIQUE (location, part_id);

/*Ensure that all parts in 'parts' have a valid manufacturer*/
ALTER TABLE parts
ADD FOREIGN KEY (manufacturer_id) REFERENCES manufacturers (id);

/*Testing the most recent constraint. Assume that 'Pip Industrial' and 'NNC Manufacturing' merge and become 'Pip-NNC Industrial'*/
INSERT INTO manufacturers(name, id) 
VALUES ('Pip-NNC Industrial', 11);

SELECT * FROM parts;

UPDATE parts
SET manufacturer_id = 11
WHERE manufacturer_id IN (1, 2);
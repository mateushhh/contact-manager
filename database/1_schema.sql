CREATE TABLE `person` (
  `person_id` integer PRIMARY KEY NOT NULL,
  `first_name` varchar(255),
  `last_name` varchar(255),
  `date_of_birth` date,
  `sex` integer,  -- 0 = unknown, 1 = male, 2 = female, 9 = other
  `partner_id` integer,
  `father_id` integer,
  `mother_id` integer
);

CREATE TABLE `company` (
  `company_id` integer PRIMARY KEY NOT NULL,
  `name` varchar(255),
  `ceo_id` integer NOT NULL
);

CREATE TABLE `employment` (
  `company_id` integer NOT NULL,
  `person_id` integer NOT NULL,
  `salary` decimal,
  `contract_type` varchar(255)
);

ALTER TABLE `person` ADD FOREIGN KEY (`partner_id`) REFERENCES `person` (`person_id`);
ALTER TABLE `person` ADD FOREIGN KEY (`father_id`) REFERENCES `person` (`person_id`);
ALTER TABLE `person` ADD FOREIGN KEY (`mother_id`) REFERENCES `person` (`person_id`);
ALTER TABLE `company` ADD FOREIGN KEY (`ceo_id`) REFERENCES `person` (`person_id`);
ALTER TABLE `employment` ADD FOREIGN KEY (`company_id`) REFERENCES `company` (`company_id`);
ALTER TABLE `employment` ADD FOREIGN KEY (`person_id`) REFERENCES `person` (`person_id`);



-- inserts person
-- grandparents
INSERT INTO person (person_id, first_name, last_name, date_of_birth, sex, partner_id, father_id, mother_id) VALUES
-- 	first_name,	last_name,	date_of_birth,	sex,	partner,	father,	mother
(1, 'Filip', 	  'Nowak', 	  '1950-01-01', 	1, 		NULL, 		NULL, 	NULL),
(2, 'Alicja',	  'Nowak', 	  '1951-02-01', 	2, 		NULL, 		NULL, 	NULL),
(3, 'Kamil', 	  'Kwiat', 	  '1952-03-01', 	1, 		NULL, 		NULL, 	NULL),
(4, 'Martyna', 	'Kwiat', 	  '1953-04-01', 	2, 		NULL, 		NULL, 	NULL),
(5, 'Milosz', 	'Kowalski', '1954-05-01', 	1, 		NULL, 		NULL, 	NULL),
(6, 'Piotr', 	  'Kowal', 	  '1955-06-01', 	1, 		NULL, 		NULL, 	NULL),
(7, 'Paulina',  'Kowal', 	  '1956-07-01', 	2, 		NULL, 		NULL, 	NULL);

UPDATE person SET partner_id = 2 WHERE person_id = 1;
UPDATE person SET partner_id = 1 WHERE person_id = 2;
UPDATE person SET partner_id = 4 WHERE person_id = 3;
UPDATE person SET partner_id = 3 WHERE person_id = 4;
UPDATE person SET partner_id = 7 WHERE person_id = 6;
UPDATE person SET partner_id = 6 WHERE person_id = 7;

-- parents 
INSERT INTO person (person_id, first_name, last_name, date_of_birth, sex, partner_id, father_id, mother_id) VALUES
-- 	first_name,	    last_name,	date_of_birth,	sex,	partner,	father,	mother
-- Nowak
(8, 'Krzysztof', 	  'Nowak', 	  '1980-01-01', 	1, 		NULL, 		1, 	    2),
(9, 'Pawel', 	      'Nowak', 	  '1981-02-01', 	1, 		NULL, 		1, 	    2),
(10, 'Julia', 	    'Nowak', 	  '1982-03-01', 	2, 		NULL, 	  1, 	    2),
(11, 'Hania',       'Nowak', 	  '1983-04-01', 	2, 		NULL, 		1, 	    2),
-- Kwiat
(12, 'Helena', 	    'Kwiat', 	  '1984-05-01', 	2, 		NULL, 		3, 	    4),
(13, 'Zofia',       'Kwiat', 	  '1985-06-01', 	2, 		NULL, 		3, 	    4),
-- Kowal
(14, 'Kacper', 	    'Kowal', 	  '1986-07-01', 	1, 		NULL, 		6, 	    7);

UPDATE person SET partner_id = 12 WHERE person_id = 8;
UPDATE person SET partner_id = 8  WHERE person_id = 12;
UPDATE person SET partner_id = 14 WHERE person_id = 13;
UPDATE person SET partner_id = 13 WHERE person_id = 14;

-- children 
INSERT INTO person (person_id, first_name, last_name, date_of_birth, sex, partner_id, father_id, mother_id) VALUES
-- 	first_name,	    last_name,	date_of_birth,	sex,	partner,	father,	mother
-- Nowak
(15, 'Bartosz', 	  'Nowak', 	  '2010-01-01', 	1, 		NULL, 		8, 	    12),
(16, 'Milena', 	    'Nowak', 	  '2011-02-01', 	2, 		NULL, 		8, 	    12),
(17, 'Emilia', 	    'Nowak', 	  '2012-03-01', 	2, 		NULL, 		8, 	    12),
-- Kowal
(18, 'Paulina', 	  'Kowal', 	  '2013-04-01', 	2, 		NULL, 		14, 	  13);



-- inserts companies
INSERT INTO company (company_id, name, ceo_id) VALUES 
(1, 'FilipBUD', 1),
(2, 'Kowal Logistyka', 7),
(3, 'Pracownia Artystyczna Helena Kwiat', 12);



-- insert employment
INSERT INTO employment (company_id, person_id, salary, contract_type) VALUES 
-- FilipBUD
(1, 1, 20000.00, 'umowa o prace'),
(1, 8, 12000.00, 'umowa o prace'),  
(1, 9, 12000.00, 'umowa o prace'),  
(1, 10, 7000.00, 'umowa zlecenie'), 

-- Kowal Logistyka
(2, 7, 10000.00, 'umowa o prace'),
(2, 11, 8000.00, 'umowa zlecenie'),
(2, 13, 7500.00, 'umowa zlecenie'),
(2, 14, 5500.00, 'umowa zlecenie'),

-- Pracownia Artystyczna Helena Kwiat
(3, 12, 5000.00, 'umowa o prace');

-- TASK1 Find a person that has the most female grandchildren 
SELECT 
    grandparent.first_name, 
    grandparent.last_name, 
    COUNT(grandchild.person_id) AS female_grandchild_count
FROM person AS grandparent
JOIN person AS parent ON (parent.father_id = grandparent.person_id OR parent.mother_id = grandparent.person_id)
JOIN person AS grandchild ON (grandchild.father_id = parent.person_id OR grandchild.mother_id = parent.person_id)
WHERE grandchild.sex = 2
GROUP BY grandparent.person_id, grandparent.first_name, grandparent.last_name
ORDER BY female_grandchild_count DESC
LIMIT 1;

-- TASK2 Show all contract types, average employee count and average salary for each contract type
SELECT 
    contract_type,
    COUNT(person_id) * 1.0 / (SELECT COUNT(*) FROM company) AS average_employees_count,
    AVG(salary) AS average_salary
FROM employment
WHERE contract_type IN ('umowa o prace', 'umowa zlecenie')
GROUP BY contract_type;

-- TASK3 Show a 2 generational family that has the lowest salary
-- earnings = salary from each job that a person is hired in
WITH Earnings AS (
    SELECT 
        p.person_id, 
        p.partner_id, 
        p.first_name, 
        p.last_name, 
        COALESCE(SUM(emp.salary), 0) AS income
    FROM person p 
    LEFT JOIN employment emp ON p.person_id = emp.person_id 
    GROUP BY p.person_id, p.partner_id, p.first_name, p.last_name
),
-- family wealth = person earnings + partner earnings + all children earnings
FamilyWealth AS (
    SELECT 
        e.person_id,
        e.partner_id,
        e.first_name,
        e.last_name,
        (
            e.income
            + COALESCE(partner.income, 0)
            + COALESCE((
                SELECT SUM(child.income + COALESCE(childs_partner.income, 0))
                FROM person c
                JOIN Earnings child ON c.person_id = child.person_id
                LEFT JOIN Earnings childs_partner ON c.partner_id = childs_partner.person_id
                WHERE c.father_id = e.person_id OR c.mother_id = e.person_id
            ), 0)
        ) AS total_family_income
    FROM Earnings e
    LEFT JOIN Earnings partner ON e.partner_id = partner.person_id
)

SELECT 
    first_name, 
    last_name, 
    total_family_income
FROM FamilyWealth
-- allows only people that have children to be showcased so its at least a 2 generational family 
WHERE EXISTS (SELECT 1 FROM person c WHERE c.father_id = FamilyWealth.person_id OR c.mother_id = FamilyWealth.person_id)
ORDER BY total_family_income ASC
LIMIT 1;

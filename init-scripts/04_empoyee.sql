-- =====================================================================
-- Seed: employees + discounts
-- File: 04_seed_people.sql
-- =====================================================================

-- Employee 1 has no manager (top of hierarchy). Others report upward.
INSERT INTO employees (first_name, last_name, email, role, hire_date, manager_id) VALUES
('Sanjay',  'Kulkarni', 'sanjay.kulkarni@techmart.example.com', 'CEO',                 '2019-01-10', NULL),
('Ritu',    'Chandra',  'ritu.chandra@techmart.example.com',    'VP Sales',            '2019-03-15', 1),
('Manish',  'Oberoi',   'manish.oberoi@techmart.example.com',   'VP Operations',       '2019-04-01', 1),
('Pallavi', 'Nayak',    'pallavi.nayak@techmart.example.com',   'Sales Manager',       '2020-02-20', 2),
('Gaurav',  'Sethi',    'gaurav.sethi@techmart.example.com',    'Sales Manager',       '2020-05-11', 2),
('Anjali',  'Trivedi',  'anjali.trivedi@techmart.example.com',  'Warehouse Manager',   '2020-06-18', 3),
('Naveen',  'Pandey',   'naveen.pandey@techmart.example.com',   'Sales Associate',     '2021-01-25', 4),
('Shalini', 'Ghosh',    'shalini.ghosh@techmart.example.com',   'Sales Associate',     '2021-03-09', 4),
('Rajesh',  'Kumar',    'rajesh.kumar@techmart.example.com',    'Sales Associate',     '2021-07-14', 5),
('Deepika', 'Rathore',  'deepika.rathore@techmart.example.com', 'Sales Associate',     '2021-09-30', 5),
('Amitabh', 'Mishra',   'amitabh.mishra@techmart.example.com',  'Warehouse Associate', '2022-01-12', 6),
('Swati',   'Kapadia',  'swati.kapadia@techmart.example.com',   'Customer Support',    '2022-04-05', 3);

INSERT INTO discounts (code, description, discount_percent, valid_from, valid_to) VALUES
('WELCOME10',   'New customer welcome discount',      10.00, '2024-01-01', '2024-12-31'),
('SUMMER15',    'Summer sale',                         15.00, '2024-04-01', '2024-06-30'),
('FESTIVE20',   'Festive season discount',             20.00, '2024-10-01', '2024-11-30'),
('FLASH25',     'Flash sale — 24 hours only',          25.00, '2024-03-15', '2024-03-16'),
('LOYALTY5',    'Loyalty member discount',              5.00, '2024-01-01', '2025-01-01'),
('CLEARANCE30', 'End-of-season clearance',             30.00, '2024-07-01', '2024-07-31'),
('BUNDLE10',    'Bundle purchase discount',            10.00, '2024-01-01', '2025-01-01'),
('STUDENT12',   'Student discount',                    12.00, '2024-01-01', '2025-01-01'),
('WEEKEND8',    'Weekend special',                      8.00, '2024-02-01', '2024-12-31'),
('REFER15',     'Referral reward discount',            15.00, '2024-01-01', '2025-01-01');
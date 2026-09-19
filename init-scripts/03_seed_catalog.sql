-- =====================================================================
-- Seed: categories + suppliers + products + product_images
-- File: 03_seed_catalog.sql
-- =====================================================================

-- Top-level categories (1-8)
INSERT INTO categories (name, description, parent_category_id) VALUES
('Electronics',           'Gadgets, computers and accessories', NULL),
('Home & Kitchen',        'Appliances and home essentials',     NULL),
('Clothing',               'Apparel for men and women',          NULL),
('Books',                  'Fiction and non-fiction titles',     NULL),
('Sports & Outdoors',      'Fitness and outdoor gear',           NULL),
('Toys & Games',           'Toys, games and puzzles',            NULL),
('Beauty & Personal Care', 'Skincare, haircare and grooming',    NULL),
('Automotive',             'Car and bike accessories',           NULL);

-- Sub-categories (9-16), referencing parents above
INSERT INTO categories (name, description, parent_category_id) VALUES
('Laptops',            'Laptops and notebooks',            1),
('Smartphones',        'Mobile phones and accessories',    1),
('Kitchen Appliances', 'Blenders, mixers, cookware',       2),
('Furniture',          'Home and office furniture',        2),
('Men''s Clothing',    'Shirts, trousers, jackets',        3),
('Women''s Clothing',  'Dresses, tops, ethnic wear',       3),
('Fiction',            'Novels and short stories',         4),
('Non-Fiction',        'Biographies, self-help, history',  4);

INSERT INTO suppliers (name, contact_email, phone, country) VALUES
('TechSource Global',      'sales@techsource.example.com',     '+1-415-555-0101', 'USA'),
('BrightHome Supplies',    'contact@brighthome.example.com',   '+44-20-7946-0102', 'UK'),
('FashionForward Ltd',     'orders@fashionforward.example.com','+91-22-6655-0103', 'India'),
('PageTurner Distributors','info@pageturner.example.com',      '+1-212-555-0104', 'USA'),
('ActiveGear Co',          'sales@activegear.example.com',     '+61-2-8000-0105', 'Australia'),
('PlayWorld Imports',      'hello@playworld.example.com',      '+86-21-6000-0106', 'China'),
('PureGlow Cosmetics',     'wholesale@pureglow.example.com',   '+82-2-555-0107',   'South Korea'),
('AutoParts Direct',       'sales@autopartsdirect.example.com','+49-30-555-0108', 'Germany'),
('KitchenCraft Wholesale', 'orders@kitchencraft.example.com',  '+91-11-4000-0109', 'India'),
('NovaElectronics',        'b2b@novaelectronics.example.com',  '+65-6000-0110',   'Singapore');

INSERT INTO products (name, description, category_id, supplier_id, price, stock_quantity, sku, created_at) VALUES
('Aeris 14" Ultrabook',            'Lightweight 14-inch laptop, 16GB RAM, 512GB SSD',        9,  1,  74999.00, 40, 'SKU-LAP-0001', '2024-02-01 10:00'),
('Aeris 15" Pro Laptop',           '15-inch laptop with dedicated GPU, 32GB RAM',            9,  1, 112999.00, 25, 'SKU-LAP-0002', '2024-02-01 10:05'),
('CoreBook Air',                   'Ultra-portable 13-inch laptop, fanless design',          9,  10, 68999.00, 30, 'SKU-LAP-0003', '2024-02-02 09:10'),
('NovaPhone X12',                  'Flagship smartphone, 6.5" OLED, 256GB storage',          10, 10, 59999.00, 60, 'SKU-PHN-0001', '2024-02-03 11:20'),
('NovaPhone X12 Lite',             'Mid-range smartphone, 128GB storage',                    10, 10, 27999.00, 80, 'SKU-PHN-0002', '2024-02-03 11:25'),
('OrbitBuds Wireless Earbuds',     'True wireless earbuds with ANC',                         1,  1,   4999.00, 150, 'SKU-ACC-0001', '2024-02-04 12:00'),
('PowerCore 20000mAh Power Bank',  'Fast-charging portable power bank',                      1,  10,  1999.00, 200, 'SKU-ACC-0002', '2024-02-04 12:10'),
('ClearView 27" Monitor',          '27-inch QHD IPS monitor, 144Hz',                         1,  1,  22999.00, 35, 'SKU-ACC-0003', '2024-02-05 14:00'),
('BlendMax Pro Mixer',             '750W kitchen mixer grinder with 3 jars',                 11, 9,   3499.00, 70, 'SKU-KIT-0001', '2024-02-06 10:30'),
('SteamGlide Iron',                'Steam iron with ceramic soleplate',                      11, 9,   1799.00, 90, 'SKU-KIT-0002', '2024-02-06 10:40'),
('ChefPro Air Fryer',              '5L digital air fryer, 8 presets',                        11, 9,   5999.00, 55, 'SKU-KIT-0003', '2024-02-07 09:15'),
('BrewMaster Coffee Machine',      'Automatic drip coffee maker, 12-cup',                    11, 2,   4499.00, 45, 'SKU-KIT-0004', '2024-02-07 09:30'),
('LuxeSit Office Chair',           'Ergonomic mesh-back office chair',                       12, 2,   8999.00, 25, 'SKU-FUR-0001', '2024-02-08 13:00'),
('OakLine Study Table',            'Solid wood study table with drawer',                     12, 2,   6499.00, 20, 'SKU-FUR-0002', '2024-02-08 13:10'),
('Classic Fit Cotton Shirt',       'Men''s slim-fit formal shirt',                           13, 3,   1299.00, 200, 'SKU-MEN-0001', '2024-02-09 10:00'),
('Urban Denim Jacket',             'Men''s casual denim jacket',                             13, 3,   2499.00, 120, 'SKU-MEN-0002', '2024-02-09 10:10'),
('ComfortFit Chinos',              'Men''s stretch-fit chinos',                              13, 3,   1599.00, 150, 'SKU-MEN-0003', '2024-02-09 10:20'),
('Floral Wrap Dress',              'Women''s summer wrap dress',                             14, 3,   1899.00, 100, 'SKU-WMN-0001', '2024-02-10 11:00'),
('Silk Blend Saree',               'Traditional silk-blend saree',                           14, 3,   3999.00, 60, 'SKU-WMN-0002', '2024-02-10 11:10'),
('Everyday Cotton Kurti',          'Women''s casual cotton kurti',                           14, 3,   999.00, 180, 'SKU-WMN-0003', '2024-02-10 11:20'),
('The Silent Orchard',             'Bestselling literary fiction novel',                     15, 4,    499.00, 250, 'SKU-BK-0001',  '2024-02-11 09:00'),
('Shadows of Kolkata',             'Mystery thriller set in 1940s Kolkata',                  15, 4,    449.00, 220, 'SKU-BK-0002',  '2024-02-11 09:10'),
('Beyond the Horizon',             'Epic fantasy adventure, book one of a trilogy',          15, 4,    599.00, 180, 'SKU-BK-0003',  '2024-02-11 09:20'),
('Atomic Habits Simplified',       'Practical guide to building better habits',              16, 4,    399.00, 300, 'SKU-BK-0004',  '2024-02-12 10:00'),
('The Founder''s Playbook',        'Startup strategy and lessons from founders',             16, 4,    549.00, 140, 'SKU-BK-0005',  '2024-02-12 10:10'),
('TrailBlazer Running Shoes',      'Lightweight running shoes with breathable mesh',         5,  5,   3299.00, 130, 'SKU-SPT-0001', '2024-02-13 11:00'),
('FlexFit Yoga Mat',               '6mm non-slip yoga mat',                                  5,  5,    899.00, 200, 'SKU-SPT-0002', '2024-02-13 11:10'),
('PowerGrip Dumbbells Set',        'Adjustable dumbbell set, 5-25kg',                        5,  5,   7999.00, 40, 'SKU-SPT-0003', '2024-02-13 11:20'),
('CampReady 2-Person Tent',        'Waterproof camping tent for two',                        5,  5,   4999.00, 35, 'SKU-SPT-0004', '2024-02-14 09:00'),
('BuildIt Wooden Blocks Set',      '100-piece wooden building blocks',                       6,  6,   1299.00, 90, 'SKU-TOY-0001', '2024-02-15 10:00'),
('PuzzleMania 1000pc Jigsaw',      '1000-piece scenic jigsaw puzzle',                        6,  6,    699.00, 120, 'SKU-TOY-0002', '2024-02-15 10:10'),
('RaceTrack Deluxe Set',           'Electric race track with two cars',                      6,  6,   2999.00, 50, 'SKU-TOY-0003', '2024-02-15 10:20'),
('GlowSkin Vitamin C Serum',       'Brightening vitamin C face serum, 30ml',                 7,  7,    899.00, 160, 'SKU-BTY-0001', '2024-02-16 11:00'),
('SilkStrand Hair Oil',            'Nourishing hair oil with argan and almond',              7,  7,    499.00, 200, 'SKU-BTY-0002', '2024-02-16 11:10'),
('PureGlow Sunscreen SPF50',       'Lightweight matte sunscreen, SPF50',                     7,  7,    699.00, 220, 'SKU-BTY-0003', '2024-02-16 11:20'),
('AquaFresh Face Wash',            'Gentle daily face wash, 150ml',                          7,  7,    349.00, 250, 'SKU-BTY-0004', '2024-02-16 11:30'),
('RoadKing All-Weather Floor Mats','Car floor mats, universal fit',                          8,  8,   1999.00, 70, 'SKU-AUTO-0001','2024-02-17 09:00'),
('DriveSafe Dash Camera',          '1080p dash camera with night vision',                    8,  8,   3499.00, 55, 'SKU-AUTO-0002','2024-02-17 09:10'),
('ShineMax Car Polish Kit',        'Complete car polishing and wax kit',                     8,  8,   1299.00, 85, 'SKU-AUTO-0003','2024-02-17 09:20'),
('QuickCharge Bike Phone Mount',   'Handlebar phone mount with USB charger',                 8,  8,    899.00, 100, 'SKU-AUTO-0004','2024-02-17 09:30');

-- Two images per product (primary + secondary), generated programmatically
INSERT INTO product_images (product_id, image_url, is_primary)
SELECT product_id, 'https://cdn.techmart.example.com/products/' || product_id || '/main.jpg', TRUE
FROM products;

INSERT INTO product_images (product_id, image_url, is_primary)
SELECT product_id, 'https://cdn.techmart.example.com/products/' || product_id || '/alt.jpg', FALSE
FROM products;
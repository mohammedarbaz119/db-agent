-- =====================================================================
-- TechMart Sample Database — Schema
-- File: 01_schema.sql
-- Runs first (alphabetical order) when mounted into
-- /docker-entrypoint-initdb.d/ of the official postgres image.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. customers
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 2. addresses  (many-to-one -> customers)
-- ---------------------------------------------------------------------
CREATE TABLE addresses (
    address_id    SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_line  VARCHAR(150) NOT NULL,
    city          VARCHAR(60)  NOT NULL,
    state         VARCHAR(60),
    postal_code   VARCHAR(20),
    country       VARCHAR(60)  NOT NULL,
    is_default    BOOLEAN NOT NULL DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- 3. categories  (self-referencing for parent/child categories)
-- ---------------------------------------------------------------------
CREATE TABLE categories (
    category_id         SERIAL PRIMARY KEY,
    name                VARCHAR(80) NOT NULL,
    description         TEXT,
    parent_category_id  INT REFERENCES categories(category_id)
);

-- ---------------------------------------------------------------------
-- 4. suppliers
-- ---------------------------------------------------------------------
CREATE TABLE suppliers (
    supplier_id     SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    contact_email   VARCHAR(100),
    phone           VARCHAR(20),
    country         VARCHAR(60)
);

-- ---------------------------------------------------------------------
-- 5. employees  (self-referencing manager_id)
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    role          VARCHAR(50),
    hire_date     DATE,
    manager_id    INT REFERENCES employees(employee_id)
);

-- ---------------------------------------------------------------------
-- 6. products  (many-to-one -> categories, suppliers)
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id      SERIAL PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    description     TEXT,
    category_id     INT REFERENCES categories(category_id),
    supplier_id     INT REFERENCES suppliers(supplier_id),
    price           NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity  INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    sku             VARCHAR(30) NOT NULL UNIQUE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 7. product_images  (many-to-one -> products)
-- ---------------------------------------------------------------------
CREATE TABLE product_images (
    image_id     SERIAL PRIMARY KEY,
    product_id   INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    image_url    VARCHAR(200) NOT NULL,
    is_primary   BOOLEAN NOT NULL DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- 8. discounts
-- ---------------------------------------------------------------------
CREATE TABLE discounts (
    discount_id       SERIAL PRIMARY KEY,
    code              VARCHAR(20) NOT NULL UNIQUE,
    description       VARCHAR(150),
    discount_percent  NUMERIC(5,2) NOT NULL CHECK (discount_percent BETWEEN 0 AND 100),
    valid_from        DATE,
    valid_to          DATE
);

-- ---------------------------------------------------------------------
-- 9. orders  (many-to-one -> customers, employees, addresses)
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id             SERIAL PRIMARY KEY,
    customer_id          INT NOT NULL REFERENCES customers(customer_id),
    employee_id          INT REFERENCES employees(employee_id),
    order_date           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status               VARCHAR(20) NOT NULL DEFAULT 'pending'
                             CHECK (status IN ('pending','processing','shipped','delivered','cancelled')),
    shipping_address_id  INT REFERENCES addresses(address_id),
    total_amount         NUMERIC(10,2) NOT NULL DEFAULT 0
);

-- ---------------------------------------------------------------------
-- 10. order_items  (many-to-one -> orders, products)
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id  SERIAL PRIMARY KEY,
    order_id       INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id     INT NOT NULL REFERENCES products(product_id),
    quantity       INT NOT NULL CHECK (quantity > 0),
    unit_price     NUMERIC(10,2) NOT NULL,
    subtotal       NUMERIC(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- ---------------------------------------------------------------------
-- 11. order_discounts  (many-to-many junction: orders <-> discounts)
-- ---------------------------------------------------------------------
CREATE TABLE order_discounts (
    order_id      INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    discount_id   INT NOT NULL REFERENCES discounts(discount_id),
    PRIMARY KEY (order_id, discount_id)
);

-- ---------------------------------------------------------------------
-- 12. payments  (many-to-one -> orders)
-- ---------------------------------------------------------------------
CREATE TABLE payments (
    payment_id      SERIAL PRIMARY KEY,
    order_id        INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_method  VARCHAR(30) NOT NULL,
    amount          NUMERIC(10,2) NOT NULL,
    payment_date    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status          VARCHAR(20) NOT NULL DEFAULT 'completed'
                        CHECK (status IN ('pending','completed','failed','refunded'))
);

-- ---------------------------------------------------------------------
-- 13. shipments  (one-to-one-ish -> orders)
-- ---------------------------------------------------------------------
CREATE TABLE shipments (
    shipment_id       SERIAL PRIMARY KEY,
    order_id          INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    carrier           VARCHAR(50),
    tracking_number   VARCHAR(50),
    shipped_date      TIMESTAMP,
    delivered_date    TIMESTAMP,
    status            VARCHAR(20) NOT NULL DEFAULT 'in_transit'
                          CHECK (status IN ('preparing','in_transit','delivered','returned'))
);

-- ---------------------------------------------------------------------
-- 14. reviews  (many-to-one -> products, customers)
-- ---------------------------------------------------------------------
CREATE TABLE reviews (
    review_id     SERIAL PRIMARY KEY,
    product_id    INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    customer_id   INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    rating        INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       TEXT,
    review_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 15. carts  (one-to-many -> customers)
-- ---------------------------------------------------------------------
CREATE TABLE carts (
    cart_id       SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 16. cart_items  (many-to-one -> carts, products)
-- ---------------------------------------------------------------------
CREATE TABLE cart_items (
    cart_item_id  SERIAL PRIMARY KEY,
    cart_id       INT NOT NULL REFERENCES carts(cart_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    added_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 17. wishlists  (many-to-many junction: customers <-> products)
-- ---------------------------------------------------------------------
CREATE TABLE wishlists (
    wishlist_id   SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    added_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (customer_id, product_id)
);

-- ---------------------------------------------------------------------
-- Indexes for common lookups / join columns
-- ---------------------------------------------------------------------
CREATE INDEX idx_addresses_customer      ON addresses(customer_id);
CREATE INDEX idx_products_category       ON products(category_id);
CREATE INDEX idx_products_supplier       ON products(supplier_id);
CREATE INDEX idx_product_images_product  ON product_images(product_id);
CREATE INDEX idx_orders_customer         ON orders(customer_id);
CREATE INDEX idx_orders_employee         ON orders(employee_id);
CREATE INDEX idx_order_items_order       ON order_items(order_id);
CREATE INDEX idx_order_items_product     ON order_items(product_id);
CREATE INDEX idx_payments_order          ON payments(order_id);
CREATE INDEX idx_shipments_order         ON shipments(order_id);
CREATE INDEX idx_reviews_product         ON reviews(product_id);
CREATE INDEX idx_reviews_customer        ON reviews(customer_id);
CREATE INDEX idx_cart_items_cart         ON cart_items(cart_id);
CREATE INDEX idx_wishlists_customer      ON wishlists(customer_id);
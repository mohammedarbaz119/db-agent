-- =====================================================================
-- Seed: orders + order_items + payments + shipments + order_discounts
-- File: 05_seed_orders.sql
-- Bulk-generated with PL/pgSQL so the dataset is large but still
-- fully referentially consistent with customers/employees/products.
-- =====================================================================

DO $$
DECLARE
    v_order_id        INT;
    v_customer_id     INT;
    v_employee_id     INT;
    v_address_id      INT;
    v_status          VARCHAR(20);
    v_order_date      TIMESTAMP;
    v_num_items       INT;
    v_product_id      INT;
    v_unit_price      NUMERIC(10,2);
    v_quantity        INT;
    v_order_total     NUMERIC(10,2);
    v_payment_method  VARCHAR(30);
    v_statuses        VARCHAR(20)[] := ARRAY['pending','processing','shipped','delivered','delivered','delivered','cancelled'];
    v_methods         VARCHAR(30)[] := ARRAY['credit_card','debit_card','upi','net_banking','cash_on_delivery'];
    v_carriers        VARCHAR(50)[] := ARRAY['BlueDart','DTDC','Delhivery','FedEx','India Post'];
    i                 INT;
    j                 INT;
BEGIN
    FOR i IN 1..60 LOOP
        -- pick a random existing customer
        SELECT customer_id INTO v_customer_id
        FROM customers ORDER BY random() LIMIT 1;

        -- pick a random employee to have "handled" the order
        SELECT employee_id INTO v_employee_id
        FROM employees ORDER BY random() LIMIT 1;

        -- prefer an address that belongs to this customer
        SELECT address_id INTO v_address_id
        FROM addresses WHERE customer_id = v_customer_id
        ORDER BY random() LIMIT 1;

        v_status     := v_statuses[1 + floor(random() * array_length(v_statuses,1))::int];
        v_order_date := TIMESTAMP '2024-03-01' + (random() * 180) * INTERVAL '1 day';

        INSERT INTO orders (customer_id, employee_id, order_date, status, shipping_address_id, total_amount)
        VALUES (v_customer_id, v_employee_id, v_order_date, v_status, v_address_id, 0)
        RETURNING order_id INTO v_order_id;

        -- 1 to 5 line items per order
        v_num_items := 1 + floor(random() * 5)::int;
        v_order_total := 0;

        FOR j IN 1..v_num_items LOOP
            SELECT product_id, price INTO v_product_id, v_unit_price
            FROM products ORDER BY random() LIMIT 1;

            v_quantity := 1 + floor(random() * 3)::int;

            INSERT INTO order_items (order_id, product_id, quantity, unit_price)
            VALUES (v_order_id, v_product_id, v_quantity, v_unit_price);

            v_order_total := v_order_total + (v_unit_price * v_quantity);
        END LOOP;

        UPDATE orders SET total_amount = v_order_total WHERE order_id = v_order_id;

        -- payment: skip for a few pending orders to vary the data
        IF v_status <> 'pending' OR random() > 0.3 THEN
            v_payment_method := v_methods[1 + floor(random() * array_length(v_methods,1))::int];
            INSERT INTO payments (order_id, payment_method, amount, payment_date, status)
            VALUES (
                v_order_id,
                v_payment_method,
                v_order_total,
                v_order_date + INTERVAL '10 minutes',
                CASE WHEN v_status = 'cancelled' THEN 'refunded' ELSE 'completed' END
            );
        END IF;

        -- shipment: only for shipped/delivered orders
        IF v_status IN ('shipped','delivered') THEN
            INSERT INTO shipments (order_id, carrier, tracking_number, shipped_date, delivered_date, status)
            VALUES (
                v_order_id,
                v_carriers[1 + floor(random() * array_length(v_carriers,1))::int],
                'TRK' || lpad(v_order_id::text, 8, '0'),
                v_order_date + INTERVAL '1 day',
                CASE WHEN v_status = 'delivered' THEN v_order_date + INTERVAL '4 days' ELSE NULL END,
                CASE WHEN v_status = 'delivered' THEN 'delivered' ELSE 'in_transit' END
            );
        END IF;

        -- ~25% of orders get a discount code applied
        IF random() < 0.25 THEN
            INSERT INTO order_discounts (order_id, discount_id)
            SELECT v_order_id, discount_id FROM discounts ORDER BY random() LIMIT 1;
        END IF;
    END LOOP;
END $$;
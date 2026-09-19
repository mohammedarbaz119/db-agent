-- =====================================================================
-- Seed: carts + cart_items + reviews + wishlists
-- File: 06_seed_engagement.sql
-- =====================================================================

DO $$
DECLARE
    v_cart_id      INT;
    v_customer_id  INT;
    v_num_items    INT;
    i              INT;
    j              INT;
    v_comments     TEXT[] := ARRAY[
        'Excellent quality, exactly as described.',
        'Good value for money, would buy again.',
        'Works well but delivery took longer than expected.',
        'Decent product, does the job.',
        'Not bad, though packaging could be better.',
        'Really happy with this purchase!',
        'Average experience, met basic expectations.',
        'Fantastic — exceeded my expectations.',
        'Okay product, a bit overpriced for what it offers.',
        'Highly recommend this to others.'
    ];
BEGIN
    -- 20 shopping carts, each belonging to a random customer, with 1-4 items
    FOR i IN 1..20 LOOP
        SELECT customer_id INTO v_customer_id FROM customers ORDER BY random() LIMIT 1;

        INSERT INTO carts (customer_id, created_at)
        VALUES (v_customer_id, TIMESTAMP '2024-05-01' + (random() * 120) * INTERVAL '1 day')
        RETURNING cart_id INTO v_cart_id;

        v_num_items := 1 + floor(random() * 4)::int;
        FOR j IN 1..v_num_items LOOP
            INSERT INTO cart_items (cart_id, product_id, quantity, added_at)
            SELECT v_cart_id, product_id, 1 + floor(random() * 3)::int,
                   TIMESTAMP '2024-05-01' + (random() * 120) * INTERVAL '1 day'
            FROM products ORDER BY random() LIMIT 1;
        END LOOP;
    END LOOP;

    -- 90 product reviews from random customers
    FOR i IN 1..90 LOOP
        INSERT INTO reviews (product_id, customer_id, rating, comment, review_date)
        SELECT
            (SELECT product_id FROM products ORDER BY random() LIMIT 1),
            (SELECT customer_id FROM customers ORDER BY random() LIMIT 1),
            1 + floor(random() * 5)::int,
            v_comments[1 + floor(random() * array_length(v_comments,1))::int],
            TIMESTAMP '2024-03-01' + (random() * 180) * INTERVAL '1 day';
    END LOOP;

    -- 40 wishlist entries (unique customer/product pairs, retried on conflict)
    FOR i IN 1..40 LOOP
        BEGIN
            INSERT INTO wishlists (customer_id, product_id, added_at)
            SELECT
                (SELECT customer_id FROM customers ORDER BY random() LIMIT 1),
                (SELECT product_id FROM products ORDER BY random() LIMIT 1),
                TIMESTAMP '2024-03-01' + (random() * 180) * INTERVAL '1 day';
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate customer/product pair
            NULL;
        END;
    END LOOP;
END $$;
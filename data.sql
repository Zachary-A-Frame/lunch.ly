DROP DATABASE IF EXISTS lunchly;

CREATE DATABASE lunchly;

\c lunchly

DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    phone text,
    notes text DEFAULT 'None'
);

CREATE TABLE reservations (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_id integer NOT NULL REFERENCES customers,
    start_at timestamp without time zone NOT NULL,
    num_guests integer NOT NULL,
    notes text DEFAULT 'None',
    CONSTRAINT reservations_num_guests_check CHECK ((num_guests > 0))
);

COPY public.customers (id, first_name, last_name, phone, notes) FROM stdin;
1	Anthony	Gonzales	590-813-4874x723	Money voice rate chair war subject kid.
2	Joseph	Wells	\N	Else quite deal culture deep candidate exactly.
\.

COPY public.reservations (id, customer_id, start_at, num_guests, notes) FROM stdin;
1	1	2018-09-08 12:20:07-07	2	Decade college home heart.
\.

SELECT pg_catalog.setval('public.customers_id_seq', 100, true);
SELECT pg_catalog.setval('public.reservations_id_seq', 200, true);

CREATE INDEX reservations_customer_id_idx ON public.reservations USING btree (customer_id);
CREATE INDEX reservations_start_at_idx ON public.reservations USING btree (start_at);
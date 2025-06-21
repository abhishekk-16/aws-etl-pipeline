-- Redshift table in which `redshift-loader-job` will load data

CREATE TABLE sales_data_table (
    country VARCHAR(256),
    item_type VARCHAR(256),
    order_date DATE,
    order_id BIGINT,
    ship_date DATE,
    units_sold BIGINT,
    unit_price DOUBLE PRECISION,
    total_revenue DOUBLE PRECISION,
    total_cost DOUBLE PRECISION,
    total_profit DOUBLE PRECISION
);

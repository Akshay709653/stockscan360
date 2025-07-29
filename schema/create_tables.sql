-- STOCKSCAN360 — SQL SCHEMA CREATION SCRIPT
-- UTF-8 Encoding assumed

-- ORGANIZATION & LOCATION MASTER TABLES
CREATE TABLE organization_master (
    org_id         NUMBER PRIMARY KEY,
    org_name       VARCHAR2(100) NOT NULL,
    gst_number     VARCHAR2(20),
    address        VARCHAR2(200),
    contact_email  VARCHAR2(100)
);

CREATE TABLE store_master (
    store_id       NUMBER PRIMARY KEY,
    org_id         NUMBER NOT NULL,
    store_code     VARCHAR2(10) UNIQUE NOT NULL,
    store_name     VARCHAR2(100),
    address        VARCHAR2(200),
    city           VARCHAR2(50),
    region         VARCHAR2(50),
    CONSTRAINT fk_store_org FOREIGN KEY (org_id) REFERENCES organization_master(org_id)
);

CREATE TABLE warehouse_master (
    warehouse_id   NUMBER PRIMARY KEY,
    org_id         NUMBER NOT NULL,
    warehouse_code VARCHAR2(10) UNIQUE NOT NULL,
    warehouse_name VARCHAR2(100),
    location       VARCHAR2(100),
    CONSTRAINT fk_warehouse_org FOREIGN KEY (org_id) REFERENCES organization_master(org_id)
);

-- PRODUCT & SKU
CREATE TABLE product_master (
    product_id     NUMBER PRIMARY KEY,
    product_name   VARCHAR2(100),
    category       VARCHAR2(50),
    brand          VARCHAR2(50),
    product_type   VARCHAR2(30),
    uom            VARCHAR2(10)
);

CREATE TABLE sku_mapping (
    sku_id         NUMBER PRIMARY KEY,
    product_id     NUMBER NOT NULL,
    sku_code       VARCHAR2(20) UNIQUE NOT NULL,
    description    VARCHAR2(200),
    barcode        VARCHAR2(30) UNIQUE,
    pack_size      VARCHAR2(20),
    color          VARCHAR2(30),
    size_variant   VARCHAR2(20),
    mrp            NUMBER(10,2),
    CONSTRAINT fk_sku_product FOREIGN KEY (product_id) REFERENCES product_master(product_id)
);

-- RACKS, SHELVES & PLANOGRAM
CREATE TABLE rack_master (
    rack_id        NUMBER PRIMARY KEY,
    rack_code      VARCHAR2(10) NOT NULL,
    store_id       NUMBER,
    warehouse_id   NUMBER,
    total_shelves  NUMBER DEFAULT 3,
    CONSTRAINT fk_rack_store FOREIGN KEY (store_id) REFERENCES store_master(store_id),
    CONSTRAINT fk_rack_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse_master(warehouse_id),
    CONSTRAINT chk_rack_fk CHECK (
        (store_id IS NOT NULL AND warehouse_id IS NULL) OR
        (store_id IS NULL AND warehouse_id IS NOT NULL)
    )
);

CREATE TABLE shelf_master (
    shelf_id       NUMBER PRIMARY KEY,
    rack_id        NUMBER NOT NULL,
    shelf_level    VARCHAR2(20), -- e.g., Top, Middle, Bottom
    facing_count   NUMBER,
    CONSTRAINT fk_shelf_rack FOREIGN KEY (rack_id) REFERENCES rack_master(rack_id)
);

CREATE TABLE planogram (
    planogram_id   NUMBER PRIMARY KEY,
    shelf_id       NUMBER NOT NULL,
    sku_id         NUMBER NOT NULL,
    display_order  NUMBER,
    ideal_qty      NUMBER,
    CONSTRAINT fk_planogram_shelf FOREIGN KEY (shelf_id) REFERENCES shelf_master(shelf_id),
    CONSTRAINT fk_planogram_sku FOREIGN KEY (sku_id) REFERENCES sku_mapping(sku_id)
);

-- INVENTORY & STOCK TRACKING
CREATE TABLE stock_inventory (
    inventory_id   NUMBER PRIMARY KEY,
    sku_id         NUMBER NOT NULL,
    location_type  VARCHAR2(20), -- Store/Warehouse
    location_id    NUMBER NOT NULL,
    rack_id        NUMBER,
    shelf_id       NUMBER,
    quantity       NUMBER NOT NULL,
    status         VARCHAR2(20), -- Available, Reserved, Damaged, etc.
    last_updated   DATE DEFAULT SYSDATE,
    CONSTRAINT fk_stock_sku FOREIGN KEY (sku_id) REFERENCES sku_mapping(sku_id)
);

CREATE TABLE stock_transaction_log (
    txn_id         NUMBER PRIMARY KEY,
    sku_id         NUMBER NOT NULL,
    txn_type       VARCHAR2(20), -- IN, OUT, RETURN, ADJUSTMENT
    quantity       NUMBER,
    source_type    VARCHAR2(20),
    source_id      NUMBER,
    txn_date       DATE DEFAULT SYSDATE,
    remarks        VARCHAR2(200)
);

-- PURCHASE & SALES
CREATE TABLE vendor_master (
    vendor_id      NUMBER PRIMARY KEY,
    vendor_name    VARCHAR2(100),
    gst_number     VARCHAR2(20),
    contact_email  VARCHAR2(100),
    rating         NUMBER(2,1)
);

CREATE TABLE purchase_order (
    po_id          NUMBER PRIMARY KEY,
    vendor_id      NUMBER NOT NULL,
    po_date        DATE DEFAULT SYSDATE,
    expected_date  DATE,
    status         VARCHAR2(20),
    CONSTRAINT fk_po_vendor FOREIGN KEY (vendor_id) REFERENCES vendor_master(vendor_id)
);

CREATE TABLE purchase_order_items (
    item_id        NUMBER PRIMARY KEY,
    po_id          NUMBER NOT NULL,
    sku_id         NUMBER NOT NULL,
    quantity       NUMBER,
    unit_price     NUMBER(10,2),
    CONSTRAINT fk_poi_po FOREIGN KEY (po_id) REFERENCES purchase_order(po_id),
    CONSTRAINT fk_poi_sku FOREIGN KEY (sku_id) REFERENCES sku_mapping(sku_id)
);

CREATE TABLE sales_order (
    so_id          NUMBER PRIMARY KEY,
    store_id       NUMBER NOT NULL,
    so_date        DATE DEFAULT SYSDATE,
    customer_name  VARCHAR2(100),
    status         VARCHAR2(20),
    CONSTRAINT fk_so_store FOREIGN KEY (store_id) REFERENCES store_master(store_id)
);

CREATE TABLE sales_order_items (
    item_id        NUMBER PRIMARY KEY,
    so_id          NUMBER NOT NULL,
    sku_id         NUMBER NOT NULL,
    quantity       NUMBER,
    price_per_unit NUMBER(10,2),
    CONSTRAINT fk_soi_so FOREIGN KEY (so_id) REFERENCES sales_order(so_id),
    CONSTRAINT fk_soi_sku FOREIGN KEY (sku_id) REFERENCES sku_mapping(sku_id)
);

-- USER, ROLE & SUPPORTING TABLES
CREATE TABLE role_master (
    role_id        NUMBER PRIMARY KEY,
    role_name      VARCHAR2(50)
);

CREATE TABLE user_master (
    user_id        NUMBER PRIMARY KEY,
    username       VARCHAR2(50) UNIQUE NOT NULL,
    password_hash  VARCHAR2(100),
    role_id        NUMBER NOT NULL,
    assigned_store NUMBER,
    assigned_wh    NUMBER,
    CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES role_master(role_id)
);

CREATE TABLE unit_master (
    unit_code      VARCHAR2(10) PRIMARY KEY,
    description    VARCHAR2(50)
);

-- Add more tables (GRN, Dispatch, Cycle Count, Adjustment) if needed later

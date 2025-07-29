# STOCKSCAN360

**Retail Inventory & Sales Management System with Rack-wise Stock Control, Warehouse Integration, and Barcode-based Stock Check**

---

## 📌 Overview

**STOCKSCAN360** is a comprehensive backend project built with Oracle 21c. It replicates a real-world inventory and sales system for retail chains like DMart, incorporating warehouse-to-store product flow, rack-based placement, barcode-driven checks, and SKU-level tracking.  

This project is ideal for showcasing SQL/PLSQL skills in a real-world business scenario.

---

## 🛠️ Tech Stack

- **Database**: Oracle 21c
- **Backend**: SQL, PL/SQL
- **Optional Frontend**: Python (Flask or Streamlit)
- **Tools Used**: GitHub, DBDiagram.io (for ERD)

---

## 🔑 Key Features

- Warehouse & Store management with zoning
- Rack & Shelf-level product mapping
- Planogram integration (facing count and visual placement)
- Barcode-based stock checking logic
- SKU-to-location mapping with stock levels
- ETL-style staging for WMS to ERP flow simulation
- Replenishment and inventory gap visibility

stockscan360/
├── schema/
│ ├── create_tables.sql -- SQL script to generate all tables and constraints
│ ├── insert_sample_data.sql -- SQL to populate tables with sample realistic data
│
├── docs/
│ └── ERD.png -- ER Diagram of database (optional)
│
├── README.md -- Project overview and instructions
├── LICENSE -- MIT License
└── .gitignore -- Files/folders to ignore (e.g., logs, pycache)


---

## 🧾 Tables Description

| Table Name            | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `warehouses`          | Master data for all warehouse locations                                     |
| `stores`              | Master data for all retail store locations                                  |
| `racks`               | Defines racks inside each store (with orientation and levels)               |
| `shelves`             | Defines shelf levels within racks (top, middle, bottom)                     |
| `products`            | SKU master with product details and barcodes                                |
| `store_inventory`     | Tracks product stock per store and per shelf                                |
| `warehouse_inventory` | Tracks product stock per warehouse                                          |
| `barcodes`            | Stores barcode mappings to SKUs (for scan simulation)                       |
| `planograms`          | Maps shelf-level SKUs and their facing count                                |
| `stock_check_logs`    | Simulates scanned stock data for audit and mismatch checks                  |
| `sku_mapping`         | Links product SKUs with planogram rules and storage assignment              |
| `erp_wms_bridge`      | Staging for syncing stock data between ERP and WMS                          |

---

## 🧪 Sample Data

The project includes:

- 3 warehouses (Zonal & Central)
- 5 stores with 20 racks and multiple shelves
- 15 SKUs across 5 product categories
- Realistic stock and barcode mapping
- Facing counts for planogram simulation

Run the following:

```sql
-- Step 1: Create the database objects
@schema/create_tables.sql

-- Step 2: Populate with demo/sample data
@schema/insert_sample_data.sql
📦 How It Works
Each store has racks (rack_code) divided into shelf levels (top/mid/bottom)

Each shelf has SKUs assigned using a planogram

Facing count helps determine how many front-facing products should be visible

Barcode-based stock check logs mimic real stock-check scenarios

Gap analysis is possible by comparing planogram and scanned data

🚀 Optional Frontend (Python)
If needed, you can later build:

Stock Check Dashboard (using Streamlit)

Planogram Visualizer

Rack-wise Product Lookup Tool

But this is optional. Project backend works fully with Oracle SQL/PLSQL.

🧾 License
MIT License – feel free to reuse and build upon this.

👨‍💻 Author
Akshay Machivale

For feedback, collaboration, or enhancements, feel free to reach out!




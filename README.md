# E-commerce Database QA Testing Project

A hands-on SQL-based QA portfolio project built on a realistic e-commerce database schema. The goal is to demonstrate how a QA engineer approaches **data integrity testing, business logic validation, and anomaly detection** at the database level — the exact skills asked about in interviews: *"How would you test our database for this problem?"*

---

## 🗃️ Database Schema — `EcommerceQA`

Five tables, deliberately seeded with real-world bugs baked in:

```
users ──────┐
            ├──> orders ──────┬──> order_items ──> products
            │                 │
            └──────────────── └──> payments
```

| Table | Rows | Description |
|-------|------|-------------|
| `users` | 4 | Registered customers — includes a **duplicate email** (intentional bug) |
| `orders` | 4 | Customer orders — 1 completed, 2 pending, 1 cancelled |
| `order_items` | 3 | Line items per order — references products |
| `payments` | 2 | Payment records — only covers 2 of 4 orders (intentional bug) |
| `products` | 4 | Product catalog — one product has `stock = 0` but still has an order (intentional bug) |

### Seeded Bugs (by design)

The test data is intentionally broken — these are the bugs the QA scenarios detect:

| # | Bug | Location | Severity |
|---|-----|----------|----------|
| 1 | Orders with no payment record | orders 3 & 4 | 🔴 Critical |
| 2 | Duplicate email address | `ali@example.com` in users | 🟠 High |
| 3 | Order placed for out-of-stock product | Mouse (stock=0) in order #2 | 🔴 Critical |
| 4 | Cancelled order with no refund record | order #3 | 🟠 High |

---

## 🧪 QA Test Scenarios (`qa_test_scenarios.sql`)

Five SQL queries that mirror real interview questions and production monitoring checks:

### Scenario 1 — Orders Without Payments *(Critical Data Integrity)*
```sql
SELECT order_id, user_id, status
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM payments);
```
**What it catches:** Orders that were created but have no payment record — a payment processing failure or a race condition bug.
**Expected result:** Orders #3 and #4 are returned.

---

### Scenario 2 — Duplicate Email Registrations *(Data Quality)*
```sql
SELECT name, email FROM users
WHERE email IN (
    SELECT email FROM users
    GROUP BY email
    HAVING COUNT(*) > 1
);
```
**What it catches:** Multiple accounts sharing the same email — a missing `UNIQUE` constraint or a registration validation bypass.
**Expected result:** Both rows with `ali@example.com` are returned.

---

### Scenario 3 — Orders for Out-of-Stock Products *(Business Logic)*
```sql
SELECT oi.order_id, p.product_name, p.stock, oi.quantity
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.stock = 0;
```
**What it catches:** The checkout flow allowed a purchase of a product with zero stock — a missing inventory check in the application layer.
**Expected result:** Order #2, Mouse, stock=0 is returned.

---

### Scenario 4 — Top 5 Customers by Spend *(Analytics / Reporting)*
```sql
SELECT u.name, SUM(p.amount) AS total_spent
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'completed'
  AND o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY u.user_id, u.name
ORDER BY total_spent DESC
LIMIT 5;
```
**What it catches:** Validates the analytics pipeline — confirms that revenue calculations only count completed orders with matching payments.
**Expected result:** Gultakin with $1,200 (Laptop purchase, order #1).

---

### Scenario 5 — Cancelled Orders Without Refunds *(Business Logic)*
```sql
SELECT o.order_id, o.status AS order_status, p.payment_status, p.amount
FROM orders o
LEFT JOIN payments p ON o.order_id = p.order_id
WHERE o.status = 'cancelled';
```
**What it catches:** A cancelled order should trigger a refund — a `NULL` in `payment_status` here means the refund workflow was never triggered.
**Expected result:** Order #3 (cancelled, `orphan@example.com`) with NULL payment fields.

---

## 🚀 How to Run

### Prerequisites
- MySQL 8.0+ (or compatible: MariaDB, MySQL Workbench, DBeaver, TablePlus)

### Setup
```bash
# 1. Connect to your MySQL instance
mysql -u root -p

# 2. Run the setup script — creates the DB, tables, and seeds all data
source database_setup.sql

# 3. Run the QA scenarios
source qa_test_scenarios.sql
```

Or open both `.sql` files in your GUI (MySQL Workbench / DBeaver) and execute them in order.

---

## 📂 Project Structure

```
Ecommerce-DB-QA-Testing/
├── database_setup.sql      # Full schema + seeded test data (with intentional bugs)
├── qa_test_scenarios.sql   # 5 QA validation queries
└── README.md
```

---


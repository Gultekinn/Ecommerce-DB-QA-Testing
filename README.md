# E-commerce Database QA Testing Project

## 📌 Project Overview
This project demonstrates backend database QA testing for an E-commerce platform. It contains a comprehensive database schema script to set up mock data and a collection of strategic SQL validation scripts designed to catch critical business logic errors, data integrity failures, and boundary anomalies.

## 📁 Repository Structure
* `database_setup.sql`: Complete DDL & DML script containing the database schema design and comprehensive mock data populating 5 tables (`users`, `products`, `orders`, `order_items`, `payments`).
* `qa_test_scenarios.sql`: Advanced production-level QA validation queries covering key business test scenarios.

## 🛠️ Executed QA Test Scenarios

### Scenario 1: Orphan Orders Detection (Critical Data Integrity Error)
* **Objective:** Find orders that have been successfully registered or remain pending but have absolutely no associated entry in the payments table.
* **Business Impact:** Prevents revenue loss from uncaptured or failed transactions leaking through the checkout funnel.

### Scenario 2: Duplicate Account Registration Check
* **Objective:** Identify accounts registered with duplicated email addresses.
* **Business Impact:** Validates backend registration rules and prevents duplicate user entities or data corruption in user lookup features.

### Scenario 3: Out-of-Stock Order Validation (Business Logic Failure)
* **Objective:** Detect instances where a user successfully created an order item containing a product that has `stock = 0`.
* **Business Impact:** Catches concurrency issues or race conditions between frontend catalog state and backend transactional validations.

### Scenario 4: Top Active Customers KPI Check (Data Analytics & Performance Testing)
* **Objective:** Extract top spending users within the last rolling 60 days.
* **Business Impact:** Verifies database calculation performance and metric precision for integrated loyalty and marketing analytical workflows.

### Scenario 5: Refund Logs for Cancelled Orders Reconciliation
* **Objective:** Cross-reference cancelled orders to verify if they are mapped correctly with automated payment returns or status logs.
* **Business Impact:** Ensures customer accounting alignment and proper technical error handling during transaction cancellations.

## 💻 Tech Stack
* **Database Engine:** MySQL 8.0+
* **IDE:** MySQL Workbench

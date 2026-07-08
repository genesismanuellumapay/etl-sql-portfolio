# Project 4: Employee Dimension Management (SCD Type 2 Ingestion)

## Business Scenario & Objective
A company's human resources and organizational structure data is highly dynamic. When an employee transitions to a new department, gets a promotion, or receives a compensation adjustment, analytics teams must be able to report on both their current assignment *and* their historical associations for accurate point-in-time performance analysis.

The objective of this project is to implement a **Slowly Changing Dimension Type 2 (SCD Type 2)** data pipeline inside **Informatica Intelligent Cloud Services (IICS)**. This ensures that historical profile changes are preserved as distinct rows with chronological tracking metadata, rather than overwriting existing database records.

---

## Pipeline Architecture
This pipeline utilizes a parallel split-stream target design pattern. It evaluates data variations directly inside a routing transformation and segregates execution tasks into multiple synchronized target objects targeting the same destination table.

```text
                        ┌──► [Group: INSERT_NEW] ──► [Expression: exp_02] ──► [Target2] (Insert Brand New)
                        │
[Source] ──► [Lookup] ──┤
                        │
                        └──► [Group: UPSERT]     ┬──► [Expression: exp_03] ──► [Target]  (Update Expire Old)
                                                 │
                                                 └──► [Expression: exp_4]  ──► [Target3] (Insert New Values)
```

### Visual Mapping Overview
<img src="screeshots/01_mapping_canvas.png" alt="IICS Complete SCD2 Mapping Canvas" width="100%">

---

## SCD Type 2 Ingestion Rule Matrix

The routing engine splits incoming records into parallel target lines based on clear database evaluation conditions:

| Evaluation Condition | Business State | Pipeline Execution Actions |
| :--- | :--- | :--- |
| **Lookup ID is Null** | New Hire / System Entry | **Insert Stream:** Routes via group `INSERT_NEW` into `exp_02`. Sets active metadata and pushes directly to `Target2` for a database **Insert** operation. |
| **Lookup ID Matches & Fields Match** | No Operational Change | **Record Ignored:** Pipeline passes row to default categories or drops it quietly to optimize network throughput. |
| **Lookup ID Matches & Fields Differ** | Structural Profile Shift | **Dual-Action Parallel Stream Execution:**<br>1. **Expire Path:** Routes via group `UPSERT` into `exp_03` to flag historical row expiration. Pushes to `Target` for a database **Update** operation.<br>2. **New Active Path:** Routes via group `UPSERT` into `exp_4` to configure the new active dataset. Pushes to `Target3` for a database **Insert** operation. |

---

## Database Schema Specification

```sql
-- 1. Source Transactional Landing Table
CREATE TABLE employee_source (
    employee_id  INT PRIMARY KEY,
    first_name   VARCHAR(50),
    last_name    VARCHAR(50),
    department   VARCHAR(50),
    job_title    VARCHAR(50),
    salary       NUMERIC(10,2),
    hire_date    DATE
);

-- 2. Target Historical Analytical Dimension Table
CREATE TABLE dim_employee (
    surrogate_key  SERIAL PRIMARY KEY, -- Auto-incrementing identity key
    employee_id    INT,                -- Operational business key
    full_name      VARCHAR(100),
    department     VARCHAR(50),
    job_title      VARCHAR(50),
    salary         NUMERIC(10,2),
    effective_date DATE NOT NULL,      -- Dimensional record start date
    end_date       DATE,               -- Dimensional record expiration date
    current_flag   CHAR(1) NOT NULL    -- Active record tracker ('Y' or 'N')
);
```

---

## Transformation Component Configurations

### 1. Target Tracking Lookup (`Lookup`)
* **Lookup Object:** `dim_employee`
* **Join Condition:** `employee_id = employee_id_src`
* **Advanced Data Filter Override:** `current_flag = 'Y'`

> 💡 **Developer Note:** By utilizing an Advanced Lookup Data Filter, the transformation cache only ingests active target records. This protects the pipeline from the "Multiple-Change Lookup Trap," ensuring arriving data evaluates solely against an employee's *most recent active profile* rather than matching older, expired historical rows.

<img src="screeshots/02_lookup_condition.png" alt="Lookup Configuration" width="100%">
<img src="screeshots/03_advance_filter_condition.png" alt="Lookup Advanced Filter" width="100%">

### 2. Stream Routing Engine (`rtr_01`)
Segregates data paths based on the presence of the business key and potential metadata transformations:
* **Group `INSERT_NEW` Condition:** `ISNULL(employee_id)`
* **Group `UPSERT` Condition:** `employee_id = employee_id_src AND (department != department_src OR job_title != job_title_src OR salary != salary_src)`

<img src="screeshots/04_router_configuration.png" alt="Router Configuration" width="100%">

### 3. Parallel Expression Transformation Blocks
Rather than using generic script commands, structural metadata changes and formatting calculations are cleanly isolated inside independent, parallel expression engines:

* **`exp_02` (New Records Branch):** Configures tracking flags for brand new system arrivals before passing the records to `Target2`.
  * `current_flag_val` = `'Y'`
  * `effective_date_value` = `SYSDATE`
  * `full_name_value` = `first_name_src||' '||last_name_src`

<img src="screeshots/05_exp_02.png" alt="Expression 02 Configuration" width="100%">

* **`exp_03` (Historical Expiration Branch):** Captures changed records from the `UPSERT` stream and updates tracking parameters to close out their active reporting window before passing them to `Target`.
  * `current_flag_val` = `'N'`
  * `end_date_value` = `ADD_TO_DATE(SYSDATE, 'DD', -1)`
  * `full_name_value` = `first_name_src||' '||last_name_src`

<img src="screeshots/06_exp_03.png" alt="Expression 03 Configuration" width="100%">

* **`exp_4` (New Active Value Branch):** Captures changed records from the `UPSERT` stream and formats them as the new current operational record before passing them to `Target3`.
  * `current_flag_val` = `'Y'`
  * `effective_date_value` = `SYSDATE`
  * `full_name_value` = `first_name_src||' '||last_name_src`

<img src="screeshots/07_exp_04.png" alt="Expression 4 Configuration" width="100%">

### 4. Downstream Target Operations Mapping
To avoid custom update scripting scripts, this mapping leverages the explicit UI configuration properties of parallel target elements pointing to the same destination table:
* **`Target2` (Connected from `exp_02`):** Configured with an **Insert** operation to add new profiles.
* **`Target` (Connected from `exp_03`):** Configured with an **Update** operation using `employee_id` as the update columns key to close out the expired record.
* **`Target3` (Connected from `exp_4`):** Configured with an **Insert** operation to append the new active configuration state.

---

## Verification & Execution Profiling

### Scenario Validation Run
To simulate an organizational shift, an employee profile was updated inside the source system, changing their department association from `IT` to `Finance`.

```sql
-- Post-ETL Audit Query to Verify Target PostgreSQL Database State
SELECT 
    employee_id, 
    full_name, 
    department, 
    effective_date, 
    end_date, 
    current_flag 
FROM dim_employee 
WHERE employee_id = 101 
ORDER BY effective_date ASC;
```

### Materialized Analytical Output
The target database results show that the pipeline successfully closed out the historical profile row and appended the new current version in parallel without record duplication:

| employee_id | full_name | department | effective_date | end_date | current_flag |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | John Doe | IT | 2026-01-01 | 2026-04-30 | N |
| 101 | John Doe | Finance | 2026-05-01 | NULL | Y |

---

## 🛠️ Production-Hardening Opportunities (Senior Engineering Scope)
While this visual mapping architecture cleanly manages standard SCD Type 2 processing criteria, the following design concepts can optimize operations at enterprise scale:

1. **Handling Empty Values (Null Handling):** Standard comparison operations (`src_col != lkp_col`) can experience issues if fields arrive empty from a source file. Wrapping comparison properties with default replacements—such as `IIF(ISNULL(src_department), '', src_department) != IIF(ISNULL(lkp_department), '', lkp_department)`—prevents system errors and ensures reliable data comparison.
2. **MD5 Change-Hash Techniques:** Chaining dozens of `OR` criteria can become difficult to maintain when managing larger tables with many columns. A cleaner corporate design approach involves generating a single hash key string using an expression pattern like `MD5(field1 || field2 || field3)`. The mapping can then evaluate a single code value comparison to determine if any profile changes have occurred instantly.
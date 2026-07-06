# ETL & SQL Portfolio

## About Me

I am refreshing and strengthening my ETL, SQL, and Informatica Intelligent Cloud Services (IICS) skills while building a professional portfolio.

This repository contains hands-on projects involving:

- SQL (PostgreSQL)
- ETL concepts
- Informatica IICS
- Data integration pipelines
- Data cleansing
- Data aggregation
- Incremental loading

---

## Technologies Used

## Technical Ecosystem

* **Cloud Data Integration:** Informatica Intelligent Cloud Services (IICS) Cloud Data Integration (CDI)
* **Databases & Warehousing:** PostgreSQL
* **Languages:** SQL (DDL, DML, Analytical Window Functions)
* **Tools & Methodologies:** GitHub, Git Version Control, Data Cleansing, Schema Design, Exception Handling

---

## Completed Projects

### Project 1 - Customer Data Cleansing Pipeline
* **Objective:** Ingest raw, unstandardized customer datasets, execute strict structural formatting, and purge invalid records prior to target database loading.
* **Pipeline Architecture:** `CSV Source` ➔ `Expression (Standardization)` ➔ `Filter (Validation)` ➔ `PostgreSQL Target`
* **Core Skills Featured:** Data normalization, character stripping, string pattern matching, and target schema enforcement.

---

### Project 2 - Monthly Customer Sales Analytics Pipeline
* **Objective:** Consolidate isolated operational data silos to generate enriched, high-performance reporting layers for monthly commercial performance reviews.
* **Pipeline Architecture:** `Contacts Source + Orders Source` ➔ `Joiner` ➔ `Expression (Derived Metrics)` ➔ `Aggregator` ➔ `PostgreSQL Analytics Target`
* **Core Skills Featured:** Multi-source relational joining, performance-optimized data aggregation, and dimensional modeling.

---

### Projects 3 & 4
*(Local migrations in progress—older architectural assets are currently being documented and uploaded to this repository shortly.)*

---

### Project 5 - Vendor Data Quarantine & Exception Handling Pipeline
* **Objective:** Prevent corrupt, incomplete, or unmapped third-party vendor catalogs from polluting downstream production environments by routing anomalies into a dedicated diagnostic quarantine layer.
* **Pipeline Architecture:** `Vendor CSV` ➔ `Unconnected Lookup (Reference Check)` ➔ `Expression (Error Flag Matrix)` ➔ `Router` ➔ `Dual Targets (Production Dim / Quarantine Log)`
* **Core Skills Featured:** Enterprise exception handling, unconnected lookup invocation, multi-variable binary error matrices, string concatenation, and native database auto-increment (`SERIAL`) coordination.

---

## Future & Ongoing Engineering Initiatives
* **Incremental Load Pipelines:** Developing high-efficiency Delta Loading (Upsert/MD5 hashing) architectures in IICS.
* **ETL Control & Audit Tables:** Designing automated logging matrices to track batch execution status, row counts, and runtime durations.
* **Slowly Changing Dimensions (SCD):** Implementing Type 1 and Type 2 historical tracking tables for master data management.
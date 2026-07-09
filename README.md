# Enterprise Data Engineering & ETL Portfolio

## About Me

I am a Data & Application Systems Engineer with over 3 years of experience specializing in data integration workflows, database administration, and process automation. 

This repository serves as a technical showcase of enterprise-grade data engineering patterns built using **Informatica Intelligent Cloud Services (IICS)** and **PostgreSQL**. The pipelines demonstrated here move beyond basic data movement, focusing on complex architectural challenges such as Slowly Changing Dimensions (SCD), High-Water Mark delta extraction, and exception-handling frameworks.

---

## Technical Ecosystem

* **Cloud Data Integration:** Informatica Intelligent Cloud Services (IICS - CDI)
* **Databases & Warehousing:** PostgreSQL, SQL Server, Relational & Dimensional Modeling
* **Languages:** SQL (DDL, DML, Analytical Window Functions), C#, Python, Bash
* **Cloud & Infrastructure:** AWS (S3, EC2), CLI 
* **Methodologies:** ETL/ELT pipelines, Git Version Control, Master Data Management (MDM)

---

## Portfolio Projects

### Project 4 - Employee Dimension Management (SCD Type 2)
* **Objective:** Preserve historical data states for highly dynamic operational records by implementing a Slowly Changing Dimension Type 2 architecture.
* **Pipeline Architecture:** `Source` ➔ `Active-Row Lookup` ➔ `Expression Logic` ➔ `Router` ➔ `Dual Targets (Expire Old via Update Strategy / Insert New)`
* **Core Skills Featured:** SCD Type 2 logic, `DD_UPDATE` active-record expiration, advanced Lookup SQL data filters.

### Project 3 - Incremental Load Pipeline (High-Water Mark)
* **Objective:** Eliminate expensive daily full-loads by dynamically querying an `etl_control` metadata table to extract and process only newly arriving delta records.
* **Pipeline Architecture:** `Source` ➔ `Unconnected Lookup` ➔ `Filter (order_id > max_id)` ➔ `Aggregator` ➔ `Dual Targets (Insert Delta / Update Control Table)`
* **Core Skills Featured:** Pipeline state management, Unconnected Lookups utilizing custom SQL Overrides and dummy match ports, data warehouse batch optimization.

### Project 5 - Vendor Data Quarantine & Exception Handling
* **Objective:** Prevent corrupt or unmapped third-party vendor catalogs from polluting downstream production environments by routing anomalies into a diagnostic quarantine layer.
* **Pipeline Architecture:** `Vendor CSV` ➔ `Unconnected Lookup` ➔ `Expression (Error Flag Matrix)` ➔ `Router` ➔ `Dual Targets (Production Dim / Quarantine Log)`
* **Core Skills Featured:** Enterprise exception handling, multi-variable binary error matrices, string concatenation.

### Project 2 - Monthly Customer Sales Analytics Pipeline
* **Objective:** Consolidate isolated operational data silos to generate enriched, high-performance reporting layers for commercial performance reviews.
* **Pipeline Architecture:** `Multi-Source` ➔ `Joiner` ➔ `Expression` ➔ `Aggregator` ➔ `PostgreSQL Analytics Target`
* **Core Skills Featured:** Multi-source relational joining, grain-level resolution, and performance-optimized data aggregation.

### Project 1 - Customer Data Cleansing Pipeline
* **Objective:** Ingest raw, unstandardized customer datasets, execute strict structural formatting, and purge invalid records prior to target database loading.
* **Pipeline Architecture:** `CSV Source` ➔ `Expression (Standardization)` ➔ `Filter (Validation)` ➔ `PostgreSQL Target`
* **Core Skills Featured:** Data normalization, string pattern matching, and target schema enforcement.

---

## Active Development (In Progress)
* **Project 7 - Multi-file ETL Pipeline:** Designing an automated file-watcher pattern to orchestrate multi-format flat-file structural ingestion.
* **Project 8 - Star Schema Data Warehouse:** Engineering a classic dimensional star schema layout, migrating operational transaction models into optimized Fact and Dimension tables.

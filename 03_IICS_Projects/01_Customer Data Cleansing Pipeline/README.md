# Project 2: Customer Data Cleansing & Standardization Pipeline (IICS)

## Business Case
In real-world enterprise environments, marketing teams frequently capture raw customer data from decentralized web forms, landing pages, and third-party platforms. This raw data is notoriously "dirty"—plagued by inconsistent casing, missing fields, and malformed email syntaxes. 

This project implements an automated cloud data pipeline using **Informatica Intelligent Cloud Services (IICS)** to ingest, clean, validate, and standardize raw customer CSV data before securely provisioning it into a production relational database.

## Pipeline Architecture
<img src="screenshots/main_mapping.png" alt="Main Mapping Canvas" width="100%">

### Key Design Patterns Used:
* **Single-Pass Standardization Engine:** Consolidated all text normalization (`INITCAP`, `UPPER`) and date type-casting (`TO_DATE`) into a single Expression transformation (`exp_1`) to minimize processing latency and reduce Secure Agent memory overhead.
* **Inline Syntactic Validation Gate:** Implemented a downstream Filter transformation (`fil_1`) using an inline string-indexing function (`INSTR`) to instantly isolate and drop malformed contact records before target database insertion.

---

## Detailed Transformation Breakdown

<details>
<summary>📊 Click to view Expression Logic & Field Calculations</summary>

The core formatting engine leverages an Expression transformation (`exp_1`) to evaluate incoming constraints, clean string data, and enforce proper database type-casting.

#### 1. Standardization Logic Configuration
Within `exp_1`, raw incoming fields are standardized using the following programmatic expressions:
* **Full Name Generation:** Concatenates first and last names while forcing proper title casing to correct messy inputs (e.g., `john` or `MARY`).
  ```sql
  INITCAP(first_name) || ' ' || INITCAP(last_name)
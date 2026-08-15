# Data Storage, Database Systems, Architecture & APIs Cheat Sheet

A comprehensive reference guide covering OLTP vs. OLAP processing models, SQL database principles and ACID guarantees, NoSQL database classification and industry applications, Data Warehouse vs. Data Lake architectures, and API and web scraping fundamentals.

---

## 1. Data Processing Paradigms: OLTP vs. OLAP

| Feature / Dimension | Online Transaction Processing (OLTP) | Online Analytical Processing (OLAP) |
| --- | --- | --- |
| **Primary Purpose** | Handles routine operational transactions and data modifications. | Formulated strictly for data querying, analysis, and reporting. |
| **Target Users** | End users interacting via DB applications or web APIs. | Data Analysts, BI Developers, and Data Scientists. |
| **Operational Execution** | Fast write, insert, update, and deletion operations. | Complex read-only queries spanning large datasets. |
| **Underlying Systems** | Relational operational databases. | Relational DBs, NoSQL DBs, Data Warehouses, and Data Lakes. |

---

## 2. Relational Databases (SQL) & ACID Properties

* **SQL (Structured Query Language):** The standard programming language engineered to query, manipulate, update, and manage structured data inside Relational Database Management Systems (RDBMS).

* **Schema:** Defines the complete architecture of a database, detailing tables, field data types, constraints, and entity relationships.

* **Tables:** The foundational structural units representing entities, where rows represent individual record instances and columns hold specific attributes.

### SQL ACID Advantages Matrix

| Property | Core Definition | Operational Guarantee |
| --- | --- | --- |
| **Atomicity**<br> | Indivisible Unit of Work | Evaluates transaction steps as a single unit; either all changes commit successfully or the entire transaction rolls back. |
| **Consistency**<br> | Valid Database State | Enforces all system integrity rules and constraints both before and after execution. |
| **Isolation**<br> | Independent Execution | Prevents concurrent transactions from interfering with one another or causing data inconsistencies. |
| **Durability**<br> | Permanent Persistence | Ensures committed transaction data permanently persists even through system crashes or power loss. |

---

## 3. Non-Relational Databases (NoSQL) & Industry Applications

* **NoSQL ("Not Only SQL"):** Non-relational database systems designed for high scalability, dynamic data models, and high user loads across modern distributed systems.

### NoSQL Paradigm Classification

| Database Type | Data Storage Model | Key Characteristics | Platform Examples |
| --- | --- | --- | --- |
| **Document Stores**<br> | Flexible, JSON-like documents. | Manages complex, hierarchical data models with dynamic schemas. | MongoDB |
| **Key-Value Stores**<br> | Simple key-value pairs. | Optimized for sub-millisecond data lookups and rapid response times. | Redis, Amazon DynamoDB |
| **Column-Family Stores**<br> | Columnar layout instead of rows. | Scalable for distributed architectures with heavy read/write operations. | Apache Cassandra, HBase |
| **Graph Databases**<br> | Nodes and relational edges. | Specialized for modeling complex networks and entity relationships. | Neo4j, Amazon Neptune |

### Database Paradigm Usage by Industry

| Industry Domain | Recommended Paradigm | Operational Use Case |
| --- | --- | --- |
| **Finance**<br> | Relational (SQL) | Processing transactional records under strict ACID consistency guarantees. |
| **Retail**<br> | Relational (SQL) | Managing relational dependencies across products, inventory, customers, and suppliers. |
| **Public Sector**<br> | Relational (SQL) | Maintaining citizen data in compliance with strict regulatory requirements. |
| **Social Media**<br> | Non-Relational (NoSQL) | Ingesting high-volume unstructured content like posts, media uploads, and profiles. |
| **Logistics**<br> | Non-Relational (NoSQL) | Real-time tracking of dynamic shipments and heterogeneous supply chain data. |
| **Gaming**<br> | Non-Relational (NoSQL) | Supporting real-time multiplayer analytics, session stores, and player leaderboards. |

---

## 4. Data Warehouses vs. Data Lakes

### Conceptual Architecture Overview

* **Data Warehouse:** A centralized corporate repository unifying structured data from heterogeneous operational systems into a consolidated, schema-driven design.

* **Data Lake:** A centralized repository capable of storing all structured, semi-structured, and unstructured data at arbitrary scale.

### Architectural Comparison Matrix

| Architectural Dimension | Data Warehouse (DWH) | Data Lake |
| --- | --- | --- |
| **Pipeline Integration** | **ETL** (Extract, Transform, Load via Staging Area). | **ELT** (Extract, Load, Transform). |
| **Accepted Formats** | Exclusively structured relational data mapped to Fact and Dimension tables. | Structured, semi-structured, and raw unstructured files (images, videos, server logs). |
| **Internal Partitioning** | Managed via Enterprise Data Warehouses (EDW) and Data Marts. | Object store retaining raw source assets at enterprise scale. |
| **Target User Base** | Data Analysts and Business Intelligence (BI) Developers. | Data Scientists, Machine Learning Engineers, Data Analysts, and BI Developers. |
| **Analytics Capabilities** | Enterprise dashboards, BI reporting, and SQL queries. | Machine learning, big data workloads, real-time streaming, and BI dashboards. |

---

## 5. APIs & Web Scraping

### Application Programming Interfaces (APIs)

* **Definition:** A formalized set of rules, protocols, and data exchange formats enabling programmatic communication between software applications.

#### API Classification Categories

* **Web APIs:** Remote network interfaces operating over standard web communication channels.
    * **REST (Representational State Transfer):** Lightweight, stateless web architectural style.
    * **SOAP (Simple Object Access Protocol):** Highly structured XML-based communication protocol.

* **Library-Based APIs:** Native language interfaces, classes, and subroutines (e.g., standard libraries in Python, Java, or C++).
* **Industry Examples:** Twitter API (extracting user interactions/tweets), Google Maps API (embedding mapping and routing logic).

### Web Scraping Concepts

* **Definition:** A Python-based programmatic workflow used to extract structured data directly from web pages when public API access is unavailable.
* **Governance:** Requires strict adherence to legal compliance frameworks and ethical scraping guidelines.
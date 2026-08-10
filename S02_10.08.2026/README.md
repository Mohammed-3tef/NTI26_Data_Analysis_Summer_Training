# Data Collection & Management Cheat Sheet

A comprehensive reference guide covering data classification, storage formats, structural types, database paradigms, and ER relational modeling principles.

---

## 1. Data Classification Frameworks

Data sources and pipelines are categorized across three operational dimensions:

### A. Internal vs. External Data Sources

| Data Source Type | Definition | Common Examples | Primary Benefits | Key Drawbacks |
| --- | --- | --- | --- | --- |
| **Internal Data** | Operational systems and data generated directly within the organization. | Enterprise Resource Planning (ERP), Customer Relationship Management (CRM) databases. | High data governance, full ownership, direct control over quality and security. | Limited scope restricted strictly to internal transactional and organizational visibility. |
| **External Data** | Data acquired or collected from sources outside the organization's boundary. | Social media feeds, public datasets, market research reports, weather/economic feeds. | Provides broader market context, competitive benchmarking, and access to new audiences. | Higher ingestion complexity, potential privacy/compliance concerns, variable data quality. |
---

### B. First-Party, Second-Party, and Third-Party Data

| Dimension | First-Party Data | Second-Party Data | Third-Party Data |
| --- | --- | --- | --- |
| **Definition** | Data collected directly from your own customers. | Another organization's first-party data shared directly with you. | Aggregated data collected by an external entity and sold to businesses. |
| **Examples** | Customer purchase history, registered user profile emails. | Co-marketing customer activity from a partner with a shared target audience. | Purchased demographic and behavioral datasets covering broad populations. |
| **Primary Benefits** | Highly accurate, high-relevance customer insights, fully owned. | Access to new, pre-vetted customer segments and lookalike audiences. | Large volume, extensive reach for broad market targeting. |
| **Key Drawbacks** | Scope is strictly limited to existing customer footprint. | Data quality depends heavily on partner standards; potential privacy issues. | Variable accuracy, privacy risks, low specificity to your niche. |

---

### C. Real-Time vs. Batch Data Processing

| Dimension | Batch Data | Real-Time Data |
| --- | --- | --- |
| **Definition** | Collected and processed in bulk groups at scheduled intervals. | Continuously collected, processed, and evaluated as events occur. |
| **Examples** | Nightly sales settlement reports, monthly financial ledger audits. | Live stock market ticker feeds, real-time social media sentiment analytics. |
| **Benefits** | Highly efficient for heavy data volumes; lower computational and infrastructure cost. | Immediate situational awareness; low latency for time-sensitive decisions. |
| **Drawbacks** | Processing lag; unsuited for immediate operational response. | Higher infrastructure expenditure; complex event-driven architecture. |

---

## 2. Structural Paradigms of Data

Data is structured according to the degree of schema enforcement applied to its storage:

| Structural Type | Definition | Common Formats & Schemas | Key Tools | Primary Applications |
| --- | --- | --- | --- | --- |
| **Structured** | Strictly organized in tabular rows and columns with fixed schemas. | Relational tables, CSV spreadsheets. | RDBMS (MySQL, PostgreSQL, SQL Server), Excel. | Financial transactions, inventory tracking. |
| **Semi-Structured** | Self-describing data with hierarchical tags/keys without a rigid tabular schema. | JSON, XML, log files, configuration blocks. | NoSQL databases (MongoDB, Cassandra), API interfaces. | System logging, web service APIs, data exchange pipelines. |
| **Unstructured** | Lacks predefined data structure or consistent schema. | Plain text documents, images, video recordings, audio files. | Big Data frameworks (Hadoop), natural language processing, computer vision tools. | Customer feedback analysis, social media monitoring, media asset management. |

---

## 3. Data Systems Architecture: DBMS & Model Paradigms

* **Database (DB):** An organized, electronically accessible store of structured or semi-structured information managed to ensure integrity, consistency, and security.

* **Database Management System (DBMS):** Software that serves as the interface between databases, applications, and end-users to manage data creation, querying, update actions, and access control.
    * *Key RDBMS Implementations:* MySQL, PostgreSQL, Microsoft SQL Server.
    * *Key NoSQL Implementation:* MongoDB.

---

## 4. Relational Database Design & Entity-Relationship Modeling

Relational database models organize domain entities, properties, and structural links prior to implementation.

### A. Relationship Degree Classification

The degree indicates the number of distinct entity types participating in a single relationship:

| Relationship Degree | Definition | Abstract Example | Practical Domain Example |
| --- | --- | --- | --- |
| **Unary (Degree 1)** | A relationship existing within a single self-referencing entity type. | Entity $A \rightarrow$ Entity $A$<br> | `Employee` manages `Employee`. |
| **Binary (Degree 2)** | A link connecting two separate entity types. | Entity $A \rightarrow$ Entity $B$<br> | `Customer` places `Order`. |
| **Ternary (Degree 3)** | An atomic link simultaneously connecting three entity types. | Entity $A \times$ Entity $B \times$ Entity $C$<br> | `Supplier` supplies `Product` to `Warehouse`. |
| **N-ary (Degree N)** | A complex relationship structure connecting more than three entity types. | Entity $A_1 \times A_2 \times \dots \times A_n$<br> | `Company` finances `Project` with `Funding` from `Investors`. |

---

### B. Cardinality Ratio Rules

Cardinality specifies maximum numerical occurrences permitted between linked entity instances:

* **One-to-One ($1:1$):** Each instance in Entity $A$ maps to at most one instance in Entity $B$, and vice versa.
    * *Example:* Each `Student` is assigned exactly one unique `Student_ID` record.

* **One-to-Many ($1:N$):** Single instances in Entity $A$ link to multiple instances in Entity $B$, but instances in $B$ link to only one instance in $A$.
    * *Example:* A single `Customer` places multiple `Orders`; each `Order` belongs to one `Customer`.

* **Many-to-Many ($M:N$):** Multiple instances in Entity $A$ relate to multiple instances in Entity $B$.
    * *Example:* Multiple `Students` enroll in multiple `Courses`. *Note: Relational engines resolve $M:N$ designs into two $1:N$ links using an intermediate join table (e.g., `StudentCourses`)*.
# FIFA World Cup Data Intelligence

> **From Data to Insight.**

An end-to-end FIFA World Cup data project combining **relational database design, SQL Server, Python data analysis, data validation, and interactive analytics**.

The project transforms historical and modern FIFA World Cup datasets into a connected data system designed to explore tournaments, teams, players, matches, goals, rankings, and performance through structured data and analytical workflows.

---

## Overview

**FIFA World Cup Data Intelligence** provides a connected view of World Cup data from **1930–2026**, combining database engineering with analytical exploration.

The project includes:

* A relational SQL Server database
* A complete Entity Relationship Diagram (ERD)
* CSV data loading and transformation workflows
* Python notebooks for analysis and cleaning
* Data validation and quality checks
* SQL analytical queries
* Interactive World Cup analytics
* A documentation/data-lab interface

The goal is to move from raw datasets to a structured, validated, and analysis-ready database.

---

## Project Highlights

| Metric          |        Value |
| --------------- | -----------: |
| Database Tables |       **17** |
| Relationships   |       **37** |
| Records         | **211,808*** |
| Matches         |    **1,352** |
| Players         |   **11,364** |
| Goals           |    **3,945** |
| Tournaments     |       **31** |

> * Verify the total record count against the final SQL Server database before publishing if the database has been updated since the project metrics were generated.

---

## Key Features

### Database Design

A normalized relational database designed around the relationships between:

* Tournaments
* Teams
* Players
* Matches
* Stadiums
* Goals
* Bookings
* Substitutions
* Player appearances
* Team appearances
* FIFA rankings
* Match statistics
* Passing network data
* Attendance
* Confederations

The database contains **17 tables and 37 relationships**, providing a connected structure for World Cup analysis.

### Interactive ERD

The project includes an interactive Entity Relationship Diagram showing:

* Tables and attributes
* Primary keys
* Foreign keys
* One-to-many relationships
* Database structure
* Entity connections

**[Open Interactive ERD](https://fifa-world-cup-data-intelligence.vercel.app/erd/FIFA_WorldCup_ERD.html)**

---

## Analytics

The analytics layer explores the World Cup through multiple perspectives, including:

### Scoring Trends

Analysis of historical goal-scoring patterns across World Cup tournaments.

### Match Performance

Comparison of match outcomes and performance indicators.

### FIFA Rankings

Exploration of team ranking data and its relationship with tournament performance.

### Player Records

Analysis of player participation and performance-related records.

### Modern Match Analytics

The project also includes modern match-level analysis and metrics such as expected goals (**xG**) and actual scoring performance.

---

## Technology Stack

### Database

* **Microsoft SQL Server**
* Relational database design
* SQL
* Primary & foreign keys
* Constraints
* Views
* Analytical queries

### Data Analysis

* **Python**
* **Pandas**
* **NumPy**
* **Matplotlib**
* Jupyter Notebook

### Frontend

* **React**
* **Vite**
* JavaScript
* CSS
* Lucide Icons

### Visualization & Presentation

* Interactive analytics dashboard
* Interactive ERD
* Data metrics
* Charts
* Analytical insights
* Documentation interface

---

## Project Workflow

The project follows a structured data pipeline:

```text
Raw CSV Datasets
       ↓
Data Loading
       ↓
SQL Server Database
       ↓
Data Cleaning
       ↓
Data Validation
       ↓
Analytical SQL Queries
       ↓
Python Analysis
       ↓
Interactive Analytics
       ↓
Insights
```

---

# SQL Server

The SQL workflow is organized into four main stages.

### 01 — Database Creation

`01_create_database.sql`

Creates the database structure, including:

* Tables
* Primary keys
* Foreign keys
* Relationships
* Constraints

---

### 02 — Data Loading

`02_bulk_insert_all.sql`

Loads the original CSV datasets into SQL Server while following the database relationships and loading tables in the appropriate order.

---

### 03 — Data Updates

`03_update_missing_data.sql`

Handles missing or incomplete data and applies required updates to the database.

---

### 04 — Analytical Queries

`04_analytical_queries.sql`

Contains analytical SQL queries used to explore the World Cup database.

The project includes **32 analytical queries** and a reusable team-performance view.

---

# Python Notebooks

The Python workflow is divided into four notebooks.

### `01_data_analysis.ipynb`

Initial exploration and analysis of the World Cup datasets.

### `02_data_cleaning.ipynb`

Data cleaning and preparation, including handling missing and inconsistent values.

### `03_data_validation.ipynb`

Validation checks used to verify data quality and consistency.

Examples include:

* Match dates within tournament dates
* Duplicate checks
* Missing-value checks
* Attendance and stadium-capacity validation
* Relationship consistency

### `04_sql_to_python_analysis.ipynb`

Connects SQL Server data with Python for further analysis and visualization.

---

# Data Validation

Data validation is an important part of the project workflow.

The validation process checks whether the datasets satisfy expected database and business rules.

Examples include:

```text
✓ Duplicate record checks
✓ Missing-value checks
✓ Date consistency checks
✓ Tournament date validation
✓ Relationship validation
✓ Attendance validation
✓ Stadium capacity checks
```

One validation result confirmed:

> **0 matches were outside their tournament date range.**

The validation workflow also identified data-quality warnings, such as matches where recorded attendance exceeded stadium capacity, allowing potential source-data issues to be identified rather than silently ignored.

---

# Database Relationships

The ERD represents the core relationships within the World Cup database.

Examples include:

```text
Tournaments
     │
     └── 1 : N ── Matches

Teams
     │
     ├── 1 : N ── Player Appearances
     ├── 1 : N ── Goals
     ├── 1 : N ── Bookings
     └── 1 : N ── Substitutions

Players
     │
     ├── 1 : N ── Goals
     ├── 1 : N ── Bookings
     └── 1 : N ── Substitutions

Stadiums
     │
     └── 1 : N ── Matches
```

The database design avoids unnecessary direct relationships and uses foreign-key relationships to maintain a structured relational model.

---

# Project Structure

```text
FIFA-World-Cup-Data-Intelligence/
│
├── src/
│   ├── components/
│   ├── data/
│   ├── hooks/
│   ├── AnalyticsPage.jsx
│   ├── DataLabPage.jsx
│   └── ...
│
├── public/
│   ├── sql/
│   ├── python/
│   ├── validation/
│   ├── erd/
│   └── ...
│
├── erd/
│   └── FIFA_WorldCup_ERD.html
│
├── python/
│   ├── 01_data_analysis.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_data_validation.ipynb
│   └── 04_sql_to_python_analysis.ipynb
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_bulk_insert_all.sql
│   ├── 03_update_missing_data.sql
│   └── 04_analytical_queries.sql
│
├── package.json
├── vite.config.js
└── README.md
```

> Adjust the folder names above if your final GitHub repository structure differs.

---

# Running the Project

## 1. Clone the repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd <YOUR_REPOSITORY_FOLDER>
```

## 2. Install dependencies

```bash
npm install
```

## 3. Start the development server

```bash
npm run dev
```

The application will be available through the local Vite development server.

---

# Database Setup

To recreate the database:

### Step 1

Run:

```text
01_create_database.sql
```

This creates the database structure and relationships.

### Step 2

Run:

```text
02_bulk_insert_all.sql
```

Load the source CSV datasets into SQL Server in relationship order.

### Step 3

Run:

```text
03_update_missing_data.sql
```

Apply the required data corrections and updates.

### Step 4

Run:

```text
04_analytical_queries.sql
```

Run the analytical queries and create the reusable analytical view.

---

# Data Sources

The project combines several World Cup data sources covering areas such as:

* Historical World Cup data
* Match analytics
* FIFA ranking data
* Stadium information
* Player data

The source datasets are transformed and organized into a relational database before analysis.

---

# Documentation

The project includes a dedicated Data Lab containing:

* SQL scripts
* Python notebooks
* Database documentation
* Validation reports
* Data sources
* Interactive ERD

**[Open Data Lab](https://fifa-world-cup-data-intelligence.vercel.app/documentation)**

**[Open Interactive ERD](https://fifa-world-cup-data-intelligence.vercel.app/erd/FIFA_WorldCup_ERD.html)**

---

# Analytics Stack

```text
SQL Server
     ↓
Relational Database
     ↓
SQL Analytics
     ↓
Python
     ↓
Pandas + NumPy
     ↓
Matplotlib
     ↓
Interactive React Dashboard
```

---

# Design Philosophy

The project was designed around three principles:

### Data

Build a structured and connected database from multiple World Cup datasets.

### Database

Model the data using relational principles, keys, constraints, and meaningful relationships.

### Analytics

Transform the structured data into visual analysis and insights that make World Cup history easier to explore.

---

# What This Project Demonstrates

This project demonstrates practical experience with:

* Relational database design
* SQL Server
* ERD modeling
* Data integration
* CSV data loading
* Data cleaning
* Data validation
* SQL analytical queries
* Python data analysis
* Pandas
* NumPy
* Matplotlib
* React
* Data visualization
* Interactive dashboards
* Technical documentation

---

# Future Improvements

Potential future extensions include:

* Additional historical datasets
* More advanced player-performance metrics
* More match-level analytical models
* Automated ETL pipelines
* Additional interactive visualizations
* Expanded ranking analysis
* Automated data-quality monitoring

---

## Project Links

* **Live Dashboard:** `https://fifa-world-cup-data-intelligence.vercel.app/`
* **GitHub Repository:** `https://github.com/Shimaa-Nashat/FIFA-World-Cup-Data-Intelligence`
* **Interactive ERD:** `./erd/FIFA_WorldCup_ERD.html`

---

## License

This project was created for educational and academic purposes.

Data sources remain subject to their respective licenses and attribution requirements.

---

<div align="center">

### FIFA WORLD CUP DATA INTELLIGENCE

**DATA · DATABASE · ANALYTICS**

*From Data to Insight.*

</div>

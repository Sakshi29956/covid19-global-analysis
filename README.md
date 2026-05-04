# 🦠 COVID-19 Global Data Analysis (Python + PostgreSQL)

> An end-to-end data analysis of the global COVID-19 pandemic — covering case trends, death rates, and vaccination progress across countries using Python and PostgreSQL.

![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?logo=pandas&logoColor=white)
![NumPy](https://img.shields.io/badge/NumPy-013243?logo=numpy&logoColor=white)
![Matplotlib](https://img.shields.io/badge/Matplotlib-11557C?logo=python&logoColor=white)
![Seaborn](https://img.shields.io/badge/Seaborn-4C72B0?logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?logo=jupyter&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

---

## 📑 Table of Contents
- [Project Overview](#-project-overview)
- [Business Questions](#-business-questions)
- [Dataset](#-dataset)
- [Tech Stack](#-tech-stack)
- [Project Workflow](#-project-workflow)
- [Data Cleaning & Feature Engineering](#-data-cleaning--feature-engineering)
- [SQL Analysis](#-sql-analysis)
- [Key Findings](#-key-findings)
- [Visualizations](#-visualizations)
- [Data Limitations](#-data-limitations)
- [How to Run This Project](#-how-to-run-this-project)
- [Repository Structure](#-repository-structure)
- [About the Author](#-about-the-author)

---

## 📌 Project Overview

The COVID-19 pandemic produced one of the largest real-world datasets in modern history, spanning cases, deaths, and vaccination rollouts across 200+ countries over multiple years. This project builds a complete, reproducible analytics pipeline to extract meaningful insights from this data.

Using **Python** for data cleaning, feature engineering, and visualization, and **PostgreSQL** for structured querying and reporting, this project mirrors the end-to-end workflow a Data or BI Analyst would follow in a real professional setting — from raw messy data to actionable insights.

This is a portfolio project demonstrating practical skills in **EDA, data wrangling, feature engineering, SQL querying, and data storytelling**.

---

## ❓ Business Questions

This analysis is framed around questions a public health agency, hospital system, or policy team would actually ask:

1. Which countries were most severely impacted by COVID-19 in terms of total cases and deaths?
2. What were the monthly trends in new cases globally and for India specifically?
3. Which countries have the highest case fatality rates (death rate)?
4. How did vaccination rollout progress across countries, and which nations led?
5. What was the peak single-day case count for each country, and when did it occur?
6. How did global monthly case numbers evolve across each wave of the pandemic?

---

## 📂 Dataset

| Detail | Info |
|--------|------|
| **Source** | [Our World in Data — COVID-19 Dataset](https://ourworldindata.org/covid-deaths) |
| **Available via** | [Kaggle](https://www.kaggle.com/datasets/caesarmario/our-world-in-data-covid19-dataset) |
| **Coverage** | Jan 2020 – 2023 |
| **Countries** | 200+ |
| **Key Columns** | `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths`, `total_vaccinations` |

### Data Dictionary

| Column | Type | Description |
|--------|------|-------------|
| `location` | TEXT | Country or region name |
| `date` | DATE | Date of record |
| `total_cases` | FLOAT | Cumulative confirmed cases |
| `new_cases` | FLOAT | New confirmed cases on that day |
| `total_deaths` | FLOAT | Cumulative confirmed deaths |
| `new_deaths` | FLOAT | New deaths on that day |
| `total_vaccinations` | FLOAT | Cumulative total vaccine doses administered |
| `death_rate` | FLOAT | Engineered feature: `total_deaths / total_cases × 100` |

> ⚠️ **Data Note:** Case counts depend heavily on each country's testing capacity. Countries with limited testing will have underreported case numbers, inflating their apparent death rates. All findings should be interpreted with this limitation in mind.

---

## 🛠 Tech Stack

| Tool | Purpose |
|------|---------|
| **Python 3.x** | Core programming language |
| **Pandas** | Data loading, cleaning, transformation |
| **NumPy** | Numerical operations |
| **Matplotlib & Seaborn** | Data visualisation |
| **PostgreSQL** | Structured querying and analytical SQL |
| **Google Colab / Jupyter Notebook** | Development environment |
| **Kaggle** | Dataset source |

---

## 🔄 Project Workflow

```
Raw CSV (Our World in Data)
        │
        ▼
1. Data Loading & Inspection      ← pandas, shape, dtypes, nulls
        │
        ▼
2. Data Cleaning                  ← handle nulls, fix dtypes, remove aggregates
        │
        ▼
3. Feature Engineering            ← death_rate, growth_rate
        │
        ▼
4. Exploratory Data Analysis      ← trends, distributions, correlations (Python)
        │
        ▼
5. Export to PostgreSQL           ← cleaned_covid_data.csv → covid_data table
        │
        ▼
6. SQL Analysis                   ← 6 analytical queries (top countries, monthly trends, etc.)
        │
        ▼
7. Insights & Visualisations      ← Matplotlib, Seaborn charts
```

---

## 🧹 Data Cleaning & Feature Engineering

### Cleaning Steps Performed

- **Missing values**: Filled numerical columns (`new_cases`, `new_deaths`, `total_vaccinations`) with `0` or forward-filled where appropriate to preserve time-series continuity
- **Data types**: Converted `date` column from object to `datetime64` format
- **Removed aggregate rows**: Filtered out non-country rows such as `"World"`, `"International"`, `"High income"` etc. which exist in the raw OWID data and can skew country-level analysis
- **Column selection**: Retained only columns relevant to the analysis scope

### Engineered Features

| Feature | Formula | Why It Matters |
|---------|---------|----------------|
| `death_rate` | `(total_deaths / total_cases) × 100` | Measures case fatality rate (CFR) as a proxy for severity. Note: this is CFR, not infection fatality rate (IFR), which would require seroprevalence data. |
| `growth_rate` | `new_cases.pct_change()` | Tracks day-over-day acceleration of the outbreak |

---

## 🗄 SQL Analysis

All SQL queries are available in [`sql/sql_analysis.sql`](sql/sql_analysis.sql).

The cleaned dataset was exported to a PostgreSQL database with the following schema:

```sql
CREATE TABLE covid_data (
    location          TEXT,
    date              DATE,
    total_cases       FLOAT,
    new_cases         FLOAT,
    total_deaths      FLOAT,
    new_deaths        FLOAT,
    total_vaccinations FLOAT,
    death_rate        FLOAT
);
```

---

### Query 1 — Top 10 Countries by Total Cases

**Business Question:** Which countries had the highest cumulative confirmed case counts?

```sql
SELECT location, MAX(total_cases) AS total_cases
FROM covid_data
GROUP BY location
ORDER BY total_cases DESC
LIMIT 10;
```

> 📌 **Insight:** The USA, India, France, and Germany consistently rank at the top. However, per-capita context is critical — smaller countries with high per-capita counts are often missed in absolute rankings.

---

### Query 2 — Countries with Highest Death Rates

**Business Question:** Which countries showed the highest case fatality rates?

```sql
SELECT location, MAX(death_rate) AS death_rate
FROM covid_data
GROUP BY location
ORDER BY death_rate DESC
LIMIT 10;
```

> 📌 **Insight:** High death rates in some countries often reflect limited testing capacity (fewer confirmed cases in the denominator) rather than worse outcomes. Yemen, Mexico, and Syria appear near the top for this reason.

---

### Query 3 — India Daily Case Trend

**Business Question:** How did daily new cases evolve in India over time?

```sql
SELECT date, new_cases
FROM covid_data
WHERE location = 'India'
ORDER BY date;
```

> 📌 **Insight:** India shows two distinct waves — a smaller 2020 peak and a much larger, sharper spike during the Delta wave of April–May 2021.

---

### Query 4 — Vaccination Leaders

**Business Question:** Which countries administered the most total vaccine doses?

```sql
SELECT location, MAX(total_vaccinations) AS vaccinations
FROM covid_data
GROUP BY location
ORDER BY vaccinations DESC
LIMIT 10;
```

> 📌 **Insight:** China, India, and the USA dominate in absolute doses — as expected given their large populations. Normalisation by population would be the next analytical step.

---

### Query 5 — Global Monthly Case Trends

**Business Question:** How did worldwide monthly case volumes change across the pandemic?

```sql
SELECT DATE_TRUNC('month', date) AS month,
       SUM(new_cases) AS total_cases
FROM covid_data
GROUP BY month
ORDER BY month;
```

> 📌 **Insight:** Monthly aggregation clearly reveals distinct pandemic waves: mid-2020, late 2020/early 2021, and the massive Omicron surge of late 2021/early 2022.

---

### Query 6 — Peak Single-Day Cases Per Country

**Business Question:** What was the worst single day for each country, and when did it occur?

```sql
SELECT location, date, new_cases
FROM covid_data c1
WHERE new_cases = (
    SELECT MAX(new_cases)
    FROM covid_data c2
    WHERE c1.location = c2.location
)
ORDER BY new_cases DESC;
```

> 📌 **Insight:** Most countries' peak days fall during the Omicron wave (Dec 2021 – Feb 2022), confirming it as the highest-transmission variant even if it produced fewer deaths per case than Delta.

---

## 💡 Key Findings

- 🌍 **USA, India, and France** recorded the highest absolute COVID-19 case counts globally
- 💉 **Vaccination leaders** by total doses administered were China, India, and the USA — though per-capita metrics shift this ranking significantly
- 📈 **India's Delta wave** (April–May 2021) showed a dramatically steeper curve than its 2020 wave, indicating far higher transmission rates
- 📅 **The Omicron wave** (late 2021 – early 2022) produced the highest single-day case counts in nearly every country analysed
- ⚠️ **Death rates vary widely** across countries — a key driver is testing capacity, not just clinical outcomes
- 📊 **Monthly trend analysis** reveals 3 clearly defined global waves, with the 3rd wave (Omicron) being the largest by case volume

---

## 📊 Visualizations

The following charts were produced as part of this analysis (see [`reports/figures/`](reports/figures/)):

| Chart | Description |
|-------|-------------|
| Total Cases Over Time — India | Line chart tracking India's cumulative case growth |
| Daily New Cases — India | Bar/line chart highlighting wave peaks in India |
| Death Rate Over Time | Line chart showing CFR evolution globally |
| Top 10 Countries — Total Cases | Horizontal bar chart of highest-case countries |
| Global Monthly Case Trends | Area chart showing pandemic waves |
| Vaccination Progress | Line chart of cumulative vaccinations for top countries |

> 📁 Charts are saved as `.png` files in the `reports/figures/` folder and embedded in the Jupyter notebook.

---

## ⚠️ Data Limitations

- **Testing bias**: Countries with low testing rates will have underreported cases, making death rates appear artificially high
- **Reporting lags**: Many countries reported weekly batches rather than daily, causing spikes in the data
- **Definition changes**: The definition of a "confirmed case" or "COVID death" changed multiple times in several countries throughout the pandemic
- **Vaccination data gaps**: Vaccination figures are missing or incomplete for many lower-income countries
- **CFR ≠ IFR**: The death rate calculated here is the Case Fatality Rate, not the Infection Fatality Rate — the latter requires seroprevalence data not available in this dataset

---

## ▶️ How to Run This Project

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/covid19-global-analysis.git
cd covid19-global-analysis
```

### 2. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 3. Download the Dataset

Download `owid-covid-data.csv` from [Kaggle](https://www.kaggle.com/datasets/caesarmario/our-world-in-data-covid19-dataset) and place it in the `data/raw/` folder.

### 4. Run the Notebooks (in order)

```
notebooks/01-data-cleaning.ipynb
notebooks/02-eda-and-visualizations.ipynb
```

### 5. Set Up PostgreSQL

```bash
# Create the database
psql -U postgres -c "CREATE DATABASE covid_project;"

# Create table and load data
psql -U postgres -d covid_project -f sql/sql_analysis.sql
```

> Update the file path in the `COPY` command inside `sql_analysis.sql` to match your local path to `cleaned_covid_data.csv`.

---

## 📁 Repository Structure

```
covid19-global-analysis/
│
├── README.md                          ← You are here
├── requirements.txt                   ← Python dependencies
├── .gitignore                         ← Excludes large data files & checkpoints
│
├── data/
│   ├── raw/                           ← Original OWID CSV (not committed — download via Kaggle)
│   └── processed/
│       └── cleaned_covid_data.csv     ← Cleaned, analysis-ready dataset
│
├── notebooks/
│   ├── 01-data-cleaning.ipynb         ← Cleaning, type fixes, null handling
│   └── 02-eda-and-visualizations.ipynb← EDA, feature engineering, charts
│
├── sql/
│   └── sql_analysis.sql               ← Schema, table creation, all 6 analytical queries
│
└── reports/
    └── figures/                       ← Exported chart PNGs
```

---

## 👩‍💻 About the Author

**Sakshi Tiwari** — Data & BI Analyst  
📍 Essen, Germany | 🎓 MSc Web & Data Science, Koblenz University

Experienced in building end-to-end data pipelines, Power BI dashboards, and SQL analytics across global business development, banking, and IT sectors.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white)](https://linkedin.com/in/sakshi-tiwari-362652188)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).  
Data sourced from [Our World in Data](https://ourworldindata.org/covid-deaths) — licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

---

*If you found this project useful or have suggestions, feel free to open an issue or connect on LinkedIn!*

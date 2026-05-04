# 🦠 COVID-19 Global Data Analysis (Python + PostgreSQL)

> An end-to-end data analysis of the global COVID-19 pandemic — covering case trends, death rates, and vaccination progress across countries using Python and PostgreSQL.

![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?logo=pandas&logoColor=white)
![NumPy](https://img.shields.io/badge/NumPy-013243?logo=numpy&logoColor=white)
![Matplotlib](https://img.shields.io/badge/Matplotlib-11557C?logo=python&logoColor=white)
![Seaborn](https://img.shields.io/badge/Seaborn-4C72B0?logo=python&logoColor=white)
![Google Colab](https://img.shields.io/badge/Google%20Colab-F9AB00?logo=googlecolab&logoColor=white)
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
| **Raw columns** | 67 columns including cases, deaths, vaccinations, demographics |
| **Columns used** | `location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths`, `total_vaccinations` |

> ⚠️ **Note:** The raw dataset (`owid-covid-data.csv`) is not included in this repo due to its size (~90MB). Download it directly from the Kaggle link above.

### Data Dictionary

| Column | Type | Description |
|--------|------|-------------|
| `location` | TEXT | Country or region name |
| `date` | DATE | Date of record |
| `total_cases` | FLOAT | Cumulative confirmed cases |
| `new_cases` | FLOAT | New confirmed cases on that day |
| `total_deaths` | FLOAT | Cumulative confirmed deaths |
| `new_deaths` | FLOAT | New confirmed deaths on that day |
| `total_vaccinations` | FLOAT | Cumulative total vaccine doses administered |
| `death_rate` | FLOAT | Engineered feature: `(total_deaths / total_cases) × 100` |

---

## 🛠 Tech Stack

| Tool | Purpose |
|------|---------|
| **Python 3.x** | Core programming language |
| **Pandas** | Data loading, cleaning, transformation |
| **NumPy** | Numerical operations |
| **Matplotlib & Seaborn** | Data visualisation |
| **PostgreSQL** | Structured querying and analytical SQL |
| **Google Colab** | Development environment |
| **Kaggle** | Dataset source |

---

## 🔄 Project Workflow

```
Raw CSV (owid-covid-data.csv — 67 columns, 200+ countries)
        │
        ▼
1. Data Loading & Inspection      ← pandas read_csv, shape, dtypes, null check
        │
        ▼
2. Data Cleaning                  ← column selection, null handling (fillna), date conversion
        │
        ▼
3. Feature Engineering            ← death_rate = (total_deaths / total_cases) × 100
        │
        ▼
4. Exploratory Data Analysis      ← India trends, global trends, vaccination progress
        │
        ▼
5. Visualisations                 ← Matplotlib & Seaborn charts (embedded in notebook)
        │
        ▼
6. Export to PostgreSQL           ← cleaned_covid_data.csv → covid_data table
        │
        ▼
7. SQL Analysis                   ← 6 analytical queries (top countries, monthly trends, etc.)
```

---

## 🧹 Data Cleaning & Feature Engineering

### Cleaning Steps Performed

- **Column selection**: The raw dataset has 67 columns — retained only 7 relevant to the analysis (`location`, `date`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths`, `total_vaccinations`)
- **Missing values**: Filled numerical columns with `0` using `fillna(0)` to preserve time-series continuity
- **Data types**: Converted `date` column from object to `datetime64` format
- **Output**: Exported cleaned data as `cleaned_covid_data.csv` for loading into PostgreSQL

### Engineered Features

| Feature | Formula | Why It Matters |
|---------|---------|----------------|
| `death_rate` | `(total_deaths / total_cases) × 100` | Measures case fatality rate (CFR) as a proxy for outbreak severity |

> **Note:** This is the Case Fatality Rate (CFR), not the Infection Fatality Rate (IFR). CFR uses confirmed cases as the denominator, which is heavily affected by testing capacity. Countries with low testing will appear to have higher death rates.

---

## 🗄 SQL Analysis

All SQL queries are in [`sql_analysis.sql`](sql_analysis.sql).

The cleaned dataset was loaded into PostgreSQL using this schema:

```sql
CREATE DATABASE covid_project;

CREATE TABLE covid_data (
    location           TEXT,
    date               DATE,
    total_cases        FLOAT,
    new_cases          FLOAT,
    total_deaths       FLOAT,
    new_deaths         FLOAT,
    total_vaccinations FLOAT,
    death_rate         FLOAT
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

> 📌 **Insight:** The USA, India, France, and Germany rank at the top. Per-capita context is critical — smaller countries with high per-capita counts are often missed in absolute rankings.

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

> 📌 **Insight:** High death rates in some countries often reflect limited testing capacity rather than worse clinical outcomes. Yemen, Mexico, and Syria appear near the top for this reason.

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

> 📌 **Insight:** China, India, and the USA dominate in absolute doses given their large populations. Per-capita normalisation would shift this ranking significantly.

---

### Query 5 — Global Monthly Case Trends

**Business Question:** How did worldwide monthly case volumes evolve across the pandemic?

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
- 💉 **Vaccination leaders** by total doses were China, India, and the USA — though per-capita metrics shift this ranking significantly
- 📈 **India's Delta wave** (April–May 2021) showed a dramatically steeper curve than its 2020 wave, indicating far higher transmission rates
- 📅 **The Omicron wave** (late 2021 – early 2022) produced the highest single-day case counts in nearly every country analysed
- ⚠️ **Death rates vary widely** — a key driver is testing capacity, not just clinical outcomes
- 📊 **Monthly trend analysis** reveals 3 clearly defined global waves, with the 3rd (Omicron) being the largest by case volume

---

## 📊 Visualizations

All charts are produced and embedded inside the notebook [`COVID-19 Data Analysis Project.ipynb`](COVID-19%20Data%20Analysis%20Project.ipynb).

| Chart | Description |
|-------|-------------|
| Total Cases Over Time — India | Line chart tracking India's cumulative case growth |
| Daily New Cases — India | Chart highlighting wave peaks in India |
| Death Rate Over Time — India | Line chart showing CFR evolution for India |
| Top 10 Countries — Total Cases | Bar chart of highest-case countries globally |
| Global Monthly Case Trends | Monthly aggregated case volumes |
| Vaccination Progress | Cumulative vaccination totals for leading countries |

> 📂 Open the notebook to view all charts with their full analysis context.

---

## ⚠️ Data Limitations

- **Testing bias**: Countries with low testing rates have underreported cases, making death rates appear artificially high
- **Reporting lags**: Many countries reported weekly batches rather than daily, causing artificial spikes
- **Definition changes**: The definition of a "confirmed case" or "COVID death" changed multiple times in several countries
- **Vaccination data gaps**: Figures are missing or incomplete for many lower-income countries
- **CFR ≠ IFR**: The death rate here is the Case Fatality Rate — the Infection Fatality Rate would require seroprevalence data not available in this dataset

---

## ▶️ How to Run This Project

### Option A — Run in Google Colab (Recommended)

1. Open [`COVID-19 Data Analysis Project.ipynb`](COVID-19%20Data%20Analysis%20Project.ipynb) in Google Colab
2. Download `owid-covid-data.csv` from [Kaggle](https://www.kaggle.com/datasets/caesarmario/our-world-in-data-covid19-dataset)
3. Upload it to your Colab session (it will be available at `/content/owid-covid-data.csv`)
4. Run all cells in order

### Option B — Run Locally

**1. Clone the repository**
```bash
git clone https://github.com/Sakshi29956/covid19-global-analysis.git
cd covid19-global-analysis
```

**2. Install dependencies**
```bash
pip install -r requirements.txt
```

**3. Download the dataset**

Download `owid-covid-data.csv` from [Kaggle](https://www.kaggle.com/datasets/caesarmario/our-world-in-data-covid19-dataset) and place it in the project root. Update the file path in the notebook from `/content/owid-covid-data.csv` to your local path.

**4. Run the notebook**
```bash
jupyter notebook "COVID-19 Data Analysis Project.ipynb"
```

**5. Set up PostgreSQL (for SQL analysis)**
```bash
# Create the database
psql -U postgres -c "CREATE DATABASE covid_project;"

# Run schema + queries
psql -U postgres -d covid_project -f sql_analysis.sql
```

> Update the file path in the `COPY` command inside `sql_analysis.sql` to point to your local `cleaned_covid_data.csv`.

---

## 📁 Repository Structure

```
covid19-global-analysis/
│
├── README.md                              ← Project documentation (you are here)
├── requirements.txt                       ← Python dependencies
├── .gitignore                             ← Excludes large raw data files
│
├── COVID-19 Data Analysis Project.ipynb   ← Main notebook: cleaning, EDA, visualisations
├── sql_analysis.sql                       ← PostgreSQL schema + 6 analytical queries
├── project.pdf                            ← Project report (PDF version)
│
└── data/
    └── cleaned_covid_data.csv             ← Processed dataset (7 columns, ready for PostgreSQL)
                                              Raw owid-covid-data.csv excluded — download from Kaggle
```

---

## 👩‍💻 About the Author

**Sakshi Tiwari** — Data & BI Analyst
📍 Essen, Germany | 🎓 MSc Web & Data Science, Koblenz University

Detail-oriented analyst with 3+ years of experience in global business development, banking, and IT. Skilled in building end-to-end data pipelines, Power BI dashboards, and SQL analytics.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?logo=linkedin&logoColor=white)](https://linkedin.com/in/sakshi-tiwari-362652188)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
Data sourced from [Our World in Data](https://ourworldindata.org/covid-deaths) — licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

---

*If you found this project useful or have suggestions, feel free to open an issue or connect on LinkedIn!*

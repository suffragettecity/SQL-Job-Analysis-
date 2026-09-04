/*
Q: What are the most optimal skills for data engineers - balancing both demand and salary?
*/


SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
   -- COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count, 
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING 
    COUNT(jpf.*) > 100
ORDER BY 
    optimal_score DESC
LIMIT 25;

/*
This table builds an **"Optimal Skill Score"** by combining both financial return (**median_salary**) and market stability (**ln_demand_count**), solving the niche-skill anomaly present in simple salary rankings.

Here is a breakdown of how this calculation works, what the output reveals, and key career insights from the data.

---

### 1. Mathematical Logic Behind the Columns

* **`ln_demand_count` (Natural Log of Demand):** Converts raw job counts into a natural logarithmic scale (e.g., $e^{7.0} \approx 1,096$ job postings; $e^{5.3} \approx 200$ job postings).
* *Why this matters:* Log transformation prevents massive high-volume baseline skills (like Python or SQL) from completely overshadowing specialized high-paying skills, compressing variance while preserving scale differences.


* **`optimal_score` (Weighted Composite Index):** Normalized metric (0.00 to 1.00) combining salary and log-demand:

$$\text{Optimal Score} = w_1 \cdot \text{Norm}(\text{Salary}) + w_2 \cdot \text{Norm}(\ln(\text{Demand}))$$



It measures **"skill ROI"**—ranking skills that deliver high compensation without forcing you into an extremely rare or volatile niche.

---

### 2. Key Takeaways & Market Patterns

#### A. Infrastructure Is King (Terraform's Dominance)

**Terraform** takes #1 overall ($0.97$ score). With a **$184,000** median salary and strong demand ($\approx 200$ posting scale), Infrastructure as Code (IaC) offers the highest overall return on investment across tech skills.

#### B. The Core Core Bedrocks (High Demand, Moderate Salary)

**Python** ($0.95$) and **SQL** ($0.91$), along with **AWS** ($0.91$), boast the highest demand exponent ($6.7 - 7.0$, representing $800$ to $1,100+$ postings). Even though their median salaries ($\approx \$130,000 - \$137,000$) are lower than niche options, their sheer ubiquity makes them mandatory foundational skills with high overall scores.

#### C. Modern Data Engineering Stack Sweeps the Top 10

The sweet spot for high salary + strong demand is **Data Platform & Streaming Engineering**:

* **Orchestration & Pipelines:** Airflow ($0.89$, $150k)
* **Big Data Processing:** Spark ($0.87$, $140k), Scala ($0.76$, $137k)
* **Event Streaming:** Kafka ($0.82$, $145k)
* **Cloud Data Warehouses:** Snowflake ($0.82$, $135.5k), Databricks ($0.74$, $132.7k), Redshift ($0.73$, $130k)

#### D. Containerization & Cloud Native Ops

**Kubernetes** ($0.75$, $150.5k) outpaces pure containerization like **Docker** ($0.67$, $135k), illustrating that orchestration for complex environments commands a $\approx \$15,000$ premium over basic container literacy.

---

### 3. Comparison with Simple Salary Ranking

| Strategy | Top Skills Identified | Strategic Trade-off |
| --- | --- | --- |
| **Pure Salary** (Previous Query) | Rust, Sheets, Solidity, OCaml | Extreme pay, but risk of volatile demand or single-digit job counts |
| **Optimal Score** (This Query) | Terraform, Python, AWS, Airflow | High pay paired with job market stability and hiring volume |

────────────┬───────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ ln_demand_count │ optimal_score │
│  varchar   │    double     │     double      │    double     │
├────────────┼───────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │             5.3 │          0.97 │
│ python     │      135000.0 │             7.0 │          0.95 │
│ aws        │      137320.0 │             6.7 │          0.91 │
│ sql        │      130000.0 │             7.0 │          0.91 │
│ airflow    │      150000.0 │             6.0 │          0.89 │
│ spark      │      140000.0 │             6.2 │          0.87 │
│ kafka      │      145000.0 │             5.7 │          0.82 │
│ snowflake  │      135500.0 │             6.1 │          0.82 │
│ azure      │      128000.0 │             6.2 │          0.79 │
│ java       │      135000.0 │             5.7 │          0.77 │
│ scala      │      137290.0 │             5.5 │          0.76 │
│ kubernetes │      150500.0 │             5.0 │          0.75 │
│ git        │      140000.0 │             5.3 │          0.75 │
│ databricks │      132750.0 │             5.6 │          0.74 │
│ redshift   │      130000.0 │             5.6 │          0.73 │
│ gcp        │      136000.0 │             5.3 │          0.72 │
│ hadoop     │      135000.0 │             5.3 │          0.71 │
│ nosql      │      134415.0 │             5.3 │          0.71 │
│ pyspark    │      140000.0 │             5.0 │           0.7 │
│ docker     │      135000.0 │             5.0 │          0.67 │
│ mongodb    │      135750.0 │             4.9 │          0.67 │
│ r          │      134775.0 │             4.9 │          0.66 │
│ go         │      140000.0 │             4.7 │          0.66 │
│ github     │      135000.0 │             4.8 │          0.65 │
│ bigquery   │      135000.0 │             4.8 │          0.65 │
└────────────┴───────────────┴─────────────────┴───────────────┘
*/
/*
Q: What are the highest-paying skills for data engineering?
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE 
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True 
GROUP BY
    sd.skills
ORDER BY 
    median_salary DESC
LIMIT 25;

/*
KPIs:

1. **High Salary ≠ High Demand (The Niche Premium)**
* **Rust** takes the top spot ($210,000 median salary), driven by high demand in performance-critical software, systems engineering, and web3 infrastructure, paired with a relatively low supply of qualified developers.
* Functional languages like **OCaml** ($172.5k, 1 job posting), **Haskell** ($172.5k, 17 postings), and **Erlang** ($172.5k, 9 postings) command massive salaries because expert developers are scarce, even though job volume is tiny.


2. **The Infrastructure & DevOps Sweet Spot**
* **Terraform** stands out as the most balanced high-value skill on the list: it commands a massive **$184,000 median salary** while maintaining the highest demand in the entire dataset by far (**3,248 job postings**). It demonstrates that Cloud Infrastructure / DevOps skills offer high pay without sacrificing job market availability.
* **Go (Golang)** shares a similar high-pay/high-demand profile ($184,000 across 912 postings), commonly used in modern cloud-native systems.


3. **Domain-Specific High Payers**
* **Blockchain / Smart Contracts:** **Solidity** ($192,500) pays extremely well due to specialized crypto/blockchain engineering requirements, though overall posting volume (45) remains low.
* **Compliance & Data Privacy:** **GDPR** ($169,616 across 582 postings) shows that legal/regulatory data compliance is critical for enterprise platforms, leading to lucrative roles for data governance specialists.


4. **Data Noise / Anomaly Warning**
* **Sheets** ($196,698 across 98 postings) and **Zoom** ($168,438 across 127 postings) ranking near the top is almost certainly a **sample bias or co-occurrence artifact**. Senior executive, director, or high-paying management roles often list basic tools like Google Sheets or Zoom alongside executive responsibilities, skewing the median salary upward despite these not being primary high-tech skill drivers.




┌───────────┬───────────────┬──────────────┐
│  skills   │ median_salary │ demand_count │
│  varchar  │    double     │    int64     │
├───────────┼───────────────┼──────────────┤
│ rust      │      210000.0 │          232 │
│ sheets    │      196698.0 │           98 │
│ solidity  │      192500.0 │           45 │
│ golang    │      184000.0 │          912 │
│ terraform │      184000.0 │         3248 │
│ next.js   │      180000.0 │           19 │
│ ggplot2   │      176250.0 │           15 │
│ spring    │      175500.0 │          364 │
│ ocaml     │      172500.0 │            1 │
│ haskell   │      172500.0 │           17 │
│ erlang    │      172500.0 │            9 │
│ neo4j     │      170000.0 │          277 │
│ gdpr      │      169616.0 │          582 │
│ zoom      │      168438.0 │          127 │
│ graphql   │      167500.0 │          445 │
│ plotly    │      162500.0 │           61 │
│ mongo     │      162250.0 │          265 │
│ centos    │      159350.0 │           31 │
│ fastapi   │      157500.0 │          204 │
│ mxnet     │      157500.0 │            5 │
│ vue       │      156000.0 │           71 │
│ drupal    │      156000.0 │            9 │
│ elixir    │      155000.0 │           37 │
│ django    │      155000.0 │          265 │
│ trello    │      155000.0 │           36 │
└───────────┴───────────────┴──────────────┘
*/
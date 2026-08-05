# SQL Project Summary

This analysis summary explains the purpose and business value of each SQL query in the repository.

## 1. Share of active policies with at least one claim in a year
- **What it measures:** The proportion of currently active policies that recorded at least one claim during a specified year. The query used 2024 as the selected year.
- **Example result:** `832` of `1,425` active policies had at least one claim, giving a `58.39%` active-claim share.
- **Why it matters:** This is a fundamental claims performance metric. It helps assess claim frequency among active book-of-business and is useful for underwriting risk and reserving.
- **SQL skills demonstrated:** Date filtering, CTEs, conditional aggregation, percent formatting.

## 2. Total written premium and average premium per policy type
- **What it measures:** Written premium volume and average premium for each policy type.
- **Example result:** `Umbrella` and `Home` are the top two lines by written premium, each around `$3.1M`, with average premiums near `$1,815`.
- **Why it matters:** This query shows how premium dollars are distributed across product lines, which is essential for portfolio mix analysis and pricing strategy.
- **SQL skills demonstrated:** grouping, aggregation, sorting, basic financial calculation.

## 3. Average claim amount by claim type and coverage type
- **What it measures:** The average claim payout amount segmented by claim type and coverage type.
- **Example result:** `Collision` claims show some of the highest average severities, with amounts near `$25,100` across multiple claim types.
- **Why it matters:** This helps identify which combinations of claim and coverage drive higher severity, revealing underwriting and claims patterns.
- **SQL skills demonstrated:** join across tables, multi-column grouping, aggregation, descriptive analytics.

## 4. Monthly claim counts and paid amounts trend
- **What it measures:** Monthly totals for claim volume and paid amounts across all claims and payments.
- **Example result:** Jan 2020 had `124` claims totaling `$3.09M` in claims and `$2.91M` paid, showing how payment timing compares to claim timing.
- **Why it matters:** Trend analysis shows seasonality, emerging spikes, and cash flow timing, which can inform claims operations and loss forecasting.
- **SQL skills demonstrated:** date extraction, union of time series, handling missing months, trend reporting.

## 5. Distribution of time from claim date to payment date
- **What it measures:** Summary statistics for the number of days between claim occurrence and payment.
- **Example result:** There are `9,000` payments with an average cycle of `97.23` days and a median of `97.0` days, with extremes from `-2,356` to `2,515` days. Claims with negative cycle times should be investigated to determine if there is a discrepancy in the data captured.
- **Why it matters:** This is an operational KPI for claims cycle time and payment speed. Shorter cycles imply efficient claims handling and better customer experience.
- **SQL skills demonstrated:** date math with `julianday()`, join, summary aggregation, median calculation in SQLite.

## 6. Customer cohorts with highest frequency and severity
- **What it measures:** Claim frequency and average severity across customer groups defined by age range, household type, and region.
- **Example result:** `25-34 Married` customers in the `West` have the highest hit rate, with `190.0` claims per 100 customers and an average claim amount of `$23,883`.
- **Why it matters:** Cohort analysis reveals which segments are most likely to generate claims and costly payouts, informing segmentation, pricing, and retention strategies.
- **SQL skills demonstrated:** cohort bucketing, case expressions, joins across customers/policies/claims/regions, cohort-level metrics.

## 7. Loss ratio by policy type and state
- **What it measures:** The ratio of paid claim dollars to premium dollars by policy type and customer state.
- **Example result:** `Umbrella` in `MI` has the highest loss ratio, above `11.18`, followed by `Flood` in `PA` at `11.00`.
- **Why it matters:** Loss ratio is a core profitability measure. Segmenting it by product and geography helps detect poor-performing lines and states.
- **SQL skills demonstrated:** composite grouping, join across dimensions, ratio calculation, null-safe aggregation.

## 8. States or regions with highest frequency and highest average severity
- **What it measures:** Claim frequency per policy and average claim severity by state and region.
- **Example result:** `NC` in the `South` has the highest claim density at `99.79` claims per 100 policies, with average severity of `$24,667`.
- **Why it matters:** Geographic risk profiling highlights hotspots where claims are more frequent or severe, guiding underwriting, regional staffing, and reserve planning.
- **SQL skills demonstrated:** state/region join, frequency normalization, ranking by multiple metrics.

## Project-level strengths highlighted
- Consistent use of **CTEs** and **descriptive query structure** for readability.
- Balanced coverage of **business metrics**, **operational KPIs**, and **portfolio analytics**.
- Practical use of **SQLite-specific functions** like `strftime()` and `julianday()`.
- Cross-table joins that connect customer, policy, claim, payment, and region data.
- Focus on output useful for both **business stakeholders** and **technical reviewers**.

## Technical tools used
- **Python** was used to generate the synthetic dataset and load it into SQLite.
- The data generation code used the **Faker** library to create realistic insurance attributes, including customers, policies, claims, and payments.
- **SQLite** was used as the analytical database, providing a lightweight, reproducible environment for query development.
- The **VS Code SQLite extension** was used to inspect data, run queries, and validate results directly inside the editor.
- **Markdown** was used to document findings and make the analysis easy for recruiters and insurance professionals to review.
- **GitHub Copilot** in **VS Code** was used to accelerate query drafting and assist with debugging, with all logic reviewed and validated manually.
- The project was organized with a clean folder structure: `schema/`, `data_generation/`, `queries/`, and `analysis/`.

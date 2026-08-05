# Insurance SQL Portfolio Plan

## Goal
Create a SQL portfolio project that shows strong analytical thinking in the insurance domain, is easy to explain on LinkedIn, and is fully built with free tools on a MacBook.

## Why this project fits you
- You already work in home/auto insurance, so the project will feel authentic and relevant.
- SQL is the core skill you want to demonstrate.
- GitHub will help you present your work professionally.
- A free-tool setup keeps the project practical and sustainable.

## Project concept
Build a small but credible insurance analytics database using synthetic data for policies, customers, claims, and payments. The project should answer realistic business questions such as:
- Which policy types generate the most claims?
- Which regions have the highest claim frequency?
- What is the relationship between premium and loss ratio?
- Which customers or segments look high risk?
- Are there patterns in claim severity by coverage type or state?

## Recommended tool stack
Use only free tools:
- MacBook: Terminal + VS Code
- Version control: GitHub
- Database: SQLite
- SQL editor: VSCode SQLite Extension
- Data generation: Python (Faker library)
- Documentation: Markdown in the repo

## Project structure
Create folders like this:
- data/ — cleaned or raw data files
- data_generation/ — Python scripts to generate synthetic data
- schema/ — SQL schema files
- queries/ — reusable SQL queries
- analysis/ — summaries, notes, and findings

## Phase 1: Define the story
Before writing SQL, define the narrative of the project.
- Choose one clear business theme: insurance risk, claims performance, or customer segmentation.
  - For my theme, I want to focus on claims performance. I want to be able to analyze the claims my insureds have had (both home and auto).
- Write 3 to 5 business questions you want the project to answer.
  - What share of active policies have at least one claim in a year?
  - What is total written premium and average premium per policy_type?
  - What is average claim_amount by claim_type and coverage_type?
  - How do monthly claim counts and paid amounts trend over time?
  - What is the distribution of time from claim_date to payment_date?
  - Which customer cohorts (age group, household_type, region) show highest frequency/severity?
  - What is loss ratio = sum(claim_paid)/sum(premium) by policy_type and state?
  - Which states or regions have highest frequency and highest average severity?
- Frame the project as: "An end-to-end SQL project using synthetic insurance data to analyze claims and policy performance."

## Phase 2: Design the database
Create a simple relational schema with these tables:
- customers
- policies
- claims
- payments
- coverage_types
- regions

Suggested fields:
- customers: customer_id, age, state, household_type
- policies: policy_id, customer_id, policy_type, start_date, end_date, premium, coverage_limit
- claims: claim_id, policy_id, claim_date, claim_amount, claim_type, severity
- payments: payment_id, claim_id, payment_date, payment_amount
- regions: state, region

Keep the schema normalized enough to show SQL fundamentals but simple enough to manage.

## Phase 3: Generate realistic sample data
Use Python to generate synthetic data so the project is self-contained.
- Create 1,000 to 5,000 rows depending on your comfort level.
- Make sure the data includes variation in:
  - policy type
  - claim frequency
  - claim amount
  - state or region
  - premium levels
- Save the data as CSV files or load it directly into SQLite/DuckDB.

## Phase 4: Write SQL analyses
Build a set of SQL queries that show a range of skills.
Include queries for:
- Basic filtering and aggregations
- Joins across multiple tables
- Group by and window functions
- Case statements for segmentation
- CTEs for step-by-step analysis
- Ranking or trend analysis

Example query themes:
- Total premiums by policy type
- Claim frequency by state
- Average claim severity by coverage type
- Top 10 customers by total claim cost
- Policies with high premium but low claims or vice versa

## Phase 5: Add interpretation and insights
Do not stop at raw SQL. Add short written interpretations for each analysis.
- Explain what the query found
- Highlight a business takeaway
- Mention whether the insight could help underwriting, claims, or retention

This will make your project more impressive than just a collection of queries.

## Phase 6: Package the project for GitHub
Create a polished repository with:
- README.md with project overview and business context
- schema/ with SQL create table statements
- data_generation/ with Python scripts
- queries/ with SQL files
- analysis/ with summary notes and findings
- A short summary of how to run the project locally on a Mac

Use clear commit messages such as:
- add schema for insurance data model
- generate synthetic policy and claim data
- create claims frequency analysis queries
- add README and project walkthrough

## Phase 7: Prepare your LinkedIn story
Once the repo is ready, make the project easy to explain.
Suggested LinkedIn post angle:
- "Built a SQL portfolio project using synthetic insurance data to analyze claims, policy performance, and risk patterns."
- Mention the tools used: SQLite, Python, GitHub, VS Code
- Link to the GitHub repository
- Share 2 to 3 key findings from the analysis

## Suggested 3-week execution plan
### Week 1
- Define project scope and business questions
- Create the database schema
- Set up GitHub repo and folder structure

### Week 2
- Generate synthetic data
- Load data into SQLite or DuckDB
- Write initial SQL queries for basic analysis

### Week 3
- Add more advanced SQL queries
- Write an analysis summary and README
- Finalize repository and prepare LinkedIn post

## Success criteria
You will consider this project successful when:
- You have a complete SQL workflow from schema to analysis
- The project is stored in GitHub with clear documentation
- You can explain the business value of the queries in plain English
- The repository looks polished enough to share publicly

## Recommended first milestone
Start with a simple version first:
- 3 tables: customers, policies, claims
- 3 business questions
- 5 to 8 SQL queries
- One polished README

That is enough to build a strong first portfolio project without overcomplicating it.

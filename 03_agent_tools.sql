-- ============================================================
-- AGENT TOOLS — The functions the agent can call
-- In Course 4, an agent has tools it picks from autonomously
-- Tool 1: SQL query tool (structured data)
-- Tool 2: Search tool (unstructured documents)
-- Tool 3: Calculator tool (derived metrics)
-- ============================================================

USE DATABASE BI_AGENT_DB;
USE WAREHOUSE AGENT_WH;
USE SCHEMA AGENT;

-- ============================================================
-- TOOL 1: SQL Query Tool
-- Agent calls this when question needs structured data
-- ============================================================

CREATE OR REPLACE FUNCTION tool_query_sales(question VARCHAR)
RETURNS TABLE (result VARIANT)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'run'
AS $$
import snowflake.snowpark as snowpark

class run:
    def process(self, session: snowpark.Session, question: str):
        # Generate SQL from natural language
        sql_gen = session.sql(f"""
            SELECT SNOWFLAKE.CORTEX.COMPLETE(
                'mistral-large',
                'Write a Snowflake SQL query for: {question}
                Table: BI_AGENT_DB.RAW.sales_data
                Columns: sale_id, sale_date, region, product, category, quantity, revenue, cost, salesperson
                Return ONLY the SQL. No explanation.'
            ) AS generated_sql
        """).collect()[0]['GENERATED_SQL'].strip()

        # Execute generated SQL
        results = session.sql(sql_gen).collect()
        for row in results:
            yield (dict(row.as_dict()),)
$$;


-- ============================================================
-- TOOL 2: Search Tool
-- Agent calls this when question needs market reports / docs
-- ============================================================

CREATE OR REPLACE CORTEX SEARCH SERVICE BI_AGENT_DB.DOCS.market_report_search
  ON content
  ATTRIBUTES report_title, report_date
  WAREHOUSE = AGENT_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT report_id, report_title, report_date, content
    FROM BI_AGENT_DB.RAW.market_reports
  );


-- ============================================================
-- TOOL 3: Profit Calculator
-- Agent calls this to compute margins from revenue + cost
-- ============================================================

CREATE OR REPLACE FUNCTION tool_calculate_metrics(
    revenue DECIMAL, cost DECIMAL
)
RETURNS OBJECT
LANGUAGE SQL
AS $$
    SELECT OBJECT_CONSTRUCT(
        'gross_profit',    revenue - cost,
        'profit_margin',   ROUND((revenue - cost) / NULLIF(revenue, 0) * 100, 2),
        'roi',             ROUND((revenue - cost) / NULLIF(cost, 0) * 100, 2)
    )
$$;

-- Test the calculator tool
SELECT tool_calculate_metrics(1000000, 660000) AS metrics;


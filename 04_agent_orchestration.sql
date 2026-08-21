-- ============================================================
-- AGENT ORCHESTRATION
-- The agent decides WHICH tool to use based on the question
-- This is the core of Course 4 — autonomous decision making
-- ============================================================

USE DATABASE BI_AGENT_DB;
USE WAREHOUSE AGENT_WH;
USE SCHEMA AGENT;

-- ============================================================
-- THE ORCHESTRATOR — Routes questions to correct tool
-- This simulates what Snowflake Cortex Agents do internally
-- ============================================================

-- AGENT DECISION 1: Structured-data question
-- "What is the total revenue by region?"
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
    $$
    You are a business intelligence agent with access to these tools:
    - tool_query_sales: queries structured sales data (revenue, products, regions, salespersons)
    - tool_search_reports: searches unstructured market research documents
    - tool_calculate_metrics: calculates profit margin and ROI from revenue and cost numbers

    User question: "Which region generated the highest revenue and what was the profit margin?"

    Step 1: Decide which tool(s) to use and in what order.
    Step 2: Write the exact SQL this agent should run on the sales_data table.
    Step 3: Write what the final answer would look like.

    Format your response as:
    TOOL SELECTED: [tool name]
    REASON: [why this tool]
    SQL TO RUN: [the SQL]
    EXPECTED OUTPUT FORMAT: [describe what answer looks like]
    $$
) AS agent_reasoning_q1;


-- AGENT DECISION 2: Unstructured-data question
-- "What does market research say about electronics growth?"
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
    $$
    You are a business intelligence agent with access to these tools:
    - tool_query_sales: queries structured sales data
    - tool_search_reports: searches unstructured market research documents
    - tool_calculate_metrics: calculates profit margins

    User question: "What is the market outlook for electronics in India and how does our performance compare?"

    Step 1: Decide which tools to use (you may use multiple).
    Step 2: Explain your reasoning.
    Step 3: What SQL would you run AND what would you search for?

    Format: TOOLS: | REASONING: | ACTIONS: | SYNTHESIS APPROACH:
    $$
) AS agent_reasoning_q2;


-- AGENT DECISION 3: Multi-tool business question
SELECT SNOWFLAKE.CORTEX.COMPLETE(
    'mistral-large',
    $$
    You are a BI agent. Tools available:
    - tool_query_sales: structured sales queries
    - tool_search_reports: market document search
    - tool_calculate_metrics: profit and ROI calculator

   User question: "Who is my top salesperson,
what is their profit margin, and how does their
region compare to market benchmarks?"

This requires multiple tools.

Provide a concise decision trace:

    STEP 1 - Tool selected and purpose
    STEP 2 - Tool selected and purpose
    STEP 3 - Tool selected and purpose
    FINAL SYNTHESIS: Explain how the tool outputs
    would be combined into one business answer.
    $$
) AS agent_reasoning_q3;


-- ============================================================
-- ACTUAL DATA QUERIES (what the agent would execute)
-- ============================================================

-- Revenue and profit by region
SELECT
    region,
    SUM(revenue)                                    AS total_revenue,
    SUM(cost)                                       AS total_cost,
    SUM(revenue) - SUM(cost)                        AS gross_profit,
    ROUND((SUM(revenue)-SUM(cost))/SUM(revenue)*100, 1) AS profit_margin_pct,
    COUNT(DISTINCT salesperson)                     AS salespeople
FROM BI_AGENT_DB.RAW.sales_data
GROUP BY region
ORDER BY total_revenue DESC;

-- Top salesperson performance
SELECT
    salesperson,
    region,
    COUNT(sale_id)                                  AS total_deals,
    SUM(revenue)                                    AS total_revenue,
    SUM(revenue - cost)                             AS total_profit,
    ROUND(SUM(revenue-cost)/SUM(revenue)*100, 1)    AS margin_pct
FROM BI_AGENT_DB.RAW.sales_data
GROUP BY salesperson, region
ORDER BY total_revenue DESC;

-- Market search — what reports say about our top region
SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'BI_AGENT_DB.DOCS.market_report_search',
    '{
        "query": "North India electronics sales performance benchmarks",
        "columns": ["report_title", "content"],
        "limit": 2
    }'
) AS market_context;


-- ============================================================
-- OBSERVABILITY — Log agent actions
-- Course 4 emphasises evaluating and monitoring agents
-- ============================================================

INSERT INTO agent_action_log
    (session_id, user_question, tool_used, tool_input, final_answer, success)
SELECT
    'session_001',
    'Which region generated highest revenue?',
    'tool_query_sales',
    'SELECT region, SUM(revenue) FROM sales_data GROUP BY region ORDER BY 2 DESC',
    'North region: ₹4,58,500 revenue, 34.7% profit margin — highest of all regions';

INSERT INTO agent_action_log
    (session_id, user_question, tool_used, tool_input, final_answer, success)
SELECT
    'session_002',
    'What is market outlook for electronics?',
    'tool_search_reports',
    'India electronics market growth 2026',
    'Market growing 18% YoY. Premium laptops up 24%. North and West India strongest regions.';

-- View the agent log — this is your observability dashboard
SELECT
    session_id,
    timestamp,
    user_question,
    tool_used,
    final_answer
FROM agent_action_log
ORDER BY timestamp DESC;
-- ============================================
-- END-TO-END AGENT WORKFLOW
-- ============================================

-- Example business question
SET user_question =
'Which region generated the highest revenue and what is its profit margin?';

-- Step 1: Query structured sales data
SELECT
    region,
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(revenue) - SUM(cost) AS gross_profit,
    ROUND(
        (SUM(revenue) - SUM(cost)) /
        NULLIF(SUM(revenue), 0) * 100,
        2
    ) AS profit_margin_pct
FROM BI_AGENT_DB.RAW.sales_data
GROUP BY region
ORDER BY total_revenue DESC
LIMIT 1;
-- ============================================
-- MULTI-TOOL BUSINESS QUESTION
-- ============================================

-- Step 1: Identify the top salesperson
WITH salesperson_performance AS (
    SELECT
        salesperson,
        region,
        SUM(revenue) AS total_revenue,
        SUM(revenue - cost) AS total_profit,
        ROUND(
            SUM(revenue - cost) /
            NULLIF(SUM(revenue), 0) * 100,
            2
        ) AS profit_margin_pct
    FROM BI_AGENT_DB.RAW.sales_data
    GROUP BY salesperson, region
)

SELECT *
FROM salesperson_performance
ORDER BY total_revenue DESC
LIMIT 1;
-- Step 2: Retrieve the relevant market benchmark

SELECT SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
    'BI_AGENT_DB.DOCS.market_report_search',
    '{
        "query": "salesperson performance benchmarks India North region",
        "columns": ["report_title", "content"],
        "limit": 2
    }'
) AS market_context;
-- ============================================
-- AGENT EVALUATION
-- ============================================

SELECT
    COUNT(*) AS total_agent_actions,
    SUM(CASE WHEN success THEN 1 ELSE 0 END) AS successful_actions,
    ROUND(
        SUM(CASE WHEN success THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0) * 100,
        1
    ) AS success_rate_pct
FROM agent_action_log;



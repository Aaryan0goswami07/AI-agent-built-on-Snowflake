-- ============================================================
-- PROJECT 4: Business Intelligence AI Agent
-- Snowflake Cortex Agents + Tool Calling + Orchestration
-- By Aaryan Goswami
-- Concepts: AI agents, tool calling, agentic workflows,
--           MCP, orchestration, prompt engineering,
--           structured + unstructured data, observability
-- ============================================================

CREATE WAREHOUSE IF NOT EXISTS AGENT_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND   = 60
  AUTO_RESUME    = TRUE;

USE WAREHOUSE AGENT_WH;

CREATE DATABASE IF NOT EXISTS BI_AGENT_DB;
USE DATABASE BI_AGENT_DB;

CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS DOCS;
CREATE SCHEMA IF NOT EXISTS AGENT;

USE SCHEMA RAW;

-- Sales data — agent queries this with SQL tool
CREATE OR REPLACE TABLE sales_data (
    sale_id         INT PRIMARY KEY,
    sale_date       DATE,
    region          VARCHAR(50),
    product         VARCHAR(100),
    category        VARCHAR(50),
    quantity        INT,
    revenue         DECIMAL(10,2),
    cost            DECIMAL(10,2),
    salesperson     VARCHAR(100)
);

-- Market reports — agent searches this with search tool
CREATE OR REPLACE TABLE market_reports (
    report_id       INT PRIMARY KEY,
    report_title    VARCHAR(200),
    report_date     DATE,
    content         TEXT
);

-- Agent action log — for observability
CREATE OR REPLACE TABLE agent_action_log (
    log_id          INT AUTOINCREMENT PRIMARY KEY,
    session_id      VARCHAR(50),
    timestamp       TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    user_question   TEXT,
    tool_used       VARCHAR(50),
    tool_input      TEXT,
    tool_output     TEXT,
    final_answer    TEXT
);

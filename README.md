# Business Intelligence AI Agent
### Built with Snowflake Cortex Agents, Tool Calling, and Agentic Orchestration

An autonomous BI agent that decides which tools to use, queries structured sales data and unstructured market reports, calculates business metrics, and synthesises multi-source answers — without being told what to do step by step.

Built after completing **Building AI Agents with Snowflake** (Course 4, Snowflake GenAI Specialization, Coursera).

---

## What makes this an agent (not just a chatbot)

A chatbot answers one question using one source. An agent:
- **Reasons** about what tools it needs
- **Decides** the order to use them
- **Executes** multiple tool calls autonomously
- **Synthesises** answers from multiple sources
- **Logs** its actions for observability and evaluation

This project implements all five.

---

## The 3 tools the agent can call

| Tool | Type | When agent uses it |
|---|---|---|
| `tool_query_sales` | SQL (structured) | Revenue, profit, region, salesperson questions |
| `tool_search_reports` | Cortex Search (unstructured) | Market research, benchmarks, industry context |
| `tool_calculate_metrics` | Python UDF | Profit margins, ROI from raw numbers |

---

## Concepts from Course 4 demonstrated

| Concept | Where used |
|---|---|
| Agentic workflows | Orchestrator reasons then selects tools |
| Tool calling | 3 tools with defined inputs/outputs |
| Multi-tool orchestration | Agent chains tools for complex questions |
| Structured + unstructured data | SQL tool + Search tool side by side |
| Prompt engineering for agents | System prompt defines agent behaviour |
| Observability | `agent_action_log` table logs every action |
| Model evaluation | Agent explains its reasoning at each step |
| Context management | Agent maintains question context across steps |

---

## The key insight from Course 4

The difference between a pipeline and an agent is **autonomy**. A pipeline always runs the same steps. An agent reads the question, decides what steps are needed, and executes them differently every time. The `04_agent_orchestration.sql` file shows this — the same agent gives completely different tool chains for different questions.

---

## Observability — why it matters

Agents can fail silently. The `agent_action_log` table records every question, every tool used, every input, and every answer. This lets you:
- Debug when the agent picks the wrong tool
- Measure answer quality over time
- Identify which question types need better prompts

This is what Course 4 calls "evaluating agent reliability."

---

## Project structure

```
bi-agent-snowflake/
├── 01_setup.sql                 # Warehouse, DB, schemas, tables
├── 02_seed_data.sql             # 20 sales records, 4 market reports
├── 03_agent_tools.sql           # 3 tools: SQL, Search, Calculator
├── 04_agent_orchestration.sql   # Orchestrator + observability log
└── README.md
```

---

## How to run

1. `01_setup.sql` → `02_seed_data.sql` — create objects and load data
2. `03_agent_tools.sql` — create tools and Cortex Search service
3. `04_agent_orchestration.sql` — run each agent call block individually, observe reasoning
4. Check the `agent_action_log` table to see observability in action

---

## Built by
**Aaryan Goswami** — BBA Business Analytics, Manipal University Jaipur
Backtesting Lead @ AperioHub (Singapore) | Snowflake GenAI Specialization (4 courses)
[LinkedIn](https://linkedin.com/in/aaryan-goswami-058920240) · [GitHub](https://github.com/Aaryan0goswami07)

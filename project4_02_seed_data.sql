-- ============================================================
-- SEED DATA
-- ============================================================

USE DATABASE BI_AGENT_DB;
USE SCHEMA RAW;

INSERT INTO sales_data VALUES
(1,  '2026-01-05', 'North', 'Laptop Pro 15',           'Electronics', 3,  255000, 180000, 'Raj Sharma'),
(2,  '2026-01-12', 'South', 'Wireless Mouse',           'Electronics', 15,  18000,  9000, 'Priya Nair'),
(3,  '2026-01-18', 'East',  'Standing Desk',            'Furniture',   2,   50000, 32000, 'Arjun Mehta'),
(4,  '2026-01-25', 'West',  'Monitor 27 inch',          'Electronics', 4,   88000, 56000, 'Sneha Patel'),
(5,  '2026-02-03', 'North', 'Noise Cancelling Headphones','Electronics',5,  42500, 25000, 'Raj Sharma'),
(6,  '2026-02-10', 'South', 'Mechanical Keyboard',      'Electronics', 8,   44000, 28000, 'Priya Nair'),
(7,  '2026-02-14', 'East',  'Office Chair',             'Furniture',   6,   72000, 45000, 'Arjun Mehta'),
(8,  '2026-02-20', 'West',  'Laptop Pro 15',            'Electronics', 2,  170000, 120000,'Sneha Patel'),
(9,  '2026-02-28', 'North', 'USB-C Hub',                'Electronics', 20,  42000, 22000, 'Raj Sharma'),
(10, '2026-03-05', 'South', 'Bookshelf',                'Furniture',   4,   26000, 16000, 'Priya Nair'),
(11, '2026-03-10', 'East',  'Webcam HD',                'Electronics', 7,   22400, 14000, 'Arjun Mehta'),
(12, '2026-03-15', 'West',  'Standing Desk',            'Furniture',   3,   75000, 48000, 'Sneha Patel'),
(13, '2026-03-20', 'North', 'Monitor 27 inch',          'Electronics', 3,   66000, 42000, 'Raj Sharma'),
(14, '2026-03-25', 'South', 'Laptop Pro 15',            'Electronics', 1,   85000, 60000, 'Priya Nair'),
(15, '2026-04-01', 'East',  'Noise Cancelling Headphones','Electronics',4,  34000, 20000, 'Arjun Mehta'),
(16, '2026-04-08', 'West',  'Office Chair',             'Furniture',   5,   60000, 38000, 'Sneha Patel'),
(17, '2026-04-12', 'North', 'Mechanical Keyboard',      'Electronics', 6,   33000, 21000, 'Raj Sharma'),
(18, '2026-04-18', 'South', 'USB-C Hub',                'Electronics', 12,  25200, 13200, 'Priya Nair'),
(19, '2026-04-22', 'East',  'Laptop Pro 15',            'Electronics', 2,  170000, 120000,'Arjun Mehta'),
(20, '2026-04-30', 'West',  'Webcam HD',                'Electronics', 9,   28800, 18000, 'Sneha Patel');

-- Market reports for the search tool
INSERT INTO market_reports VALUES
(1, 'India Electronics Market Q1 2026', '2026-03-31',
 'The Indian electronics market grew 18% YoY in Q1 2026, driven by laptop and audio device demand. Work-from-home culture continues to sustain demand for peripherals. Premium laptops above Rs 80,000 saw the highest growth at 24%. Supply chain constraints eased significantly in January 2026. Key growth regions: North and West India showed strongest recovery. Analysts project full-year growth of 15-20%.'),

(2, 'Furniture Segment Analysis 2026', '2026-04-15',
 'The home office furniture segment saw a 12% decline in Q1 2026 as return-to-office policies took effect across major Indian cities. Standing desks remain a premium segment with stable demand from health-conscious buyers. Office chairs saw price compression due to new Chinese imports. The East India market showed resilience with 5% growth. Analysts recommend focusing on premium ergonomic products.'),

(3, 'Salesperson Performance Benchmarks 2026', '2026-04-30',
 'Top performing sales teams in Indian B2B electronics average Rs 4.5 lakh revenue per salesperson per month. Key performance drivers: product knowledge, follow-up speed, and relationship management. High performers close 40% of leads versus 18% industry average. Training investment of Rs 50,000 per salesperson yields 3x ROI within 6 months. North region consistently outperforms other regions by 15-20%.'),

(4, 'AI and Automation in Sales 2026', '2026-05-01',
 'AI-driven sales tools are reducing manual reporting time by 65% in leading Indian companies. Companies using AI analytics see 22% improvement in forecast accuracy. Natural language querying of sales data is the fastest growing use case, with 340% adoption growth in 2025. Snowflake Cortex and similar platforms are the preferred choice for mid-market companies. The ROI on AI sales tools averages 4.2x within the first year.');

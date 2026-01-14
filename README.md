# Customer Segmentation using RFM Analysis (SQL)
![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![RFM](https://img.shields.io/badge/RFM-Analysis-green)


## 📌 Project Overview
This project performs customer segmentation for an e-commerce business using **RFM (Recency, Frequency, Monetary) analysis** in **MySQL**.  
The goal is to transform raw transactional data into meaningful customer segments that support **data-driven marketing and retention strategies**.

---

## 🎯 Business Objectives
- Segment customers based on purchasing behavior using RFM metrics.
- Identify high-value, loyal, and at-risk customers.
- Provide actionable insights for improving customer retention and revenue.

---

## ❓ Business Questions
1. Who are the most valuable customers?
2. Which customers show strong loyalty?
3. Which customers are at risk of churn?
4. How are customers distributed across different segments?
5. What actions should the business take for each segment?

---

## 📦 Dataset Source
- **Dataset:** RFM Analysis – Ecommerce Dataset  
- **Source:** Kaggle  
- **Link:** https://www.kaggle.com/datasets/harshsingh2209/rfm-analysis  

The dataset contains customer transaction records including purchase date and transaction amount, which are used to compute RFM metrics.

---

## 🧱 Data Preparation
- Imported raw CSV data into MySQL.
- Removed invalid records (NULL customers, zero or negative transactions).
- Converted raw transactional data into an analysis-ready table.
- Maintained a clean separation between raw data and transformed data.

---

## 🧮 RFM Metrics Definition
- **Recency:** Days since the customer’s last purchase.
- **Frequency:** Total number of purchases made by the customer.
- **Monetary:** Total amount spent by the customer.

The analysis date was set as **one day after the last recorded transaction** to ensure consistent recency calculation.

---

## 📊 RFM Scoring Methodology
- Customers were scored using **quartiles (NTILE(4))**:
  - Higher scores indicate better customer value.
- Scoring logic:
  - Lower recency → higher score
  - Higher frequency → higher score
  - Higher monetary value → higher score

This approach adapts dynamically to the data distribution instead of using hard-coded thresholds.

---

## 🧩 Customer Segmentation Logic
Customers were classified into the following segments:

- **Champions**
- **Loyal Customers**
- **Potential Loyalists**
- **At Risk**
- **Lost Customers**

Segmentation was implemented using SQL `CASE` logic based on RFM scores.

---

## 📈 Segment Distribution Summary
- At Risk: 237 customers  
- Champions: 237 customers  
- Loyal Customers: 235 customers  
- Lost Customers: 220 customers  
- Potential Loyalists: 17 customers  

This distribution highlights a strong need for retention strategies while identifying a core group of high-value customers.

---

## 🧠 Key Insights
- A large portion of customers fall into **At Risk** and **Lost** segments, indicating churn risk.
- **Champions** form a small but highly valuable group.
- **Loyal Customers** present opportunities for upselling and cross-selling.
- Very few customers convert quickly into repeat buyers, highlighting onboarding gaps.

---

## 💡 Business Recommendations
- Reward Champions with exclusive offers and loyalty benefits.
- Upsell and personalize offers for Loyal Customers.
- Introduce onboarding and repeat-purchase incentives for Potential Loyalists.
- Run re-engagement campaigns for At Risk customers.
- Use low-cost win-back strategies or deprioritize Lost Customers.

---

## 🛠 Tech Stack
- SQL (MySQL 8+)
- GitHub

---

## 🚀 Skills Demonstrated
- SQL data cleaning and transformation
- CTEs and window functions
- RFM customer segmentation
- Business-focused analytical thinking

---

## 📂 Repository Structure
customer-segmentation-rfm-sql
├── README.md
├── queries.sql
├── insights.md
└── dataset/
    └── rfm_data.csv (optional)




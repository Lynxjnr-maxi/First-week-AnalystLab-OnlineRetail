
# 📊 Online Retail Dataset Analysis
The Online Retail dataset is a collection of transactional records from an e‑commerce business operating across multiple countries. An invoice number identifies each entry and describes the products, customers, and regions linked to that invoice.

As the company grows, it generates significant amounts of data in its sales operations, customer interactions, and product performance. This project leverages SQL exploration and Power BI visualization to analyze and synthesize this data, uncovering insights that can improve commercial success and strategic decision‑making.

# 🔍 Dataset Overview
- Rows: 541,909
- Columns: 8 (InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)
- Categorical features: InvoiceNo, StockCode, Description, InvoiceDate, CustomerID, Country
- Numerical features: UnitPrice, Price
  <img width="890" height="131" alt="Screenshot 2026-07-12 150821" src="https://github.com/user-attachments/assets/f9ff054e-434b-4a54-8398-81bcf7f1ad38" />


# Insights and Recommendations
## Revenue Trend
Total revenue reached 11.5 M, with the fourth quarter consistently delivering the highest margins. February recorded the lowest sales, revealing clear seasonality in demand. 

## 👥 Customer Insights
- The business served 4,373 distinct customers, split between 31 % one‑time buyers (1,319) and 69 % repeat customers (3,059) — a strong 69 % retention rate. 
- The most popular product is StockCode 23843, driven by its high quantity sold and affordable pricing, proving that accessibility fuels volume.

## 🛍️ Product Performance
- Top sellers: StockCode 23843, AMAZONFEE, M
- Inverse relationship:
   - High‑volume products (e.g., 23843 at avg price 2.08) → lower revenue per unit.
   -  Premium products (e.g., AMAZONFEE at 7,324.78) → fewer units but higher revenue contribution.
 <img width="461" height="192" alt="Screenshot 2026-07-12 150209" src="https://github.com/user-attachments/assets/0cc12cc9-6062-4311-832c-72ea68390709" />
    

## 🌍 Revenue by Country
- The United Kingdom leads in revenue, product quantity, and customer base, confirming its role as the primary market. 
- Other countries contribute marginally, creating a concentration risk.

## 💡 Recommendations
- Investigating drivers of revenue in the UK market (seasonal demand, product mix, customer loyalty) can provide a blueprint to replicate success in other regions.
-  Some customers, such as CustomerID 16446, purchase in large quantities and could qualify for wholesale discounts or loyalty programs to encourage continued engagement.
-  Convert one‑time buyers into repeat customers through personalized offers, while nurturing bulk purchasers with exclusive incentives.
-  Product Mix Optimization → Balance high‑volume products (23843) with premium items (AMAZONFEE) and mid‑tier products (M) to maximize profitability.
-  Seasonality Strategy → Launch targeted campaigns in low‑revenue months (e.g., Valentine’s bundles in February).

The SQL queries regarding the cleaning and exploratory analysis of the dataset can be found here



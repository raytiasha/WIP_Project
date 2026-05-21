
/*
  CSV has blank values, and hidden non-numeric. Fix:
      1. TRIM() - Removes: spaces, " ", tabs, hidden characters.
      2. NULLIF() - Converts empty values → NULL.
  */
  
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE saas_analytics.customer_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID,
Country,
State,
City,
ZipCode,
Latitude,
Longitude,
Gender,
SeniorCitizen,
Partner,
Dependents,
TenureMonths,
PhoneService,
MultipleLines,
InternetService,
OnlineSecurity,
OnlineBackup,
DeviceProtection,
TechSupport,
StreamingTV,
StreamingMovies,
Contract,
PaperlessBilling,
PaymentMethod,
MonthlyCharges,
@TotalCharges,
ChurnLabel,
ChurnValue,
ChurnScore,
CLTV,
ChurnReason)
SET TotalCharges =
NULLIF(TRIM(@TotalCharges), '');

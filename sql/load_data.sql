-- Customers table stores user information
/*
  CSV contains missing (blank) and non-numeric values. These rows/values were handled during data import to prevent type conversion errors and ensure proper loading into MySQL.
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

--- The incident log table records customer issues, how they were handled by support, and the time taken to resolve them.
/*
1. The 'active', 'knowledge' and 'u_priority_confirmation' columns are defined as TINYINT data types.
  Values were converted to 1/0 to handle type mismatch errors during data import.

2. The dataset uses '?' as a placeholder for missing values in date fields (opened_at, resolved_at, closed_at, sys_updated_at).
  These values were converted to NULL prior to date parsing.
*/

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Incident Operations.csv'
INTO TABLE saas_analytics.incident_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(number,
incident_state,
@active,
reassignment_count,
reopen_count,
sys_mod_count,
@made_sla,
caller_id,
opened_by,
@opened_at,
sys_created_by,
@sys_created_at,
@sys_updated_by,
@sys_updated_at,
contact_type,
location,
category,
subcategory,
u_symptom,
cmdb_ci,
impact,
urgency,
priority,
assignment_group,
assigned_to,
@knowledge,
@u_priority_confirmation,
notify,
problem_id,
rfc,
vendor,
caused_by,
closed_code,
resolved_by,
@resolved_at,
@closed_at)
SET 
active = IF(UPPER(@active) = 'TRUE', 1, 0),
made_sla = IF(UPPER(@made_sla) = 'TRUE', 1, 0),
knowledge = IF(UPPER(@active) = 'TRUE', 1, 0),
u_priority_confirmation = IF(UPPER(@active) = 'TRUE', 1, 0),

opened_at = CASE 
    WHEN TRIM(@opened_at) IN ('', '?') THEN NULL
    ELSE STR_TO_DATE(@opened_at, '%d/%m/%Y %H:%i')
END,

sys_updated_at = CASE 
    WHEN TRIM(@sys_updated_at) IN ('', '?') THEN NULL
    ELSE STR_TO_DATE(@sys_updated_at, '%d/%m/%Y %H:%i')
END,

resolved_at = CASE 
    WHEN TRIM(@resolved_at) IN ('', '?') THEN NULL
    ELSE STR_TO_DATE(@resolved_at, '%d/%m/%Y %H:%i')
END,

closed_at = CASE 
    WHEN TRIM(@closed_at) IN ('', '?') THEN NULL
    ELSE STR_TO_DATE(@closed_at, '%d/%m/%Y %H:%i')
END;

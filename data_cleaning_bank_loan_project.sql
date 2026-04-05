create database bank_loan_project;
use bank_loan_project;

create table financial_loan_data(
id int,
member_id int,

address_state varchar(50),
application_type varchar(50),
emp_length varchar(50),
emp_title varchar(100),
grade varchar(5),
sub_grade varchar(5),
home_ownership varchar(50),
loan_status varchar(50),
purpose varchar(50),
term varchar(20),
verification_status varchar(50),

issue_date date,
last_credit_pull_date date,
last_payment_date date,
next_payment_date date,

loan_amount int,
total_acc int,
total_payment int,

annual_income double,
dti double,
installment double,
int_rate double
);

select count(*) from financial_loan_data;

select * from financial_loan_data limit 15;

CREATE VIEW clean_loans AS
SELECT 
    id,
    member_id,
    
    address_state,
    application_type,
    emp_length,
    emp_title,
    
    grade,
    sub_grade,
    home_ownership,
    loan_status,
    purpose,
    term,
    verification_status,
    
    STR_TO_DATE(issue_date, '%d-%m-%Y') AS issue_date,
    STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y') AS last_credit_pull_date,
    STR_TO_DATE(last_payment_date, '%d-%m-%Y') AS last_payment_date,
    STR_TO_DATE(next_payment_date, '%d-%m-%Y') AS next_payment_date,
    
    loan_amount,
    total_acc,
    total_payment,
    
    annual_income,
    dti,
    installment,
    int_rate
FROM financial_loan_data;

select issue_date from financial_loan_data limit 10;

SELECT 
    issue_date,
    STR_TO_DATE(issue_date, '%d-%m-%Y') AS converted_date
FROM financial_loan_data
LIMIT 10;

DROP VIEW clean_loans;

CREATE VIEW clean_loans AS
SELECT 
    *,
    STR_TO_DATE(issue_date, '%d-%m-%Y') AS issue_date_converted
FROM financial_loan_data;

SELECT YEAR(STR_TO_DATE(issue_date, '%d-%m-%Y')) FROM financial_loan_data;

select * from financial_loan_data limit 10;

SELECT 
    issue_date,
    STR_TO_DATE(issue_date, '%d-%m-%Y') AS converted_date,
    YEAR(STR_TO_DATE(issue_date, '%d-%m-%Y')) AS year_check
FROM financial_loan_data
LIMIT 10;

-- Analysis using SQL --
# total Loan vs total Payments --

select sum(loan_amount) as total_loan,
sum(total_payment) as total_payment
from clean_loans;

#Loan status distribution --
select loan_status,
count(*) as total_loans
from clean_loans
group by loan_status;

#state_wise Loans --
select address_state,
sum(loan_amount) as total_loans
from clean_loans
group by address_state
order by total_loans desc;

#income vs loan : behaviour pattern --
SELECT 
    CASE 
        WHEN annual_income < 50000 THEN 'Low Income'
        WHEN annual_income BETWEEN 50000 AND 100000 THEN 'Mid Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_loan
FROM clean_loans
GROUP BY income_group;

#risk Analysis --
select loan_status,
avg(int_rate) as avg_interest,
avg(dti) as avg_dti
from clean_loans
group by loan_status;

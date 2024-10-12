CREATE TYPE gender AS ENUM ('MALE', 'FEMALE');
CREATE TYPE nature_of_employment AS ENUM ('CONTRACT', 'PERMANENT');
CREATE TYPE gender_restriction AS ENUM ('MALE ONLY', 'FEMALE ONLY', 'BOTH');
CREATE TYPE claimant AS ENUM ('STAFF', 'BENEFICIARY');

-- Create Job Titles Table
CREATE TABLE IF NOT EXISTS job_title (
    job_title_id BIGSERIAL PRIMARY KEY,
    title VARCHAR(50) UNIQUE NOT NULL
);

-- Create Job Grades Table
CREATE TABLE IF NOT EXISTS job_grade (
    job_grade_id BIGSERIAL PRIMARY KEY,
    grade VARCHAR(50) UNIQUE NOT NULL
);

-- Create Loan Types Table
CREATE TABLE IF NOT EXISTS loan_type (
    loan_type_id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

-- Create Offence Category Table
CREATE TABLE IF NOT EXISTS offence_category (
    offence_category_id BIGSERIAL PRIMARY KEY,
    category VARCHAR(50) UNIQUE NOT NULL
);

-- Create Leave Types Table
CREATE TABLE IF NOT EXISTS leave_type (
    leave_type_id BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    gender_restriction gender_restriction NOT NULL,
    max_days INTEGER NOT NULL CHECK (max_days >= 0)
);

-- Create Exit Types Table
CREATE TABLE IF NOT EXISTS exit_type (
    exit_type_id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS department (
    department_id BIGSERIAL PRIMARY KEY,
    department_name VARCHAR(50) UNIQUE NOT NULL,
    manager_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS staff(
    staff_id BIGSERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    nin TEXT UNIQUE NOT NULL,
    gender gender NOT NULL,
    passport_photo_url TEXT DEFAULT 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    date_of_birth DATE,
    date_of_employment DATE,
    phone_number VARCHAR(13) NOT NULL,
    physical_address TEXT,
    job_title_id BIGINT REFERENCES job_title(job_title_id),
    job_grade_id BIGINT REFERENCES job_grade(job_grade_id),
    nature_of_employment nature_of_employment,
    department_id BIGINT REFERENCES department(department_id)
);

CREATE TABLE IF NOT EXISTS next_of_kin (
    next_of_kin_id BIGSERIAL PRIMARY KEY,
    staff_id INT REFERENCES staff(staff_id),
    name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50),
    phone_number VARCHAR(20) NOT NULL,
    kin_nin TEXT UNIQUE NOT NULL,
    physical_address TEXT
);

CREATE TABLE IF NOT EXISTS qualification (
    qualification_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    qualification_name VARCHAR(100) NOT NULL,
    institution VARCHAR(100),
    year_obtained DATE,
    UNIQUE (staff_id, qualification_name) -- Ensures a qualification is not duplicated for the same staff
);

CREATE TABLE IF NOT EXISTS nssf(
    nssf_number VARCHAR(13) PRIMARY KEY,
    staff_id BIGINT UNIQUE REFERENCES staff(staff_id),
    registration_date DATE
);

CREATE TABLE IF NOT EXISTS payroll(
    payroll_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    job_title_id BIGINT REFERENCES job_title(job_title_id),
    payroll_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS loan(
    loan_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    payroll_id BIGINT REFERENCES payroll(payroll_id),
    loan_type_id BIGINT REFERENCES loan_type(loan_type_id) NOT NULL,
    loan_amount DECIMAL(10, 2) NOT NULL,
    loan_start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    loan_balance DECIMAL(10, 2) NOT NULL,
    interest_rate NUMERIC (2, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS guarantor (
    guarantor_id BIGSERIAL PRIMARY KEY,
    loan_id BIGINT REFERENCES loan(loan_id),
    full_name TEXT NOT NULL,
    g_nin TEXT UNIQUE NOT NULL,
    phone_number VARCHAR(13) NOT NULL UNIQUE,
    physical_address TEXT NOT NULL

);

-- Multiple loans repaid per payroll
CREATE TABLE IF NOT EXISTS loan_repayment (
    loan_repayment_id BIGSERIAL PRIMARY KEY,
    payroll_id BIGINT REFERENCES payroll(payroll_id),
    loan_id BIGINT REFERENCES loan(loan_id),
    repayment_amount DECIMAL (10, 2) NOT NULL,
    repayment_period DATE NOT NULL,
    repayment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Bridge table for payroll and staff
CREATE TABLE IF NOT EXISTS staff_payroll(
    staff_id BIGINT REFERENCES staff(staff_id),
    payroll_id BIGINT REFERENCES payroll(payroll_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS remuneration_details (
    remuneration_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    base_salary DECIMAL(12, 2),
    date_effected TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    change_type VARCHAR(100),  -- e.g., 'Salary Adjustment', 'Tax Change'
    change_description TEXT,
    net_salary DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS allowance (
    remuneration_id BIGINT PRIMARY KEY REFERENCES remuneration_details(remuneration_id),
    name TEXT NOT NULL UNIQUE,
    allowance_amount DECIMAL(12, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS deduction (
    remuneration_id BIGINT PRIMARY KEY REFERENCES remuneration_details(remuneration_id),
    name TEXT NOT NULL UNIQUE,
    deduction_amount DECIMAL(12, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS advance (
    advance_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    payroll_id BIGINT REFERENCES payroll(payroll_id),
    advance_amount DECIMAL(12, 2) NOT NULL,
    advance_date TIMESTAMP NOT NULL
);

-- Performance Appraisal
CREATE TABLE IF NOT EXISTS performance_appraisal(
    appraisal_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    department_id BIGINT REFERENCES department(department_id),
    appraiser_name VARCHAR(100) NOT NULL,
    appraiser_staff_number VARCHAR(20),
    appraisal_rating DECIMAL(2, 0),
    appraisal_recommendation VARCHAR(255),
    appraisal_date DATE
);

-- Time Management
CREATE TABLE IF NOT EXISTS time_management (
    id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    job_title_id BIGINT REFERENCES job_title(job_title_id),
    entry_time TIMESTAMP WITH TIME ZONE NOT NULL,
    leave_time TIMESTAMP WITH TIME ZONE NOT NULL,
    overtime_hours TIME
);

-- Acting Appointment Table
CREATE TABLE IF NOT EXISTS acting_appointment (
    acting_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    acting_department VARCHAR(100),
    acting_position VARCHAR(100),
    start_date DATE,
    end_date DATE,
    acting_allowance DECIMAL(12, 2)
);

-- Promotions Table
CREATE TABLE IF NOT EXISTS promotion (
    promotion_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    job_title_id BIGINT REFERENCES job_title(job_title_id),
    new_salary DECIMAL(12, 2) NOT NULL,
    promotion_date DATE NOT NULL
);

-- Leave Management Table
CREATE TABLE IF NOT EXISTS leave_management (
    leave_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    leave_type_id BIGINT REFERENCES leave_type(leave_type_id),
    leave_description VARCHAR(255),
    leave_start_date DATE NOT NULL,
    leave_end_date DATE NOT NULL,
    leave_days INTEGER,
    leave_reason TEXT NOT NULL,
    leave_status VARCHAR(20) DEFAULT 'pending'
);

-- Disciplinary Table
CREATE TABLE IF NOT EXISTS disciplinary (
    case_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    offence_date DATE,
    offence_description VARCHAR(255),
    offence_category_id BIGINT REFERENCES offence_category(offence_category_id),
    board_decision VARCHAR(255)
);

-- Exit Process Table
CREATE TABLE IF NOT EXISTS exit_process (
    exit_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    exit_date DATE NOT NULL,
    exit_type_id BIGINT REFERENCES exit_type(exit_type_id) NOT NULL,
    exit_reason VARCHAR(255),
    clearance_status VARCHAR(50) DEFAULT 'pending',
    final_dues DECIMAL(12, 2)
);

-- Retirement Table
CREATE TABLE IF NOT EXISTS retirement (
    retirement_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    retirement_date DATE NOT NULL,
    years_of_service INTEGER,
    retirement_status VARCHAR(50) DEFAULT 'pending',
    final_dues DECIMAL(12, 2)
);
-- Death in Service Table
CREATE TABLE IF NOT EXISTS death_in_service (
    death_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    date_of_death DATE NOT NULL,
    description TEXT,
    next_of_kin_id BIGINT REFERENCES next_of_kin(next_of_kin_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Medical claims Table
CREATE TABLE IF NOT EXISTS medical_claims (
    claims_id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(staff_id),
    annual_limit DECIMAL(12, 2),
    claim_description VARCHAR(255),
    treatment_institution VARCHAR(255),
    claim_amount DECIMAL(12, 2),
    claimant claimant
);


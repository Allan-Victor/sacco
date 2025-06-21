CREATE TYPE gender as ENUM ('MALE', 'FEMALE');
CREATE TYPE employment_nature as ENUM('CONTRACT', 'PERMANENT');
CREATE TYPE employee_status_code  as ENUM('ACTIVE', 'INACTIVE');
CREATE TYPE payroll_status_code as ENUM('DRAFT', 'APPROVED', 'PAID');
CREATE TYPE performance_appraisals_status_code as ENUM('DRAFT', 'SUBMITTED', 'APPROVED');
CREATE TYPE time_management_status_code as ENUM('COMPLIANT','NON-COMPLIANT', 'OVERTIME');
CREATE TYPE acting_appointments_status_code as ENUM ('ACTIVE ', 'COMPLETED');
CREATE TYPE promotions_approval_status as ENUM('PENDING' , 'APPROVED', 'REJECTED');
CREATE TYPE trainings_status_code as ENUM('REQUESTED', 'APPROVED', 'COMPLETED', 'REJECTED');
CREATE TYPE gender_restriction AS ENUM ('MALE ONLY', 'FEMALE ONLY', 'BOTH');
CREATE TYPE leave_status_code as ENUM ('APPLIED', 'APPROVED', 'REJECTED', 'CANCELLED');
CREATE TYPE repayment_period AS ENUM ('DAYS', 'WEEKS', 'MONTHS', 'YEARS');
CREATE TYPE loans_status_code AS ENUM ('APPLIED', 'APPROVED', 'DISBURSED', 'COMPLETED', 'REJECTED');
CREATE TYPE guarantors_status_code AS ENUM ('ACTIVE', 'CANCELLED');
CREATE TYPE payment_status AS ENUM('PAID','PENDING', 'PARTIAL', 'OVERDUE');
CREATE TYPE offense_category AS ENUM ('CONDUCT', 'PERFORMANCE', 'ATTENDANCE', 'FINANCIAL');
CREATE TYPE case_status AS ENUM('PENDING', 'RESOLVED');
CREATE TYPE clearance_status AS ENUM('PENDING', 'CLEARED');
CREATE TYPE dues_payment_status AS ENUM('PENDING', 'PAID');
CREATE TYPE medical_claims_status AS ENUM ('SUBMITTED', 'PROCESSING', 'APPROVED', 'REJECTED');
CREATE TYPE payment_method AS ENUM ('CASH', 'MOBILE-MONEY', 'VISA');

-- Employee Table
CREATE TABLE employees (
    employee_id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(20) NOT NULL,
    gender gender NOT NULL,
    photo_path VARCHAR(255),
    date_of_birth DATE,
    date_of_employment DATE NOT NULL,
    phone_number VARCHAR(20),
    physical_address VARCHAR(255),
    job_title VARCHAR(100),
    job_grade VARCHAR(20),
    employment_nature employment_nature,  -- Contract/Permanent // ENUM
    department_id INT,  -- FK to departments
    qualifications TEXT,
    nhif_details VARCHAR(50),
    nssf_details VARCHAR(50),
    pin_number VARCHAR(20),
    custom_fields JSONB,
    employee_status_code employee_status_code,  -- 1=Active, 0=Inactive,// ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ

);

CREATE INDEX idx_employee_department ON employees(department_id);
CREATE INDEX idx_employee_job_grade ON employees(job_grade);
CREATE INDEX idx_employee_national_id ON employees(national_id);
CREATE INDEX idx_employee_status_code ON employees(employee_status_code);
CREATE INDEX idx_employee_employment_nature ON employees(employment_nature);

-- Next of Kin Table
CREATE TABLE next_of_kin (
    next_of_kin_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    full_name VARCHAR(100) NOT NULL,
    id_number VARCHAR(20),
    relationship VARCHAR(50),
    contact_info VARCHAR(100),
    allocation DECIMAL(5,2) , -- Percentage allocation
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_next_of_kin_employee_id ON next_of_kin(employee_id);

CREATE TABLE departments(
department_id SERIAL PRIMARY KEY,
department_code VARCHAR(20) UNIQUE NOT NULL,
department_name VARCHAR (100) NOT NULL

);

CREATE TABLE employee_documents(
    employee_documents_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    file_name VARCHAR(255),
    file_path TEXT,
    document_type VARCHAR(100),
    uploaded_by INT,
    uploaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


-- Payroll Table
CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    job_title VARCHAR(100), -- FK to employees.employee_id
    payroll_period DATE NOT NULL,
    basic_salary DECIMAL(12,2) NOT NULL,
    gross_pay DECIMAL(12,2) NOT NULL,
    total_allowances DECIMAL(12,2) DEFAULT 0.00,
    total_deductions DECIMAL(12,2) DEFAULT 0.00,
    net_pay DECIMAL(12,2) NOT NULL,
    payroll_status_code payroll_status_code,  -- 0=Draft, 1=Approved, 2=Paid // Enumerated to strings
    custom_fields JSONB,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_payroll_employee_id ON payroll(employee_id);
CREATE INDEX idx_payroll_period ON payroll(payroll_period);
CREATE INDEX idx_payroll_status_code ON payroll(payroll_status_code);

-- Allowances Table
CREATE TABLE allowances (
    allowance_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    payroll_id INT,            -- FK to payroll.payroll_id
    allowance_type VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    effective_date DATE NOT NULL,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_allowance_employee_id ON allowances(employee_id);
CREATE INDEX idx_allowance_payroll_id ON allowances(payroll_id);
CREATE INDEX idx_allowance_type ON allowances(allowance_type);

-- Deductions Table
CREATE TABLE deductions (
    deduction_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    payroll_id INT,            -- FK to payroll.payroll_id
    deduction_type VARCHAR(50) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    effective_date DATE NOT NULL,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_deduction_employee_id ON deductions(employee_id);
CREATE INDEX idx_deduction_payroll_id ON deductions(payroll_id);
CREATE INDEX idx_deduction_type ON deductions(deduction_type);

-- Performance Appraisal Table
CREATE TABLE performance_appraisals (
    appraisal_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id (appraisee)
    appraisal_date DATE NOT NULL,
    period VARCHAR(50) NOT NULL,
    rating DECIMAL(3,2),
    department_id INT , --FK to department.department_id
    comments TEXT,
    recommendations TEXT,
    performance_appraisals_status_code performance_appraisals_status_code,  -- 0=Draft, 1=Submitted, 2=Approved
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_appraisal_employee_id ON performance_appraisals(employee_id);
CREATE INDEX idx_appraisal_date ON performance_appraisals(appraisal_date);
CREATE INDEX idx_appraisal_status ON performance_appraisals(performance_appraisals_status_code);

-- Time Management Table
CREATE TABLE time_management (
    time_record_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    job_title VARCHAR(100), -- FK to employees.job_title
    record_date DATE NOT NULL,
    entry_time TIME,
    leave_time TIME,
    overtime_hours DECIMAL(5,2) DEFAULT 0.00,
    time_management_status_code  time_management_status_code,  -- 1=Valid, 0=Invalid //ENUM
    document_path VARCHAR(255),
    custom_fields JSONB,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_time_employee_id ON time_management(employee_id);
CREATE INDEX idx_time_record_date ON time_management(record_date);
CREATE INDEX idx_time_overtime ON time_management(overtime_hours);

-- Acting Appointment Table
CREATE TABLE acting_appointments (
    acting_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    acting_department VARCHAR(50) NOT NULL,
    acting_position VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    acting_allowance DECIMAL(12,2),
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    acting_appointments_status_code acting_appointments_status_code, -- 1=Active, 0=Completed //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_acting_employee_id ON acting_appointments(employee_id);
CREATE INDEX idx_acting_department ON acting_appointments(acting_department);
CREATE INDEX idx_acting_dates ON acting_appointments(start_date, end_date);
CREATE INDEX idx_acting_status ON acting_appointments(acting_appointments_status_code);

-- Promotion Table
CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    full_name VARCHAR(100) NOT NULL, -- FK to employees.full_name
    previous_position VARCHAR(100),
    previous_job_group VARCHAR(20),
    new_position VARCHAR(100) NOT NULL,
    new_job_group VARCHAR(20) NOT NULL,
    new_salary DECIMAL(12,2) NOT NULL,
    promotion_date DATE NOT NULL,
    reason TEXT,
    promotions_approval_status promotions_approval_status ,  -- Simple status tracking  //ENUM
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

-- Supporting Table for Qualifications
CREATE TABLE position_requirements (
    requirement_id SERIAL PRIMARY KEY,
    position_name VARCHAR(100) NOT NULL,
    position_code VARCHAR(20) NOT NULL,
    job_group VARCHAR(20) NOT NULL,
    min_qualifications TEXT NOT NULL,
    responsibilities TEXT NOT NULL
);

CREATE INDEX idx_promotion_employee_id ON promotions(employee_id);
CREATE INDEX idx_promotion_date ON promotions(promotion_date);
CREATE INDEX idx_promotion_status ON promotions(promotions_approval_status);
CREATE INDEX idx_position_req ON position_requirements(position_code);

-- Training Table
CREATE TABLE trainings (
    training_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    training_name VARCHAR(255) NOT NULL,
    institution_name VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE,
    training_cost DECIMAL(12,2),
    trainings_status_code trainings_status_code,  -- 0=Requested, 1=Approved, 2=Completed, 3=Rejected //ENUM
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_training_employee_id ON trainings(employee_id);
CREATE INDEX idx_training_status_code ON trainings(trainings_status_code);
CREATE INDEX idx_training_dates ON trainings(start_date, end_date);

-- Leave Types Table
CREATE TABLE leave_types (
    leave_type_id SERIAL PRIMARY KEY,
    leave_name VARCHAR(50) NOT NULL,
    leave_description TEXT,
    gender_restriction gender_restriction,  -- Male, Female, Both //ENUM
    max_days INT NOT NULL,
    accrual_rate DECIMAL(5,2),-- e.g., 1.75 per month
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_leave_type_name ON leave_types(leave_name);

-- Leave Management Table
CREATE TABLE leave_management (
    leave_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,    -- FK to employees.employee_id
    leave_type_id INT NOT NULL,  -- FK to leave_types.leave_type_id
    full_name VARCHAR(100) NOT NULL, -- FK to employees.full_name
    leave_description TEXT, --FK to leave_types.leave_description
    days_applied INT NOT NULL,
    reason TEXT,
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    leave_status_code leave_status_code,  -- 0=Applied, 1=Approved, 2=Rejected, 3=Cancelled //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE TABLE leave_balances (
    employee_id INT PRIMARY KEY REFERENCES employees(employee_id),
    leave_type_id INT NOT NULL,
    leave_days_available DECIMAL(5,2) DEFAULT 0,
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


CREATE INDEX idx_leave_employee_id ON leave_management(employee_id);
CREATE INDEX idx_leave_type_id ON leave_management(leave_type_id);
CREATE INDEX idx_leave_dates ON leave_management(start_date, end_date);
CREATE INDEX idx_leave_status ON leave_management(leave_status_code);

-- Staff Loans Table
CREATE TABLE staff_loans (
    loan_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    full_name VARCHAR(100) NOT NULL, -- FK to employees.full_name
    loan_type VARCHAR(50) NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    repayment_amount DECIMAL(12,2) NOT NULL,
    repayment_period repayment_period,  -- in months
--    CREATE TYPE repayment_unit AS ENUM ('DAYS', 'WEEKS', 'MONTHS', 'YEARS');
    interest_rate DECIMAL(5,2),
    loan_balance DECIMAL(12,2),
    interest_accrued DECIMAL(12,2),
    disbursement_date DATE,
    loans_status_code loans_status_code,  -- 0=Applied, 1=Approved, 2=Disbursed, 3=Completed, 4=Rejected //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_loan_employee_id ON staff_loans(employee_id);
CREATE INDEX idx_loan_type ON staff_loans(loan_type);
CREATE INDEX idx_loan_status ON staff_loans(loans_status_code);

-- Loan Guarantors Table
CREATE TABLE loan_guarantors (
    guarantor_id SERIAL PRIMARY KEY,
    loan_id INT NOT NULL,       -- FK to staff_loans.loan_id
    employee_id INT NOT NULL,   -- FK to employees.employee_id
    guarantee_amount DECIMAL(12,2) NOT NULL,
    guarantors_status_code guarantors_status_code,  -- 1=Active, 0=Released //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_guarantor_loan_id ON loan_guarantors(loan_id);
CREATE INDEX idx_guarantor_employee_id ON loan_guarantors(employee_id);

CREATE TABLE loan_repayments (
    repayment_id SERIAL PRIMARY KEY,
    loan_id INT NOT NULL, --FK to staff_loans.loan_id
    employee_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(12,2) NOT NULL,
    payment_method payment_method, --ENUM field
    receipt_number VARCHAR (50),
    payment_status payment_status , -- Paid, Partial, Overdue //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_repayment_loan_id ON loan_repayments(loan_id);

-- Disciplinary Cases Table
CREATE TABLE disciplinary_cases (
    case_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    full_name VARCHAR(100) NOT NULL, -- FK to employees.full_name
    designation VARCHAR(100),
    offense_date DATE NOT NULL,
    offense_description TEXT NOT NULL,
    offense_category offense_category, --//ENUM
    board_decision TEXT,
    case_status case_status,  -- 0=Pending, 1=Resolved // ENUM
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_disciplinary_employee_id ON disciplinary_cases(employee_id);
CREATE INDEX idx_disciplinary_category ON disciplinary_cases(offense_category);
CREATE INDEX idx_disciplinary_status ON disciplinary_cases(case_status);

-- Exit Process Table
CREATE TABLE exit_process (
    exit_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    exit_date DATE NOT NULL,
    exit_type VARCHAR(50) NOT NULL, --ENUM
    exit_reason TEXT,
    clearance_status clearance_status,  -- 0=Pending, 1=Cleared //ENUM
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    comments TEXT,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_exit_employee_id ON exit_process(employee_id);
CREATE INDEX idx_exit_date ON exit_process(exit_date);
CREATE INDEX idx_exit_type ON exit_process(exit_type);
CREATE INDEX idx_exit_clearance ON exit_process(clearance_status);

-- Retirement Table
CREATE TABLE retirement (
    retirement_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    retirement_date DATE NOT NULL,
    years_of_service INT,
    dues_payment_status dues_payment_status,  -- 0=Pending, 1=Paid //ENUM
    payment_details TEXT,
    document_path VARCHAR(255), -- For scanned documents
    custom_fields JSONB, -- For customizable fields
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_retirement_employee_id ON retirement(employee_id);
CREATE INDEX idx_retirement_date ON retirement(retirement_date);
CREATE INDEX idx_retirement_payment ON retirement(dues_payment_status);

-- Death In Service Table
CREATE TABLE death_in_service (
    death_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,  -- FK to employees.employee_id
    next_of_kin_id INT NOT NULL, -- FK to next_of_kin.next_of_kin_id (if nominee/nextofkin)
    death_date DATE NOT NULL,
    description TEXT,
    payment_status payment_status,  -- 0=Pending, 1=Paid //ENUM
    document_path VARCHAR(255),
    custom_fields JSONB,
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_death_employee_id ON death_in_service(employee_id);
CREATE INDEX idx_death_date ON death_in_service(death_date);
CREATE INDEX idx_death_payment ON death_in_service(payment_status);

-- Medical Insurance Claims Table
CREATE TABLE medical_claims (
    claim_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,    -- FK to employees.employee_id
    claimant_type VARCHAR(20) NOT NULL,  -- Staff or Beneficiary //ENUM
    beneficiary_id INT,          -- FK to next_of_kin.next_of_kin_id (if beneficiary)
    institution VARCHAR(255) NOT NULL,
    claim_date DATE NOT NULL,
    claim_amount DECIMAL(12,2) NOT NULL,
    annual_limit DECIMAL(12,2) NOT NULL,
    claim_description TEXT,
    medical_claims_status medical_claims_status,  -- 0=Submitted, 1=Processing, 2=Approved, 3=Rejected //ENUM
    created_by INT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by INT,
    updated_at TIMESTAMPTZ
);

CREATE INDEX idx_claim_employee_id ON medical_claims(employee_id);
CREATE INDEX idx_claim_beneficiary_id ON medical_claims(beneficiary_id);
CREATE INDEX idx_claim_date ON medical_claims(claim_date);
CREATE INDEX idx_claim_status ON medical_claims(medical_claims_status);
CREATE INDEX idx_claim_claimant_type ON medical_claims(claimant_type);


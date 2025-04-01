CREATE TABLE IF NOT EXISTS task (
    description VARCHAR(64) NOT NULL,
    completed   VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS auth_user (
    phone_number VARCHAR(255) PRIMARY KEY,
    OTP VARCHAR(255),
    last_try TIMESTAMPTZ,
    num_tries INT,
    same_otp_tries INT
);

CREATE TABLE IF NOT EXISTS app_user (
    phone_number VARCHAR(225) PRIMARY KEY,
    country VARCHAR(255),
    city VARCHAR(255),
    religion VARCHAR(255),
    language VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS job_info (
       id SERIAL PRIMARY KEY,
       user_phone_number VARCHAR(255),
       employer_name VARCHAR(255),
       start_date DATE,
       salary_per_hour FLOAT DEFAULT 0,
       salary_per_day FLOAT DEFAULT 0,
       travel_per_day FLOAT DEFAULT 0,
       travel_per_month FLOAT DEFAULT 0,
       food_per_day FLOAT DEFAULT 0,
       food_per_month FLOAT DEFAULT 0,
       break_time_minutes FLOAT,
       min_work_hours_break_time FLOAT,
       shifts BOOLEAN default False,
       shifts_info JSON,
       over_time_info JSON,
       week_end_info JSON,
       curr_start TIMESTAMPTZ
)
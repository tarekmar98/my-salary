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
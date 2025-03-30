CREATE TABLE IF NOT EXISTS task (
    description VARCHAR(64) NOT NULL,
    completed   VARCHAR(30) NOT NULL
);

DROP TABLE IF EXISTS auth_user;

CREATE TABLE auth_user (
    phone_number VARCHAR(255) PRIMARY KEY,
    OTP VARCHAR(255),
    last_try TIMESTAMPTZ,
    num_tries INT,
    same_otp_tries INT
);
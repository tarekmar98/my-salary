# MySalary

> A comprehensive platform for managing salary-related operations, built with a Spring Boot (Java) back-end and a Flutter front-end. The system is equipped with authentication, authorization, and resource handling features.

## Project Overview
This repository contains the implementation of **MySalary**, a solution designed to manage and interact with users' salary and financial data.
### Features:
- Secure user authentication with JWT.
- Role-based access control to protect sensitive operations.
- CORS support for seamless interaction between client and server.
- Dockerized infrastructure for local run with PostgreSQL.

## Tech Stack
### Back-end:
- **Java** (Spring Boot)
    - Security: Spring Security (JWT Authentication, CORS, CSRF Protection).
    - REST Controllers for exposing APIs.
    - Service and Business logic layers.

- **Configuration**:
    - YAML formats for server settings.
    - JSON for additional configurations like supported countries.
    
- **Docker** (via `compose.yml`): For local run with PostgreSQL.

### Front-end:
- **Flutter**:
    - Responsive UI for client interactions.
    - Defined and managed with the `pubspec.yaml` configuration file.

## Installation and Usage
### Prerequisites:
- **Back-end**:
    - Java 21+
    - Docker

- **Front-end**:
    - Flutter 2.x+

- **Database**:
    - Ensure the database is properly configured in `application.yaml`.

### Steps to Run:
1. **Clone the repository**:
``` bash
   git clone https://github.com/tarekmar98/my-salary.git
   cd MySalary
```
1. **Set up the Back-end**:
    - Navigate to the `server` directory:
``` bash
   cd server
```
- Init the database
``` bash
   docker-compose -f compose.yml up -d
```
- Build and run the application:
``` bash
   ./mvnw spring-boot:run
```
1. **Set up the Front-end**:
    - Navigate to the `client` directory:
``` bash
   cd client
```
- Fetch Flutter dependencies:
``` bash
   flutter pub get
```
- Run the Flutter application:
``` bash
   flutter run
```

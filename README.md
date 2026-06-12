# Learning Dashboard - Developer & Setup Guide

Welcome to the **Learning Dashboard**! This is a centralized, aggregated platform designed to help students and professionals discover, compare, and manage online courses from multiple learning environments (like Coursera, Udemy, edX, and YouTube) in one place.

The application has been written as a native **Java Dynamic Web Application** using **JSP (JavaServer Pages), Java Servlets, Custom Vanilla CSS (with Outfit/Inter fonts & glassmorphic styling), and MySQL**.

---

## 🏗️ Project Architecture (MVC)

The project is structured around the standard **Model-View-Controller (MVC)** design pattern:

```
LearningDashboard/
├── src/com/learningdashboard/
│   ├── models/              # POJO Data Models (User, UserProfile, Course, etc.)
│   ├── dao/                 # Data Access Objects (UserDAO, EnrollmentDAO, etc.)
│   ├── servlets/            # Controller Servlets (Login, Enroll, Profile, etc.)
│   ├── filter/              # AuthenticationFilter (Session security & role checks)
│   └── utils/               # Database Connection & Password hashing utilities
├── WebContent/              # Public web resources
│   ├── student/             # Student dashboard, profile edit, and certificate views
│   ├── admin/               # Admin panel, courses management, and analytics views
│   ├── WEB-INF/             # Web application configuration (web.xml) and lib jars
│   ├── css/                 # Premium styling stylesheet (style.css)
│   ├── js/                  # Form validation and client-side interactions (main.js)
│   ├── index.jsp            # Home landing page
│   ├── login.jsp            # Login interface
│   ├── register.jsp         # User signup page
│   └── courses.jsp          # Public course catalog and search interface
├── docs/
│   └── database_schema.sql  # MySQL database configuration and mock data
├── build.bat                # Java compilation script
└── run.bat                  # Deployment, Tomcat startup, and launch orchestrator
```

### MVC Core Elements:
1. **Models (`src/com/learningdashboard/models/`)**: Represents domain entities (`User.java`, `UserProfile.java`, `Course.java`, `Enrollment.java`, `Progress.java`, and `Certificate.java`).
2. **DAOs (`src/com/learningdashboard/dao/`)**: Contains JDBC queries utilizing `PreparedStatement` to ensure SQL-injection security.
3. **Servlets (`src/com/learningdashboard/servlets/`)**: Handles request routing. Map servlets in `web.xml` to endpoints such as `/profile`, `/enrollCourse`, and `/admin/courses`.
4. **Views (`WebContent/`)**: JSP files displaying user-specific workspaces. Styled with modern responsive CSS.

---

## ⚡ Prerequisites

Before running the dashboard, ensure you have the following installed on your machine:
* **Java Development Kit (JDK)**: JDK 11 or higher installed and added to your `PATH`.
* **MySQL Server**: MySQL 8.0+ running on port `3306`.
* **Apache Tomcat**: Tomcat 9.0+ (compatible with the `javax.servlet` Servlet 4.0 specification).

---

## 🚀 Quick Setup & Run Instructions

To get the application up and running locally, follow these steps:

### Step 1: Database Setup
1. Open your MySQL client (CLI or Workbench) and enter your credentials.
2. Create the database:
   ```sql
   CREATE DATABASE learning_dashboard;
   ```
3. Import the schema and seed data from the project directory:
   ```bash
   mysql -u root -p learning_dashboard < docs/database_schema.sql
   ```

### Step 2: Configure Database Credentials
Open `src/com/learningdashboard/utils/DBConnection.java` and edit the database password to match your local MySQL installation:
```java
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_mysql_password"; // Update this line
```

### Step 3: Build the Code
Run the compilation batch script from your command prompt:
```cmd
build.bat
```
*This compiles all Java source files under `src/` directly to `WebContent/WEB-INF/classes` using Tomcat's servlet libraries.*

### Step 4: Deploy and Launch Tomcat
Run the run batch script:
```cmd
run.bat
```
*This script will copy the web resources to your Tomcat deployment directory (`webapps/LearningDashboard`), start the Tomcat server (if it's not already running), and prepare the app for traffic.*

### Step 5: Open in Browser
Visit the dashboard in your web browser:
👉 **[http://localhost:8080/LearningDashboard/](http://localhost:8080/LearningDashboard/)**

---

## 👥 Demo Accounts

You can test both user workflows using these built-in credentials:

* **Student Account**:
  * **Username**: `student1`
  * **Password**: `Demo@1234`
  * **Role**: Student (Accesses Profile, Enrolled Courses, Notes, and Certificates)
  
* **Administrator Account**:
  * **Username**: `admin`
  * **Password**: `Admin@1234`
  * **Role**: Admin (Accesses User suspension/deletion list, Course CRUD, and Analytics)

---

## 🎨 Visuals & Features

* **Premium Style Overhaul**: Styled using Google Fonts **Outfit** (impactful headers) and **Inter** (clean body typography) with vibrant HSL palettes and glassmorphic headers.
* **Glow Progress Bars**: Student dashboards highlight learning paths with subtle animated completion gradients.
* **Public Certificate Verification**: Completed courses generate a unique certificate ID that can be validated by anyone on the certificate verification search page.
* **AJAX Progress Updates**: Students can modify study progress and save study logs asynchronously without page refreshes.

---


## 🛠️ Troubleshooting

* **Tomcat Port Conflict (8080)**:
  If port `8080` is already in use by another service, open Tomcat's `conf/server.xml` and change the connector port:
  ```xml
  <Connector port="8080" protocol="HTTP/1.1" ... />
  ```
* **"HttpServlet cannot be resolved" IDE Error**:
  If your IDE (such as VS Code or Antigravity IDE) highlights servlets with unresolved references, ensure you have Tomcat's jar files referenced. A `.vscode/settings.json` has been configured at the root to automatically map `servlet-api.jar` and `jsp-api.jar` to the active language server.
* **Connection Refused in Database**:
  Check if your MySQL service is running. On Windows, you can start it via command line:
  ```cmd
  net start MySQL80
  ```

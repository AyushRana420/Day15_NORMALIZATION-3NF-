CREATE Database DAY15

use DAY15;

Create Table EmployeeDetails(
EmpID INT,
EmpName VARCHAR(100),
Role VARCHAR(50),
Dept VARCHAR(50),
DeptLocation VARCHAR(100),
ManagerName VARCHAR(100),
ManagerRole VARCHAR(50),
ManagerDept VARCHAR(50)
);

INSERT INTO EmployeeDetails VALUES 
(201, 'Alice Brown', 'HR Executive', 'HR', 'Mumbai', 'Priya Mehta', 'HR Manager', 'HR'),
(202, 'Bob Smith', 'IT Analyst', 'IT', 'Pune', 'Karan Kapoor', 'IT Head', 'IT'),
(203, 'John Davis', 'HR Executive', 'HR', 'Mumbai', 'Priya Mehta', 'HR Manager', 'HR'),
(204, 'Riya Shah', 'HR Manager', 'HR', 'Mumbai', 'Arjun Sharma', 'HR Director', 'HR'),
(205, 'Priya Mehta', 'HR Manager', 'HR', 'Mumbai', 'Arjun Sharma', 'HR Director', 'HR');

SELECT * FROM EmployeeDetails

--2NF: Eliminate partial dependencies and separate repeating groups

--Step 1 : Creating differnt Tables 

CREATE TABLE Employee(
EmpID INT PRIMARY KEY,
EmpName VARCHAR(100),
Role VARCHAR(50),
Dept VARCHAR(50)
);

INSERT INTO Employee (EmpID, EmpName, Role, Dept)
SELECT DISTINCT EmpID, EmpName, Role, Dept
FROM EmployeeDetails;


CREATE TABLE Department (
Dept VARCHAR(50) PRIMARY KEY,
DeptLocation VARCHAR(100)
);

INSERT INTO Department (Dept, DeptLocation)
SELECT DISTINCT Dept, DeptLocation
FROM EmployeeDetails;


CREATE TABLE Manager (
ManagerName VARCHAR(100) PRIMARY KEY,
ManagerRole VARCHAR(50),
ManagerDept VARCHAR(50)
);

INSERT INTO Manager (ManagerName, ManagerRole, ManagerDept)
SELECT DISTINCT ManagerName, ManagerRole, ManagerDept
FROM EmployeeDetails;

--Used to Map employee with their managers
CREATE TABLE EmployeeManager (
EmpID INT,
ManagerName VARCHAR(100),
PRIMARY KEY (EmpID, ManagerName),
FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
FOREIGN KEY (ManagerName) REFERENCES Manager(ManagerName)
);

INSERT INTO EmployeeManager (EmpID, ManagerName)
SELECT DISTINCT EmpID, ManagerName
FROM EmployeeDetails;

SELECT * FROM Employee;
SELECT * FROM Department;
SELECT * FROM Manager;
SELECT * FROM EmployeeManager;


--3NF:Eliminate transitive dependencies
--Manager table now gets a unique ID (ManagerID), and EmployeeManager maps by ID


DROP TABLE IF EXISTS EmployeeManager;
DROP TABLE IF EXISTS Manager;

CREATE TABLE Manager (
ManagerID INT PRIMARY KEY IDENTITY(1,1),
ManagerName VARCHAR(100),
ManagerRole VARCHAR(50),
Dept VARCHAR(50),
FOREIGN KEY (Dept) REFERENCES Department(Dept)
);

INSERT INTO Manager (ManagerName, ManagerRole, Dept)
SELECT DISTINCT ManagerName, ManagerRole, ManagerDept
FROM EmployeeDetails;

CREATE TABLE EmployeeManager (
EmpID INT,
ManagerID INT,
PRIMARY KEY (EmpID, ManagerID),
FOREIGN KEY (EmpID) REFERENCES Employee(EmpID),
FOREIGN KEY (ManagerID) REFERENCES Manager(ManagerID)
);

INSERT INTO EmployeeManager (EmpID, ManagerID)
SELECT e.EmpID, m.ManagerID
FROM EmployeeDetails e
JOIN Manager m 
    ON e.ManagerName = m.ManagerName 
    AND e.ManagerRole = m.ManagerRole 
    AND e.ManagerDept = m.Dept;

SELECT * FROM Manager;
SELECT * FROM EmployeeManager;

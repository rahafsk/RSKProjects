-- 1. CREATE DATABASE
CREATE DATABASE SkyTrackAirlineDB;

USE SkyTrackAirlineDB;

-- 2. AIRPORT
CREATE TABLE Airport (
    AirportID INT IDENTITY PRIMARY KEY,
    IATACode VARCHAR(10) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL
);

-- 3. AIRCRAFT
CREATE TABLE Aircraft (
    AircraftID INT IDENTITY PRIMARY KEY,
    RegistrationNumber VARCHAR(50) NOT NULL UNIQUE,
    Model VARCHAR(100) NOT NULL,
    Manufacturer VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0)
);

-- 4. FLIGHT
CREATE TABLE Flight (
    FlightID INT IDENTITY PRIMARY KEY,
    FlightNumber VARCHAR(50) NOT NULL UNIQUE,
    DepartureDateTime DATETIME NOT NULL,
    ArrivalDateTime DATETIME NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Scheduled',
    DepartureAirportID INT,
    ArrivalAirportID INT,
    AircraftID INT,

    CONSTRAINT chk_FlightStatus CHECK (Status IN ('Scheduled','Delayed','Cancelled','Completed')),
    CONSTRAINT chk_Date CHECK (ArrivalDateTime > DepartureDateTime),

    FOREIGN KEY (DepartureAirportID) REFERENCES Airport(AirportID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (ArrivalAirportID) REFERENCES Airport(AirportID)
        ON DELETE NO ACTION ON UPDATE NO ACTION,

    FOREIGN KEY (AircraftID) REFERENCES Aircraft(AircraftID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. PASSENGER
CREATE TABLE Passenger (
    PassengerID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    NationalID VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Nationality VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL
);

-- 6. BOOKING
CREATE TABLE Booking (
    BookingID INT IDENTITY PRIMARY KEY,
    SeatNumber VARCHAR(10) NOT NULL,
    Class VARCHAR(20) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    BookingDate DATE DEFAULT GETDATE(),
    PassengerID INT,
    FlightID INT,

    CONSTRAINT chk_Class CHECK (Class IN ('Economy','Business','First')),

    FOREIGN KEY (PassengerID) REFERENCES Passenger(PassengerID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. CREW MEMBER
CREATE TABLE CrewMember (
    CrewID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT chk_Role CHECK (Role IN ('Pilot','Co-Pilot','Flight Attendant','Engineer'))
);

-- 8. CREW ASSIGNMENT (Bridge Table)
CREATE TABLE CrewAssignment (
    CrewID INT,
    FlightID INT,
    PRIMARY KEY (CrewID, FlightID),

    FOREIGN KEY (CrewID) REFERENCES CrewMember(CrewID)
        ON DELETE CASCADE ON UPDATE CASCADE,

    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- AIRPORTS
INSERT INTO Airport (IATACode, Name, City, Country) VALUES
('MCT','Muscat Intl','Muscat','Oman'),
('DXB','Dubai Intl','Dubai','UAE'),
('LHR','Heathrow','London','UK'),
('JFK','John F Kennedy','New York','USA'),
('IST','Istanbul Airport','Istanbul','Turkey');

-- AIRCRAFT
INSERT INTO Aircraft (RegistrationNumber, Model, Manufacturer, Capacity) VALUES
('A100','A320','Airbus',180),
('B200','737','Boeing',160),
('A300','A350','Airbus',300),
('B400','787','Boeing',250),
('A500','A330','Airbus',220);


-- PASSENGERS
INSERT INTO Passenger (FullName, NationalID, Email, Phone, Nationality, DateOfBirth) VALUES
('Ali Ahmed','N1','ali@mail.com','111','Omani','2000-01-01'),
('Sara Khan','N2','sara@mail.com','222','Pakistani','1999-02-02'),
('John Smith','N3','john@mail.com','333','American','1998-03-03'),
('Fatima Noor','N4','fatima@mail.com','444','Omani','2001-04-04'),
('Omar Ali','N5','omar@mail.com','555','Omani','1997-05-05'),
('Lina Said','N6','lina@mail.com','666','Jordanian','1996-06-06'),
('David Lee','N7','david@mail.com','777','Korean','1995-07-07'),
('Mona Hassan','N8','mona@mail.com','888','Egyptian','1994-08-08');

-- CREW
INSERT INTO CrewMember (FullName, Role, LicenseNumber) VALUES
('Pilot One','Pilot','L1'),
('Pilot Two','Co-Pilot','L2'),
('Attendant One','Flight Attendant','L3'),
('Engineer One','Engineer','L4'),
('Attendant Two','Flight Attendant','L5'),
('Pilot Three','Pilot','L6');

-- FLIGHTS
INSERT INTO Flight (FlightNumber, DepartureDateTime, ArrivalDateTime, Status, DepartureAirportID, ArrivalAirportID, AircraftID) VALUES
('SK101','2026-05-01 08:00','2026-05-01 10:00','Scheduled',1,2,1),
('SK102','2026-05-01 09:00','2026-05-01 12:00','Delayed',2,3,2),
('SK103','2026-05-02 07:00','2026-05-02 09:00','Cancelled',3,4,3),
('SK104','2026-05-02 06:00','2026-05-02 08:00','Completed',4,5,4),
('SK105','2026-05-03 05:00','2026-05-03 07:00','Scheduled',5,1,5),
('SK106','2026-05-03 11:00','2026-05-03 13:00','Delayed',1,3,1),
('SK107','2026-05-04 12:00','2026-05-04 14:00','Completed',2,5,2),
('SK108','2026-05-04 15:00','2026-05-04 17:00','Cancelled',3,1,3);

-- BOOKINGS
INSERT INTO Booking (SeatNumber, Class, Price, PassengerID, FlightID) VALUES
('1A','Economy',100,1,1),
('2A','Business',300,2,1),
('3A','First',500,3,2),
('4A','Economy',120,4,2),
('5A','Economy',110,5,3),
('6A','Business',320,6,4),
('7A','First',550,7,5),
('8A','Economy',130,8,6),
('9A','Business',310,1,7),
('10A','First',600,2,8);

-- CREW ASSIGNMENT
INSERT INTO CrewAssignment VALUES
(1,1),(3,1),
(2,2),(4,2),
(1,3),(3,3),
(2,4),(5,4),
(6,5),(3,5),
(1,6),(5,6),
(2,7),(3,7),
(6,8),(5,8);


--UPDATE
UPDATE Flight SET Status='Completed' WHERE FlightNumber='SK101';

UPDATE Flight SET Status='Cancelled' WHERE FlightNumber='SK102';

UPDATE Booking SET Price = Price * 1.10 WHERE Class='Economy';

UPDATE Passenger SET Phone='999' WHERE PassengerID=1;

UPDATE CrewMember SET Role='Engineer' WHERE CrewID=2;


--DELETE 
SELECT * FROM Flight WHERE Status='Cancelled';
DELETE FROM Flight WHERE FlightNumber='SK103';

SELECT * FROM Booking WHERE FlightID=3;
DELETE FROM Booking WHERE FlightID=3;

--DELETE PASSENGER
SELECT * FROM Passenger WHERE PassengerID=1;
DELETE FROM Passenger WHERE PassengerID=1;

--BAISC
-- 1
SELECT FlightNumber, Status
FROM Flight
ORDER BY DepartureDateTime;

-- 2
SELECT * FROM Passenger
ORDER BY FullName;

-- 3
SELECT Model, Capacity
FROM Aircraft
ORDER BY Capacity DESC;

-- 4
SELECT DISTINCT Class
FROM Booking;

-- 5
SELECT *
FROM Flight
WHERE Status IN ('Delayed','Cancelled');

-- 6
SELECT *
FROM Passenger
WHERE Nationality = 'Omani';

-- 7
SELECT *
FROM Airport
ORDER BY Country;


--MEDIUM
-- 1
SELECT f.FlightNumber, a1.Name AS Origin, a2.Name AS Destination
FROM Flight f
JOIN Airport a1 ON f.DepartureAirportID = a1.AirportID
JOIN Airport a2 ON f.ArrivalAirportID = a2.AirportID;

-- 2
SELECT b.BookingID, p.FullName, f.FlightNumber
FROM Booking b
JOIN Passenger p ON b.PassengerID = p.PassengerID
JOIN Flight f ON b.FlightID = f.FlightID;

-- 3
SELECT c.FullName, c.Role
FROM CrewMember c
JOIN CrewAssignment ca ON c.CrewID = ca.CrewID
JOIN Flight f ON ca.FlightID = f.FlightID
WHERE f.FlightNumber = 'SK101';

-- 4
SELECT f.FlightNumber, ac.Model
FROM Flight f
JOIN Aircraft ac ON f.AircraftID = ac.AircraftID
WHERE f.Status = 'Completed';

-- 5
SELECT p.FullName, COUNT(b.BookingID) AS TotalBookings
FROM Passenger p
LEFT JOIN Booking b ON p.PassengerID = b.PassengerID
GROUP BY p.FullName
ORDER BY TotalBookings DESC;

-- 6
SELECT Class, SUM(Price) AS TotalRevenue
FROM Booking
GROUP BY Class;

-- 7
SELECT ac.Model, COUNT(f.FlightID) AS FlightsCount
FROM Aircraft ac
LEFT JOIN Flight f ON ac.AircraftID = f.AircraftID
GROUP BY ac.Model;

-- 8
SELECT FlightID, COUNT(*) AS BookingCount
FROM Booking
GROUP BY FlightID
HAVING COUNT(*) > 1;

-- 9


--ADVANCE
--2
SELECT *
FROM Passenger p
LEFT JOIN Booking b ON p.PassengerID = b.PassengerID
WHERE b.BookingID IS NULL;

--4
SELECT c.FullName, COUNT(ca.FlightID) AS Flights
FROM CrewMember c
JOIN CrewAssignment ca ON c.CrewID = ca.CrewID
GROUP BY c.FullName
HAVING COUNT(ca.FlightID) > 1;

-- 5
SELECT FlightID, AVG(Price) AS AvgPrice
FROM Booking
GROUP BY FlightID
HAVING AVG(Price) > (SELECT AVG(Price) FROM Booking);


--AIRLINE
CREATE TABLE Airline (
    AirlineID INT IDENTITY PRIMARY KEY,
    IATACode VARCHAR(10) NOT NULL UNIQUE,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Country VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100) NOT NULL UNIQUE
);

-- GATE
CREATE TABLE Gate (
    GateID INT IDENTITY PRIMARY KEY,
    GateCode VARCHAR(20) NOT NULL,
    Terminal VARCHAR(50) NOT NULL,
    AirportID INT NOT NULL,
    CONSTRAINT UQ_Gate UNIQUE (GateCode, AirportID),
    FOREIGN KEY (AirportID) REFERENCES Airport(AirportID)
);

-- BAGGAGE
CREATE TABLE Baggage (
    BaggageID INT IDENTITY PRIMARY KEY,
    TagNumber VARCHAR(50) NOT NULL UNIQUE,
    WeightKG DECIMAL(5,2) NOT NULL CHECK (WeightKG > 0),
    Type VARCHAR(20) NOT NULL CHECK (Type IN ('Cabin','Checked')),
    BookingID INT NOT NULL,

    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- FLIGHT DELAY LOG
CREATE TABLE FlightDelayLog (
    DelayID INT IDENTITY PRIMARY KEY,
    Reason VARCHAR(255) NOT NULL,
    DurationMinutes INT NOT NULL CHECK (DurationMinutes > 0),
    RecordedAt DATETIME NOT NULL,
    FlightID INT NOT NULL,

    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 1. Add columns 
ALTER TABLE Flight
ADD AirlineID INT NULL,
    GateID INT NULL;

	
--  Add foreign keys
ALTER TABLE Flight
ADD CONSTRAINT FK_Flight_Airline
FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID)
ON DELETE NO ACTION  
ON UPDATE CASCADE;



ALTER TABLE Flight
ADD CONSTRAINT FK_Flight_Gate
FOREIGN KEY (GateID) REFERENCES Gate(GateID)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

--INSER
--AIRLINE
INSERT INTO Airline (IATACode, Name, Country, ContactEmail) VALUES
('OMA','Oman Air','Oman','oma@air.com'),
('UAE','Emirates','UAE','em@air.com'),
('BAW','British Airways','UK','ba@air.com'),
('THY','Turkish Airlines','Turkey','thy@air.com');

--Gates (8 gates, 3 airports)
INSERT INTO Gate (GateCode, Terminal, AirportID) VALUES
('G1','T1',1),('G2','T1',1),
('G3','T2',2),('G4','T2',2),
('G5','T3',3),('G6','T3',3),
('G7','T1',4),('G8','T2',5);

INSERT INTO Gate (GateCode, Terminal, AirportID) VALUES
('G1','T1',1),
('G2','T1',1),
('G3','T2',2);

 --Update Flights (assign airline + gate)
 INSERT INTO Gate (GateCode, Terminal, AirportID) VALUES
('G1','T1',1),
('G2','T1',1),
('G3','T2',2);


UPDATE Flight SET AirlineID=1, GateID=1 WHERE FlightNumber='SK101';
UPDATE Flight SET AirlineID=2, GateID=3 WHERE FlightNumber='SK102';
UPDATE Flight SET AirlineID=3, GateID=5 WHERE FlightNumber='SK103';
UPDATE Flight SET AirlineID=4, GateID=7 WHERE FlightNumber='SK104';
UPDATE Flight SET AirlineID=1, GateID=2 WHERE FlightNumber='SK105';
UPDATE Flight SET AirlineID=2, GateID=4 WHERE FlightNumber='SK106';


--Baggage (10 records)

SELECT * FROM Baggage;
INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B11',10,'Cabin',BookingID FROM Booking WHERE BookingID=2;

INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B12',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B13',20,'Checked',BookingID FROM Booking WHERE BookingID=4;

INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B14',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B15',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B16',20,'Checked',BookingID FROM Booking WHERE BookingID=4;

INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B17',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B18',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


INSERT INTO Baggage (TagNumber, WeightKG, Type, BookingID)
SELECT 'B19',20,'Checked',BookingID FROM Booking WHERE BookingID=4;


--DELAY LOG

INSERT INTO FlightDelayLog (Reason, DurationMinutes, RecordedAt, FlightID)
SELECT 'Weather', 60, GETDATE(), FlightID
FROM Flight
WHERE FlightNumber = 'SK102';

INSERT INTO FlightDelayLog (Reason, DurationMinutes, RecordedAt, FlightID)
SELECT 'Weather', 60, GETDATE(), FlightID
FROM Flight
WHERE FlightNumber = 'SK102';

INSERT INTO FlightDelayLog (Reason, DurationMinutes, RecordedAt, FlightID)
SELECT 'Technical Issue', 45, GETDATE(), FlightID
FROM Flight
WHERE FlightNumber = 'SK102';

INSERT INTO FlightDelayLog (Reason, DurationMinutes, RecordedAt, FlightID)
SELECT 'Crew Delay', 30, GETDATE(), FlightID
FROM Flight
WHERE FlightNumber = 'SK102';

INSERT INTO FlightDelayLog (Reason, DurationMinutes, RecordedAt, FlightID)
SELECT 'Late Arrival', 50, GETDATE(), FlightID
FROM Flight
WHERE FlightNumber = 'SK102';

--BASIC LEVEL

-- BASIC 1
SELECT Name, Country FROM Airline ORDER BY Name;

-- BASIC 2
SELECT g.GateCode, g.Terminal, a.Name AS Airport
FROM Gate g
JOIN Airport a ON g.AirportID = a.AirportID;

-- BASIC 3
SELECT * FROM Baggage ORDER BY WeightKG DESC;

-- BASIC 4
SELECT d.*, f.FlightNumber
FROM FlightDelayLog d
JOIN Flight f ON d.FlightID = f.FlightID
ORDER BY d.RecordedAt;

-- BASIC 5
SELECT * FROM Flight WHERE GateID IS NULL;

--MEDIUM LEVEL 
-- MEDIUM 1
SELECT f.FlightNumber, al.Name AS AirlineName, g.GateCode
FROM Flight f
JOIN Airline al ON f.AirlineID = al.AirlineID
JOIN Gate g ON f.GateID = g.GateID

-- MEDIUM 3
SELECT b.BookingID, p.FullName, COUNT(bg.BaggageID) AS BaggageCount
FROM Booking b
JOIN Passenger p ON b.PassengerID = p.PassengerID
LEFT JOIN Baggage bg ON b.BookingID = bg.BookingID
GROUP BY b.BookingID, p.FullName;

-- MEDIUM 4
SELECT f.FlightNumber, al.Name AS AirlineName, d.Reason, d.DurationMinutes
FROM FlightDelayLog d
JOIN Flight f ON d.FlightID = f.FlightID
JOIN Airline al ON f.AirlineID = al.AirlineID;

-- MEDIUM 7
SELECT f.FlightNumber, COUNT(d.DelayID) AS DelayCount
FROM Flight f
JOIN FlightDelayLog d ON f.FlightID = d.FlightID
GROUP BY f.FlightNumber
HAVING COUNT(d.DelayID) > 1;


--ADVANCE LEVEL
-- ADVANCED 1
SELECT al.Name,
COUNT( f.FlightID) AS TotalFlights,
COUNT( b.PassengerID) AS TotalPassengers,
SUM(b.Price) AS TotalRevenue
FROM Airline al
LEFT JOIN Flight f ON al.AirlineID = f.AirlineID
LEFT JOIN Booking b ON f.FlightID = b.FlightID
GROUP BY al.Name;

-- ADVANCED 3
SELECT f.FlightNumber, al.Name AS AirlineName,
COUNT(d.DelayID) AS TotalDelays,
SUM(d.DurationMinutes) AS TotalDelayMinutes
FROM Flight f
JOIN Airline al ON f.AirlineID = al.AirlineID
JOIN FlightDelayLog d ON f.FlightID = d.FlightID
GROUP BY f.FlightNumber, al.Name;
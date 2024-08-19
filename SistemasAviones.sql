CREATE DATABASE SistemaAviones;

USE SistemaAviones;

-- Tabla FrequentFlyerCard
CREATE TABLE FrequentFlyerCard (
    FFCNumber INT PRIMARY KEY,
    Miles INT,
    MealCode VARCHAR(10)
);

-- Tabla Airport
CREATE TABLE Airport (
    AirportID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL
);

-- Tabla Airplane
CREATE TABLE Airplane (
    AirplaneID INT PRIMARY KEY IDENTITY(1,1),
    RegistrationNumber VARCHAR(50),
    BeginOperationDate DATE,
    Status VARCHAR(50)
);

-- Tabla PlaneModel
CREATE TABLE PlaneModel (
    ModelID INT PRIMARY KEY IDENTITY(1,1),
    Description VARCHAR(100),
    Graphic VARBINARY(MAX)
);

-- Tabla Seat
CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    Size VARCHAR(50),
    Number INT,
    Location VARCHAR(50),
    AirplaneID INT FOREIGN KEY REFERENCES Airplane(AirplaneID)
);

-- Tabla Customer
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    DateOfBirth DATE,
    Name VARCHAR(100),
    FFCNumber INT FOREIGN KEY REFERENCES FrequentFlyerCard(FFCNumber)
);

-- Tabla Ticket
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    TicketingCode VARCHAR(50),
    CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID)
);

-- Tabla Flight
CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    BoardingTime TIME,
    FlightDate DATE,
    Gate VARCHAR(50),
    CheckInCounter VARCHAR(50),
    DepartureTime TIME,
    Description VARCHAR(100),
    Type VARCHAR(50),
    Airline VARCHAR(50),
    StartAirportID INT FOREIGN KEY REFERENCES Airport(AirportID),
    GoalAirportID INT FOREIGN KEY REFERENCES Airport(AirportID),
    PlaneModelID INT FOREIGN KEY REFERENCES PlaneModel(ModelID)
);

-- Tabla AvailableSeat
CREATE TABLE AvailableSeat (
    AvailableSeatID INT PRIMARY KEY IDENTITY(1,1),
    SeatID INT FOREIGN KEY REFERENCES Seat(SeatID),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID)
);

-- Tabla Coupon
CREATE TABLE Coupon (
    CouponID INT PRIMARY KEY IDENTITY(1,1),
    DateOfRedemption DATE,
    Class VARCHAR(50),
    Standby BIT,
    MealCode VARCHAR(10),
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID)
);

-- Tabla Luggage
CREATE TABLE Luggage (
    LuggageID INT PRIMARY KEY IDENTITY(1,1),
    Number INT,
    Weight DECIMAL(5, 2),
    CouponID INT FOREIGN KEY REFERENCES Coupon(CouponID)
);

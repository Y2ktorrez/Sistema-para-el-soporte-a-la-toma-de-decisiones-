
if db_id('script4') is null
begin
	create database script4;
end
go

use script4;
go

---------------------------------------------------------------------

if object_id('Customer', 'U') is null
begin
    create table Customer(
        Ci int primary key,
        DateOfBirth DATE not null check (DateOfBirth >= DATEADD(YEAR, -100, GETDATE())),
        Name varchar(30) not null
    );

	create index Customer on Customer(Name);

end
go

---------------------------------------------------------------------

if object_id('Country', 'U') is null
begin
    create table Country(
        id int identity(1,1) primary key,
        Name varchar(30) not null unique
    );

	create index Country on Country(Name);

end
go

---------------------------------------------------------------------

if object_id('DocumentType', 'U') is null
begin
    create table DocumentType(
        id int identity(1,1) primary key,
        Name varchar(30) not null unique
    );

	create index DocumentType on DocumentType(Name);

end
go

---------------------------------------------------------------------

if object_id('Document', 'U') is null
begin
    create table Document(
        id int identity(1,1) primary key,
        Date_of_Issue date not null check (Date_of_Issue <= GETDATE()),
        Valid_Date date not null,
        Document_Type_id int not null,
        Customer_id int not null,
        Country_id int not null,
        foreign key (Customer_id) references Customer(Ci),
        foreign key (Country_id) references Country(id) ON DELETE NO ACTION,
        foreign key (Document_Type_id) references DocumentType(id) ON DELETE NO ACTION
    );

	create index Document on Document(Valid_Date);

end
go

---------------------------------------------------------------------

if object_id('City', 'U') is null
begin
    create table City(
        id int identity(1,1) primary key,
        Country_id int not null,
        Name varchar(30) not null unique,
        foreign key (Country_id) references Country(id) 
    );

	create index City on City(Name);

end
go

---------------------------------------------------------------------

if object_id('Airport', 'U') is null
begin
    create table Airport(
        id int identity(1,1) primary key,
        Name varchar(100) not null unique check (LEN(Name) > 2),
        City_id int not null,
        foreign key (City_id) references City(id)
    );

	create index Airport on Airport(Name);

end
go

---------------------------------------------------------------------

if object_id('Plane_Model', 'U') is null
begin
    create table Plane_Model(
        id int identity(1,1) primary key,
        Description varchar(60) not null check (LEN(Description) > 4),
        Graphic varchar(50) not null check (LEN(Graphic) > 4)
    );
end
go

---------------------------------------------------------------------

if object_id('Frequent_Flyer_Card', 'U') is null
begin
    create table Frequent_Flyer_Card(
        FFC_Number int identity(1,1) primary key,
        Miles int not null check (Miles >= 100 AND Miles <= 8000),
        Meal_Code int not null default 3 check (Meal_Code >= 1 AND Meal_Code <= 10),
        Customer_id int not null,
        foreign key (Customer_id) references Customer(Ci) 
    );

	create index FFC_CustomerId on Frequent_Flyer_Card(Customer_id);

end
go

---------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
    create table Airplane(
        Registration_Number int identity(1,1) primary key,
        Begin_of_Operation date not null check (Begin_of_Operation <= GETDATE()),
        Status varchar(15) not null Default 'Active' check (Status IN ('Active', 'Inactive', 'Maintenance')),
        Plane_Model_id int null,
        foreign key (Plane_Model_id) references Plane_Model(id) ON DELETE SET NULL
    );

	create index Airplane on Airplane(Registration_Number, Status);

end
go

---------------------------------------------------------------------

if object_id('Flight_Number', 'U') is null
begin
    create table Flight_Number(
        id int identity(1,1) primary key,
        Departure_Time time not null,
        Description varchar(50) not null check (LEN(Description) > 4),
        Type bit not null,
        Airline varchar(50) not null,
        Airport_Start int not null,
        Airport_Goal int not null,
		Plane_id int not null,
        foreign key (Airport_Start) references Airport(id) ON DELETE NO ACTION,
        foreign key (Airport_Goal) references Airport(id) ON DELETE NO ACTION,
		foreign key (Plane_id) references Plane_Model(id),
        CONSTRAINT Check_Airport check (Airport_Start <> Airport_Goal)
    );

	create index Flight_Number on Flight_Number(Airport_Start, Airport_Goal);

end
go

---------------------------------------------------------------------

if object_id('Category', 'U') is null
begin
    create table Category(
        id int identity(1,1) primary key,
        Name varchar(20) not null check(Name IN ('Economic', 'Premium Economic', 'Business', 'First Class'))
    );

	create index Category on Category(Name);

end
go

---------------------------------------------------------------------

if object_id('Ticket', 'U') is null
begin
    create table Ticket(
        Ticketing_Code int identity(1,1) primary key,
        Number int not null check (Number > 0),
        Customer_id int not null,
        Category_id int not null,
        foreign key (Customer_id) references Customer(Ci),
        foreign key (Category_id) references Category(id) 
    );

	create index Ticket on Ticket(Customer_id, Category_id, Number);

end
go

---------------------------------------------------------------------

if object_id('Flight', 'U') is null
begin
    create table Flight(
        id int identity(1,1) primary key,
        Boarding_Time time not null,
        Flight_Date date not null unique check (Flight_Date >= CONVERT(DATE, GETDATE())),
        Gate tinyint not null check (Gate BETWEEN 1 AND 255),
        Check_In_Counter bit not null,
        Flight_Number_id int not null,
        foreign key (Flight_Number_id) references Flight_Number(id) ON DELETE NO ACTION
    );

	create index Flight on Flight(Gate, Boarding_Time);

end
go

---------------------------------------------------------------------

if object_id('Seat', 'U') is null
begin
    create table Seat(
        id int identity(1,1) primary key,
        Size varchar(10) not null default 'Medium' check (Size IN ('Small', 'Medium', 'Large')),
        Number int not null unique check (Number > 0),
        Location varchar(30) not null check (LEN(Location) > 2),
        Plane_Model_id int not null,
        foreign key (Plane_Model_id) references Plane_Model(id) ON DELETE NO ACTION
    );

	create index Seat on Seat(Size, Location);

end
go

---------------------------------------------------------------------

if object_id('Available_Seat', 'U') is null
begin
    create table Available_Seat(
        id int identity(1,1) primary key,
        Flight_id int not null,
        Seat_id int not null,
        foreign key (Flight_id) references Flight(id) ON DELETE NO ACTION,
        foreign key (Seat_id) references Seat(id) ON DELETE NO ACTION
    );

	create index Available_Seat_Flight on Available_Seat(Flight_id);  
    create index Available_Seat_Seat on Available_Seat(Seat_id);

end
go

---------------------------------------------------------------------

if object_id('Coupon', 'U') is null
begin
    create table Coupon(
	id int identity(1,1) primary key,
	Date_of_Redemption date not null check (Date_of_Redemption >= GETDATE()),
	Class varchar(20) not null check (Class IN ('Economic', 'Premium Economic', 'Business', 'First Class')),
	Standby varchar(20) not null check (Standby IN ('Confirmed', 'Waiting')),
	Meal_Code int not null check (Meal_Code >= 1 AND Meal_Code <= 10),
	Ticketing_Code int not null,
	Flight_id int not null,
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code),
	foreign key (Flight_id) references Flight(id)
		
	);

end
go

---------------------------------------------------------------------

if object_id('Available_Seat_Coupon', 'U') is null
begin
	create table Available_Seat_Coupon(
	Coupon_id int not null,
	Available_Seat_id int not null,
	foreign key (Available_Seat_id) references Available_Seat(id),
	foreign key (Coupon_id) references Coupon(id)
		
	);
end 
go

---------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
    create table Pieces_of_Luggage(
	id int identity(1,1) primary key,
	Number int not null check (Number > 0),
	Weight decimal not null check (Weight >= 0 AND Weight <= 50),
	Coupon_id int not null,
	foreign key (Coupon_id) references Coupon(id)
	);
end
go

---------------------------------------------------------------------

if object_id('Reserve', 'U') is null
begin 
	create table Reserve(
		id int identity(1,1) primary key,
		State varchar(20),
		Reservation_Date date unique check (Reservation_Date >= Getdate()),
		Ticket_id int not null,
		foreign key (Ticket_id) references Ticket(Ticketing_Code)
	);

	create index Reservation_Date on Reserve(id);

end
go

if object_id('Cancellation', 'U') is null
begin
	create table Cancellation(
		id int identity(1, 1) primary key,
		Reason varchar(20),
		Cancellation_Date date unique ,
		Reserve_id int not null,
		foreign key (Reserve_id) references Reserve(id),
	);

end 
go

if object_id('Type', 'U') is null
begin 
	create table Type(
		id int identity(1,1) primary key,
		Name varchar(50) unique 
	);
end
go

if object_id('Customer_Type', 'U') is null
begin 
	create table Customer_Type(
		Type_id int not null,
		Customer_id int not null,
		foreign key (Type_id) references Type(id),
		foreign key (Customer_id) references Customer(Ci)
	);
end 
go

if object_id('Boarding_Pass', 'U') is null
begin 
	create table Boarding_Pass(
		id int  identity(1,1) primary key,
		Gate int not null,
		Coupon_id int not null,
		foreign key (Coupon_id) references Coupon(id)
	);
end
go

if object_id ('Baggage_Check_In', 'U') is null
begin
	create table Baggage_Check_In(
		id int identity (1, 1) primary key,
		Prohibited_Item bit default(0),
		Weight decimal check (Weight >= 0 AND Weight <= 50),
		Pieces_of_Luggage_id int not null,
		foreign key (Pieces_of_Luggage_id) references Pieces_of_Luggage(id)
	);
end 
go


--POBLACIÓN DE DATOS
--Customer
if not exists (select 1 from Customer)
begin
	INSERT INTO Customer (Ci, DateOfBirth, Name) VALUES 
	(123456, '1990-01-01', 'Juan Perez'), 
	(234567, '1985-05-05', 'Maria Lopez'), 
	(345678, '1970-07-07', 'Carlos Garcia'), 
	(456789, '1995-09-09', 'Ana Martinez'), 
	(567890, '2000-03-03', 'Luis Hernandez'), 
	(678901, '1980-11-11', 'Marta Rodriguez'), 
	(789012, '1993-02-02', 'Pedro Sanchez'), 
	(890123, '1975-04-04', 'Lucia Gonzalez'), 
	(901234, '1988-06-06', 'Roberto Flores'), 
	(101112, '1999-12-12', 'Elena Suarez');
select * from Customer
end
go

--Country
if not exists (select 1 from Country)
begin
	INSERT INTO Country (Name) VALUES 
	('Bolivia'), 
	('Argentina'), 
	('Chile'), 
	('Brasil'), 
	('Peru'), 
	('Colombia'), 
	('Ecuador'), 
	('Paraguay'), 
	('Uruguay'), 
	('Venezuela');
select * from Country
end;
go

--TypeDocument
if not exists (select 1 from DocumentType)
begin
	INSERT INTO DocumentType (Name) VALUES 
	('Pasaporte'), 
	('Licencia de Conducir'), 
	('DNI'),  
	('Visa'), 
	('ID Militar'), 
	('Carnet Universitario'), 
	('Certificado de Nacimiento');
select * from DocumentType
end;
go

--Document
if not exists (select 1 from Document)
begin
	INSERT INTO Document(Date_of_Issue, Valid_Date,Document_Type_id,Customer_id,Country_id) VALUES
	('2022-01-15', '2032-01-15', 1, 234567, 1),
	('2021-05-10', '2031-05-10', 2, 123456, 2),
	('2019-08-20', '2029-08-20', 3, 345678, 3),
	('2023-03-25', '2033-03-25', 4, 456789, 4),
	('2020-07-18', '2030-07-18', 5, 567890, 5),
	('2018-11-09', '2028-11-09', 6, 678901, 6),
	('2021-04-02', '2031-04-02', 7, 789012, 7),
	('2022-10-16', '2032-10-16', 1, 890123, 8),
	('2023-01-05', '2033-01-05', 2, 901234, 9),
	('2020-02-23', '2030-02-23', 4, 101112, 10);
select * from Document
end;
go
--City
if not exists (select 1 from City)
begin
	INSERT INTO City (Country_id,Name) VALUES 
	(1, 'Santa Cruz'), 
	(2, 'Buenos Aires'), 
	(3, 'Santiago'), 
	(4, 'Rio de Janeiro'), 
	(5, 'Lima'), 
	(6, 'Bogotá'), 
	(7, 'Quito'), 
	(8, 'Asunción'), 
	(9, 'Montevideo'), 
	(10, 'Caracas');
select * from City
end;
go

--Airport
if not exists (select 1 from Airport)
begin
	INSERT INTO Airport (Name, City_id) VALUES 
	('Airport Viru Viru', 1), 
	('Airport Ezeiza', 2), 
	('Airport Arturo Merino Benítez', 3), 
	('Airport Galeão', 4), 
	('Airport Jorge Chávez', 5), 
	('Airport El Dorado', 6), 
	('Airport Mariscal Sucre', 7), 
	('Airport Silvio Pettirossi', 8), 
	('Airport Carrasco', 9), 
	('Airport de Maiquetía', 10);
select * from Airport
end;

--PlaneModel
if not exists (select 1 from Plane_Model)
begin
	INSERT INTO Plane_Model (Description, Graphic) VALUES 
	('Boeing 737', 'Grafico1'), 
	('Airbus A320', 'Grafico2'), 
	('Boeing 777', 'Grafico3'), 
	('Airbus A380', 'Grafico4'), 
	('Embraer 190', 'Grafico5'), 
	('Boeing 747', 'Grafico6'), 
	('Airbus A330', 'Grafico7'), 
	('Cessna 172', 'Grafico8'), 
	('Bombardier CRJ200', 'Grafico9'), 
	('Boeing 787', 'Grafico10');
select * from Plane_Model
end;

--FrequebtFuyerCard
if not exists (select 1 from Frequent_Flyer_Card)
begin
	INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Customer_id) VALUES 
	(1000, 1, 123456), 
	(1500, 2, 234567), 
	(2000, 3, 345678), 
	(2500, 4, 456789), 
	(3000, 5, 567890), 
	(3500, 6, 678901), 
	(4000, 7, 789012), 
	(4500, 8, 890123), 
	(5000, 9, 901234), 
	(5500, 10, 101112);
select * from Frequent_Flyer_Card
end;

--Airplane
if not exists (select 1 from Airplane)
begin
	INSERT INTO Airplane (Begin_of_Operation, Status, Plane_Model_id) VALUES 
	('2020-01-01', 'Active', 1), 
	('2020-02-01', 'Active', 2), 
	('2020-03-01', 'Maintenance', 3), 
	('2020-04-01', 'Active', 4), 
	('2020-05-01', 'Inactive', 5), 
	('2020-06-01', 'Active', 6), 
	('2020-07-01', 'Active', 7), 
	('2020-08-01', 'Maintenance', 8), 
	('2020-09-01', 'Inactive', 9), 
	('2020-10-01', 'Active', 10);
select * from Airplane
end

--FlightNumber
if not exists (select 1 from Flight_Number)
begin
	INSERT INTO Flight_Number (Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal, Plane_id) VALUES 
	('10:00:00', 'Vuelo a Buenos Aires', 0, 'Aerolíneas Argentinas', 1, 2, 1), 
	('12:00:00', 'Vuelo a Santiago', 0, 'LATAM', 1, 3, 2), 
	('14:00:00', 'Vuelo a Lima', 0, 'Avianca', 1, 5, 3), 
	('16:00:00', 'Vuelo a Bogotá', 0, 'Copa Airlines', 1, 6, 4), 
	('18:00:00', 'Vuelo a Río de Janeiro', 1, 'GOL', 1, 4, 5), 
	('20:00:00', 'Vuelo a Quito', 1, 'TAME', 1, 7, 6), 
	('22:00:00', 'Vuelo a Asunción', 1, 'Paranair', 1, 8, 7), 
	('00:00:00', 'Vuelo a Montevideo', 1, 'Pluna', 1, 9, 8), 
	('02:00:00', 'Vuelo a Caracas', 1, 'Conviasa', 1, 10, 9), 
	('04:00:00', 'Vuelo a Buenos Aires', 1, 'Aerolíneas Argentinas', 2, 1, 10);
select * from Flight_Number
end

--Category
if not exists (select 1 from Category)
begin
	INSERT INTO Category (Name) VALUES
	('Economic'),
	('Business'),
	('First Class'),
	('Premium Economic');
select * from Category
end;


--Ticket
if not exists (select 1 from Ticket)
begin
	INSERT INTO Ticket (Number, Customer_id,Category_id) VALUES 
	(1, 123456,1), 
	(2, 234567,2), 
	(3, 345678,3), 
	(4, 456789,4), 
	(5, 567890,1), 
	(6, 678901,2), 
	(7, 789012,3), 
	(8, 890123,4), 
	(9, 901234,3), 
	(10, 101112,1);
select * from Ticket
end;

--Flight
if not exists (select 1 from Flight)
begin
	INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_in_Counter, Flight_Number_id) VALUES
	('08:00:00', '2024-09-11', 1, 0, 1),
	('09:30:00', '2024-09-12', 2, 0, 2),
	('10:45:00', '2024-09-13', 3, 1, 3),
	('12:15:00', '2024-09-14', 4, 1, 4),
	('14:00:00', '2024-09-05', 5, 0, 5),
	('15:30:00', '2024-09-06', 6, 1, 6),
	('17:00:00', '2024-09-07', 7, 0, 7),
	('18:45:00', '2024-09-08', 8, 0, 8),
	('20:00:00', '2024-09-09', 9, 0, 9),
	('22:15:00', '2024-09-10', 10, 0, 10);
select * from Flight
end

--Seat
if not exists (select 1 from Seat)
begin
	INSERT INTO Seat (Size, Number, Location, Plane_Model_id) VALUES
	('Large', 3, 'Window', 1),
	('Medium', 4, 'Aisle', 1),
	('Small', 5, 'Middle', 1),
	('Large', 6, 'Aisle', 2),
	('Medium', 7, 'Window', 2),
	('Small', 8, 'Middle', 2),
	('Large', 9, 'Window', 3),
	('Medium', 10, 'Aisle', 3),
	('Small', 11, 'Middle', 3),
	('Large', 12, 'Window', 4);
select * from Seat
end

--AvailableSeat
if not exists (select 1 from Available_Seat)
begin
	INSERT INTO Available_Seat (Flight_id, Seat_id) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10);
select * from Available_Seat
end

--Coupon
if not exists (select 1 from Coupon)
begin
	INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_id) VALUES
	('2024-09-11', 'Economic', 'Confirmed', 1, 1, 1),
	('2024-09-12', 'Business', 'Waiting', 2, 2, 2),
	('2024-09-13', 'First Class', 'Confirmed', 3, 3, 3),
	('2024-09-14', 'Premium Economic', 'Confirmed', 4, 4, 4),
	('2024-09-05', 'Business', 'Waiting', 5, 5, 5),
	('2024-09-06', 'First Class', 'Confirmed', 6, 6, 6),
	('2024-09-07', 'Economic', 'Waiting', 7, 7, 7),
	('2024-09-08', 'Business', 'Confirmed', 8, 8, 8),
	('2024-09-09', 'First Class', 'Confirmed', 9, 9, 9),
	('2024-09-10', 'Economic', 'Waiting', 10, 10, 10);
select * from Coupon
end;

--AvailableSeat
if not exists (select 1 from Available_Seat_Coupon)
begin
	INSERT INTO Available_Seat_Coupon(Coupon_id, Available_Seat_id) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10);
select * from Available_Seat
end

--PiecesOfLuggage
if not exists (select 1 from Pieces_of_Luggage)
begin
	INSERT INTO Pieces_of_Luggage (Number, Weight, Coupon_id) VALUES
	(1, 10.5, 1),
	(2, 15.0, 2),
	(3, 8.2, 3),
	(4, 12.3, 4),
	(5, 18.4, 5),
	(6, 20.0, 6),
	(7, 25.1, 7),
	(8, 30.5, 8),
	(9, 40.7, 9),
	(10, 50.0, 10);
select * from Pieces_of_Luggage
end;
go

--Reserve
if not exists (select 1 from Reserve) 
begin
	INSERT INTO Reserve (State, Reservation_Date, Ticket_id) VALUES
	('Pending','2024-09-15', 1),
	('Confirmed', '2024-09-20', 2),
	('Modified', '2024-09-25', 3),
	('Confirmed', '2024-09-30', 4),
	('Pending', '2024-10-05', 5),
	('Confirmed', '2024-10-10', 6),
	('Cancelled', '2024-10-15', 7),
	('Confirmed', '2024-10-20', 8),
	('Cancelled','2024-10-25', 9),
	('Pending', '2024-10-30', 10);
select * from Reserve
end;
go

--Cancellation
if not exists (select 1 from Cancellation) 
begin
	INSERT INTO Cancellation(Reason, Cancellation_Date, Reserve_id) VALUES
	('Personal', '2024-09-10', 7),
	('Personal', '2024-09-12', 9);
select * from Cancellation
end;
go

--Type
if not exists (select 1 from Type) 
begin
	INSERT INTO Type(Name) VALUES
	('Regular Customer'),
	('VIP Customer'),
	('Economic Class Customer'),
	('Business Class Customer'),
	('First Class Customer'),
	('Frequent Customer');
select * from Type
end
go

--Customer_Type
if not exists (select 1 from Customer_Type)
begin
	INSERT INTO Customer_Type (Type_id, Customer_id) VALUES
	(1, 123456),
	(2, 234567),
	(3, 345678),
	(4, 456789),
	(5, 567890),
	(6, 678901),
	(1, 789012),
	(2, 890123),
	(3, 901234),
	(4, 101112);
select * from Customer_Type
end
go

--Boarding_Pass
if not exists (select 1 from Boarding_Pass )
begin 
 INSERT INTO Boarding_Pass(Gate, Coupon_id)VALUES
 (1, 1),
 (2, 2),
 (3, 3),
 (4, 4),
 (5, 5),
 (2, 6),
 (7, 7),
 (8, 8),
 (4, 9),
 (5, 10);
select * from Boarding_Pass
end
go

--Bagagge_Check_In
if not exists (select 1 from Baggage_Check_In )
begin 
	INSERT INTO Baggage_Check_In(Prohibited_Item, Weight, Pieces_of_Luggage_id)VALUES
	(0, 23, 1),
	(0, 30, 2),
	(0, 45, 3),
	(0, 22, 4),
	(1, 35, 5),
	(0, 18, 6),
	(0, 29, 7),
	(1, 41, 8),
	(0, 20, 9),
	(0, 33, 10);
select * from Baggage_Check_In
end
go
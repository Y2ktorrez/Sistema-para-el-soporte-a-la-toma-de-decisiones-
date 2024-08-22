use master;

/********************** Andres Torrez Vaca ****************************/
/********************** 220153914 ****************************/

if db_id('airport') is null
begin 
	create database airport;
end 
go 

use airport;
go 


-----------------------------------------------------------------------

if object_id ('Country', 'U') is null
begin 
	create table Country(
		id int identity(1,1 ) primary key,
		name varchar(30) not null,
	);
end 

go

if object_id ('Customer', 'U') is null
begin 
	create table Customer(
		id int identity(1, 1) primary key,
		dateOfBirth date not null,
		name varchar(30) not null,
	);
end

go

if object_id ('Passport', 'U') is null
begin 
	create table Passport(
		id int identity(1, 1) primary key,
		dateOfBirth date not null,
		validDate date not null,
		customerId int not null,
		contryId int not null,
		foreign key(customerId) references Customer(id),
		foreign key(contryId) references Country(id),
	);
end 

go
 
if object_id ('City', 'U') is null
begin 
	create table City(
		id int identity(1, 1) primary key,
		countryId int not null,
		name varchar(30) not null,
		foreign key (countryId) references Country(id)
	);
end 

go

if object_id ('Airport', 'U') is null
begin 
	create table Airport(
		id int identity(1, 1) primary key,
		name varchar(30) not null,
		cityId int not null,
		foreign key (cityId) references City(id)
	);
end 

go

if object_id('PlaneModel', 'U') is null
begin
	create table PlaneModel(
	id int identity(1,1) primary key,
	description varchar(60) not null,
	graphic varchar(50) not null,
	);
end 

go

if object_id('FrequentFlyerCard', 'U') is null
begin
	create table FrequentFlyerCard(
	FFCNumber int identity(1,1) primary key,
	miles int not null,
	mealCode int not null,
	customerId int not null,
	foreign key (customerId) references Customer(id)
	);
end 

go

if object_id('Airplane', 'U') is null
begin
	create table Airplane(
	registrationNumber int identity(1,1) primary key,
	beginofOperation date not null,
	status varchar(30) not null,
	planeModelId int not null,
	foreign key (PlaneModelId) references PlaneModel(id),
	);
end 

go

if object_id('FlightNumber', 'U') is null
begin
	create table FlightNumber(
	id int identity(1,1) primary key,
	departureTime time not null,
	description varchar(50) not null,
	type bit not null,
	airline varchar(20) not null,
	airportStart int not null,
	airportGoal int not null,
	foreign key (airportStart) references Airport(id),
	foreign key (airportGoal) references Airport(id),
	);
end 

go

if object_id('Ticket', 'U') is null
begin
	create table Ticket(
	ticketingCode int identity(1,1) primary key,
	number int not null,
	customerId int not null,
	foreign key (customerId) references Customer(id)
	);
end 

go

if object_id('Flight', 'U') is null
begin
	create table Flight(
	id int identity(1,1) primary key,
	boardingTime time not null,
	flightDate date not null,
	gate tinyint not null,
	checkInCounter bit not null,
	flightNumberid int not null,
	foreign key (FlightNumberid) references FlightNumber(id),
	);
end 

go

if object_id('Seat', 'U') is null
begin
	create table Seat(
	id int identity(1,1) primary key,
	size int not null,
	number int not null,
	location varchar(30) not null,
	planeModelId int not null,
	foreign key (PlaneModelId) references PlaneModel(id),
	);
end 

go

if object_id('AvailableSeat', 'U') is null
begin
	create table AvailableSeat(
	id int identity(1,1) primary key,
	flightId int not null,
	seatId int not null,
	foreign key (flightId) references Flight(id),
	foreign key (seatId) references Seat(id),
	);
end 

go

if object_id('Coupon', 'U') is null
begin
	create table Coupon(
	id int identity(1,1) primary key,
	dateOfRedemption date not null,
	class varchar(20) not null,
	standby varchar(20) not null,
	mealCode int not null,
	ticketingCode int not null,
	flightId int not null,
	foreign key (ticketingCode) references Ticket(TicketingCode),
	foreign key (flightId) references Flight(id),
	);
end 

go

if object_id('AvailableSeatCoupon', 'U') is null
begin
	create table AvailableSeatCoupon(
	couponId int not null,
	availableSeatId int not null,
	foreign key (availableSeatId) references AvailableSeat(id),
	foreign key (CouponId) references Coupon(id),
	);
end 

go

if object_id('PiecesOfLuggage', 'U') is null
begin
	create table PiecesOfLuggage(
	id int identity(1,1) primary key,
	number int not null,
	weight int not null,
	couponId int not null,
	foreign key (couponId) references Coupon(id),
	);
end 

go

---------------------------------------------------------------------------------
insert into Country (name) values 
('USA'), 
('Germany'), 
('Brazil'), 
('Japan'), 
('Australia'), 
('Canada');

insert into Customer (dateOfBirth, name) values 
('1985-02-15', 'John Doe'),
('1990-06-10', 'Jane Smith'),
('1978-12-25', 'Carlos Silva'),
('1983-03-05', 'Maria Gomez'),
('1992-11-20', 'Yuki Yamamoto'),
('1988-09-30', 'Anna Müller');

insert into Passport (dateOfBirth, validDate, customerId, contryId) values 
('1985-02-15', '2030-02-14', 1, 1),
('1990-06-10', '2031-06-09', 2, 2),
('1978-12-25', '2029-12-24', 3, 3),
('1983-03-05', '2028-03-04', 4, 4),
('1992-11-20', '2032-11-19', 5, 5),
('1988-09-30', '2031-09-29', 6, 6);

insert into City (countryId, name) values 
(1, 'New York'),
(2, 'Berlin'),
(3, 'Rio de Janeiro'),
(4, 'Tokyo'),
(5, 'Sydney'),
(6, 'Toronto');

insert into Airport (name, cityId) values 
('JFK International', 1),
('Berlin Brandenburg', 2),
('Galeão International', 3),
('Narita International', 4),
('Sydney Kingsford Smith', 5),
('Toronto Pearson', 6);

insert into PlaneModel (description, graphic) values 
('Boeing 737', 'B737'),
('Airbus A320', 'A320'),
('Embraer E190', 'E190'),
('Boeing 777', 'B777'),
('Airbus A380', 'A380'),
('Boeing 787', 'B787');

insert into FrequentFlyerCard (miles, mealCode, customerId) values 
(15000, 1, 1),
(25000, 2, 2),
(18000, 3, 3),
(22000, 1, 4),
(30000, 2, 5),
(27000, 3, 6);

insert into Airplane (beginofOperation, status, planeModelId) values 
('2010-01-01', 'Active', 1),
('2015-06-15', 'Active', 2),
('2012-03-30', 'Active', 3),
('2008-11-10', 'Active', 4),
('2017-09-25', 'Active', 5),
('2019-07-20', 'Active', 6);

insert into FlightNumber (departureTime, description, type, airline, airportStart, airportGoal) values 
('08:00:00', 'NY to Berlin', 1, 'Delta', 1, 2),
('10:00:00', 'Berlin to Tokyo', 1, 'Lufthansa', 2, 4),
('14:00:00', 'Rio to Sydney', 1, 'LATAM', 3, 5),
('16:00:00', 'Tokyo to Toronto', 1, 'ANA', 4, 6),
('09:00:00', 'Sydney to New York', 1, 'Qantas', 5, 1),
('13:00:00', 'Toronto to Rio', 1, 'Air Canada', 6, 3);

insert into Ticket (number, customerId) values 
(101, 1),
(102, 2),
(103, 3),
(104, 4),
(105, 5),
(106, 6);

insert into Flight (boardingTime, flightDate, gate, checkInCounter, flightNumberid) values 
('07:30:00', '2024-09-01', 5, 1, 1),
('09:30:00', '2024-09-02', 3, 0, 2),
('13:30:00', '2024-09-03', 2, 1, 3),
('15:30:00', '2024-09-04', 4, 0, 4),
('08:30:00', '2024-09-05', 1, 1, 5),
('12:30:00', '2024-09-06', 6, 0, 6);

insert into Seat (size, number, location, planeModelId) values 
(30, 1, 'Front', 1),
(30, 2, 'Middle', 2),
(30, 3, 'Back', 3),
(30, 4, 'Front', 4),
(30, 5, 'Middle', 5),
(30, 6, 'Back', 6);

insert into AvailableSeat (flightId, seatId) values 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

insert into Coupon (dateOfRedemption, class, standby, mealCode, ticketingCode, flightId) values 
('2024-09-01', 'Economy', 'No', 1, 1, 1),
('2024-09-02', 'Business', 'No', 2, 2, 2),
('2024-09-03', 'First', 'Yes', 3, 3, 3),
('2024-09-04', 'Economy', 'Yes', 1, 4, 4),
('2024-09-05', 'Business', 'No', 2, 5, 5),
('2024-09-06', 'First', 'Yes', 3, 6, 6);

insert into AvailableSeatCoupon (couponId, availableSeatId) values 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6);

insert into PiecesOfLuggage (number, weight, couponId) values 
(2, 20, 1),
(1, 25, 2),
(3, 30, 3),
(2, 18, 4),
(1, 23, 5),
(2, 22, 6);



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

if object_id('PiecesOIfLuggage', 'U') is null
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

select * from airport;
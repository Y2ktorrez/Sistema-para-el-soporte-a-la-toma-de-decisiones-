use master;

if db_id('airport') is null
begin 
	create database airport;
end 
go 

use airport;
go 

if object_id ('Country', 'U') is null
begin 
	create table Country(
		id int identity(1,1) primary key,
		name varchar(30) not null unique
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
	create unique index IX_City_Name_CountryId on City(name, countryId);
	create index IX_City_CountryId on City(countryId);
end 
go

if object_id ('Customer', 'U') is null
begin 
	create table Customer(
		id int identity(1, 1) primary key,
		dateOfBirth date not null,
		name varchar(30) not null
	);
	create unique index UQ_Customer_DateOfBirth_Name on Customer(dateOfBirth, name);
	create index IX_Customer_Name on Customer(name);
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
	create unique index IX_Airport_Name_CityId on Airport(name, cityId);
	create index IX_Airport_CityId on Airport(cityId);
end 
go

if object_id('PlaneModel', 'U') is null
begin
	create table PlaneModel(
		id int identity(1,1) primary key,
		description varchar(60) not null,
		graphic varchar(50) not null
	);
end 
go

if object_id ('Passport', 'U') is null
begin 
	create table Passport(
		id int identity(1, 1) primary key,
		dateOfIssue date not null,
		validDate date not null,
		customerId int not null,
		countryId int not null,
		foreign key(customerId) references Customer(id),
		foreign key(countryId) references Country(id)
	);
	create unique index IX_Passport_CustomerId_CountryId on Passport(customerId, countryId);
	create index IX_Passport_CustomerId on Passport(customerId);
end 
go

if object_id('FrequentFlyerCard', 'U') is null
begin
	create table FrequentFlyerCard(
		FFCNumber int identity(1,1) primary key,
		miles int not null check (miles >= 0),
		mealCode int not null check (mealCode >= 0),
		customerId int not null,
		foreign key (customerId) references Customer(id)
	);
	create index IX_FrequentFlyerCard_CustomerId on FrequentFlyerCard(customerId);
end 
go

if object_id('Airplane', 'U') is null
begin
	create table Airplane(
		registrationNumber int identity(1,1) primary key,
		beginofOperation date not null,
		status varchar(30) not null,
		planeModelId int not null,
		foreign key (planeModelId) references PlaneModel(id)
	);
	create unique index IX_Airplane_RegistrationNumber on Airplane(registrationNumber);
	create index IX_Airplane_PlaneModelId on Airplane(planeModelId);
end 
go

if object_id('FlightCategory', 'U') is null
begin
	create table FlightCategory(
		id int identity(1,1) primary key,
		name varchar(30) not null unique
	);
end 
go

if object_id('FlightNumber', 'U') is null
begin
	create table FlightNumber(
		id int identity(1,1) primary key,
		departureTime time not null check (departureTime >= '00:00:00' and departureTime <= '23:59:59'),
		description varchar(50) not null,
		type bit not null,
		airline varchar(20) not null,
		airportStart int not null,
		airportGoal int not null,
		flightCategoryId int not null,
		foreign key (airportStart) references Airport(id),
		foreign key (airportGoal) references Airport(id),
		foreign key (flightCategoryId) references FlightCategory(id)
	);
	create index IX_FlightNumber_AirportStart on FlightNumber(airportStart);
	create index IX_FlightNumber_AirportGoal on FlightNumber(airportGoal);
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
	create index IX_Ticket_CustomerId on Ticket(customerId);
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
		flightNumberId int not null,
		foreign key (flightNumberId) references FlightNumber(id)
	);
	create index IX_Flight_FlightNumberId on Flight(flightNumberId);
end 
go

if object_id('Seat', 'U') is null
begin
	create table Seat(
		id int identity(1,1) primary key,
		size int not null check (size > 0),
		number int not null,
		location varchar(30) not null,
		planeModelId int not null,
		foreign key (planeModelId) references PlaneModel(id)
	);
	create unique index IX_Seat_Number_PlaneModelId on Seat(number, planeModelId);
	create index IX_Seat_PlaneModelId on Seat(planeModelId);
end 
go

if object_id('AvailableSeat', 'U') is null
begin
	create table AvailableSeat(
		id int identity(1,1) primary key,
		flightId int not null,
		seatId int not null,
		foreign key (flightId) references Flight(id),
		foreign key (seatId) references Seat(id)
	);
	create index IX_AvailableSeat_FlightId on AvailableSeat(flightId);
	create index IX_AvailableSeat_SeatId on AvailableSeat(seatId);
end 
go

if object_id('Coupon', 'U') is null
begin
	create table Coupon(
		id int identity(1,1) primary key,
		dateOfRedemption date not null,
		class varchar(20) not null check (class in ('Economy', 'Business', 'First')),
		standby varchar(20) not null,
		mealCode int not null,
		ticketingCode int not null,
		flightId int not null,
		foreign key (ticketingCode) references Ticket(ticketingCode),
		foreign key (flightId) references Flight(id)
	);
	create index IX_Coupon_TicketingCode on Coupon(ticketingCode);
	create index IX_Coupon_FlightId on Coupon(flightId);
end 
go

if object_id('AvailableSeatCoupon', 'U') is null
begin
	create table AvailableSeatCoupon(
		couponId int not null,
		availableSeatId int not null,
		foreign key (availableSeatId) references AvailableSeat(id),
		foreign key (couponId) references Coupon(id)
	);
	create index IX_AvailableSeatCoupon_CouponId on AvailableSeatCoupon(couponId);
	create index IX_AvailableSeatCoupon_AvailableSeatId on AvailableSeatCoupon(availableSeatId);
end 
go

if object_id('PiecesOfLuggage', 'U') is null
begin
	create table PiecesOfLuggage(
		id int identity(1,1) primary key,
		number int not null check (number > 0),
		weight int not null check (weight > 0 and weight <= 50),
		couponId int not null,
		foreign key (couponId) references Coupon(id)
	);
	create index IX_PiecesOfLuggage_CouponId on PiecesOfLuggage(couponId);
end
go




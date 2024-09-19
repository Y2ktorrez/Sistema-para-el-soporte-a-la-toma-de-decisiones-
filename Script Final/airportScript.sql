use master

if db_id('airportScript') is null
begin
	create database airportScript;
end
go

use airportScript;
go

---------------------------------------------------------------------

if object_id('Country','U') is null
begin
	create table Country(
		ID int identity(1,1) primary key not null,
		Name varchar(30) not null,
	);
end
go

---------------------------------------------------------------------

if object_id('City', 'U') is null
begin
    create table City(
        ID int identity(1,1) primary key,
        Country_ID int not null,
        Name varchar(30) not null unique,
        foreign key (Country_ID) references Country(ID) 
    );
end
go

---------------------------------------------------------------------

if object_id('Airport', 'U') is null
begin
    create table Airport(
        ID int identity(1,1) primary key,
        Name varchar(100) not null unique check (len(Name) > 2),
        City_ID int not null,
        foreign key (City_ID) references City(ID)
    );
end
go

---------------------------------------------------------------------

if object_id('Plane_Model', 'U') is null
begin
    create table Plane_Model(
        ID int identity(1,1) primary key,
        Description varchar(60) not null check (len(Description) > 4),
        Graphic varchar(50) not null check (len(Graphic) > 4)
    );
end
go

---------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
    create table Airplane(
        Registration_Number int identity(1,1) primary key,
        Begin_of_Operation date not null check (Begin_of_Operation <= GETDATE()),
        Status varchar(15) Default 'Active' check (Status IN ('Active', 'Inactive', 'Maintenance')),
        Plane_Model_ID int null,
        foreign key (Plane_Model_ID) references Plane_Model(ID) ON DELETE SET NULL
    );
end
go

---------------------------------------------------------------------

if object_id('Flight_Number', 'U') is null
begin
    create table Flight_Number(
        id int identity(1,1) primary key,
        Departure_Time time not null,
        Type bit not null,
        Airport_Start int not null,
        Airport_Goal int not null,
		Plane_id int not null,
        foreign key (Airport_Start) references Airport(id) ON DELETE NO ACTION,
        foreign key (Airport_Goal) references Airport(id) ON DELETE NO ACTION,
		foreign key (Plane_id) references Plane_Model(id) ON DELETE NO ACTION,
        CONSTRAINT Check_Airport check (Airport_Start <> Airport_Goal)
    );
end
go

---------------------------------------------------------------------

if object_id('Seat', 'U') is null
begin
    create table Seat(
        ID int identity(1,1) primary key,
        Size varchar(10) default 'Medium' check (Size IN ('Small', 'Medium', 'Large')),
        Number int not null unique check (Number > 0),
        Location varchar(30) check (Location IN ('Window','Aisle','Middle','Left','Right')),
        Plane_Model_ID int not null,
        foreign key (Plane_Model_ID) references Plane_Model(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Flight', 'U') is null
begin
    create table Flight(
        ID int identity(1,1) primary key,
        Boarding_Time time not null,
        Flight_Date date not null check (Flight_Date >= CONVERT(DATE, GETDATE())),
        Gate tinyint not null check (Gate BETWEEN 1 AND 255),
        Check_In_Counter bit not null,
        Flight_Number_id int not null,
        foreign key (Flight_Number_ID) references Flight_Number(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Flight_Scale', 'U') is null
begin
    create table Flight_Scale(
        ID int identity(1,1) primary key,
        Scale_Type varchar(30) check (Scale_Type IN('Technical scale','Regular scale','Connected flight')),
		Scale_Time time not null,
    );
end
go

---------------------------------------------------------------------

if object_id('Scale', 'U') is null
begin
    create table Scale(
        ID int identity(1,1) primary key,
        Date date not null,
		Time time not null,
		Flight_ID int not null,
		Airport_ID int not null,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
		foreign key (Airport_ID) references Airport(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Available_Seat', 'U') is null
begin
    create table Available_Seat(
        ID int identity(1,1) primary key,
        Flight_ID int not null,
        Seat_ID int not null,
        foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
        foreign key (Seat_ID) references Seat(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Airline', 'U') is null
begin
    create table Airline(
        ID int identity(1,1) primary key,
        Name varchar(100) not null check (len(Name) > 5),
		Country_ID int not null,
		foreign key (Country_ID) references Country(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Passenger_Type', 'U') is null
begin
    create table Passenger_Type(
        ID int identity(1,1) primary key,
        Name varchar(30) not null check (len(Name) > 5),
    );
end
go

---------------------------------------------------------------------

if object_id('Type_Assigment', 'U') is null
begin
    create table Type_Assigment(
        ID int identity(1,1) primary key,
        Date date not null,
		Passenger_Type_ID int not null,
		foreign key (Passenger_Type_ID) references Passenger_Type(ID) ON DELETE NO ACTION,
	);
end
go

---------------------------------------------------------------------

if object_id('Person_Type', 'U') is null
begin
    create table Person_Type(
        ID int identity(1,1) primary key,
        Name varchar(30) not null check (Name IN('natural person','artificial person')),
    );
end
go

---------------------------------------------------------------------

if object_id('Person', 'U') is null
begin
    create table Person(
        ID int identity(1,1) primary key,
        Name varchar(50) not null unique check (len(Name) > 5),
		Phone varchar(20) not null,
		Email varchar(50) not null check (len(Email) > 10),
		Type varchar(10) not null default 'Passenger' check ( Type in('Crew Member','Passenger','Both')),
		Person_Type_ID int not null,
		foreign key (Person_Type_ID) references Person_Type(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Passenger', 'U') is null
begin
    create table Passenger(
        ID int identity(1,1) primary key,
        Number_Of_Flights int not null,
		Type varchar(10) not null default 'Passenger' check ( Type in('Passenger','Both')),
		Type_Assigment_ID int not null,
		Person_ID int not null,
		foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
		foreign key (Type_Assigment_ID) references Type_Assigment(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Crew_Member', 'U') is null
begin
    create table Crew_Member(
        ID int identity(1,1) primary key,
        Flying_Hours int not null,
		Type varchar(50) not null default 'Crew Member' check ( Type in('Crew Member','Both')),
		Person_ID int not null,
		foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
    );
end
go

select * from Crew_Member
---------------------------------------------------------------------

if object_id('Crew_Rol', 'U') is null
begin
    create table Crew_Rol(
        ID int identity(1,1) primary key,
        Name varchar(30) not null check (len(Name) > 5),
    );
end
go

---------------------------------------------------------------------

if object_id('Crew_Assigment', 'U') is null
begin
    create table Crew_Assigment(
        ID int identity(1,1) primary key,
		Date date not null,
		Crew_Rol_ID int not null,
		Flight_ID int not null,
		Crew_Member_ID int not null,
		foreign key (Crew_Rol_ID) references Crew_Rol(ID) ON DELETE NO ACTION,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
		foreign key (Crew_Member_ID) references Crew_Member(ID) ON DELETE NO ACTION,
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
        Passenger_ID int not null,
        foreign key (Passenger_ID) references Passenger(ID) 
    );
end
go

---------------------------------------------------------------------

if object_id('Flight_Cancellation', 'U') is null
begin
    create table Flight_Cancellation(
        ID int identity(1,1) primary key,
		Reason varchar(75) not null check (len(Reason)>15),
        NewDepartureDate date not null,
		Flight_ID int not null,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Flight_Reprograming', 'U') is null
begin
    create table Flight_Reprograming(
        ID int identity(1,1) primary key,
        NewDepartureDate date not null,
		NewDepartureTime time not null,
		Flight_Cancellation_ID int not null,
		foreign key (Flight_Cancellation_ID) references Flight_Cancellation(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Payment_Type', 'U') is null
begin
    create table Payment_Type(
        ID int identity(1,1) primary key,
        Name varchar(40) not null check (len(Name) > 2),
    );
end
go

---------------------------------------------------------------------

if object_id('Payment', 'U') is null
begin
    create table Payment(
        ID int identity(1,1) primary key,
		Currency varchar(10) not null default 'Bs' check (Currency in ('Bs', 'USD')),
		Amount int not null,
		Date date not null,
		Payment_Type_ID int not null,
		foreign key (Payment_Type_ID) references Payment_Type(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Document_Type', 'U') is null
begin
    create table Document_Type(
        ID int identity(1,1) primary key,
        Name varchar(50) not null check (len(Name) > 2),
    );
end
go

---------------------------------------------------------------------

if object_id('Document', 'U') is null
begin
    create table Document(
        id int identity(1,1) primary key,
        Date_of_Issue date not null check (Date_of_Issue <= GETDATE()),
        Valid_Date date not null,
        Document_Type_ID int not null,
        Country_ID int not null,
        foreign key (Country_ID) references Country(id) ON DELETE NO ACTION,
        foreign key (Document_Type_ID) references Document_Type(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Category', 'U') is null
begin
    create table Category(
        id int identity(1,1) primary key,
        Name varchar(20) not null check(Name IN ('Economic', 'Premium Economic', 'Business', 'First Class'))
    );
end
go

---------------------------------------------------------------------

if object_id('Ticket', 'U') is null
begin
    create table Ticket(
        Ticketing_Code int identity(1,1) primary key,
        Number int not null check (Number > 0),
        Category_ID int not null,
		Document_ID int not null,
        foreign key (Category_ID) references Category(ID) ON DELETE NO ACTION,
		foreign key (Document_ID) references Document(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Reserve', 'U') is null
begin
    create table Reserve(
        ID int identity(1,1) primary key,
		State bit not null default 1,
		Reservation_Date date not null default getdate(),
        Person_ID int not null,
		Payment_ID int not null,
		Ticketing_Code int not null,
        foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
		foreign key (Payment_ID) references Payment(ID) ON DELETE NO ACTION,
		foreign key (Ticketing_Code) references Ticket(Ticketing_Code) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Confirmation', 'U') is null
begin
    create table Confirmation(
        ID int identity(1,1) primary key,
		Date date not null default getdate(),
		Reserve_ID int not null,
		foreign key (Reserve_ID) references Reserve(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Cancellation', 'U') is null
begin
    create table Cancellation(
        ID int identity(1,1) primary key,
		Reason varchar(50) not null check (len(Reason) > 5),
		Cancellation_Date date not null default getdate(),
		Penalty int not null,
		Reserve_ID int not null,
		foreign key (Reserve_ID) references Reserve(ID) ON DELETE NO ACTION,
    );
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
	Flight_ID int not null,
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code)  ON DELETE NO ACTION,
	foreign key (Flight_ID) references Flight(ID)  ON DELETE NO ACTION,
	);
end
go

---------------------------------------------------------------------

if object_id('Boarding_Pass', 'U') is null
begin 
	create table Boarding_Pass(
		id int  identity(1,1) primary key,
		Gate int not null,
		Coupon_ID int not null,
		foreign key (Coupon_ID ) references Coupon(ID ) ON DELETE NO ACTION,
	);
end
go

---------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
    create table Pieces_of_Luggage(
		ID int identity(1,1) primary key,
		Number int not null check (Number > 0),
		Weight decimal not null check (Weight >= 0 AND Weight <= 50),
		Coupon_ID int not null,
		foreign key (Coupon_ID) references Coupon(ID)
	);
end
go

---------------------------------------------------------------------

if object_id ('Baggage_Check_In', 'U') is null
begin
	create table Baggage_Check_In(
		ID int identity (1, 1) primary key,
		Prohibited_Item bit default(0),
		Weight decimal check (Weight >= 0 AND Weight <= 50),
		Pieces_of_Luggage_ID int not null,
		foreign key (Pieces_of_Luggage_ID) references Pieces_of_Luggage(ID)
	);
end 
go

---------------------------------------------------------------------

if object_id('Available_Seat_Coupon', 'U') is null
begin
	create table Available_Seat_Coupon(
		ID int not null identity(1,1) primary key,
		Coupon_id int not null,
		Available_Seat_id int not null,
		foreign key (Available_Seat_id) references Available_Seat(ID),
		foreign key (Coupon_id) references Coupon(ID)
	);
end 
go
























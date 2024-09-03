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
        id int identity(1,1) primary key,
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
        foreign key (Customer_id) references Customer(id) ON DELETE CASCADE,
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
        foreign key (Country_id) references Country(id) ON DELETE CASCADE
    );

	create index City on City(Name);

end
go

---------------------------------------------------------------------

if object_id('Airport', 'U') is null
begin
    create table Airport(
        id int identity(1,1) primary key,
        Name varchar(30) not null unique check (LEN(Name) > 2),
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
        foreign key (Customer_id) references Customer(id) ON DELETE CASCADE
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
        Airline varchar(20) not null,
        Airport_Start int not null,
        Airport_Goal int not null,
        foreign key (Airport_Start) references Airport(id) ON DELETE NO ACTION,
        foreign key (Airport_Goal) references Airport(id) ON DELETE NO ACTION,
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
        foreign key (Customer_id) references Customer(id) ON DELETE CASCADE,
        foreign key (Category_id) references Category(id) ON DELETE CASCADE
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
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code)
		on delete cascade,
	foreign key (Flight_id) references Flight(id)
		on delete cascade,
	);

end
go

---------------------------------------------------------------------

if object_id('Available_Seat_Coupon', 'U') is null
begin
	create table Available_Seat_Coupon(
	Coupon_id int not null,
	Available_Seat_id int not null,
	foreign key (Available_Seat_id) references Available_Seat(id)
		on delete cascade,
	foreign key (Coupon_id) references Coupon(id)
		on delete cascade
	);
end 
go

---------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
    create table Pieces_of_Luggage(
	id int identity(1,1) primary key,
	Number int not null check (Number > 0),
	Weight int not null check (Weight >= 0 AND Weight <= 50),
	Coupon_id int not null,
	foreign key (Coupon_id) references Coupon(id)
		on delete cascade
	);
end
go


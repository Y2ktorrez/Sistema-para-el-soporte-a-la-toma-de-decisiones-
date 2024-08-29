-- Estudiante: Joseph Benitez Arroyo 
-- Reg: 221043837

if db_id('airport1') is null
begin
	create database airport1;
end
go

use airport1;
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Customer','U') is null
begin
	create table Customer(
	id int identity(1,1) primary key,
	Date_of_Birth date not null,
	Name varchar(30) not null,
	constraint Check_DOB check (Date_of_Birth >= dateadd(year, -100, getdate()))
	);

	create index Customer_Name on Customer(Name);
end
go

if not exists (select 1 from Customer)
begin
	declare @length tinyint=20;
	declare @counter tinyint=1;
	declare @minDate date='1960-01-01';
	declare @maxDate date='2014-12-31';

	while @counter <= @length
	begin

		declare @random date;
		set @random=dateadd(day,floor(rand()*datediff(day,@minDate,@maxDate)+1),@minDate);

		insert into Customer(Name,Date_of_Birth)
		values('Customer '+cast(@counter as varchar(10)),@random);

		set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Country','U') is null
begin
	create table Country(
	id int identity(1,1) primary key,
	Name varchar(30) not null,
	constraint Check_name unique (Name),
	);

	create index Country_Name on Country(Name);
end
go

if not exists(select 1 from Country)
begin
	declare @length int=9;
	declare @counter int=0;

	while @counter<= @length 
	begin
	insert into Country(Name)
	values('country '+ cast(@counter as varchar(10)));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Document_Type','U') is null
begin
	create table Document_Type(
	id int identity(1,1) primary key,
	Name varchar(30) not null,
	constraint Check_nameDT unique (Name), 
	);

	create index Country_DocumentT on Document_Type(Name);
end

if not exists(select 1 from Document_Type)
begin
	insert into Document_Type(Name) values
	('Passport'),
	('CI');
end

--------------------------------------------------------------------------------------------------------------------------

if object_id('Document', 'U') is null
begin
	create table Document(
	id int identity(1,1) primary key,
	Date_of_Issue date not null,
	Valid_Date date not null,
	Document_Type_id int not null,
	Customer_id int not null,
	Country_id int not null,
	foreign key (Customer_id) references Customer(id),
	foreign key (Country_id) references Country(id),
	foreign key (Document_Type_id) references Document_Type(id),
	);

	create index Document_ValidD on Document(Valid_Date);
end 
go

if not exists(select 1 from Document)
begin
	declare @length tinyint=30;
	declare @minIssueDate date='2010-01-01';
	declare @maxIssueDate date='2023-12-31';
	declare @counter tinyint=0;
	declare @issueDate date;
	declare @validDate date;
	declare @customerId tinyint;
	declare @countryId tinyint;
	declare @documentTypeId tinyint;

	declare @tempCustomer table (id int);

	insert into @tempCustomer (id)
	select id from Customer;

	while exists(select 1 from @tempCustomer)
	begin
		select top 1 @customerId = id from @tempCustomer;

		set @issueDate=dateadd(day,floor(rand()*datediff(day,@minIssueDate,@maxIssueDate)+1),@minIssueDate);
		set @validDate=dateadd(year,1+floor(rand()*9),@issueDate);

		set @documentTypeId =1+floor(rand()*2);

		select @countryId=id from Country order by newid() offset @counter % (
			select count(*) from Country
		) rows fetch next 1 rows only;

		insert into Document(Date_of_Issue,Valid_Date,Customer_id,Country_id, Document_Type_id) 
		values(@issueDate, @validDate, @customerId, @countryId, @documentTypeId);

		delete from @tempCustomer where id=@customerId;

		set @counter=@counter+1;
	end

	while @counter<@length
	begin

	set @issueDate=dateadd(day,floor(rand()*datediff(day,@minIssueDate,@maxIssueDate)+1),@minIssueDate);
	set @validDate=dateadd(year,1+floor(rand()*9),@issueDate);

	select @customerId=id from Customer order by newid() offset @counter % ( 
		select count(*) from Customer
	) rows fetch next 1 rows only;

	select @countryId=id from Country order by newid() offset @counter % (
		select count(*) from Country
	) rows fetch next 1 rows only;

	set @documentTypeId =1+floor(rand()*2);

	insert into Document(Date_of_Issue,Valid_Date,Customer_id,Country_id, Document_Type_id) 
	values(@issueDate, @validDate, @customerId, @countryId, @documentTypeId);

	set @counter=@counter+1;
	end

end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('City','U') is null
begin
	create table City(
	id int identity(1,1) primary key,
	Country_id int not null,
	Name varchar(30) not null,
	foreign key (Country_id) references Country(id)
	);

	create index City on City(Name);
end
go

if not exists(select 1 from City)
begin
	declare @length int=14;
	declare @counter int=0;

	while @counter<=@length
	begin
	insert into City(Name,Country_id)
	values('city '+cast(@counter as varchar(10)),
	(select top 1 id from Country order by newid()));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------


if object_id('Airport', 'U') is null
begin
	create table Airport(
	id int identity(1,1) primary key,
	Name varchar(30) not null,
	City_id int not null,
	foreign key (City_id) references City(id),
	unique (Name),
	);

	create index Airport_Name on Airport(Name);
end 
go

if not exists(select 1 from Airport)
begin
	declare @length int=40;
	declare @counter int=0;

	while @counter<=@length
	begin
	insert into Airport(Name,City_id)
	values('airport '+cast(@counter as varchar(10)),
	(select top 1 id from City order by newid()));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Plane_Model', 'U') is null
begin
	create table Plane_Model(
	id int identity(1,1) primary key,
	Description varchar(60) not null,
	Graphic varchar(50) not null,
	);
end 
go

if not exists(select 1 from Plane_Model)
begin
    insert into Plane_Model (Description, Graphic) values
    ('Boeing 737', 'boeing737.png'),
    ('Airbus A320', 'airbusA320.png'),
    ('Boeing 777', 'boeing777.png'),
    ('Airbus A380', 'airbusA380.png'),
    ('Embraer E190', 'embraerE190.png');
end
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Frequent_Flyer_Card', 'U') is null
begin
	create table Frequent_Flyer_Card(
	FFC_Number int identity(1,1) primary key,
	Miles int not null,
	Meal_Code int not null default 3,
	Customer_id int not null,
	foreign key (Customer_id) references Customer(id),
	constraint Check_miles check (Miles >= 100 and Miles <=8000),
	constraint Check_meal_code check (Meal_Code >=1 and Meal_Code <=10),
	);

	create index FFC_CustomerId on Frequent_Flyer_Card(Customer_id);
end 
go

if not exists(select 1 from Frequent_Flyer_Card)
begin
	declare @length tinyint=(select count(*) from Customer);
	declare @counter int=1;
	declare @maxMiles int=8000;
	declare @minMiles int=100;
	declare @maxMealCode tinyint=10;
	declare @minMealCode tinyint=1;

	while @counter <= @length
	begin
		insert into Frequent_Flyer_Card (Miles, Meal_Code,Customer_id) values(
		(floor(rand()*(@maxMiles- @minMiles+1)+@minMiles)),
		(floor(rand()*(@maxMealCode-@minMealCode+1)+@minMealCode)),
		@counter
		);

		set @counter=@counter+1;
	end
end
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
	create table Airplane(
	Registration_Number int identity(1,1) primary key,
	Begin_of_Operation date not null,
	Status varchar(15) not null default 'Active',
	Plane_Model_id int not null,
	foreign key (Plane_Model_id) references Plane_Model(id),
	constraint Check_status check (Status in('Active', 'Inactive', 'Maintenance'))
	);

	create index Airplane_Status on Airplane(Registration_Number, Status);
end 
go

if not exists(select 1 from Airplane)
begin

	declare @length tinyint=50;
	declare @minBeginDate date='2000-01-01';
	declare @maxBeginDate date= getdate();
	declare @counter tinyint=0;
	declare @beginDate date;
	declare @status varchar(15);
	declare @planeModelId int;
	declare @randomValue tinyint;

	while @counter<@length
	begin
		set @beginDate=dateadd(day,floor(rand()*datediff(day,@minBeginDate, @maxBeginDate)+1),@minBeginDate);

		set @randomValue=floor(rand()*3)

		if @randomValue=0
			set @status='Active'
		else if @randomValue=1
			set @status='Inactive'
		else
			set @status='Maintenance'

		select @planeModelId=id from Plane_Model order by newid() offset @counter %(
			select count(*) from Plane_Model
		) rows fetch next 1 rows only;

		insert into Airplane(Begin_of_Operation, Status, Plane_Model_id) values
		(@beginDate,@status, @planeModelId)

		set @counter=@counter +1;
	end
end

--------------------------------------------------------------------------------------------------------------------------


if object_id('Flight_Number', 'U') is null
begin
	create table Flight_Number(
	id int identity(1,1) primary key,
	Departure_Time time not null,
	Description varchar(50) not null,
	Type bit not null,
	Airline varchar(20) not null,	--hacer una tabla
	Airport_Start int not null,
	Airport_Goal int not null,
	foreign key (Airport_Start) references Airport(id),
	foreign key (Airport_Goal) references Airport(id),
	constraint Check_airtport check (Airport_Start <> Airport_Goal),
	);

	create index Travel on Flight_Number(Airport_Start, Airport_Goal);
end 
go

if not exists(select 1 from Flight_Number)
begin 

	declare @length tinyint=30;
	declare @counter tinyint=0;
	declare @departureTime time;
	declare @description varchar(50);
	declare @type bit;
	declare @airline varchar(20);
	declare @airportStart int;
	declare @airportGoal int;
	declare @offset int;

	declare @airlines table (name varchar(20));
	insert into @airlines (name)
	values ('Airline A'), ('Airline B'), ('Airline C'), ('Airline D');

	while @counter<@length
	begin
		
		set @departureTime=cast(dateadd(minute,floor(rand()*1440),'00:00:00')as time)

		set @type =floor(rand()*2);

		select @airline=name from @airlines order by newid() offset 0 rows fetch next 1 row only;

		set @offset=floor(rand()*(select count(*) from Airport));

		select @airportStart=id from Airport order by newid() offset @offset rows fetch next 1 row only;

		while @airportGoal is null or @airportGoal=@airportStart
		begin
			set @offset=floor(rand()*(select count(*) from Airport));
			select @airportGoal=id from Airport order by newid() offset @offset rows fetch next 1 row only;
		end
		set @description='Flight '+cast(@airportStart as varchar(15))+' to'+cast(@airportGoal as varchar(15))

		insert into Flight_Number(Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal)
		values(@departureTime, @description, @type, @airline, @airportStart, @airportGoal);

		set @airportGoal=null;

		set @counter=@counter+1;
	end
end

--------------------------------------------------------------------------------------------------------------------------

if object_id('Category', 'U') is null
begin
	create table Category(
	id int identity(1,1) primary key,
	Name varchar(20) not null,
	constraint Check_NameCategory check(Name in ('Economic','Premium Economic', 'Business','First Class'))
	);

	create index Category_Name on Category(Name);
end

if not exists(select 1 from Category)
begin
	insert into Category(Name) values
	('Economic'),
	('Premium Economic'), 
	('Business'),
	('First Class');
end

--------------------------------------------------------------------------------------------------------------------------

if object_id('Ticket', 'U') is null
begin
	create table Ticket(
	Ticketing_Code int identity(1,1) primary key,
	Number int not null,
	Customer_id int not null,
	Category_id int not null,
	foreign key (Customer_id) references Customer(id),
	foreign key (Category_id) references Category(id),
	);

	create index Ticket_info on Ticket(Customer_id, Category_id, Number);
end 
go

if not exists(select 1 from Ticket)
begin
	declare @length tinyint=30;
	declare @counter tinyint=0;
	declare @ticketNumber int;
	declare @customerId int;
	declare @categoryId int;
	declare @categoryCount int;
	declare @offset int;

	select @categoryCount=count(*) from Category;

	while @counter < @length
	begin
		set @ticketNumber=1000+floor(rand()*9000);

		select @customerId=id from Customer order by newid()  offset 0 rows fetch next 1 row only;

		select @categoryId=id from Category order by newid() offset 0 rows fetch next 1 row only;


		insert into Ticket(Number, Customer_id, Category_id)
		values(@ticketNumber, @customerId, @categoryId)

		set @counter=@counter+1;
	end
end 

--------------------------------------------------------------------------------------------------------------------------

if object_id('Flight', 'U') is null
begin
	create table Flight(
	id int identity(1,1) primary key,
	Boarding_Time time not null,
	Flight_Date date not null,
	Gate tinyint not null,
	Check_In_Counter bit not null,
	Flight_Number_id int not null,
	foreign key (Flight_Number_id) references Flight_Number(id),
	constraint Check_FD check (Flight_Date >= getdate()),
	);

	create index Flight_info on Flight(Gate, Boarding_Time);
end 
go

if not exists (select 1 from Flight)
begin
	declare @length tinyint = 30;
	declare @counter tinyint = 0;
	declare @boardingtime time;
	declare @flightdate date;
	declare @gate tinyint;
	declare @checkincounter bit;
	declare @flightnumberid int;
	declare @maxflightnumberid int;

	select @maxflightnumberid = max(id) from flight_number;

	while @counter < @length
	begin
		set @boardingtime = cast(dateadd(minute, floor(rand() * 1440), '00:00:00') as time);

		set @flightdate = dateadd(day, floor(rand() * 365) + 1, cast(getdate() as date));

		set @gate = floor(rand() * 256);

		set @checkincounter = floor(rand() * 2);
		set @flightnumberid = floor(rand() * @maxflightnumberid) + 1;

		insert into flight (boarding_time, flight_date, gate, check_in_counter, flight_number_id)
		values (@boardingtime, @flightdate, @gate, @checkincounter, @flightnumberid);

		set @counter = @counter + 1;
	end
end
go


--------------------------------------------------------------------------------------------------------------------------

if object_id('Seat', 'U') is null
begin
	create table Seat(
	id int identity(1,1) primary key,
	Size varchar(10) not null default 'Medium', 
	Number int not null,
	Location varchar(30) not null,
	Plane_Model_id int not null,
	foreign key (Plane_Model_id) references Plane_Model(id),
	constraint Check_size check (size in ('Small', 'Medium', 'Large'))
	);

	create index Seat_info on Seat(Size, Location);
end 
go

if not exists (select 1 from seat)
begin
	declare @length tinyint = 30;
	declare @counter tinyint = 0;
	declare @size varchar(10);
	declare @number int;
	declare @location varchar(30);
	declare @planemodelid int;
	declare @maxplanemodelid int;

	select @maxplanemodelid = max(id) from plane_model;

	while @counter < @length
	begin
		set @size = case floor(rand() * 3)
			when 0 then 'small'
			when 1 then 'medium'
			else 'large'
		end;

		set @number = floor(rand() * 100) + 1;

		set @location = 'row ' + cast(floor(rand() * 20) + 1 as varchar(2)) + ', seat ' + cast(floor(rand() * 30) + 1 as varchar(2));

		set @planemodelid = floor(rand() * @maxplanemodelid) + 1;

		insert into seat (size, number, location, plane_model_id)
		values (@size, @number, @location, @planemodelid);

		set @counter = @counter + 1;
	end
end
go


--------------------------------------------------------------------------------------------------------------------------

if object_id('Available_Seat', 'U') is null
begin
	create table Available_Seat(
	id int identity(1,1) primary key,
	Flight_id int not null,
	Seat_id int not null,
	foreign key (Flight_id) references Flight(id),
	foreign key (Seat_id) references Seat(id),
	);
end 
go

if not exists (select 1 from available_seat)
begin
    declare @length tinyint = 30;
    declare @counter tinyint = 0;
    declare @flightid int;
    declare @seatid int;
    declare @maxflightid int;
    declare @maxseatid int;

    select @maxflightid = max(id) from flight;

    select @maxseatid = max(id) from seat;

    while @counter < @length
    begin
        set @flightid = floor(rand() * @maxflightid) + 1;

        set @seatid = floor(rand() * @maxseatid) + 1;

        insert into available_seat (flight_id, seat_id)
        values (@flightid, @seatid);

        set @counter = @counter + 1;
    end
end
go


--------------------------------------------------------------------------------------------------------------------------

if object_id('Coupon', 'U') is null
begin
	create table Coupon(
	id int identity(1,1) primary key,
	Date_of_Redemption date not null,
	Class varchar(20) not null,
	Standby varchar(20) not null,
	Meal_Code int not null,
	Ticketing_Code int not null,
	Flight_id int not null,
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code),
	foreign key (Flight_id) references Flight(id),
	constraint Check_MCC check (Meal_Code >=1 and Meal_Code <=10),
	);

	create index Coupon_info on Coupon(Class, Meal_Code, Date_of_Redemption);
end 
go

if not exists (select 1 from coupon)
begin
    declare @length tinyint = 30;
    declare @counter tinyint = 0;
    declare @dateofredemption date;
    declare @class varchar(20);
    declare @standby varchar(20);
    declare @mealcode int;
    declare @ticketingcode int;
    declare @flightid int;
    declare @maxticketingcode int;
    declare @maxflightid int;

    select @maxticketingcode = max(ticketing_code) from ticket;
    select @maxflightid = max(id) from flight;

    declare @classes table (classname varchar(20));
    insert into @classes (classname)
    values ('economy'), ('premium economy'), ('business'), ('first class');

    declare @standbyoptions table (standbyoption varchar(20));
    insert into @standbyoptions (standbyoption)
    values ('yes'), ('no');

    while @counter < @length
    begin
        set @dateofredemption = dateadd(day, floor(rand() * 30), getdate());

        select top 1 @class = classname
        from @classes
        order by newid();

        select top 1 @standby = standbyoption
        from @standbyoptions
        order by newid();

        set @mealcode = floor(rand() * 10) + 1;

        select @ticketingcode = ticketing_code
        from (
            select ticketing_code, row_number() over (order by newid()) as rn
            from ticket
        ) as sub
        where rn = floor(rand() * (select count(*) from ticket)) + 1;

        select @flightid = id
        from (
            select id, row_number() over (order by newid()) as rn
            from flight
        ) as sub
        where rn = floor(rand() * (select count(*) from flight)) + 1;

        insert into coupon (date_of_redemption, class, standby, meal_code, ticketing_code, flight_id)
        values (@dateofredemption, @class, @standby, @mealcode, @ticketingcode, @flightid);

        set @counter = @counter + 1;
    end
end
go


--------------------------------------------------------------------------------------------------------------------------

if object_id('Available_Seat_Coupon', 'U') is null
begin
	create table Available_Seat_Coupon(
	Coupon_id int not null,
	Available_Seat_id int not null,
	foreign key (Available_Seat_id) references Available_Seat(id),
	foreign key (Coupon_id) references Coupon(id),
	);
end 
go

if not exists (select 1 from available_seat_coupon)
begin
    declare @length tinyint = 30;
    declare @counter tinyint = 0;
    declare @couponid int;
    declare @availableseatid int;

    declare @maxcouponid int;
    declare @maxavailableseatid int;

    select @maxcouponid = max(id) from coupon;
    select @maxavailableseatid = max(id) from available_seat;

    while @counter < @length
    begin
        select @couponid = id
        from (
            select id, row_number() over (order by newid()) as rn
            from coupon
        ) as sub
        where rn = floor(rand() * (select count(*) from coupon)) + 1;

        select @availableseatid = id
        from (
            select id, row_number() over (order by newid()) as rn
            from available_seat
        ) as sub
        where rn = floor(rand() * (select count(*) from available_seat)) + 1;

        insert into available_seat_coupon (coupon_id, available_seat_id)
        values (@couponid, @availableseatid);

        set @counter = @counter + 1;
    end
end
go


--------------------------------------------------------------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
	create table Pieces_of_Luggage(
	id int identity(1,1) primary key,
	Number int not null,
	Weight int not null,
	Coupon_id int not null,
	foreign key (Coupon_id) references Coupon(id),
	constraint Check_weight check(Weight >=0 and Weight <=50)
	);

	create index POF_info on Pieces_of_Luggage(Weight, Number);
end 
go

if not exists (select 1 from pieces_of_luggage)
begin
    declare @length tinyint = 30;
    declare @counter tinyint = 0;
    declare @number int;
    declare @weight int;
    declare @couponid int;
    declare @maxcouponid int;

    select @maxcouponid = max(id) from coupon;

    while @counter < @length
    begin
        set @number = floor(rand() * 1000) + 1;

        set @weight = floor(rand() * 51);

        select @couponid = id
        from (
            select id, row_number() over (order by newid()) as rn
            from coupon
        ) as sub
        where rn = floor(rand() * (select count(*) from coupon)) + 1;

        insert into pieces_of_luggage (number, weight, coupon_id)
        values (@number, @weight, @couponid);

        set @counter = @counter + 1;
    end
end
go
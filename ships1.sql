DROP TABLE Dim_Ship
DROP TABLE fact_trip

CREATE TABLE Dim_Ship(
 id int,
 ShipName varchar(255),
 ShipType varchar(255),
 Nationality varchar(255),
 PRIMARY KEY(id))
 
 Select * from Dim_Ship
 
 
 CREATE TABLE Fact_Trip(
 id int,
 RecID int,
 Year int,
 Month int,
 Day int,
 Distance int,
 Lat3 int,
 Lon3 int,
 DimShipId int REFERENCES Dim_Ship(id),
 strDate varchar(255),
 Date DATE)
 
 Select * from Fact_Trip

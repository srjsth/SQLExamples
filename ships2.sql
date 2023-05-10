CREATE TABLE Ships_Staging(
 ShipName varchar(255),
 ShipType varchar(255),
 Nationality varchar(255));

select * from ships_staging;


CREATE TABLE Trips_Staging(
 ShipName varchar(255),
 ShipType varchar(255),
 Nationality varchar(255),
 RecID int,
 Year int,
 Month int,
 Day int,
 Distance int,
 Lat3 int,
 Lon3 int);

UPDATE Trips_Staging SET ShipType = 'N/A' WHERE ShipType IS NULL;
UPDATE ships_staging SET ShipType = 'N/A' WHERE ShipType IS NULL;


select DISTINCT ShipName, ShipType, Nationality from Trips_Staging WHERE ShipType is null ORDER BY nationality;


SELECT COUNT(*) as count_distinct_Ships
FROM (
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Ships_Staging)s;


SELECT DISTINCT ShipName, ShipType, Nationality
FROM Trips_Staging WHERE (ShipName, ShipType, Nationality) NOT IN(
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Ships_Staging)

SELECT DISTINCT ShipName, ShipType, Nationality
FROM ships_staging
UNION
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Trips_Staging WHERE (ShipName, ShipType, Nationality) NOT IN(
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Ships_Staging)


CREATE TABLE DimShipSQL(
 dimshipid SERIAL NOT NULL,
 ShipName varchar(255),
 ShipType varchar(255),
 Nationality varchar(255),
 PRIMARY KEY(dimshipid));

INSERT INTO DimShipSQL(dimshipid, shipname, shiptype, nationality)
SELECT row_number() OVER () AS dimshipid, shipname, shiptype, nationality
from(
SELECT DISTINCT ShipName, ShipType, Nationality
FROM ships_staging
UNION
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Trips_Staging 
	WHERE (ShipName, ShipType, Nationality) NOT IN(
SELECT DISTINCT ShipName, ShipType, Nationality
FROM Ships_Staging)
	)s

select * from DimShipSQL
select count(*) from DimShipSQL

 CREATE TABLE TripFactSQL (
 TripFactSQLID Serial NOT NULL,
 DimShipID int REFERENCES DimShipSQL(DimShipID) NOT NULL,
 TripRecID int,
 Date DATE,
 Distance int,
 Lat3 int,
 Lon3 int,
 PRIMARY KEY(TripFactSQLID));
 
 
 DROP VIEW factview
 
 CREATE VIEW FactView AS
 SELECT row_number() OVER () AS TripFactSQLID, DimShipID, RecID, Year, Month, Day, Distance, Lat3, Lon3
 FROM Trips_Staging A
 INNER JOIN DimShipSQL B ON ((A.ShipName = B.ShipName) 
						  AND (A.ShipType = B.ShipType) 
						  AND (A.Nationality = B.Nationality))
 
select * from FactView 

create or replace function check_date(arg text)
returns date language plpgsql
as $$
begin
    begin
        return to_date(arg, 'yyyy/mm/dd');
    exception when others then
        return NULL;
    end;
end $$;

CREATE VIEW dateview as
SELECT TripFactSQLID,TO_DATE((check_date(strDate))::TEXT, 'YYYY/MM/DD') AS Date FROM(
SELECT TripFactSQLID, 
CASE
    WHEN Year = NULL THEN NULL
	WHEN Month = NULL THEN NULL
	WHEN Day = NULL THEN NULL
	ELSE CONCAT(Year,'/',Month,'/',Day )
END AS strDate
FROM FactView)S

select * from dateview

INSERT INTO TripFactSQL(TripFactSQLID, DimShipID, TripRecID, Date, Distance, Lat3, Lon3)
SELECT factview.TripFactSQLID, DimShipID, RecID, Date, Distance, Lat3, Lon3
FROM factview 
JOIN dateview
ON factview.tripfactsqlid = dateview.tripfactsqlid


select * from TripFactSQL



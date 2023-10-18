# Nashivlle-Data-Cleaning

## Introduction
Nashville data cleaning prpject is an extensive data cleaning project that I recently completed. The project aims to test my ability to use SQL to clean a dirty data making it clean and useful for further analysis.

## Tool
SQL Server Managemnt Studio

## Data Source.
 - [Download here](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)

## Data Anatomy

The data was downloaded as a Microsoft Excel file and had to be imported into SSMS using the import and export wizard of SSMS. After importation, it was discovered that the data consisted of 19 columns (which included unique ID, property address, owner address, zip code and more) And about 57000 rows.

## Special SQL Functions in this Project

``` sql
---Conversion of Datetime to date
SELECT Saledate, convert(date,     Saledate)
FROM Nashivlle

---Self Join
SELECT *
FROM Nashivlle a
JOIN Nashivlle b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] != b.[UniqueID ]

---Self Join and use of ISNULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress) 
FROM Nashivlle a
JOIN Nashivlle b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null.


---Use of Substring and CharIndex to locate and Split columns

SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as address,
SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress) +1, Len(propertyAddress)) as City
--CHARINDEX(',', PropertyAddress)
FROM Nashivlle

--- Use of Parsename to split owner address.


SELECT
PARSENAME(Replace(owneraddress, ',', '.'), 3), 
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
FROM Nashivlle

--- Use of Case Statement


SELECT soldasvacant,
Case When Soldasvacant = 'Y' THEN 'Yes'
     When Soldasvacant = 'N' THEN 'NO'
	 Else Soldasvacant
END
FROM Nashivlle

---Using row-num and CTE to delete duplicate values

SELECT *, row_number() over ( 
          PARTITION BY ParcelID, 
		               Propertyaddress, 
		               Saleprice, 
					   Saledate, 
					   legalreference 
					   ORDER BY UniqueID
					   ) row_num
FROM NASHIVLLE
order by ParcelID

WITH Row_numCTE AS (
 SELECT *, row_number() over ( 
          PARTITION BY ParcelID, 
		               Propertyaddress, 
		               Saleprice, 
					   Saledate, 
					   legalreference 
					   ORDER BY UniqueID
					   ) row_num

FROM Nashivlle
)

SELECT * FROM Row_numCTE
Where row_num > 1



----DELETE columns
Alter table Nashivlle
DROP COLUMN owneraddress, propertyaddress, taxdistrict, saledate
```

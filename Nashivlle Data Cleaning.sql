SELECT * FROM Nashivlle ---Testing the imported data to ensure it got imported properly

-----Cleaning the date format for saledate from datetime to date
SELECT Saledate FROM Nashivlle

SELECT Saledate, convert(date, Saledate)
FROM Nashivlle
---updating the table
UPDATE Nashivlle
SET SaleDate = convert(date, Saledate) ---Does not work you will need to create a column abd populate the column

ALTER TABLE Nashivlle
ADD saledateConverted Date

UPDATE Nashivlle
SET saledateConverted = convert(date, Saledate)

----Going down to property address
SELECT PropertyAddress
FROM Nashivlle
where PropertyAddress is null

SELECT *
FROM Nashivlle
--where PropertyAddress is null
order by ParcelID
----We need to do self join

SELECT *
FROM Nashivlle a
JOIN Nashivlle b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] != b.[UniqueID ]


  ----WE use ISNULL to compare and populate the missing values in the property address column. This was possible because we discovered that
  -----the parcel Id of some of rows have the same property address. This could only mean that only the property owner with the parcelID
  ----- had more than 1 property. And so we carried out a self join and used ISNULL to compare and populate

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress) 
FROM Nashivlle a
JOIN Nashivlle b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null

----Updating the table
UPDATE a
SET PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress) 
FROM Nashivlle a
JOIN Nashivlle b
  on a.ParcelID = b.ParcelID
  AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null


-----Remove the delimiter using character index and a delimiter. We are spliting the property address into address and city
SELECT PropertyAddress
FROM Nashivlle
---Using Parsename and substrings
SELECT propertyAddress,
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2),
PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)
FROM Nashivlle

SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress)) as address
FROM Nashivlle


SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress)) as address,
CHARINDEX(',', PropertyAddress)
FROM Nashivlle





SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as address
--CHARINDEX(',', PropertyAddress)
FROM Nashivlle

SELECT
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1) as address,
SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress) +1, Len(propertyAddress)) as City
--CHARINDEX(',', PropertyAddress)
FROM Nashivlle

---Let add it to the table

ALTER TABLE Nashivlle
ADD propertysplitaddress NVARCHAR(255)

UPDATE Nashivlle
SET  propertysplitaddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE Nashivlle
ADD propertycitylocation nvarchar(255)

UPDATE Nashivlle
SET propertycitylocation = SUBSTRING(Propertyaddress, CHARINDEX(',', PropertyAddress) +1, Len(propertyAddress))

SELECT * FROM Nashivlle



--SELECT OwnerAddress
--, SUBSTRING(Owneraddress, 1, CHARINDEX(',', owneraddress) -1)
--,SUBSTRING(owneraddress, CHARINDEX(', TN', Owneraddress) +2, len(Owneraddress))
--FROM Nashivlle

--SELECT OwnerAddress
--, SUBSTRING(Owneraddress, 1, CHARINDEX(',', Owneraddress) -1)
--, SUBSTRING(Owneraddress, CHARINDEX(',', Owneraddress) +2, len(Owneraddress))
--,SUBSTRING(owneraddress, CHARINDEX('TN', Owneraddress) -1, len(Owneraddress))
--FROM Nashivlle


SELECT
PARSENAME(owneraddress, 1) ----Parsename looks for period
FROM Nashivlle



SELECT
PARSENAME(Replace(owneraddress, ',', '.'), 3), 
PARSENAME(REPLACE(owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(owneraddress, ',', '.'), 1)
FROM Nashivlle

ALTER TABLE Nashivlle
ADD ownersplitaddress NVARCHAR(255)

UPDATE Nashivlle
SET ownersplitaddress = PARSENAME(Replace(owneraddress, ',', '.'), 3)

ALTER TABLE Nashivlle
ADD ownersplitcity nvarchar(255)

UPDATE Nashivlle
SET ownersplitcity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)

ALTER TABLE Nashivlle
ADD ownersplitstate NVARCHAR(255)

UPDATE Nashivlle
SET  ownersplitstate =PARSENAME(REPLACE(owneraddress, ',', '.'), 1)


SELECT * FROM 
Nashivlle
----Let clean the soldasvacant column.
SELECT distinct(soldasvacant)
FROM Nashivlle ---- Runing the selected query shows that it contains a mixture of Yes, No, N, and Y

SELECT distinct(soldasvacant), Count(soldasvacant)
FROM Nashivlle
GROUP by soldasvacant
ORDER by 2

SELECT soldasvacant,
Case When Soldasvacant = 'Y' THEN 'Yes'
     When Soldasvacant = 'N' THEN 'NO'
	 Else Soldasvacant
END
FROM Nashivlle

UPDATE Nashivlle
SET SoldAsVacant =Case When Soldasvacant = 'Y' THEN 'Yes'
     When Soldasvacant = 'N' THEN 'NO'
	 Else Soldasvacant
END
-----Deleting duplicates using row_number and the use of CTE
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



SELECT  OwnerName,
CASE When ownername is null then 'Not Available'
     Else OwnerName
END
FROM [Nashivlle Housing].dbo.Nashivlle

SELECT * FROM Nashivlle

SELECT distinct(UniqueId)
FROM Nashivlle

SELECT [ParcelID], PropertyAddress
FROM Nashivlle
Group by [ParcelID],


/*

--Cleaning Data in SQL Queries

*/


SELECT*
FROM [portfolio project]..NASHVILLEHOUSING
ORDER BY ParcelID

--------------------------------------------------------------------------------------------------------------------------

--STANDARDISE DATE FORMAT

SELECT SALEDATECONVERTED,CONVERT(DATE,SALEDATE) 
FROM [portfolio project]..NASHVILLEHOUSING
ORDER BY ParcelID

UPDATE [portfolio project]..NASHVILLEHOUSING
SET SALEDATE= CONVERT(DATE,SALEDATE) 

--IF IT DOESNT UPDATE PROPERLY

ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD SALEDATECONVERTED DATE;

UPDATE [portfolio project]..NASHVILLEHOUSING
SET SALEDATECONVERTED =CONVERT(DATE,SALEDATE)



--------------------------------------------------------------------------------------------------------------------------

--POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM [portfolio project]..NASHVILLEHOUSING
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
FROM [portfolio project]..NASHVILLEHOUSING a
join [portfolio project]..NASHVILLEHOUSING b
 on a.ParcelID =b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
set Propertyaddress =ISNULL(a.propertyaddress,b.PropertyAddress)
FROM [portfolio project]..NASHVILLEHOUSING a
join [portfolio project]..NASHVILLEHOUSING b
 on a.ParcelID =b.ParcelID
  and a.[UniqueID ]<>b.[UniqueID ]



  --------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [portfolio project]..NASHVILLEHOUSING

select 
substring(PropertyAddress,1, charindex(',',PropertyAddress)-1) AS ADDRESS
, SUBSTRING(PROPERTYADDRESS,charindex(',',PropertyAddress)+1,LEN(PROPERTYADDRESS)) AS ADDRESS
FROM [portfolio project]..NASHVILLEHOUSING 
ORDER BY ParcelID

ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD PROPERTYSPLITADDRESS NVARCHAR(255);

UPDATE [portfolio project]..NASHVILLEHOUSING
SET  PROPERTYSPLITADDRESS =substring(PropertyAddress,1, charindex(',',PropertyAddress)-1)


ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD PROPERTYSPLITCITY NVARCHAR(255);

UPDATE [portfolio project]..NASHVILLEHOUSING
SET PROPERTYSPLITCITY =SUBSTRING(PROPERTYADDRESS,charindex(',',PropertyAddress)+1,LEN(PROPERTYADDRESS))

SELECT*
FROM [portfolio project]..NASHVILLEHOUSING





SELECT OWNERADDRESS
FROM [portfolio project]..NASHVILLEHOUSING

SELECT 
PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
FROM [portfolio project]..NASHVILLEHOUSING
ORDER BY ParcelID

ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD OWNERSPLITADDRESS NVARCHAR(255);

UPDATE [portfolio project]..NASHVILLEHOUSING
SET  OWNERSPLITADDRESS =PARSENAME(REPLACE(OWNERADDRESS,',','.'),3)

ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD OWNERSPLITCITY NVARCHAR(255);

UPDATE [portfolio project]..NASHVILLEHOUSING
SET  OWNERSPLITCITY =PARSENAME(REPLACE(OWNERADDRESS,',','.'),2)

ALTER TABLE [portfolio project]..NASHVILLEHOUSING
ADD OWNERSPLITSTATE NVARCHAR(255);

UPDATE [portfolio project]..NASHVILLEHOUSING
SET  OWNERSPLITSTATE =PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)


SELECT *
FROM [portfolio project]..NASHVILLEHOUSING



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT distinct(soldasvacant), count(soldasvacant)
from [portfolio project]..NASHVILLEHOUSING
group by SoldAsVacant
order by 2


select soldasvacant,
case when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end
from [portfolio project]..NASHVILLEHOUSING

update [portfolio project]..NASHVILLEHOUSING
set soldasvacant=case when soldasvacant='y' then 'yes'
when soldasvacant='n' then 'no'
else soldasvacant
end




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


with row_numCTE as(
select *,
row_number() over(
partition by ParcelID,
             PropertyAddress,
             SalePrice,
             saledate,
             legalreference
             ORDER BY 
             UniqueID
             ) as row_num
from [portfolio project]..NASHVILLEHOUSING
--order by ParcelID
)
select*
from row_numCTE
where row_num > 1
--order by PropertyAddress

select*
from [portfolio project]..NASHVILLEHOUSING





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


 
 select*
from [portfolio project]..NASHVILLEHOUSING

Alter table [portfolio project]..nashvillehousing
drop column taxdistrict, owneraddress, propertyaddress,saledate











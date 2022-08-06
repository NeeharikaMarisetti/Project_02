--cleaning data through SQL Queries

select * 
from Portfolio_project_01.dbo.Nashvilehousing



-- Standardising Date formate (from date time to date)
select SaleDate
from Portfolio_project_01.dbo.Nashvilehousing

ALTER TABLE Portfolio_project_01.dbo.Nashvilehousing
ADD SaleDateConverted Date

 UPDATE Nashvilehousing
 set SaleDateConverted = CONVERT(Date,SaleDate)

 select SaleDateConverted
 from Portfolio_project_01.dbo.Nashvilehousing



 -- Populating NULL Values with data

 --1. checking the null values in property address
 select *
 from Portfolio_project_01.dbo.Nashvilehousing
 where PropertyAddress is null

 --2.person with same parcelID has same property adress, so populating with data
 select a.ParcelID,a.PropertyAddress,b.PropertyAddress,  b.ParcelID
 from Portfolio_project_01.dbo.Nashvilehousing a
 JOIN Portfolio_project_01.dbo.Nashvilehousing b
 ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null   

 UPDATE a
 SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from Portfolio_project_01.dbo.Nashvilehousing a
 JOIN Portfolio_project_01.dbo.Nashvilehousing b
 ON a.ParcelID = b.ParcelID
    AND a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null 

 select *
 from Portfolio_project_01.dbo.Nashvilehousing
 where PropertyAddress is null


 -- Breaking out Address into Individual Columns( Address, City, State)
 select PropertyAddress
 from Portfolio_project_01.dbo.Nashvilehousing

 select PropertyAddress,
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))
 from Portfolio_project_01.dbo.Nashvilehousing

 ALTER TABLE Nashvilehousing
 add Propertysplitaddress varchar(255)

 Update Nashvilehousing
 SET Propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)


 ALTER TABLE Nashvilehousing
 add PropertysplitCity varchar(255)

  Update Nashvilehousing
 SET  PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


   --- Changing values in the column
   select SoldAsVacant, 
   case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END 
   from Portfolio_project_01.dbo.Nashvilehousing


   UPDATE Nashvilehousing
   SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
		END 


-- Remove Duplicates
select *
 from Portfolio_project_01.dbo.Nashvilehousing

WITH  RowNumCTE AS
( select  *, 
      ROW_NUMBER() over(
	  partition by	ParcelID, 
                    PropertyAddress,
		        	SaleDate,
					SalePrice,
					LegalReference
					ORDER BY UniqueID) num
                  from  Portfolio_project_01.dbo.Nashvilehousing
				 )
delete from RowNumCTE
where num >1

select *
from RowNumCTE



-- Delete unused columns
select * 
from Portfolio_project_01.dbo.Nashvilehousing
				 
ALTER TABLE Portfolio_project_01.dbo.Nashvilehousing
DROP COLUMN OwnerAddress, TaxDistrict				 				  
				 

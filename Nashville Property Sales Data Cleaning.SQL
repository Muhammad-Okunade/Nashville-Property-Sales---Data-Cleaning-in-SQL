select * from NvilleHs.nnn 

-- Change SaleDate data type from string to date
select SaleDate, parse_date('%B %e, %Y', SaleDate) 
from NvilleHs.nnn 

-- Update Table
UPDATE NvilleHs.nnn 
set SaleDate = parse_date('%B %e, %Y', SaleDate) 

-- Populating Property Address Column
select count(*)
from NvilleHs.nnn 
where PropertyAddress is null 

select * 
from NvilleHs.nnn 
order by PropertyAddress 

# Since, there are multiple entries of the same property (multiple sales), a self-join on the ParcelID will give the missing addresses.
select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress as UpdatedAddress
from NvilleHs.nnn as a
left join NvilleHs.nnn as b 
on a.ParcelID = b.ParcelID 
where b.PropertyAddress is not null 
order by a.PropertyAddress 

select a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress as UpdatedAddress
from NvilleHs.nnn as a
left join NvilleHs.nnn as b 
on a.ParcelID = b.ParcelID and a.UniqueID_ <> b.UniqueID_ 
order by a.PropertyAddress 

update a 
set PropertyAddress = case when a.PropertyAddress is null then b.PropertyAddress else a.PropertyAddress end 
from NvilleHs.nnn as a
left join NvilleHs.nnn as b 
on a.ParcelID = b.ParcelID and a.UniqueID_ <> b.UniqueID_ 

-- Extract City from Property Address
select 
split(PropertyAddress, ',')[safe_ordinal(1)] as nPropertyAddress, split(PropertyAddress, ', ')[safe_ordinal(2)] as nPropertyCity
from NvilleHs.nnn

-- Extract City and State from Owner Address
select 
split (OwnerAddress, ',')[safe_ordinal(1)] as nOwnerAddress, split (OwnerAddress, ',')[safe_ordinal(2)] as nOwnerCity, split (OwnerAddress, ',')[safe_ordinal(3)] as nOwnerState
from NvilleHs.nnn
order by nOwnerCity desc 

-- Remove Duplicates
with includesduplicates as (select *, row_number() over (partition by FullBath, HalfBath, YearBuilt, Bedrooms, TotalValue, BuildingValue, LandValue, TaxDistrict, OwnerAddress, OwnerName, SoldAsVacant, LandUse, ParcelID, SaleDate, SalePrice, PropertyAddress, LegalReference order by UniqueID_) as rn
from NvilleHs.nnn)

select * from includesduplicates 
where rn = 1



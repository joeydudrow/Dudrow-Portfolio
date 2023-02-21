SELECT * 
FROM HousingData

-- Property Address Cleaning
SELECT *
FROM HousingData
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

-- Seperating Address
SELECT PropertyAddress
FROM HousingData

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM HousingData

ALTER TABLE HousingData
ADD PropertySplitAddress NVARCHAR (255);

UPDATE HousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE HousingData
ADD PropertySplitCity NVARCHAR (255);

UPDATE HousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)))

-- Seperating Owner Address
SELECT OwnerAddress
FROM HousingData

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM HousingData


ALTER TABLE HousingData
ADD OwnerSplitAddress NVARCHAR (255);

UPDATE HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE HousingData
ADD OwnerSplitCity NVARCHAR (255);

UPDATE HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE HousingData
ADD OwnerSplitState NVARCHAR (255);

UPDATE HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


-- Changing SoldAsVacant
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM HousingData
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END
FROM HousingData

UPDATE HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END


-- Removing Duplicates

WITH RomNumCTE AS (
SELECT *, 
    ROW_NUMBER() OVER(
        PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        Order BY UniqueID
    ) row_num
FROM HousingData)
DELETE
FROM RomNumCTE
WHERE row_num > 1


-- Removing Unused Columns

ALTER TABLE HousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE HousingData
DROP COLUMN SaleDate

SELECT *
FROM HousingData
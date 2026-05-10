--Create view to see inventory by booth (View 1)
CREATE VIEW vw_InventoryByBooth AS
SELECT 
    i.item_ID,
    i.item_name,
    i.price,
    i.condition,
    i.quantity,
    i.date_added,
    b.booth_ID,
    b.booth_name,
    b.location_description,
    v.vendor_ID,
    v.vendor_name,
    v.vendor_email,
    v.vendor_phone,
    CASE 
        WHEN h.hold_ID IS NOT NULL AND h.status = 'In progress' THEN 'On Hold'
        WHEN sd.sale_ID IS NOT NULL THEN 'Sold'
        ELSE 'Available'
    END AS current_status,
    h.customer_ID AS hold_customer_ID,
    h.hold_date,
    h.release_date
FROM Inventory i
JOIN Booths b ON i.booth_ID = b.booth_ID
LEFT JOIN Vendors v ON i.vendor_ID = v.vendor_ID
LEFT JOIN Customer_Holds h ON i.item_ID = h.item_ID AND (h.status = 'In progress' OR h.release_date IS NULL)
LEFT JOIN Sale_Details sd ON i.item_ID = sd.item_ID
LEFT JOIN Sales s ON sd.sale_ID = s.sale_ID;
GO


-- See available items in a specific booth (View 2)
SELECT * FROM vw_InventoryByBooth WHERE booth_name = 'Valley Flower' AND current_status = 'Available';

--Create view for a summary of vendors sales
CREATE VIEW vw_VendorSalesSummary AS
SELECT 
    v.vendor_ID,
    v.vendor_name,
    COUNT(DISTINCT s.sale_ID) AS total_transactions,
    COUNT(sd.sale_details_ID) AS total_items_sold,
    SUM(sd.final_total) AS total_sales_amount,
    MIN(s.sale_date) AS first_sale_date,
    MAX(s.sale_date) AS last_sale_date
FROM Vendors v
JOIN Inventory i ON v.vendor_ID = i.vendor_ID
JOIN Sale_Details sd ON i.item_ID = sd.item_ID
JOIN Sales s ON sd.sale_ID = s.sale_ID
GROUP BY v.vendor_ID, v.vendor_name;
GO

--test the view with the vendors name
SELECT * FROM vw_VendorSalesSummary
WHERE vendor_name = 'Amy Watering';
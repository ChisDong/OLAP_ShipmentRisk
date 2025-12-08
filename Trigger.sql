CREATE TRIGGER trg_DimBuyer_Insert_OnlyNew
ON DimBuyer
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimBuyer (
        Buyer_ID,
        Organization_ID,
        Dominant_Buyer_Flag,
        Available_Historical_Records,
        Data_Sharing_Consent
        -- thêm các cột khác nếu có, MIỄN là nullable hoặc có default
    )
    SELECT DISTINCT
        i.Buyer_ID,
        i.Organization_ID,
        i.Dominant_Buyer_Flag,
        i.Available_Historical_Records,
        i.Data_Sharing_Consent
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimBuyer d
        WHERE d.Buyer_ID = i.Buyer_ID
          AND d.Organization_ID = i.Organization_ID
    );
END;
GO

------

CREATE TRIGGER trg_DimSupplier_Insert_OnlyNew
ON DimSupplier
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimSupplier (
        Supplier_ID,
        Supplier_Reliability_Score,
        Historical_Disruption_Count
        -- thêm cột khác nếu bảng bạn có
    )
    SELECT DISTINCT
        i.Supplier_ID,
        i.Supplier_Reliability_Score,
        i.Historical_Disruption_Count
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimSupplier d
        WHERE d.Supplier_ID = i.Supplier_ID
    );
END;
GO

----

CREATE TRIGGER trg_DimProductCategory_Insert_OnlyNew
ON DimProductCategory
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimProductCategory (
        Product_Category
        -- thêm cột mô tả khác nếu có
    )
    SELECT DISTINCT
        i.Product_Category
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimProductCategory d
        WHERE d.Product_Category = i.Product_Category
    );
END;
GO
--------

CREATE TRIGGER trg_DimShippingMode_Insert_OnlyNew
ON DimShippingMode
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimShippingMode (
        Shipping_Mode
        -- thêm cột mô tả khác nếu có
    )
    SELECT DISTINCT
        i.Shipping_Mode
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimShippingMode d
        WHERE d.Shipping_Mode = i.Shipping_Mode
    );
END;
GO
--------

CREATE TRIGGER trg_DimDisruption_Insert_OnlyNew
ON DimDisruption
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimDisruption (
        Disruption_Type,
        Disruption_Severity
        -- thêm cột khác nếu có
    )
    SELECT DISTINCT
        i.Disruption_Type,
        i.Disruption_Severity
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimDisruption d
        WHERE d.Disruption_Type    = i.Disruption_Type
          AND d.Disruption_Severity = i.Disruption_Severity
    );
END;
GO

----------

CREATE TRIGGER trg_DimDate_Insert_OnlyNew
ON DimDate
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO DimDate (
        DateKey,
        FullDate,
        [Year],
        [Quarter],
        [Month],
        [Day],
        [DayOfWeek]
        -- thêm cột khác nếu có
    )
    SELECT DISTINCT
        i.DateKey,
        i.FullDate,
        i.[Year],
        i.[Quarter],
        i.[Month],
        i.[Day],
        i.[DayOfWeek]
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimDate d
        WHERE d.DateKey = i.DateKey
    );
END;
GO
---------
CREATE TRIGGER trg_DimOrganization_Insert_OnlyNew
ON DimOrganization
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Chỉ chèn những Organization_ID chưa có trong DimOrganization
    INSERT INTO DimOrganization (
          Organization_ID
    )
    SELECT
          i.Organization_ID
    
    FROM inserted AS i
    WHERE NOT EXISTS (
        SELECT 1
        FROM DimOrganization d
        WHERE d.Organization_ID = i.Organization_ID
    );
END;
GO

---------

CREATE TRIGGER trg_FactShipment_Insert_OnlyNew
ON FactShipment
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO FactShipment (
        BuyerKey,
        SupplierKey,
        ProductCategoryKey,
        ShippingModeKey,
        DisruptionKey,
        OrderDateKey,
        DispatchDateKey,
        DeliveryDateKey,
        Quantity_Ordered,
        Order_Value_USD,
        Delay_Days,
        Federated_Round,
        Parameter_Change_Magnitude,
        Communication_Cost_MB,
        Energy_Consumption_Joules,
        Supply_Risk_Flag
    )
    SELECT DISTINCT
        i.BuyerKey,
        i.SupplierKey,
        i.ProductCategoryKey,
        i.ShippingModeKey,
        i.DisruptionKey,
        i.OrderDateKey,
        i.DispatchDateKey,
        i.DeliveryDateKey,
        i.Quantity_Ordered,
        i.Order_Value_USD,
        i.Delay_Days,
        i.Federated_Round,
        i.Parameter_Change_Magnitude,
        i.Communication_Cost_MB,
        i.Energy_Consumption_Joules,
        i.Supply_Risk_Flag
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM FactShipment f
        WHERE f.BuyerKey          = i.BuyerKey
          AND f.SupplierKey       = i.SupplierKey
          AND f.ProductCategoryKey= i.ProductCategoryKey
          AND f.ShippingModeKey   = i.ShippingModeKey
          AND f.DisruptionKey     = i.DisruptionKey
          AND f.OrderDateKey      = i.OrderDateKey
          AND f.DispatchDateKey   = i.DispatchDateKey
          AND f.DeliveryDateKey   = i.DeliveryDateKey
    );
END;
GO

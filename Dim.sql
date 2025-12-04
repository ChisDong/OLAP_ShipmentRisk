CREATE DATABASE DOAN
USE DOAN

CREATE TABLE DimDate (
    DateKey     INT         NOT NULL PRIMARY KEY, 
    FullDate    DATE        NOT NULL,
    [Day]       TINYINT     NOT NULL,
    [Month]     TINYINT     NOT NULL,
    [Year]      SMALLINT    NOT NULL,
    [Quarter]   TINYINT     NOT NULL,
    DayOfWeek   TINYINT     NOT NULL                 
);

CREATE TABLE DimBuyer (
    BuyerKey                    INT IDENTITY(1,1) PRIMARY KEY,
    Buyer_ID                    VARCHAR(50)             NOT NULL,  
    Organization_ID             VARCHAR(50)             NULL,
    Dominant_Buyer_Flag         BIT             NULL,
    Data_Sharing_Consent        BIT             NULL,
    Available_Historical_Records INT            NULL
);


CREATE TABLE DimSupplier (
    SupplierKey                 INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_ID                 VARCHAR(50)             NOT NULL,    
    Supplier_Reliability_Score  DECIMAL(5,2)   NULL,
    Historical_Disruption_Count INT            NULL
);

CREATE TABLE DimProductCategory (
    ProductCategoryKey  INT IDENTITY(1,1) PRIMARY KEY,
    Product_Category    VARCHAR(100) NOT NULL
);

CREATE TABLE DimShippingMode (
    ShippingModeKey INT IDENTITY(1,1) PRIMARY KEY,
    Shipping_Mode   NVARCHAR(50) NOT NULL
);

CREATE TABLE DimDisruption (
    DisruptionKey        INT IDENTITY(1,1) PRIMARY KEY,
    Disruption_Type      VARCHAR(100) NOT NULL,
    Disruption_Severity  VARCHAR(50)  NULL
);

CREATE TABLE FactShipment (
    ShipmentKey INT IDENTITY(1,1) PRIMARY KEY,

    BuyerKey INT FOREIGN KEY REFERENCES DimBuyer(BuyerKey),
    SupplierKey INT FOREIGN KEY REFERENCES DimSupplier(SupplierKey),
    ProductCategoryKey INT FOREIGN KEY REFERENCES DimProductCategory(ProductCategoryKey),
    ShippingModeKey INT FOREIGN KEY REFERENCES DimShippingMode(ShippingModeKey),
    DisruptionKey INT FOREIGN KEY REFERENCES DimDisruption(DisruptionKey),

    OrderDateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    DispatchDateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    DeliveryDateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),

    -- Measures
    Quantity_Ordered INT,
    Order_Value_USD DECIMAL(12,2),
    Delay_Days INT,

    -- Federated Learning metrics (cũng là measures)
    Federated_Round INT,
    Parameter_Change_Magnitude DECIMAL(10,4),
    Communication_Cost_MB DECIMAL(12,4),
    Energy_Consumption_Joules DECIMAL(18,4),
    Supply_Risk_Flag BIT
)

--NHAP
Delete From DimDate
Delete From DimBuyer --NONE
Delete From DimSupplier --NONE
Delete From DimProductCategory
Delete From DimShippingMode
Delete From DimDisruption
Delete From FactShipment --NONE

ALTER TABLE DimBuyer
ALTER COLUMN Organization_ID VARCHAR(50) NOT NULL;
ALTER TABLE DimSupplier
ALTER COLUMN Supplier_ID VARCHAR(50) NOT NULL;

ALTER TABLE DimProductCategory
ALTER COLUMN Product_Category VARCHAR(100) NOT NULL;

ALTER TABLE DimShippingMode
ALTER COLUMN Shipping_Mode VARCHAR(50) NOT NULL;

ALTER TABLE DimDisruption
ALTER COLUMN Disruption_Type VARCHAR(100) NOT NULL;
ALTER TABLE DimDisruption
ALTER COLUMN Disruption_Severity VARCHAR(50) NULL;
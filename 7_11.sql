

create table Fact_ProductSalesTarget (
    DimProductID number CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID),
    DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY),
    ProductTargetSalesQuantity number
);



insert into Fact_ProductSalesTarget(
DimProductID,
DimTargetDateID,
ProductTargetSalesQuantity
)
select "ProductID",DIM_DATE.DATE_PKEY,"SalesQuantity"
from "IMT577_DW_NIKKI_LI"."PUBLIC"."SalesDetail".Dim_Date
where date("CreatedDate") = Dim_Date.DATE;

select * from Fact_ProductSalesTarget



create table Fact_SRCSalesTarget (
    DimStoreID number CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Store(DimStoreID),
    DimResellerID number CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES DIM_Reseller(DimResellerID),
    DimChannnelID number CONSTRAINT FK_DimTargetDateID FOREIGN KEY REFERENCES DIM_Channel(DimChannelID),
    DimTargetDateID number(9) CONSTRAINT FK_DimTargetDateID_SRC FOREIGN KEY REFERENCES DIM_DATE(DATE_PKEY),
    SalesTargetAmount number
);



insert into Fact_SRCSalesTarget(
DimStoreID,
DimResellerID,
DimChannnelID,
DimTargetDateID,
SalesTargetAmount
)
select  DIM_STORE.DimStoreID,DIM_Reseller.DimResellerID,Dim_Channel.DIMCHANNELID,dd.DATE_PKEY,sum("SalesAmount")
from
"IMT577_DW_NIKKI_LI"."PUBLIC"."SalesHeader" as sh
inner join "IMT577_DW_NIKKI_LI"."PUBLIC"."SalesDetail" as sd on (sh."SalesHeaderID" = sd."SalesHeaderID")
left join Dim_Date as dd on (date(sd."CreatedDate") = dd.DATE)
left join DIM_STORE on (sh."StoreID" = DIM_STORE.SourceStoreID )
left join DIM_Reseller on DIM_Reseller.ResellerID = sh."ResellerID"
left join Dim_Channel on Dim_Channel.CHANNELID = sh."ChannelID"
group by DIM_STORE.DimStoreID,DIM_Reseller.DimResellerID,Dim_Channel.DIMCHANNELID,dd.DATE_PKEY,dd.DATE_PKEY;


select * from Fact_SRCSalesTarget;


create table Fact_SalesActual (
    DimProductID number CONSTRAINT FK_DimProductID FOREIGN KEY REFERENCES Dim_Product(DimProductID),
    DimStoreID number CONSTRAINT FK_DimStoreID FOREIGN KEY REFERENCES DIM_Store(DimStoreID),
    DimResellerID number CONSTRAINT FK_DimResellerID FOREIGN KEY REFERENCES DIM_Reseller(DimResellerID),
    DimCustomerID number CONSTRAINT FK_DimCustomerID FOREIGN KEY REFERENCES DIM_CUSTOMER(DimCustomerID),
    DimChannellID number CONSTRAINT FK_DimChannellID FOREIGN KEY REFERENCES DIM_Channel(DIMCHANNELID),
    DimSaleDateID number(9) CONSTRAINT FK_DimSaleDateID FOREIGN KEY REFERENCES DIM_Date(DATE_PKEY),
    DimLocationID number CONSTRAINT FK_DimLocationID FOREIGN KEY REFERENCES DIM_Location(DimLocationID),
    SalesHeaderID number,
    SalesDetailID number,
    SaleAmount float,
    SaleQuantity number,
    SaleUnitPrice float,
    SaleExtendedCost float,
    SaleTotalProfit float
);






insert into Fact_SalesActual(
  DimProductID,
  DimStoreID,
  DimResellerID,
  DimCustomerID,
  DimChannellID,
  DimSaleDateID,
  DimLocationID,
  SalesHeaderID,
  SalesDetailID,
  SaleAmount,
  SaleQuantity,
  SaleUnitPrice,
  SaleExtendedCost,
  SaleTotalProfit
)
select  DIM_PRODUCT.DIMPRODUCTID,DIM_STORE.DimStoreID,DIM_Reseller.DimResellerID,Dim_Customer.DimCustomerID,Dim_Channel.DIMCHANNELID
,dd.DATE_PKEY,Dim_Customer.DIMLOCATIONID,sh."SalesHeaderID",sd."SalesDetailID",sd."SalesAmount",sd."SalesQuantity",
DIM_PRODUCT.ProductRetailPrice,DIM_PRODUCT.ProductCost,(DIM_PRODUCT.ProductRetailPrice - DIM_PRODUCT.ProductCost)*sd."SalesQuantity"
from
"IMT577_DW_NIKKI_LI"."PUBLIC"."SalesHeader" as sh
inner join "IMT577_DW_NIKKI_LI"."PUBLIC"."SalesDetail" as sd on (sh."SalesHeaderID" = sd."SalesHeaderID")
left join Dim_Date as dd on (date(sd."CreatedDate") = dd.DATE)
left join DIM_STORE on (sh."StoreID" = DIM_STORE.SourceStoreID )
left join DIM_Reseller on DIM_Reseller.ResellerID = sh."ResellerID"
left join Dim_Channel on Dim_Channel.CHANNELID = sh."ChannelID"
left join DIM_PRODUCT on DIM_PRODUCT.ProductID = sd."ProductID"
left join Dim_Customer on Dim_Customer.CustomerID = sh."CustomerID"



select * from Fact_SalesActual;


drop table Fact_ProductSalesTarget;
drop table Fact_SRCSalesTarget;
drop table Fact_SalesActual;


















